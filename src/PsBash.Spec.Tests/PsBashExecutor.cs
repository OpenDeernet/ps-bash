using PsBash.Spec;
using PsBash.Testing;

namespace PsBash.Spec.Tests;

/// <summary>
/// One real ps-bash launcher process per case (<c>ps-bash -c script</c>). <c>PSBASH_SPEC_MODE</c> picks how the host
/// behind the launcher is provided: <c>perinv</c> (a fresh host per case, the Phase 1 behaviour), or <c>warm</c> (default:
/// one daemon on a private endpoint shared by every case of the run, so host start-up is paid once).
/// </summary>
internal sealed class PsBashExecutor : IScriptExecutor
{
    public static string Mode { get; } = Environment.GetEnvironmentVariable("PSBASH_SPEC_MODE") is { Length: > 0 } m ? m : "warm";

    // One endpoint per test process; the daemon idles out shortly after the run.
    private static readonly string Endpoint =
        "unix:" + Path.Combine(Path.GetTempPath(), "ps-bash", "spec-" + Guid.NewGuid().ToString("N") + ".sock");

    private static readonly Dictionary<string, string> Env = Mode == "perinv"
        ? new() { ["PSBASH_PER_INVOCATION"] = "1" }
        : new()
        {
            ["PSBASH_PER_INVOCATION"] = "0",
            ["PSBASH_IPC_ENDPOINT"] = Endpoint,
            ["PSBASH_HOST_IDLE_SECS"] = "20",
            ["PSBASH_HOST_MAX_MB"] = "1536",
        };

    public async Task<ExecResult> RunAsync(string script, TimeSpan timeout, CancellationToken cancel)
    {
        var r = await PsBashRunner.Create().WithTimeout(timeout).WithEnv(Env).RunScriptAsync(script);
        return new ExecResult(r.ExitCode, r.Stdout, r.Stderr, r.WallMs);
    }
}
