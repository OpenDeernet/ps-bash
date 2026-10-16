using System.Diagnostics;
using PsBash.Core.Runtime.Ipc;
using Xunit;

namespace PsBash.Shell.Tests;

/// <summary>
/// The point of the daemon: a second `ps-bash -c` from the same session reuses the warm host.
/// On Linux it never did. The session endpoint embedded the anchor's .NET StartTime, which each
/// launcher process computes 0.3-5 ms differently, so every call keyed a new endpoint and cold
/// started a host (and the #7 anchor watcher then saw its live session as gone).
/// Oracle note (Directive 1): no bash oracle — ps-bash host lifecycle surface.
/// </summary>
[Trait("Category", "Spawn")]
public class SessionDaemonReuseTests
{
    [SkippableFact]
    public async Task TwoCallsFromOneSession_ShareOneHost()
    {
        Skip.If(InteractiveShellHarness.FindPsBashBinary() is null, "ps-bash binary not built");
        // The automatic session: no endpoint, no session name, not per-invocation. The launcher's
        // parent is this test host, an unrecognised process, so it is the session anchor for both.
        var env = new Dictionary<string, string?>
        {
            [IpcTransportFactory.EndpointEnvVar] = null,
            [IpcTransportFactory.SessionEnvVar] = null,
            ["PSBASH_PER_INVOCATION"] = null,
            ["PSBASH_HOST_IDLE_SECS"] = "20",
        };
        try
        {
            var first = await HostPidAsync(env);
            var second = await HostPidAsync(env);
            Assert.Equal(first, second);
        }
        finally
        {
            await RunAsync(env, "host", "shutdown");
        }
    }

    private static async Task<int> HostPidAsync(IReadOnlyDictionary<string, string?> env)
    {
        var (exit, stdout) = await RunAsync(env, "--ps", "-c", "$PID");
        Assert.Equal(0, exit);
        return int.Parse(stdout.Trim());
    }

    private static async Task<(int Exit, string Stdout)> RunAsync(IReadOnlyDictionary<string, string?> env, params string[] args)
    {
        var psi = PsBashTestProcess.Create(args, env: env, isolatedIpc: false);
        psi.RedirectStandardOutput = true;
        psi.RedirectStandardError = true;
        using var p = Process.Start(psi)!;
        var stdout = p.StandardOutput.ReadToEndAsync();
        var stderr = p.StandardError.ReadToEndAsync();
        using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(60));
        await p.WaitForExitAsync(cts.Token);
        _ = await stderr;
        return (p.ExitCode, await stdout);
    }
}
