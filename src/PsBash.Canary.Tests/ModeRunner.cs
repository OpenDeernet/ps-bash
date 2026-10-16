using System.Diagnostics;
using PsBash.Testing;

namespace PsBash.Canary.Tests;

/// <summary>
/// Mode identifiers for the QA rubric Directive 4 mode interaction matrix.
/// M4 (interactive TTY) is intentionally excluded — too flaky for CI.
///
/// Aliased onto the shared <see cref="PsBashMode"/> so the canary suite and
/// the unified runner agree on mode numbering.
/// </summary>
public enum Mode
{
    M1_CFlag = (int)PsBashMode.M1_CFlag,        // ps-bash -c script
    M2_StdinPipe = (int)PsBashMode.M2_StdinPipe, // echo script | ps-bash
    M3_FileArg = (int)PsBashMode.M3_FileArg,     // ps-bash script.sh
    M5_InvokeEval = (int)PsBashMode.M5_InvokeEval,  // Invoke-BashEval cmdlet (in-process)
    M6_InvokeSource = (int)PsBashMode.M6_InvokeSource // Invoke-BashSource cmdlet (in-process, .sh file)
}

/// <summary>
/// Captured result of running a bash script in one execution mode.
/// </summary>
public sealed record ModeResult(
    Mode Mode,
    string Stdout,
    string Stderr,
    int ExitCode,
    long WallMs);

/// <summary>
/// Dispatches a bash script across all active modes (M1, M2, M3, M5, M6).
///
/// REFACTOR-3: the external-process modes (M1/M2/M3) now delegate to the
/// shared <see cref="PsBashRunner"/> / <see cref="ProcessSpawn"/> helpers, so
/// the Process.Start + pipe-drain + timeout + kill-tree loop is no longer
/// duplicated here. The 60 s canary timeout is expressed as a builder call.
/// The in-process cmdlet modes (M5/M6) stay local — they are a different
/// shape (no Process.Start) and run through <see cref="CanaryPwshFixture"/>.
///
/// PROCESS SPAWN CONTRACT (process_spawn_contract memory note):
///   Every external spawn uses a 60 s hard cap timeout.
///   On timeout: Kill(entireProcessTree: true) in finally, then fail.
///   The Kill fires even if the await is cancelled.
///   (Contract is now enforced once, in PsBash.Testing.ProcessSpawn.)
/// </summary>
public sealed class ModeRunner
{
    public static readonly TimeSpan DefaultTimeout = TimeSpan.FromSeconds(60);

    private readonly PsBashRunner _baseRunner;
    private readonly string? _psBashPath;

    public ModeRunner()
    {
        // Keep the warm shared daemon (per-invocation cold-starts a host for every
        // test x mode: 6 min instead of ~1.5), but let it idle out 30 s after the
        // last canary instead of the default 600 s, so a run leaves no host behind.
        _baseRunner = PsBashRunner.Create()
            .WithTimeout(DefaultTimeout)
            .WithEnv(new Dictionary<string, string> { ["PSBASH_HOST_IDLE_SECS"] = "30" });
        _psBashPath = _baseRunner.TryResolveBinary();
    }

    /// <summary>
    /// Path to the ps-bash binary. Null when not built yet — spawn modes skip.
    /// </summary>
    public string? PsBashPath => _psBashPath;

    /// <summary>
    /// Runs <paramref name="script"/> in every mode available here and returns one result per
    /// mode that ran. An unavailable mode is left out, not reported as a skip: a skip sentinel
    /// in this list made each `*_AllModes` test Skip.If the WHOLE test and discard the modes
    /// that did run — M5 (Invoke-BashEval) ships only in the experimental module, so all 25
    /// AllModes tests skipped everywhere, ran nothing, and still paid ~6 s each. Only when no
    /// mode at all is available does the list hold skip sentinels (ExitCode = -999).
    /// </summary>
    public async Task<IReadOnlyList<ModeResult>> RunAllAsync(
        string script,
        TimeSpan? timeout = null)
    {
        var modes = AllModes.Where(IsAvailable).ToList();
        if (modes.Count == 0)
            return AllModes.Select(m => Unavailable(m)).ToList();
        return await Task.WhenAll(modes.Select(m => RunAsync(m, script, timeout)));
    }

    /// <summary>
    /// Runs <paramref name="script"/> in one mode, or returns the skip sentinel (ExitCode = -999)
    /// when that mode is unavailable here.
    /// </summary>
    public Task<ModeResult> RunAsync(Mode mode, string script, TimeSpan? timeout = null)
    {
        if (!IsAvailable(mode)) return Task.FromResult(Unavailable(mode));
        var runner = timeout is { } t ? _baseRunner.WithTimeout(t) : _baseRunner;
        return mode switch
        {
            Mode.M5_InvokeEval => RunM5Async(script),
            Mode.M6_InvokeSource => RunM6Async(script),
            _ => RunSpawnModeAsync(runner, mode, (PsBashMode)(int)mode, script),
        };
    }

    private static readonly Mode[] AllModes =
        [Mode.M1_CFlag, Mode.M2_StdinPipe, Mode.M3_FileArg, Mode.M5_InvokeEval, Mode.M6_InvokeSource];

    private bool IsAvailable(Mode mode) => mode switch
    {
        Mode.M5_InvokeEval => InProcessCmdlets.Value.Eval,
        Mode.M6_InvokeSource => InProcessCmdlets.Value.Source,
        _ => _psBashPath is not null,
    };

    private static ModeResult Unavailable(Mode mode) => new(mode, "", mode switch
    {
        Mode.M5_InvokeEval => "Invoke-BashEval not available (experimental module only)",
        Mode.M6_InvokeSource => "Invoke-BashSource not available",
        _ => "ps-bash binary not found",
    }, -999, 0);

    // Which in-process cmdlets the canary runspace exports, asked once per process: the per-call
    // Get-Command probe built a whole runspace (module load included) just to learn the answer.
    private static readonly Lazy<(bool Eval, bool Source)> InProcessCmdlets = new(() =>
    {
        using var pwsh = CanaryPwshFixture.Create();
        pwsh.Commands.Clear();
        pwsh.AddScript("[bool](Get-Command Invoke-BashEval -ErrorAction SilentlyContinue); " +
                       "[bool](Get-Command Invoke-BashSource -ErrorAction SilentlyContinue)");
        var found = pwsh.Invoke();
        return (found.Count > 0 && found[0].BaseObject is true, found.Count > 1 && found[1].BaseObject is true);
    });

    // -------------------------------------------------------------------------
    // M1/M2/M3: external-process modes — delegate to the shared PsBashRunner.
    // -------------------------------------------------------------------------
    private static async Task<ModeResult> RunSpawnModeAsync(
        PsBashRunner runner, Mode mode, PsBashMode psBashMode, string script)
    {
        var result = await runner.WithMode(psBashMode).RunScriptAsync(script);
        return new ModeResult(mode, result.Stdout, result.Stderr, result.ExitCode, result.WallMs);
    }

    // -------------------------------------------------------------------------
    // M5: Invoke-BashEval cmdlet (in-process PowerShell SDK)
    // -------------------------------------------------------------------------
    private static async Task<ModeResult> RunM5Async(string script)
    {
        return await Task.Run(() =>
        {
            var sw = Stopwatch.StartNew();
            try
            {
                using var pwsh = CanaryPwshFixture.Create();
                pwsh.Commands.Clear();

                // Clear errors that accumulated during fixture setup so we only see script errors
                pwsh.Streams.Error.Clear();

                pwsh.AddCommand("Invoke-BashEval").AddParameter("Source", script);
                var results = pwsh.Invoke();
                sw.Stop();

                var stdout = string.Join("\n", results.Select(r => r.ToString()));
                var stderr = string.Join("\n", pwsh.Streams.Error.Select(e => e.ToString()));

                return new ModeResult(Mode.M5_InvokeEval, stdout, stderr, InProcessExitCode(pwsh), sw.ElapsedMilliseconds);
            }
            catch (Exception ex)
            {
                sw.Stop();
                return new ModeResult(Mode.M5_InvokeEval, "", ex.Message, 1, sw.ElapsedMilliseconds);
            }
        });
    }

    /// <summary>
    /// The script's exit status in an in-process mode: <c>$LASTEXITCODE</c>, as the spawn modes
    /// report the process exit code. It used to be "1 if anything reached the error stream",
    /// which made `echo err &gt;&amp;2` (bash exit 0) fail every AllModes check once M6 ran.
    /// </summary>
    private static int InProcessExitCode(System.Management.Automation.PowerShell pwsh)
        => pwsh.Runspace.SessionStateProxy.GetVariable("LASTEXITCODE") is int code ? code : 0;

    // -------------------------------------------------------------------------
    // M6: Invoke-BashSource cmdlet (in-process, reads from .sh file)
    // -------------------------------------------------------------------------
    private static async Task<ModeResult> RunM6Async(string script)
    {
        var tempFile = Path.Combine(Path.GetTempPath(), "ps-bash", $"canary-m6-{Guid.NewGuid()}.sh");
        Directory.CreateDirectory(Path.GetDirectoryName(tempFile)!);
        try
        {
            await File.WriteAllTextAsync(tempFile, script);
            return await Task.Run(() =>
            {
                var sw = Stopwatch.StartNew();
                try
                {
                    using var pwsh = CanaryPwshFixture.Create();
                    pwsh.Commands.Clear();
                    pwsh.Streams.Error.Clear();
                    pwsh.AddCommand("Invoke-BashSource").AddParameter("Path", tempFile);
                    var results = pwsh.Invoke();
                    sw.Stop();

                    var stdout = string.Join("\n", results.Select(r => r.ToString()));
                    var stderr = string.Join("\n", pwsh.Streams.Error.Select(e => e.ToString()));

                    return new ModeResult(Mode.M6_InvokeSource, stdout, stderr, InProcessExitCode(pwsh), sw.ElapsedMilliseconds);
                }
                catch (Exception ex)
                {
                    sw.Stop();
                    return new ModeResult(Mode.M6_InvokeSource, "", ex.Message, 1, sw.ElapsedMilliseconds);
                }
            });
        }
        finally
        {
            try { File.Delete(tempFile); } catch { }
        }
    }
}
