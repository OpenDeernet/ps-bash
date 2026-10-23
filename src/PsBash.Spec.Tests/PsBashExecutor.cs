using PsBash.Spec;
using PsBash.Testing;

namespace PsBash.Spec.Tests;

/// <summary>Phase 1 executor: one real ps-bash launcher process per case (<c>ps-bash -c script</c>).</summary>
internal sealed class PsBashExecutor : IScriptExecutor
{
    public async Task<ExecResult> RunAsync(string script, TimeSpan timeout, CancellationToken cancel)
    {
        var r = await PsBashRunner.Create().WithTimeout(timeout).RunScriptAsync(script);
        return new ExecResult(r.ExitCode, r.Stdout, r.Stderr, r.WallMs);
    }
}
