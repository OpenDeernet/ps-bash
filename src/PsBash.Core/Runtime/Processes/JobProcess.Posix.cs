using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;
using PsBash.Core.Runtime.Ipc;

namespace PsBash.Core.Runtime.Processes;

public sealed partial class JobProcess
{
    // POSIX state. _reaped flips (under _gate) the moment waitpid returns: before that the pid cannot have
    // been recycled, so signalling the group is safe; after it a group kill is only allowed shortly afterwards
    // and only while the group still exists (see SignalPosix).
    private bool _reaped;
    private long _reapedAtTicks;
    private static readonly TimeSpan PostExitGroupKillWindow = TimeSpan.FromSeconds(30);

    private static JobProcess StartPosix(JobProcessStart spec)
    {
        var argv = new List<IntPtr> { Utf8(spec.FileName) };
        foreach (var a in spec.Arguments) argv.Add(Utf8(a));
        argv.Add(IntPtr.Zero);

        var merged = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (System.Collections.DictionaryEntry e in System.Environment.GetEnvironmentVariables())
            if (e.Key is string k && e.Value is string v) merged[k] = v;
        if (spec.Environment is not null)
            foreach (var (k, v) in spec.Environment)
            {
                if (v is null) merged.Remove(k);
                else merged[k] = v;
            }
        var envp = new List<IntPtr>(merged.Count + 1);
        foreach (var (k, v) in merged) envp.Add(Utf8(k + "=" + v));
        envp.Add(IntPtr.Zero);

        var path = Utf8(spec.FileName);
        var nullPath = Utf8("/dev/null");
        var argvBlock = PointerArray(argv);
        var envpBlock = PointerArray(envp);
        var actions = Marshal.AllocHGlobal(Posix.SpawnStructSize);
        var attr = Marshal.AllocHGlobal(Posix.SpawnStructSize);
        var sigDefault = Marshal.AllocHGlobal(Posix.SpawnStructSize);
        var sigMask = Marshal.AllocHGlobal(Posix.SpawnStructSize);
        bool actionsInit = false, attrInit = false;
        try
        {
            Check("posix_spawn_file_actions_init", Posix.posix_spawn_file_actions_init(actions)); actionsInit = true;
            // stdin/stdout/stderr -> /dev/null (O_RDWR); every other descriptor is CLOEXEC in .NET.
            for (int fd = 0; fd <= 2; fd++)
                Check("addopen", Posix.posix_spawn_file_actions_addopen(actions, fd, nullPath, 2 /* O_RDWR */, 0));

            Check("posix_spawnattr_init", Posix.posix_spawnattr_init(attr)); attrInit = true;
            // Own process group (pgid = pid) so signals reach the whole tree; default dispositions (the runtime
            // may have SIGPIPE ignored, which exec would otherwise pass on); empty signal mask.
            Check("sigfillset", Posix.sigfillset(sigDefault));
            Check("setsigdefault", Posix.posix_spawnattr_setsigdefault(attr, sigDefault));
            Check("sigemptyset", Posix.sigemptyset(sigMask));
            Check("setsigmask", Posix.posix_spawnattr_setsigmask(attr, sigMask));
            Check("setpgroup", Posix.posix_spawnattr_setpgroup(attr, 0));
            Check("setflags", Posix.posix_spawnattr_setflags(attr, (short)(Posix.SetPGroup | Posix.SetSigDef | Posix.SetSigMask)));

            int rc = Posix.posix_spawnp(out int pid, path, actions, attr, argvBlock, envpBlock);
            if (rc != 0)
                throw new HostUnavailableException($"posix_spawnp('{spec.FileName}') failed (rc={rc}): {Marshal.GetPInvokeErrorMessage(rc)}");

            ProcessIdentity identity;
            try
            {
                using var probe = Process.GetProcessById(pid);
                identity = new ProcessIdentity(pid, ProcessIdentity.StartTicksOf(probe));
            }
            catch (Exception ex) when (ex is ArgumentException or InvalidOperationException)
            {
                identity = new ProcessIdentity(pid, 0); // exited before we could look; the waiter still reaps it
            }

            var job = new JobProcess(pid, identity);
            var waiter = new Thread(() => job.ReapLoop()) { IsBackground = true, Name = $"job-wait-{pid}" };
            waiter.Start();
            return job;
        }
        finally
        {
            if (actionsInit) Posix.posix_spawn_file_actions_destroy(actions);
            if (attrInit) Posix.posix_spawnattr_destroy(attr);
            Marshal.FreeHGlobal(actions); Marshal.FreeHGlobal(attr);
            Marshal.FreeHGlobal(sigDefault); Marshal.FreeHGlobal(sigMask);
            Marshal.FreeHGlobal(argvBlock); Marshal.FreeHGlobal(envpBlock);
            Marshal.FreeHGlobal(path); Marshal.FreeHGlobal(nullPath);
            foreach (var p in argv) if (p != IntPtr.Zero) Marshal.FreeHGlobal(p);
            foreach (var p in envp) if (p != IntPtr.Zero) Marshal.FreeHGlobal(p);
        }
    }

    /// <summary>Blocks in waitpid so the child is always reaped (no zombies), then publishes the status.</summary>
    private void ReapLoop()
    {
        int status = 0;
        while (true)
        {
            int rc = Posix.waitpid(Pid, out status, 0);
            if (rc == Pid) break;
            int err = Marshal.GetLastPInvokeError();
            if (rc < 0 && err == Posix.EINTR) continue;
            status = unchecked((int)0xFF00); // ECHILD: someone else reaped it; report 255 rather than a false success
            break;
        }
        lock (_gate)
        {
            _reaped = true;
            _reapedAtTicks = Stopwatch.GetTimestamp();
        }
        // WIFEXITED -> WEXITSTATUS; WIFSIGNALED -> 128 + signal (the shell convention).
        int code = (status & 0x7f) == 0 ? (status >> 8) & 0xff : 128 + (status & 0x7f);
        _exited.TrySetResult(code);
    }

    private bool SignalPosix(JobSignal signal)
    {
        int sig = signal == JobSignal.Kill ? Posix.SIGKILL : Posix.SIGTERM;
        return SendToGroup(sig);
    }

    private bool SuspendPosix(bool suspend) => SendToGroup(suspend ? Posix.SIGSTOP : Posix.SIGCONT);

    // Caller holds _gate.
    private bool SendToGroup(int sig)
    {
        if (_reaped)
        {
            // The leader is gone and its pid may have been recycled. The group (its descendants) can still exist;
            // only touch it for a short while after exit and only if it demonstrably still has members.
            if (Stopwatch.GetElapsedTime(_reapedAtTicks) > PostExitGroupKillWindow) return false;
            if (Posix.kill(-Pid, 0) != 0) return false;
        }
        return Posix.kill(-Pid, sig) == 0;
    }

    private static IntPtr Utf8(string s)
    {
        var bytes = Encoding.UTF8.GetBytes(s);
        var p = Marshal.AllocHGlobal(bytes.Length + 1);
        Marshal.Copy(bytes, 0, p, bytes.Length);
        Marshal.WriteByte(p, bytes.Length, 0);
        return p;
    }

    private static IntPtr PointerArray(List<IntPtr> pointers)
    {
        var block = Marshal.AllocHGlobal(IntPtr.Size * pointers.Count);
        Marshal.Copy(pointers.ToArray(), 0, block, pointers.Count);
        return block;
    }

    private static void Check(string call, int rc)
    {
        if (rc != 0) throw new HostUnavailableException($"{call} failed (rc={rc}): {Marshal.GetPInvokeErrorMessage(rc)}");
    }

    private static class Posix
    {
        // Sizes are upper bounds for glibc/musl/macOS opaque types (posix_spawn_file_actions_t, posix_spawnattr_t, sigset_t).
        public const int SpawnStructSize = 1024;
        // Values identical on Linux (glibc, musl) and macOS.
        public const int SetPGroup = 0x02, SetSigDef = 0x04, SetSigMask = 0x08;
        public const int SIGTERM = 15, SIGKILL = 9;
        public static readonly int SIGSTOP = OperatingSystem.IsMacOS() ? 17 : 19;
        public static readonly int SIGCONT = OperatingSystem.IsMacOS() ? 19 : 18;
        public const int EINTR = 4;

        [DllImport("libc", SetLastError = true)] public static extern int kill(int pid, int sig);
        [DllImport("libc", SetLastError = true)] public static extern int waitpid(int pid, out int status, int options);
        [DllImport("libc")] public static extern int posix_spawnp(out int pid, IntPtr file, IntPtr actions, IntPtr attr, IntPtr argv, IntPtr envp);
        [DllImport("libc")] public static extern int posix_spawn_file_actions_init(IntPtr a);
        [DllImport("libc")] public static extern int posix_spawn_file_actions_destroy(IntPtr a);
        [DllImport("libc")] public static extern int posix_spawn_file_actions_addopen(IntPtr a, int fd, IntPtr path, int oflag, int mode);
        [DllImport("libc")] public static extern int posix_spawnattr_init(IntPtr a);
        [DllImport("libc")] public static extern int posix_spawnattr_destroy(IntPtr a);
        [DllImport("libc")] public static extern int posix_spawnattr_setflags(IntPtr a, short flags);
        [DllImport("libc")] public static extern int posix_spawnattr_setpgroup(IntPtr a, int pgroup);
        [DllImport("libc")] public static extern int posix_spawnattr_setsigdefault(IntPtr a, IntPtr set);
        [DllImport("libc")] public static extern int posix_spawnattr_setsigmask(IntPtr a, IntPtr set);
        [DllImport("libc")] public static extern int sigfillset(IntPtr set);
        [DllImport("libc")] public static extern int sigemptyset(IntPtr set);
    }
}
