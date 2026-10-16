using System.Diagnostics;

namespace PsBash.Core.Runtime;

/// <summary>
/// Opt-in launcher phase timing (<c>PSBASH_TRACE_LAUNCH=1</c>): one stderr line per phase,
/// <c>[ps-bash launch] &lt;phase&gt; +&lt;ms since the previous mark&gt; at=&lt;ms since process start&gt;</c>.
/// Measured from the OS process start, so runtime startup before <c>Main</c> shows in the first
/// mark. The launcher-side counterpart of the host's <c>PSBASH_TRACE_STARTUP</c>; used to find
/// where a warm <c>ps-bash -c</c> spends its time.
/// </summary>
public static class LaunchTrace
{
    private static readonly bool Enabled = Environment.GetEnvironmentVariable("PSBASH_TRACE_LAUNCH") == "1";
    private static readonly DateTime ProcessStartUtc = Enabled ? ReadProcessStartUtc() : default;
    private static double _lastMs;

    public static void Mark(string phase)
    {
        if (!Enabled) return;
        var at = (DateTime.UtcNow - ProcessStartUtc).TotalMilliseconds;
        var delta = at - _lastMs;
        _lastMs = at;
        Console.Error.WriteLine($"[ps-bash launch] {phase} +{delta:0}ms at={at:0}ms");
    }

    private static DateTime ReadProcessStartUtc()
    {
        using var self = Process.GetCurrentProcess();
        return self.StartTime.ToUniversalTime();
    }
}
