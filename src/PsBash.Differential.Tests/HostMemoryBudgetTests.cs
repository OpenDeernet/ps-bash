using System.Diagnostics;
using PsBash.Differential.Tests.Oracle;
using Xunit;

namespace PsBash.Differential.Tests;

/// <summary>
/// Memory-pressure gate: a warm host serving many commands must stay under a working-set budget
/// (it plateaued near 1.2 GB before GC.ConserveMemory; now ~840 MB). Override with PSBASH_TEST_MEM_BUDGET_MB.
/// Oracle note: resource measurement has no bash equivalent, so this asserts ps-bash directly.
/// </summary>
public class HostMemoryBudgetTests
{
    private static long HostWorkingSetMb()
    {
        long total = 0;
        foreach (var p in Process.GetProcessesByName("ps-bash-host"))
        {
            try
            {
                var path = p.MainModule?.FileName ?? "";
                if (path.Contains(Path.Combine("bin", ""), StringComparison.OrdinalIgnoreCase)
                    && path.Contains("PsBash.Host", StringComparison.OrdinalIgnoreCase))
                    total += p.WorkingSet64;
            }
            catch (Exception) { /* exited or inaccessible */ }
            finally { p.Dispose(); }
        }
        return total / (1024 * 1024);
    }

    [SkippableFact]
    public async Task WarmHost_StaysUnderMemoryBudget_AfterManyCommands()
    {
        var budget = long.TryParse(Environment.GetEnvironmentVariable("PSBASH_TEST_MEM_BUDGET_MB"), out var b) ? b : 2500;
        long peak = 0;
        for (var i = 0; i < 150; i++)
        {
            var r = await AssertOracle.RunPsBashOnlyAsync($"echo {i} | cat | wc -l", TimeSpan.FromSeconds(30));
            Assert.Equal(0, r.ExitCode);
            if (i % 25 == 24) peak = Math.Max(peak, HostWorkingSetMb());
        }
        Assert.True(peak <= budget, $"dev-build ps-bash-host working set peaked at {peak} MB (budget {budget} MB; all hosts under repo bin)");
    }
}
