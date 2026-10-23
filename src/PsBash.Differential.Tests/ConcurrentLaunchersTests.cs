using System.Diagnostics;
using PsBash.Testing;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// Real concurrent launchers against one session's hosts (docs/specs/executor-slots.md): more simultaneous commands than
/// fit on slot 0 must spill to other slots, run in parallel, and keep their shell state apart. Hand-written asserts: the
/// oracle fixture runs one script at a time.
/// </summary>
public class ConcurrentLaunchersTests
{
    private const int Launchers = 4; // more than slot 0 can run at once, fewer than MaxExecSlots (6): no private-host fallback, bounded memory
    private const int HoldSeconds = 2;

    [SkippableFact]
    public async Task ManyLaunchers_RunInParallel_AndKeepTheirStateApart()
    {
        // The suite default is a private host per launcher; this test is about the shared daemon and its slots, so it
        // runs its own session (own endpoint) whose hosts exit by themselves a few seconds after the last command.
        var env = new Dictionary<string, string>
        {
            ["PSBASH_PER_INVOCATION"] = "0",
            ["PSBASH_SESSION"] = "slots" + Guid.NewGuid().ToString("N")[..8],
            ["PSBASH_HOST_IDLE_SECS"] = "15",
        };
        var runner = PsBashRunner.Create().WithTimeout(90).WithEnv(env);
        Skip.If(runner.TryResolveBinary() is null, "ps-bash binary not found -- build PsBash.Shell first");

        // First burst creates the slot daemons (a cold runspace each); only the second, warm burst is timed.
        await Task.WhenAll(Enumerable.Range(0, Launchers).Select(i => runner.RunScriptAsync($"sleep {HoldSeconds}; echo warm{i}")));

        var sw = Stopwatch.StartNew();
        var runs = Enumerable.Range(0, Launchers).Select(i =>
            runner.RunScriptAsync($"v=launcher{i}; sleep {HoldSeconds}; echo \"$v\"")).ToArray();
        var results = await Task.WhenAll(runs);
        sw.Stop();

        for (int i = 0; i < Launchers; i++)
        {
            Assert.Equal(0, results[i].ExitCode);
            Assert.Equal($"launcher{i}", results[i].Stdout.Trim());
        }

        // Overlap is a timing claim, and six warm hosts need several GB: on a memory-starved machine the hosts page and
        // the burst is slower than serial. So it is opt-in (PSBASH_PERF_TESTS=1) on a machine with room for the slots.
        if (Environment.GetEnvironmentVariable("PSBASH_PERF_TESTS") != "1") return;

        // Serial execution would take Launchers * HoldSeconds; overlap is the point of the slots.
        double serial = Launchers * HoldSeconds;
        Assert.True(sw.Elapsed.TotalSeconds < serial * 0.75,
            $"{Launchers} launchers took {sw.Elapsed.TotalSeconds:F1}s; serial would be {serial}s, so they did not overlap. Per-launcher ms: "
            + string.Join(", ", results.Select(r => r.WallMs)));
    }
}
