using System.Diagnostics;

namespace PsBash.TestRunner;

/// <summary>
/// Machine-wide CPU use while a tier runs, from the aggregate <c>cpu</c> line of /proc/stat once a
/// second. Answers whether the fast pass is CPU-bound (then only less total work makes it faster)
/// or waiting on something (then the scheduling or a serial long pole is the lever). Each sample
/// also records how many assemblies were running, so the timeline shows the saturated phase and the
/// long-pole tail apart. Linux only; elsewhere <see cref="Stop"/> returns null.
/// </summary>
internal sealed class CpuSampler
{
    private readonly Func<int> _running;
    private readonly List<CpuSample> _samples = new();
    private readonly CancellationTokenSource _stop = new();
    private readonly Thread? _thread;
    private readonly Stopwatch _clock = Stopwatch.StartNew();

    internal sealed record CpuSample(double Seconds, double BusyPercent, double IoWaitPercent, int RunningAssemblies);

    internal sealed record CpuProfile(
        int Cores, int Samples, double MeanBusyPercent, double P50BusyPercent, double P90BusyPercent,
        double SaturatedFraction, double MeanIoWaitPercent, List<CpuSample> Timeline);

    /// <summary>A sample at or above this is a saturated second.</summary>
    internal const double SaturatedBusyPercent = 95;

    public CpuSampler(Func<int> runningAssemblies)
    {
        _running = runningAssemblies;
        if (!OperatingSystem.IsLinux() || ReadTicks() is null) return;
        _thread = new Thread(Loop) { IsBackground = true, Name = "cpu-sampler" };
        _thread.Start();
    }

    public CpuProfile? Stop()
    {
        if (_thread is null) return null;
        _stop.Cancel();
        _thread.Join();
        lock (_samples) return Summarize(_samples.ToList(), Environment.ProcessorCount);
    }

    private void Loop()
    {
        var prev = ReadTicks()!.Value;
        while (!_stop.Token.WaitHandle.WaitOne(TimeSpan.FromSeconds(1)))
        {
            if (ReadTicks() is not { } now) return;
            double total = now.Total - prev.Total;
            if (total > 0)
            {
                var sample = new CpuSample(
                    Math.Round(_clock.Elapsed.TotalSeconds, 1),
                    Math.Round(100 * (total - (now.Idle - prev.Idle) - (now.IoWait - prev.IoWait)) / total, 1),
                    Math.Round(100 * (now.IoWait - prev.IoWait) / total, 1),
                    _running());
                lock (_samples) _samples.Add(sample);
            }
            prev = now;
        }
    }

    internal static CpuProfile Summarize(List<CpuSample> samples, int cores)
    {
        if (samples.Count == 0) return new CpuProfile(cores, 0, 0, 0, 0, 0, 0, samples);
        var busy = samples.Select(s => s.BusyPercent).Order().ToList();
        double Percentile(double p) => busy[(int)Math.Min(busy.Count - 1, Math.Floor(p * busy.Count))];
        return new CpuProfile(
            cores, samples.Count,
            Math.Round(busy.Average(), 1), Percentile(0.5), Percentile(0.9),
            Math.Round((double)busy.Count(b => b >= SaturatedBusyPercent) / busy.Count, 3),
            Math.Round(samples.Average(s => s.IoWaitPercent), 1),
            samples);
    }

    internal readonly record struct CpuTicks(long Total, long Idle, long IoWait);

    /// <summary>The aggregate line: <c>cpu user nice system idle iowait irq softirq steal ...</c>.</summary>
    internal static CpuTicks? ParseStatCpuLine(string line)
    {
        var fields = line.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (fields.Length < 6 || fields[0] != "cpu") return null;
        long total = 0;
        // guest/guest_nice (fields 9, 10) are already counted in user/nice.
        for (int i = 1; i < Math.Min(fields.Length, 9); i++) total += long.Parse(fields[i]);
        return new CpuTicks(total, long.Parse(fields[4]), long.Parse(fields[5]));
    }

    private static CpuTicks? ReadTicks()
    {
        try
        {
            using var reader = new StreamReader("/proc/stat");
            return reader.ReadLine() is { } line ? ParseStatCpuLine(line) : null;
        }
        catch (IOException) { return null; }
        catch (UnauthorizedAccessException) { return null; }
    }
}
