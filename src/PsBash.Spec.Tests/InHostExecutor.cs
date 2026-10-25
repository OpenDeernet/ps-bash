using System.Collections;
using System.Text;
using System.Threading.Channels;
using PsBash.Core.Runtime;
using PsBash.Core.Transpiler;
using PsBash.Core.Parser;
using PsBash.Testing;

namespace PsBash.Spec.Tests;

/// <summary>
/// Runs cases through the same pipeline the launcher uses (transpile, then one framed request to a host) but without a
/// launcher process per case: the runner transpiles in-process and keeps N hosts alive, one case at a time on each.
/// A launcher costs ~500 ms per case (process start, JIT, connect); a framed request on a warm host ~15 ms.
/// Each slot owns a private host (<see cref="Lifetime.PerInvocation"/>), so slots run in parallel.
/// </summary>
internal sealed class InHostExecutor : IScriptExecutor, IAsyncDisposable
{
    private readonly string _hostBinary;
    private readonly Channel<IpcWorker?> _slots;

    private const string WarmupScript =
        "x=1; f() { echo \"$x\"; }; f | cat; [[ a == a ]] && echo $((x+1)); for i in 1 2; do :; done; y=$(echo z); case $y in z) ;; esac; printf %s ok >&2";

    // A host is reused across cases, so each case must start from the same shell state: a baseline is taken once per fresh
    // host (bash variables, aliases, shopt/set options, dir stack, plus the function table) and restored after every case.
    private const string BaselineScript =
        "$global:__spec_ss = [PsBash.Cmdlets.BashShellState]::Save($ExecutionContext.SessionState); " +
        "$global:__spec_fn = @((Get-ChildItem function:).Name)";

    private const string RestoreScript =
        "[void][PsBash.Cmdlets.BashShellState]::Restore($ExecutionContext.SessionState, $global:__spec_ss); " +
        "Get-ChildItem function: | Where-Object { $_.Name -notin $global:__spec_fn } | Remove-Item -ErrorAction SilentlyContinue";

    public InHostExecutor(int slots)
    {
        var launcher = PsBashLocator.ResolveRequired(BuildConfig.Auto);
        _hostBinary = Path.Combine(Path.GetDirectoryName(launcher)!, IpcWorker.GetHostBinaryName());
        _slots = Channel.CreateBounded<IpcWorker?>(slots);
        for (var i = 0; i < slots; i++) _slots.Writer.TryWrite(null); // null = host not started yet
    }

    public async Task<ExecResult> RunAsync(string script, TimeSpan timeout, CancellationToken cancel)
    {
        string ps;
        try { ps = BashTranspiler.Transpile(script); }
        catch (ParseException ex)
        {
            return new ExecResult(2, "", $"ps-bash: parse error: {ex.Message}\n");
        }

        using var caseDir = new CaseDir(script);
        var worker = await _slots.Reader.ReadAsync(cancel);
        var healthy = false;
        try
        {
            if (worker is null)
            {
                worker = await IpcWorker.StartAsync(_hostBinary, lifetime: Lifetime.PerInvocation, ct: cancel);
                worker.OutputCallback = _ => { };
                worker.ErrorCallback = _ => { };
                await worker.ExecuteAsync(BaselineScript, cancel, CaptureEnvironment());
            }
            var stdout = new StringBuilder();
            var stderr = new StringBuilder();
            worker.OutputCallback = s => stdout.Append(s);
            worker.ErrorCallback = s => stderr.Append(s);
            using var cts = CancellationTokenSource.CreateLinkedTokenSource(cancel);
            cts.CancelAfter(timeout);
            var sw = System.Diagnostics.Stopwatch.StartNew();
            int code;
            try
            {
                code = await worker.ExecuteAsync(CwdPreamble(caseDir.Path) + ps, cts.Token, CaptureEnvironment());
                healthy = true;
            }
            catch (OperationCanceledException) when (!cancel.IsCancellationRequested)
            {
                return new ExecResult(124, stdout.ToString(), stderr + "runner: case timed out\n", sw.ElapsedMilliseconds);
            }
            var result = new ExecResult(code, stdout.ToString(), stderr.ToString(), sw.ElapsedMilliseconds);
            // Back to the baseline shell state; a host that cannot is replaced rather than reused dirty.
            worker.OutputCallback = _ => { };
            worker.ErrorCallback = _ => { };
            try { await worker.ExecuteAsync(CwdPreamble(caseDir.Path) + RestoreScript, cancel, CaptureEnvironment()); }
            catch (Exception) when (!cancel.IsCancellationRequested) { healthy = false; }
            return result;
        }
        finally
        {
            if (!healthy && worker is not null)
            {
                await worker.DisposeAsync(); // a wedged or failed host is replaced, never reused
                worker = null;
            }
            _slots.Writer.TryWrite(worker);
        }
    }

    private static string CwdPreamble(string dir)
    {
        var cwd = dir.Replace("'", "''");
        return "$__psbash_invocation_cwd = '" + cwd + "'; [System.Environment]::CurrentDirectory = $__psbash_invocation_cwd; "
             + "$env:PWD = $__psbash_invocation_cwd; Set-Location -LiteralPath $__psbash_invocation_cwd -ErrorAction SilentlyContinue; ";
    }

    private static List<KeyValuePair<string, string>> CaptureEnvironment()
    {
        var entries = new List<KeyValuePair<string, string>>();
        foreach (DictionaryEntry e in Environment.GetEnvironmentVariables())
            if (e.Key is string name) entries.Add(new(name, e.Value as string ?? ""));
        return entries;
    }

    public async ValueTask DisposeAsync()
    {
        _slots.Writer.TryComplete();
        while (_slots.Reader.TryRead(out var w))
            if (w is not null) await w.DisposeAsync();
    }
}
