# PsBash production readiness review 2026 10 20

The review reproduced local data-loss and startup defects. The working tree now fixes gzip output preservation, unrelated-file cleanup, installer ownership and Windows path resolution, history startup recovery, and terminal replay/ownership. Unsupported safety options now fail explicitly. Imported-module gzip integrity and session discovery are now fixed; Windows variable-name case folding is documented as an intentional platform difference. Other platforms still need execution evidence.

Reviewed baseline: `d00a920` on Windows x64, followed by the working-tree fixes below. The user clarified that this is an entirely local product. All eleven J journeys and twelve R stories in [production user journeys](planning/production-user-journeys.md) were considered; R01–R12 are proposed remote-product scope and do not gate this release. Existing local terminal features remain in scope. Source review covers more scenarios than runtime checks; Linux and macOS were not exercised as PsBash execution hosts.

This document records baseline findings and subsequent fixes. The pre-existing untracked `BashParityGapDifferentialTests.cs` was preserved; its declarations are not proof of executed failures. Builds include it, but default cassette mode skips its live-only scenarios.

## Remediation status

| Finding | Working-tree result |
|---|---|
| F01 gzip | Existing-output and decode-exception data loss fixed: require force and stage before promotion. Truncated-stream integrity still needs correction; see F13. |
| F02 file replacement | Fixed: removed directory-wide filename cleanup. Only this operation's exact rollback path is discarded. Locked retained files may require explicit cleanup. |
| F03 safety options | Fixed by explicit rejection, not feature implementation: unsupported set options (including nounset, noclobber, noexec and noglob), dynamic options and unsupported combinations exit 2. Unsupported launcher flags and missing `-c` arguments fail before execution. PowerShell fallback cannot bypass rejection. Use separate supported `set` commands, e.g. `set -e`, and `set -- ...` for positional parameters. |
| F04 stalled replay | Fixed: five-second replay write timeout releases shared fanout; deterministic blocked-stream regression passes. |
| F05 competing brokers | Fixed: exclusive endpoint lease covers shell creation, listener lifetime and disposal. A losing serve cannot unlink the winner. Real-broker regression passes on Windows; Unix remains unexecuted here. |
| F06 installer ownership | Fixed: reject nonempty unmarked directories; retain unique upgrade backups; roll back failed promotion. Legacy unmarked packages must be moved aside explicitly. |
| F07 release gates | Updated: short shell safety/recovery scenarios and differential cassette replay block promotion. Broad interactive/PTY suite remains advisory. GitHub matrix execution still required. |
| F08 history startup | Fixed: directory creation is inside the recovery boundary; blocked persistence still permits a working prompt. |
| F09 session discovery | Fixed: `session list` unions host sidecars with terminal broker sockets and `session status` reports both halves (`terminal=running/stale/none`). Unit-tested; not exercised against a live broker on Unix. |
| F10 advertised module | README now installs PsBash, labels experimental/optional features, and requires PowerShell 7.4. Clean released-package acceptance remains outstanding. |
| F11 Windows HOME | Fixed: Unix package paths are resolved only on Unix. |
| F12 shared-user temp | Optional local hardening, not a release blocker for the stated product scope. No exploit was demonstrated. |
| F13 truncated gzip | Fixed in both modes. The standalone host enables strict validation at startup; `GzipIntegrity.OpenDecoder` (gzip and `tar -z`) probes whether strict mode took effect and otherwise verifies the CRC32/ISIZE trailer itself, failing closed (a multi-member archive is rejected in that fallback). |
| Windows variable case | Not fixed, documented: variables are process environment variables, which Windows folds. Listed in `intentional-differences.md`; a case-sensitive store is a separate design change. |

## Findings and release decisions

The descriptions below record the baseline defects and original closure criteria; the status table above records subsequent changes. P1/P2 labels describe baseline impact. Proposed remote-product features are outside the current release scope.

### F01 P1 Gzip overwrites existing output without force

**Affected stories:** J05, J03. **Evidence:** reproduced against this checkout, with GNU gzip comparison and filesystem-state checks.

`InvokeBashGzipCommand` parses `Force` but explicitly discards it. Compression opens `file.gz` with `File.Create`; decompression opens the suffix-stripped destination the same way before validating the compressed stream. Existing output is truncated without requiring `-f`. A failed decompression can therefore destroy an existing plain file while returning an error. Compression also removes the input after replacing the pre-existing archive.

Sources: [discarded force option](../src/PsBash.Cmdlets/InvokeBashGzipCommand.cs#L323), [decompression output](../src/PsBash.Cmdlets/InvokeBashGzipCommand.cs#L499), [compression output](../src/PsBash.Cmdlets/InvokeBashGzipCommand.cs#L590).

**Close when:** default behavior refuses or explicitly confirms existing outputs according to the supported noninteractive/interactive contract; `-f` is enforced; decoding or write failure preserves pre-existing data. Verify file contents, input retention, status and stderr against GNU gzip for both directions, corrupt/truncated streams, links, permissions and interrupted writes.

### F02 P1 Locked file replacement deletes unrelated matching siblings

**Affected story:** J05. **Evidence:** reproduced in an isolated Windows fixture. `cp` returned 0, replaced the intended target, and deleted the unrelated matching sibling.

When an overwrite fails on a locked Windows destination, `FileTransfer.ReplaceAside` calls `SweepAsides`. That scans the whole destination directory for `.*.psbash-replaced-*` and force-deletes every match except the current source. It does not establish that a match belongs to PsBash, to this destination, or to a completed replacement. An unrelated file matching that pattern can be deleted by `cp source target`. The existing test protects a matching source name but does not protect unrelated siblings. An unheld backup belonging to another in-progress replacement is also exposed by this policy.

Sources: [replacement cleanup](../src/PsBash.Cmdlets/FileTransfer.cs#L320), [directory-wide sweep](../src/PsBash.Cmdlets/FileTransfer.cs#L362), [existing source-only regression](../src/PsBash.Cmdlets.Tests/FileTransferTests.cs#L259).

**Close when:** cleanup acts only on replacements whose ownership and completed lifecycle are established. Preserve unrelated matching files and another operation's rollback copy. Test concurrent replacements and failure after moving the original aside.

### F03 P1 Shell safety options can be accepted without their safety behavior

**Affected stories:** J03, J05, J11. **Evidence:** reproduced against this checkout and compared with explicit GNU Bash invocations.

`EmitSet` turns unrecognized `set -o NAME` options into success, including `noclobber`. A script can enable it, overwrite an existing file with `>`, and receive success. `set -u` is translated to PowerShell strict mode, while ordinary Bash variables are emitted as environment-variable reads; that does not establish Bash's unbound-variable behavior. Separately, the launcher drops unknown options, including a standalone `-e`, instead of applying errexit or refusing it. These are safety-relevant differences from accepting a tuning option whose result is unchanged.

Sources: [set option handling](../src/PsBash.Transpiler/Parser/PsEmitter.cs#L3163), [launcher option handling](../src/PsBash.Shell/Args.cs#L169).

**Close when:** implement the supported options or reject unsupported ones before executing the script. Probe `set -u`, `set -o nounset`, `set -C`, `set -o noclobber`, `+` forms, bundles and launcher `-e` in command, stdin and file modes. Keep the documented `pipefail`/`PIPESTATUS` architectural exclusions explicit; this finding does not reclassify those exclusions as new bugs.

### F04 P1 A stalled reconnect can block every terminal client

**Affected stories:** J04, J11, R03, R05, R12. **Evidence:** source-confirmed unbounded-write path. The live Windows probe with a full replay buffer and a nonreading client did not induce backpressure; this is not a reproduced Windows failure. Unix behavior still requires execution.

`HandleClientAsync` holds the shared `_fanout` semaphore while writing as much as 1 MiB of scrollback to a new client. That write uses only the broker lifetime token. The five-second timeout in `SendLockedAsync` covers later broadcasts, not this initial replay. If the new client stops reading, the output pump and other joining clients wait behind it. The new client is not registered in `_clients` until replay finishes, so normal registered-client cleanup does not cover it. The final exit broadcast also waits on the same semaphore.

Sources: [initial replay under the shared gate](../src/PsBash.Shell/Sessions/TerminalBroker.cs#L159), [broadcast timeout](../src/PsBash.Shell/Sessions/TerminalBroker.cs#L249).

**Close when:** bound initial replay writes and release shared fanout promptly on a stalled/disconnected client. A per-client queue is one option. Verify that a stalled observer cannot indefinitely delay healthy clients, PTY draining, stop or shutdown, using an actually backpressured socket on each supported platform.

### F05 P1 Terminal broker startup has no single owner

**Affected stories:** R03, R05, R12. **Evidence:** source-confirmed; simultaneous cold attachment was not exercised in the Windows probe.

`ConnectOrStartBrokerAsync` performs connect-then-spawn without a cross-process startup lock. Two clients attaching to a cold name can both start brokers. Each broker spawns its interactive shell and then invokes `UnixSocketTransport.ListenAsync`, which deletes an existing socket path before binding. On Unix, a later binder can unlink a live broker's discovery address and put a different shell at that name; existing connections can still refer to the original broker. Disposal also deletes by pathname without checking ownership of the currently bound socket. The command-host path already has `HostSpawnLock` to prevent this class of race; the terminal path does not use an equivalent.

Sources: [unlocked broker startup](../src/PsBash.Shell/Sessions/TerminalClient.cs#L182), [shell before listener](../src/PsBash.Shell/Sessions/TerminalBroker.cs#L70), [unlink before bind](../src/PsBash.Core/Runtime/Ipc/UnixSocketTransport.cs#L32), [unconditional listener cleanup](../src/PsBash.Core/Runtime/Ipc/UnixSocketTransport.cs#L91).

**Close when:** serialize broker creation per endpoint, recheck health while holding the lock, and bind/clean up only a socket generation owned by that broker. A simultaneous cold-attach test must prove one broker, one shell, one stable identity and surviving discovery after either client detaches.

### F06 P1 Windows installation assumes ownership of the whole requested directory

**Affected story:** J01. **Evidence:** source-confirmed and reproduced by executing the unchanged Windows promotion branch against dummy directories. No full live installation was performed.

On Windows, `install.ps1 -InstallDir PATH` moves the entire existing directory to `PATH.previous`, deletes any pre-existing `PATH.previous` recursively, then puts the package at `PATH`. It performs no package-ownership check. Selecting a shared binary directory relocates unrelated tools out of PATH; a later installation can delete the previous directory containing those tools. The default application-specific directory reduces exposure, but the configurable directory path remains affected.

Sources: [install directory semantics](../install.ps1#L42), [previous directory deletion and replacement](../install.ps1#L117).

**Close when:** install into an owned package/version subdirectory and update an entry point. Refuse to replace an unowned existing directory or preserve all unrelated entries. Test fresh install, upgrade, shared bin directories, reinstallation, active hosts, interrupted promotion and rollback with an isolated HOME/PATH.

### F07 P1 Release gates still allow shell and differential failures

**Affected stories:** J01, J03, J04, J11. **Evidence:** source-confirmed; a current shell-suite failure was observed locally.

The release workflow now stages artifacts, resolves one source SHA and runs Core, Cmdlets and Host as blocking gates. Those address much of the previous review. However, both Shell.Tests and Differential.Tests still use unconditional `continue-on-error: true`. The release promotion job can therefore publish while either suite fails. The release's differential step also leaves the oracle in default cassette replay mode; its comment about Linux running a live oracle does not set `PSBASH_ORACLE_LIVE=1`. A separate weekly cassette audit is useful but does not gate the released SHA.

Sources: [shell gate](../.github/workflows/publish.yml#L323), [differential gate](../.github/workflows/publish.yml#L349), [default replay behavior](../src/PsBash.Differential.Tests/Oracle/AssertOracle.cs#L203), [weekly live audit](../.github/workflows/cassette-audit.yml#L22).

**Close when:** deterministic supported shell/lifecycle/parity scenarios block promotion. Provision the necessary platform/PTY/oracle cases separately and give individually quarantined cases explicit reasons and ownership. A broad advisory suite is not a substitute for a blocking subset. Require the installed package as well as the extracted archive to pass its first-command checks.

### F08 P2 Unavailable history directories bypass startup recovery

**Affected stories:** J06, J10, J11. **Evidence:** reproduced. A file occupying the history-directory path caused an unhandled IOException at startup and process exit `-532462766`, with `--noprofile` set.

`InteractiveShell.RunAsync` calls `Directory.CreateDirectory(psbashDir)` before the try/catch that falls back from unavailable SQLite history to memory. A non-creatable `.psbash` directory can therefore terminate shell startup even with `--noprofile`. Handling an inaccessible database does not cover an inaccessible history directory.

Source: [directory creation outside the recovery boundary](../src/PsBash.Host/Shell/InteractiveShell.cs#L65).

**Close when:** include directory resolution/creation in the degraded-persistence boundary, retain a usable prompt and emit a concise warning. Exercise absent/read-only parents, a file occupying `.psbash`, denied access and disk-full conditions.

### F09 P2 Session discovery excludes live terminal brokers

**Affected stories:** J11, R03, R11, R12. **Evidence:** reproduced while the broker was serving a working shell. Status returned 1 with `status: stopped`; list returned 0 with no entries.

`session attach` creates a terminal broker independently of the command host. `session list` enumerates command-host metadata files, and `session status` probes only that host. A terminal created by `attach` alone can be running while list omits it and status says stopped. `session start --idle-secs N` also configures the command host, while a separately started terminal broker reads its own process environment rather than that host's persisted idle setting.

Sources: [session list](../src/PsBash.Shell/SessionCommands.cs#L160), [status routing](../src/PsBash.Shell/SessionCommands.cs#L108), [independent broker idle setting](../src/PsBash.Shell/Sessions/TerminalClient.cs#L97).

**Close when:** expose command-host and terminal state explicitly under one stable session identity, including mode, PID/generation and effective lifetime policy. Test terminal-only, host-only, both running, failed broker, expired host and explicit stop.

### F10 P2 Advertised module and styling surfaces differ from default builds

**Affected stories:** J01, J02, J09, J10. **Evidence:** source-confirmed; current build command-discovery probe included.

The README instructs users to install `PsBash.Cmdlets` and invoke `Invoke-BashEval`. The default project excludes that cmdlet unless `EnableExperimentalBashEval=true`; the release workflow explicitly does not publish the standalone Cmdlets module. Styled-output cmdlets are separately excluded when the optional sibling Strata feed is unavailable, which is the documented default CI environment. Local builds with the sibling feed can therefore expose features that clean release builds omit. The PsBash manifest also advertises PowerShell 7.0 while the binary module targets .NET 8/10 and its own manifest specifies PowerShell 7.4+.

Sources: [README installation path](../README.md#L119), [experimental exclusion](../src/PsBash.Cmdlets/PsBash.Cmdlets.csproj#L24), [styling exclusion](../src/PsBash.Cmdlets/PsBash.Cmdlets.csproj#L46), [optional feed contract](../src/Strata.props#L6), [module prerequisite](../src/PsBash.Module/PsBash.psd1#L35), [binary module prerequisite](../src/PsBash.Cmdlets/PsBash.Cmdlets.psd1#L21).

**Close when:** publish one explicit support matrix, make onboarding match the actual distributable, and verify advertised commands from a clean staged PSGallery package and each release archive. Keep experimental eval opt-in unless it satisfies its own acceptance criteria; changing the docs is a valid way to remove an unsupported release promise.

### F11 P1 Windows installer depends on a Unix environment variable

**Affected story:** J01. **Evidence:** reproduced in an isolated child process with network functions disabled. The installer raised `Cannot bind argument to parameter 'Path' because it is null` before reaching either network stub.

`install.ps1` computes the Unix-only `$packageRoot` unconditionally using `Join-Path $env:HOME ...` when `INSTALL_ROOT` is absent. A Windows process with `USERPROFILE`/`LOCALAPPDATA` set but no `HOME` reaches a null `-Path` error before downloading anything. The Windows destination selection correctly uses `LOCALAPPDATA`, but that does not avoid the unused Unix path calculation. The installer probe removes `HOME` only from a new child process and replaces both network functions with fail-fast stubs.

Source: [unconditional Unix package root](../install.ps1#L51).

**Close when:** resolve only the active platform's installation paths, using the platform user-profile API where appropriate. Test a clean Windows environment without `HOME` or `INSTALL_ROOT`, an explicit InstallDir, and the Unix overrides.

### F12 Optional hardening: process substitution bypasses the private runtime directory

**Affected local scenario:** Unix host shared with a malicious co-resident user. **Evidence:** source-confirmed protection gap; no exploit or Unix permission test was performed. This is conditional hardening for the local product, not evidence of a remotely exposed service.

The module's `Invoke-ProcessSub` still creates files beneath `Path.GetTempPath()/ps-bash/proc-sub`, rather than the owner-validated per-user directory used by IPC. It creates that directory without an explicit private mode or ownership/link validation and opens its random output path with `FileMode.Create`, without exclusive creation or an explicit owner-only mode. A process substitution can contain sensitive producer output; a pre-created shared temp directory is outside the protections described for the canonical runtime directory. Random filenames do not establish directory ownership or confidentiality.

Sources: [process substitution directory and cleanup](../src/PsBash.Module/PsBash.psm1#L186), [output file creation](../src/PsBash.Cmdlets/ProcessSubFileWriter.cs#L31), [canonical private runtime contract](../src/PsBash.Core/Runtime/PsBashRuntimeDirectory.cs#L3).

**Close when:** use the verified per-user private runtime directory and exclusive private file creation, refuse foreign/link-controlled parents, and validate permissions under a permissive umask with a second local user. Replace the five-minute age assumption used for cleanup with actual ownership/lifetime tracking; on Unix an old still-active producer's file can otherwise be unlinked by a later substitution.

### F13 P1 Truncated gzip streams can be accepted as complete

**Affected story:** J05. **Status:** fixed in the standalone host and in imported
PowerShell module mode (trailer self-check, see the status table). A product probe accepted a gzip stream with four footer bytes
removed, returned 0 and deleted its archive input (`archiveRetained=false`, 37 output
bytes). The decoder's [strict-validation switch is off by default](https://raw.githubusercontent.com/dotnet/runtime/v10.0.0/src/libraries/System.IO.Compression/src/System/IO/Compression/DeflateZLib/DeflateStream.cs).

The owned host now sets that runtime option before compression initialization; truncated
input fails before promotion/deletion. Empty compressed files are rejected separately,
and empty plain files produce complete gzip members. Single and concatenated-member
acceptance tests cover the owned host. Enabling a process-wide cached switch inside an
imported PowerShell module cannot guarantee behavior after another caller initialized
compression, so that mode still needs its own integrity-validation solution. Until then,
`-k` retains archive inputs but does not establish that decoding was complete.

## Coverage of every documented user story

The local journey assessments below combine implementation review and the fixes above. They are not blanket acceptance of unexercised environments.

| Story | Current assessment and remaining acceptance work |
|---|---|
| J01 Install, verify, upgrade, remove | F06/F11 fixed with isolated installer tests; F07 gates and F10 onboarding corrected. Full downloaded/installed-package acceptance and uninstall still need execution evidence. Digest retrieval remains optional. |
| J02 Familiar commands and typed objects | Object-preserving command/pipeline implementations and extensive tests exist. Default module prerequisites/features need F10 corrected. Windows case-sensitive Bash variable names remain a compatibility gap; compare the explicit probe result. |
| J03 Agent and CI execution | F03 now refuses unsupported safety promises, and release gates were strengthened. Command/stdin/file checks pass. The baseline host-reuse failure came from its overlong temp fixture; its path was shortened for retesting. |
| J04 Interactive terminal | Line editing, completion, history and PTY implementations exist. F04/F05 corrected and local session tests pass on Windows. Platform terminal/cancellation/resize/paste/Unicode/accessibility acceptance remains separate. |
| J05 File mutation and archives | F01/F02 overwrite/deletion regressions fixed; F03 protections explicitly refused. F13 validation is fixed for the standalone host, still open for imported module mode. Existing tar link checks remain; hostile concurrent filesystem mutation is a separate exploitation scenario. |
| J06 Private history and recall | Leading-space/private-mode capture suppression and clear/delete operations exist. F08 affects degraded operation; F12 is a separate Unix temp-output boundary. `history -d` deletes the persistent row but leaves `_sessionHistory` used by `!!`/`!n`; full deletion semantics need alignment. Unix history-directory/file permissions need platform verification; no explicit owner-only creation is present in these stores. |
| J07 Directory navigation | Frecency, stale-path handling and completion paths exist. Validate failed jumps, cancellation, ambiguous matches and hooks. No new independent release blocker was established in this review. |
| J08 AI command assistance | Default-off egress, disable precedence, process limits and deliberate review are present. Validate configured/offline/malformed-provider paths and keyboard/terminal behavior. These protections do not establish that arbitrary generated commands are safe. |
| J09 Object inspection and actions | Original objects are retained in browse rows; destructive built-in actions return a safety preview before force execution. Styling availability depends on F10. Process actions use IDs without validating process start identity at execution; stale PID reuse requires a targeted acceptance test. |
| J10 Startup and extensions | RC sourcing and profile bypass exist. F08/F10 affect recovery/support. TOML configuration and DLL plugin discovery are specifications rather than implemented general extension loading; the plugin specification itself says this. |
| J11 Failure diagnosis and recovery | Frame bounds, watchdogs, logs and command-start acknowledgements exist. F04/F05/F08 fixed and gates improved. F09 discovery remains open; platform and release-artifact evidence is still required. |
| R01 Goal-oriented workspaces | Out of scope: proposed remote-product catalog/work-card requirements. |
| R02 Remote machine trust | Out of scope: optional SSH use delegates transport and trust to SSH. |
| R03 Detach and resume | Remote guarantees out of scope. Existing local detach/replay is covered under J04/J11 and F04/F05/F09. |
| R04 Agent attention | Out of scope: proposed remote attention and notification service. |
| R05 Multiple clients and input ownership | Remote writer-lease requirements out of scope. Local writable clients intentionally share input; read-only clients cannot type, resize or quit. |
| R06 Unknown command outcomes | Remote reconciliation/ledger out of scope. Existing local command-start acknowledgements remain relevant to J03/J11. |
| R07 Restart/reboot recovery | Out of scope: a local detached shell does not promise recovery of process memory after reboot. |
| R08 Remote files and services | Out of scope: proposed editing, transfer and port-forward APIs. |
| R09 Safe server update | Remote live-session preservation guarantees out of scope. Local installer data preservation is covered under J01/F06. |
| R10 Session data control | Remote export/retention/revocation requirements out of scope. Local history remains covered under J06. |
| R11 Headless session orchestration | Remote orchestration APIs out of scope. Existing local CLI discovery is covered by F09. |
| R12 Week-long operation and deliberate close | Remote soak commitments out of scope. Local replay bounds and explicit stop remain covered under J11; no week-long soak was performed. |

## Verification and evidence

Environment: Windows build 26200 x64, .NET SDK 10.0.113, runtime 10.0.13, PowerShell 7.6.7. Focused external comparisons used Git-for-Windows GNU Bash 4.4.23 and GNU gzip 1.11; they are not a Bash 5.2/GNU 9.4 platform certification. Local Strata packages were available, so styling cmdlets existed in this build; F10's missing styling surface concerns clean builds without that optional feed.

### Complete Windows solution run

`tman test` built successfully and returned 1 because two tests failed. All seven test projects completed. Total: **13,667 passed, 145 skipped, 2 failed**.

| Project | Passed | Failed | Skipped |
|---|---:|---:|---:|
| Shell | 724 | 1 | 34 |
| Core | 2195 | 0 | 3 |
| Cmdlets | 8205 | 1 | 41 |
| Differential | 1881 | 0 | 41 |
| Canary | 13 | 0 | 25 |
| Escalation | 23 | 0 | 0 |
| Host | 626 | 0 | 1 |

The differential run used default cassette replay. Live-only cases, including the pre-existing untracked known-gap cases, were skipped. Canary's unavailable eval-mode checks were also skipped; this is not evidence that the advertised eval entry point passed.

The failures were `ProcessLifecycleTests.SequentialCalls_FromOneParent_ReuseOneHost` (first invocation returned 125) and `ProcessSubStreamingTests.ProducerOutput_IsOnDisk_WhileTheProducerIsStillRunning` (`False True 5408895`). The former creates an overlong temporary root; the matching probe reported the socket-length diagnostic before host startup. Its fixture leaf was shortened. The streaming test passed when rerun in isolation, as did the smaller streaming probe (`mid=393216`, `final=498894`); a product streaming defect was not established.

### Fix verification

Regression tests first reproduced five overwrite/deletion failures, the history-directory
startup crash, eight unsupported-option failures, and both empty-gzip failures. The fixes
then passed the relevant checks:

| Check | Result |
|---|---|
| Full Core.Tests, including final static/quoted/unknown option guards | 2,215 passed, 3 skipped |
| Gzip and file-transfer classes, including empty-file fixes | 46 passed |
| Shell, history, session and host-reuse checks before the final gzip policy changes | 171 passed |
| Initial host strict-validation/quoted-option check | 8 passed |
| Final shell, history, session, host-reuse and gzip-policy checks | 176 passed |
| Exact release-blocking shell subset after all unsupported-option guards | 85 passed |
| Full differential replay before final quoted-option/gzip refinements | 1,881 passed, 41 skipped |
| Final focused byte/parity rerun after all source changes | 66 passed |
| Initial complete Pester gate, including installer ownership/rollback tests | 1,085 passed, 6 skipped |
| Final complete Pester gate after all source changes, including net8.0 rebuild | 1,085 passed, 6 skipped |
| Workflow YAML and blocking safety/replay step configuration | Validated locally; GitHub matrix not executed |

This is not a claim that the entire solution suite was rerun after every fix. No Linux/macOS
runtime or downloaded-release acceptance run was performed.

### Focused production probes

`tman dev artifacts/production-audit-2026-10-20/run-probes.sh` completed with exit 0. That means the diagnostic driver completed; the intentionally failing product behaviors below remain defects. The probes used a fresh temporary fixture and their own broker. No user installation, PATH or profile was changed. The installer ownership check ran only its original promotion branch against dummy files.

| Check | Observed PsBash result | Comparison or implication |
|---|---|---|
| First real command | Exit 0; `ready` and count 3 | Baseline execution works in the fixture |
| `set -u` followed by an unset variable | Exit 0; `[]` then `after` | Bash returned nonzero and did not execute the following echo |
| Launcher `-e -c 'false; echo after'` | Exit 0; `after` | Bash with errexit returned 1 and printed nothing |
| `set -o noclobber` before replacing a file | Redirect status 0; contents `replaced` | Bash redirect status 1; original bytes retained |
| `-c` with no command and closed stdin | Exit 0, no diagnostic | Missing command is silently accepted |
| Differently cased variable names | `two two` | Bash: `one two` |
| Locked-target `cp` | Exit 0; unrelated matching file deleted | Confirms F02 outside the requested operand set |
| `gzip payload.txt` with an existing archive | Exit 0; old archive replaced and source deleted | GNU gzip returned 2 and retained both original files |
| Invalid gzip input with an existing plain destination | Exit 1; original destination became empty | GNU gzip returned 1 and retained the original destination bytes |
| Installer without HOME/INSTALL_ROOT | Null-path failure before network | Confirms F11 on Windows |
| Installer promotion into a shared dummy directory | Unrelated tool moved; unrelated `.previous` backup deleted | Confirms F06's ownership assumptions |
| History directory occupied by a file | Unhandled startup exception with `--noprofile` | Confirms F08 |
| Working terminal without a command host | List empty; status reports stopped | Confirms F09 |
| Full Windows replay with a nonreading client | Healthy joining client still reached its marker | Did not reproduce F04; no recovery claim is made from the subsequent already-consumed marker |
| Default eval command discovery | `Invoke-BashEval=False`; source/syntax cmdlets present | Confirms the default-build portion of F10 |

Raw evidence is retained locally in `artifacts/production-audit-2026-10-20/`: `solution-test.log`, `solution-test-failures.log`, `probe-results.json`, and the probe scripts. These artifacts are ignored by Git. The source references and scenarios above carry the durable review; retain the artifacts separately if the review is shared.

## Order of work before release

Resolve F09 for complete local session discovery and F13 for imported-module gzip integrity. Verify Linux/macOS behavior and clean released artifacts before platform signoff. Windows case-sensitive Bash variable names remain a compatibility gap (`audit_lower` and `AUDIT_LOWER` share one environment slot). Broad PTY suite flakes need triage even though the short safety/recovery subset now blocks release. R01–R12 remain out of scope; writer leases, remote trust catalogs and remote orchestration are not requirements for this local product.
