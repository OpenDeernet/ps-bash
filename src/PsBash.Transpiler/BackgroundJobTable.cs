using System.Collections.Concurrent;

namespace PsBash.Core;

/// <summary>
/// The background jobs this process owns, by OS pid. A job runs in its own host process
/// (docs/specs/background-jobs.md), so <c>kill $!</c> must reach the job's whole process tree and the job must
/// report the signal as its status — which a bare <c>Process.Kill</c> on the pid does not. The host registers
/// each job here; <c>kill</c> (a cmdlet in another assembly) looks the pid up. Lives in the Transpiler assembly
/// because that is the one both sides already share.
/// </summary>
public static class BackgroundJobTable
{
    private static readonly ConcurrentDictionary<int, Action<int>> Jobs = new();

    /// <summary>Register <paramref name="signal"/> (takes the signal number) as the way to stop job <paramref name="pid"/>.</summary>
    public static void Register(int pid, Action<int> signal) => Jobs[pid] = signal;

    /// <summary>Jobs currently running; the fork-bomb guard (PSBASH_JOBS_MAX) compares against this.</summary>
    public static int Count => Jobs.Count;

    public static void Unregister(int pid) => Jobs.TryRemove(pid, out _);

    /// <summary>Deliver <paramref name="signal"/> to a registered job. False when <paramref name="pid"/> is not a job of this process.</summary>
    public static bool TrySignal(int pid, int signal)
    {
        if (!Jobs.TryGetValue(pid, out var send)) return false;
        send(signal);
        return true;
    }
}
