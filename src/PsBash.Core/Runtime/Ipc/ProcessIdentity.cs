using System.Diagnostics;
using System.Globalization;

namespace PsBash.Core.Runtime.Ipc;

/// <summary>
/// A process's pid paired with a stamp of when it started. The stamp makes the identity
/// unique over time: two different processes that reuse one PID still get distinct
/// identities. It must also be the SAME value whichever process computes it, because two
/// launchers key one session's daemon endpoint from it (see <see cref="StartStampOf"/>). Used as the automatic session anchor
/// (<see cref="ProcessAncestry.FindSessionAnchor"/>) and handed to the daemon it keys
/// as <c>--session-anchor=&lt;pid&gt;:&lt;startTicks&gt;</c>, so the daemon can exit once its
/// session is gone (see <c>docs/specs/host-lifecycle-contract.md</c> §Session anchor lifetime).
/// </summary>
public readonly record struct ProcessIdentity(int Pid, long StartStamp)
{
    /// <summary>The host argument name that carries a session anchor.</summary>
    public const string SessionAnchorArg = "--session-anchor";

    /// <summary>
    /// The start stamp of <paramref name="process"/>, the one formula every identity uses. On
    /// Linux it is the raw starttime of <c>/proc/&lt;pid&gt;/stat</c> (clock ticks since boot).
    /// NOT <see cref="Process.StartTime"/>: .NET derives that from a boot time each process
    /// computes for itself as now minus uptime, so two processes reading the same pid got values
    /// 0.3-5 ms apart. Every launcher then keyed a different endpoint (a cold daemon per
    /// `ps-bash -c`, no warm reuse on Linux), and a daemon's anchor check saw its live session
    /// as a different process and exited. Windows and macOS report the exact OS start time.
    /// Throws <see cref="InvalidOperationException"/> when the process has exited.
    /// </summary>
    internal static long StartStampOf(Process process)
    {
        if (!OperatingSystem.IsLinux()) return process.StartTime.ToUniversalTime().Ticks;
        return ProcStat.TryRead(process.Id, out _, out var startTime)
            ? startTime
            : throw new InvalidOperationException($"process {process.Id} has exited");
    }

    /// <summary><c>&lt;pid&gt;:&lt;startStamp&gt;</c>, the <see cref="SessionAnchorArg"/> value.</summary>
    public string ToArgumentValue()
        => Pid.ToString(CultureInfo.InvariantCulture) + ":" + StartStamp.ToString(CultureInfo.InvariantCulture);

    /// <summary>Parse a <see cref="ToArgumentValue"/> string; false for anything malformed.</summary>
    public static bool TryParse(string? value, out ProcessIdentity identity)
    {
        identity = default;
        if (string.IsNullOrEmpty(value)) return false;
        var colon = value.IndexOf(':');
        if (colon <= 0) return false;
        if (!int.TryParse(value.AsSpan(0, colon), NumberStyles.None, CultureInfo.InvariantCulture, out var pid) || pid <= 0)
            return false;
        if (!long.TryParse(value.AsSpan(colon + 1), NumberStyles.None, CultureInfo.InvariantCulture, out var stamp))
            return false;
        identity = new ProcessIdentity(pid, stamp);
        return true;
    }

    /// <summary>
    /// True while THIS process is running: the pid exists, has not exited, and still has
    /// the recorded start stamp. A recycled pid (different stamp) is not this process.
    /// Returns true when the start time cannot be read for a live pid (access denied):
    /// an unreadable process must not shut a daemon down.
    /// </summary>
    public bool IsRunning()
    {
        Process process;
        try { process = Process.GetProcessById(Pid); }
        catch (ArgumentException) { return false; }      // no such pid
        catch (InvalidOperationException) { return false; }
        using (process)
        {
            try
            {
                if (process.HasExited) return false;
                return StartStampOf(process) == StartStamp;
            }
            catch (InvalidOperationException) { return false; } // exited between calls
            catch (System.ComponentModel.Win32Exception) { return true; } // unreadable, not proven gone
            catch (NotSupportedException) { return true; }
        }
    }
}
