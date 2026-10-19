using System.Diagnostics;

namespace PsBash.Testing;

/// <summary>
/// Tells "slow because the machine is starved" from "stuck", so test waits need no
/// absolute wall-clock verdict. A fixed deadline fails a correct-but-slow run on a
/// loaded CI runner (one ps-bash invocation costs seconds of CPU; with the cores
/// saturated it finishes in 12-23 s instead of 3 s) and says nothing about whether the
/// child was alive. The deadline here is only a checkpoint: when it passes, the child
/// is still given more time for as long as the machine measurably is contended, and
/// declared stuck only once the machine is quiet and the child still has not finished.
/// <para>
/// Contention is a RATIO against this process's own best sample, so it needs no
/// calibrated constant and adapts to whatever hardware runs the suite.
/// </para>
/// </summary>
public static class ContentionProbe
{
    private const int SpinIterations = 2_000_000;

    // Fastest probe seen in this process = the uncontended cost on this machine.
    private static long _bestTicks = long.MaxValue;

    /// <summary>Contention above this ratio over the uncontended probe counts as starved.</summary>
    public const double StarvedRatio = 1.5;

    /// <summary>Never extend past this many multiples of the base deadline (hang backstop).</summary>
    private const int MaxExtensions = 20;

    /// <summary>
    /// How many times slower than its fastest run a fixed CPU spin is right now
    /// (1.0 = idle machine). The spin runs on its own thread so a busy pool does not skew it.
    /// </summary>
    public static async Task<double> MeasureAsync()
    {
        var ticks = await Task.Factory.StartNew(
            () =>
            {
                var sw = Stopwatch.StartNew();
                double acc = 1;
                for (var i = 1; i <= SpinIterations; i++) acc += Math.Sqrt(i) / (acc + i);
                GC.KeepAlive(acc);
                return sw.ElapsedTicks;
            },
            TaskCreationOptions.LongRunning);

        long best;
        do
        {
            best = Interlocked.Read(ref _bestTicks);
            if (ticks >= best) break;
        } while (Interlocked.CompareExchange(ref _bestTicks, ticks, best) != best);

        return (double)ticks / Math.Min(best, ticks);
    }

    /// <summary>
    /// Waits for <paramref name="process"/> to exit. <paramref name="checkpoint"/> is how
    /// long a healthy run is expected to take on an idle machine; past it the wait keeps
    /// going only while the machine is starved. Returns false when the child is still
    /// running on a quiet machine (genuinely stuck) or the extension cap is reached.
    /// </summary>
    public static async Task<bool> WaitForExitAsync(Process process, TimeSpan checkpoint, bool extendWhenStarved = true)
    {
        // Sample before waiting so the baseline is taken as early (and as quiet) as possible.
        await MeasureAsync();
        for (var round = 0; round <= (extendWhenStarved ? MaxExtensions : 0); round++)
        {
            using var cts = new CancellationTokenSource(checkpoint);
            try
            {
                await process.WaitForExitAsync(cts.Token);
                return true;
            }
            catch (OperationCanceledException)
            {
                if (!extendWhenStarved || await MeasureAsync() < StarvedRatio) return false;
            }
        }
        return false;
    }
}
