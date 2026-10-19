# Known Issues

## Production blockers reviewed 2026-10-18

The [production readiness review](production-readiness-review-2026-10-18.md)
records evidence, affected journeys, and closure criteria. Status:

- **Fixed — archive extraction (B01):** `tar -x` now refuses to write through an
  existing symlink/junction ancestor or final component (nonzero exit, outside
  content untouched). Residual: a link swapped in between the check and the open
  by a concurrent attacker is narrowed, not eliminated; still extract untrusted
  archives into a fresh directory with trusted ancestors.
- **Fixed — installers (B02):** `install.sh` / `install.ps1` install the complete
  package into a versioned directory, run a real command before switching, verify
  the published digest, and keep the previous version. Unsupported platforms fail
  with a named error.
- **Fixed — release integrity (B03–B05):** binaries are staged as workflow
  artifacts and only promoted after every gate passes; every job builds the tag's
  single resolved SHA; Core, Cmdlets and Host tests block. Shell and Differential
  stay advisory: on 2-core Linux runners some interactive/PTY tests stall (the
  prompt prints one character then nothing; a 50,000-term `[ a -o ... ]`
  hostile-input test exits 125). Harness waits now extend only while the machine
  is measurably starved, so these are open product-or-environment questions, not
  timeouts.
- **Partly fixed — history privacy (B08):** a line starting with a space, or any
  line while `PSBASH_HISTORY_PRIVATE=1`, is never recorded; an unopenable history
  DB degrades to in-memory with a warning. `history`, `history -d ID` and
  `history -c` list and delete (`-c` runs `secure_delete` + WAL truncate + VACUUM).
  Still open: retention policy; bash-compatible `history` flags beyond these.

- **Partly fixed — durable sessions and per-session concurrency (B06, B07):** `ps-bash session start/list/status/stop NAME` + `PSBASH_SESSION=NAME` give a host that outlives its launchers and runs concurrently with other sessions ([sessions](sessions.md)). Still open: a reattachable PTY/screen owned by the session. Original note:
  product-scope decisions, not shell bugs. The warm host is not a durable session
  manager, and commands sharing one daemon run serially. The
  [journey contract](planning/production-user-journeys.md) labels proposed remote
  behavior separately from current capabilities.
## Architecture differences (not bugs — won't fix)

These diverge from bash because of the PowerShell pipeline model, not missing
effort. A bash pipe is N OS processes, each with an exit status the shell
`waitpid`s into `PIPESTATUS`. A PowerShell pipeline is one cooperative object
stream with a single `$LASTEXITCODE` and record-interleaved stages — there is no
per-stage process status to collect, and "stage N's exit code" is not
well-defined mid-stream. The following three are one knot:

- **`set -o pipefail` / `$PIPESTATUS`** — standalone `set -o pipefail` maps only
  to `$ErrorActionPreference='Stop'`; per-stage exit codes are not tracked.
  `false | true; echo $?` prints `0` (last-command-wins), not `1`.
- **Broken pipe / SIGPIPE** — `cmd | head -1` does not deliver SIGPIPE to the
  producer; exit-141 semantics do not exist. Mapped cmdlets get partial
  early-stop via `StopUpstreamCommandsException` (from `-First N`), but that is
  not SIGPIPE.
- **The trade-off** — the only route to true `PIPESTATUS` is to stop emitting
  bash pipes as PowerShell pipelines (run each stage as a separately-captured
  invocation), which kills streaming and breaks broken-pipe behavior. PsBash
  keeps streaming; these stay won't-fix.

Public-facing summary: `docs/src/content/docs/comparison.mdx` ("When Bash Wins").
Current behavior is frozen by skipped goldens in
`src/PsBash.Differential.Tests/PipeDifferentialTests.cs`.

## `eval "$(cmd)"` — runtime eval (resolved)

**Status:** supported as of REFACTOR-5a-2. Supersedes the v0.8.14
parse-time-rejection design.

**History:** v0.8.14 resolved `eval` entirely at parse time in
`PsEmitter.EmitEval` and *rejected* dynamic eval bodies — `eval "$(cmd)"`,
`eval \`cmd\``, `eval $((expr))`, `eval <(cmd)` — with a `ParseException`,
because the transpiler could not reach a body computed at runtime. The
rationale was avoiding a nested-ps-bash-subprocess hang.

**Current behavior:** `EmitEval` still folds **static** eval bodies (literals,
quoted literals) inline at parse time via `TryReconstructBashSource` — lossless
and zero-runtime-cost. But when any arg requires runtime expansion (command
sub, arithmetic, process sub, variable, glob, brace expansion) the emitter now
emits an **in-process runtime eval block** instead of rejecting:

```powershell
$__psbash_eval_src = @(<args>) -join ' '
# depth-guarded (limit 5), then:
$__psbash_eval_pwsh = [PsBash.Core.Transpiler.BashTranspiler, PsBash.Transpiler]::Transpile(
    $__psbash_eval_src, [PsBash.Core.Transpiler.TranspileContext, PsBash.Transpiler]::Eval)
Invoke-Expression $__psbash_eval_pwsh
```

The eval body is re-transpiled **in-process** by `BashTranspiler` inside the
ps-bash-host SDK runspace and run via `Invoke-Expression`. No nested ps-bash
subprocess is spawned, so the v0.8.14 hang risk does not return. A depth probe
(`$global:__BashEvalDepth`, limit 5) guards against runaway `eval`-of-`eval`
recursion.

`fnm env --shell bash`, `direnv hook bash`, `ssh-agent -s`, and `dircolors`
shell-init idioms work directly — no manual inlining required.

**Perf:** the fnm-shaped payload (`eval $(printf 'export ...\n...')`) runs well
under the 15 s hang-detection budget — sub-second in local runs. The 15 s
budget on the eval differential tests is a *hang* oracle, not a perf target:
REFACTOR-7 made non-interactive modes spawn a private host per invocation, so
each `-c` pays a single-digit-second host cold-start cost that a 2 s budget
would conflate with a genuine eval hang.

**Regression guards** (in `BashTranspilerTests`):
- `Transpile_EvalWithCommandSubstitution_EmitsRuntimeSubexpression`
- `Transpile_EvalWithMappedCommandSubstitution_TranspilesInner`
- `Transpile_EvalWithBackquoteCommandSub_EmitsRuntimeSubexpression`
- `Transpile_EvalWithArithmeticExpansion_EmitsRuntimeSubexpression`
- `Transpile_EvalWithVariableReference_ForwardsToRuntimeEval`

Differential (bash-oracle) guards in `EvalDifferentialTests`:
- `Differential_Eval_CmdSubMultilineExports_DoesNotHang`
- `Differential_Eval_QuotedCmdSubMultiline_DoesNotHang`
- `Differential_Eval_FnmShapedPayload_DoesNotHang`
- `PsBash_Eval_CmdSubMultiline_WallTimeUnder15000ms`
