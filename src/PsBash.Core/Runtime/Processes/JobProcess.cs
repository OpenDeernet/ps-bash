using PsBash.Core.Runtime.Ipc;

namespace PsBash.Core.Runtime.Processes;

/// <summary>What to start. Executors speak IPC, so stdio is the null device on every platform.</summary>
/// <param name="FileName">Program; resolved through PATH when not rooted.</param>
/// <param name="Arguments">argv[1..], not shell-quoted.</param>
/// <param name="Environment">Overrides applied on top of this process's environment; a null value removes the variable.</param>
public sealed record JobProcessStart(
    string FileName,
    IReadOnlyList<string> Arguments,
    IReadOnlyDictionary<string, string?>? Environment = null);

/// <summary>How <see cref="JobProcess.Signal"/> asks a job tree to stop.</summary>
public enum JobSignal
{
    /// <summary>SIGTERM to the process group on POSIX. Windows has no console-app equivalent that can be
    /// delivered across consoles, so it is an immediate tree termination there (status 143).</summary>
    Terminate,

    /// <summary>SIGKILL to the process group / <c>TerminateJobObject</c> (status 137).</summary>
    Kill,
}

/// <summary>
/// A child process plus everything it spawns, as one unit (docs/specs/background-jobs.md §6). One
/// implementation per OS behind this contract:
/// <list type="bullet">
/// <item>Windows — <c>CreateProcessW</c> with an explicit handle list (no inherited handles), started
/// suspended, assigned to its own kill-on-close Job Object, then resumed, so no descendant can escape before
/// containment. Disposing the object kills the tree.</item>
/// <item>POSIX — <c>posix_spawn</c> into its own process group (default signal dispositions, empty mask);
/// signals go to the group, so grandchildren die with the leader. A dedicated thread <c>waitpid</c>s, so a
/// finished job never lingers as a zombie.</item>
/// </list>
/// "Dies with its parent" is deliberately NOT here: on Windows the Job Object does it; on POSIX the child
/// runs <c>ParentDeathWatcher</c> (no PDEATHSIG through posix_spawn, none on macOS).
/// </summary>
public sealed partial class JobProcess : IDisposable
{
    private readonly TaskCompletionSource<int> _exited = new(TaskCreationOptions.RunContinuationsAsynchronously);
    private readonly object _gate = new();
    private bool _released;
    private bool _disposed;

    private JobProcess(int pid, ProcessIdentity identity)
    {
        Pid = pid;
        Identity = identity;
    }

    /// <summary>OS process id of the job leader.</summary>
    public int Pid { get; }

    /// <summary>pid + start time: survives PID reuse, for sidecars and the orphan reaper.</summary>
    public ProcessIdentity Identity { get; }

    /// <summary>Completes with the exit status once the leader has exited: its code, or 128+n when a signal ended it.</summary>
    public Task<int> Exited => _exited.Task;

    public bool HasExited => _exited.Task.IsCompleted;

    /// <summary>Start a job. Throws <see cref="HostUnavailableException"/> when the OS refuses.</summary>
    public static JobProcess Start(JobProcessStart spec)
    {
        ArgumentNullException.ThrowIfNull(spec);
        return OperatingSystem.IsWindows() ? StartWindows(spec) : StartPosix(spec);
    }

    /// <summary>Ask the job (leader and descendants) to stop. False when there was nothing to signal.</summary>
    public bool Signal(JobSignal signal)
    {
        lock (_gate)
        {
            if (_disposed) return false;
            return OperatingSystem.IsWindows() ? SignalWindows(signal) : SignalPosix(signal);
        }
    }

    /// <summary>Kill the whole tree now.</summary>
    public bool KillTree() => Signal(JobSignal.Kill);

    /// <summary>Freeze every process of the job (SIGSTOP on POSIX; <c>NtSuspendProcess</c> per member on Windows).</summary>
    public bool Suspend() => ChangeRunState(suspend: true);

    public bool Resume() => ChangeRunState(suspend: false);

    private bool ChangeRunState(bool suspend)
    {
        lock (_gate)
        {
            if (_disposed) return false;
            return OperatingSystem.IsWindows() ? SuspendWindows(suspend) : SuspendPosix(suspend);
        }
    }

    /// <summary>
    /// Let the job outlive this object (and, on Windows, this process): after this, <see cref="Dispose"/>
    /// only frees handles. Used for jobs that are deliberately detached at command end.
    /// </summary>
    public void Release()
    {
        lock (_gate)
        {
            if (_released || _disposed) return;
            _released = true;
            if (OperatingSystem.IsWindows()) ReleaseWindows();
        }
    }

    /// <summary>Kills the tree unless <see cref="Release"/>d, then frees OS handles. Never blocks.</summary>
    public void Dispose()
    {
        lock (_gate)
        {
            if (_disposed) return;
            if (!_released)
            {
                if (OperatingSystem.IsWindows()) SignalWindows(JobSignal.Kill);
                else SignalPosix(JobSignal.Kill);
            }
            _disposed = true;
            if (OperatingSystem.IsWindows()) DisposeWindows();
        }
    }
}
