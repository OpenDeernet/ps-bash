# Production readiness review — 2026-10-18

**Verdict:** do not ship the affected archive-extraction and Unix installer paths as production-ready. Do not describe the current PsBash host as a durable remote-session manager.

Reviewed checkout: `f8f35e00df15ec9d3a13ac92ab294b9a1655ecd1`, Windows x64. This is an audit and documentation change; the runtime findings below remain open.

## Scope and evidence

The requested product competes with Herdr through advanced remote session management. This checkout describes a Bash-to-PowerShell runtime, PowerShell module, and local interactive shell. A separate checkout at `C:\Users\andyb\work\beagle-term` appears to contain the terminal product. Its ownership of the requested work has not been confirmed; no changes were made there. The proposed remote journeys here are requirements, not claims that PsBash implements them or that the other product lacks them.

Reviewed the README, install/agent/shell guides, subsystem specs, CI/release workflows, launcher/PTY path, IPC transports, host lifetime, worker scheduling, history persistence, AI-assist activation, and archive extraction. This is a focused source review and selected runtime verification, not a full security assessment or a full cross-platform test run. Existing untracked `BashParityGapDifferentialTests.cs` was left untouched and is not evidence of verified failures.

Evidence labels:

- **Reproduced:** executed against this checkout through `tman`.
- **Source-confirmed:** demonstrated by control flow/configuration; no live release or installation was performed.
- **Product gap:** absent from the reviewed PsBash surfaces; conditional on assigning the remote product responsibility to this repository.
- **Unverified:** requires a platform, service, or broader test run not exercised here.

Severity: P1 blocks the affected production journey; P2 needs correction before broad adoption. A conditional product gap is a release requirement, not a newly discovered shell regression.

## Findings

| ID | Priority | Evidence | Affected journey | Finding |
|---|---|---|---|---|
| B01 | P1 | Reproduced | J05 | `tar` follows an existing junction out of the extraction destination |
| B02 | P1 | Source-confirmed | J01 | Unix installers discard the required host/runtime files |
| B03 | P1 | Source-confirmed | J01, R09 | Binary assets are published before release tests finish |
| B04 | P1 | Source-confirmed | J01, R09 | Manual release version and checked-out source can disagree |
| B05 | P1 | Source-confirmed | J03, J04, R03 | Release verification does not block on shell/differential failures or explicitly run Host.Tests |
| B06 | Conditional launch blocker | Product gap | R01–R12 | Current host lifetime/transport does not implement durable remote sessions |
| B07 | Conditional P1 | Source-confirmed | R04, R05 | Commands sharing one daemon execute through a single process-wide gate |
| B08 | P2 now; conditional P1 for managed sessions | Source-confirmed | J06, R10 | History persistence lacks a user-facing private-session/deletion contract |

Journey IDs and acceptance criteria: [production user journeys](planning/production-user-journeys.md).

### B01 — Extraction containment checks do not resolve filesystem links

`src/PsBash.Cmdlets/InvokeBashTarCommand.cs`: `TryResolveWithinDest` and `PathIsWithin` compare full path strings; `DoExtract` opens the resulting path with `File.Create`. An existing parent directory can be a junction/symlink. Its lexical path is inside the destination while the actual write target is outside it. `ExtractLink` rejects escaping links supplied by the archive, but that does not protect against an existing link on disk.

**Reproduction:** create a fresh temporary root with sibling `extract/` and `outside/` directories. Add a Windows junction `extract/pivot` pointing to `outside`. Create a tar containing the regular entry `pivot/marker.txt` with harmless content `audit-marker`. Run this checkout using `tman dev -c "tar -xf '<archive>' -C '<extract>'"`.

**Observed:** exit `0`; `outside/marker.txt` exists with `audit-marker`. The fixture wrote only inside its own temporary root. The local probe is `artifacts/production-audit/Probe-TarContainment.ps1`. A corresponding GNU tar probe in Ubuntu 24.04 through WSL returned `2`, reported `Cannot open: Invalid cross-device link`, and did not write outside the destination. That oracle exercises a Unix symlink rather than a Windows junction; Linux PsBash extraction itself was not run.

**Impact:** extracting an untrusted archive into a tree containing a redirected ancestor can overwrite another writable file as the current user. This is not evidence of privilege escalation or unauthenticated network access.

**Defensive action:** inspect unfamiliar archives and extract them into a fresh directory whose parents are trusted and contain no filesystem redirects. Do not extract untrusted content into an existing workspace. A new directory alone is not a defense if an untrusted actor can alter its ancestors concurrently.

**Close when:** extraction opens paths with enforced containment, covering reparse points/symlink ancestors and the final target, including link chains and replacement races. Add regression tests for pre-existing directory links, a pre-existing file link, archive-created pivots, hardlinks, and ordinary nested files on Windows and Unix. A second `GetFullPath` comparison is insufficient. Refusal must return nonzero and leave outside content unchanged.

### B02 — Installed Unix layout differs from the tested package

`install.sh` extracts the release archive into a temporary directory and copies only `ps-bash` to the installation directory. The non-Windows branch of `install.ps1` also copies only the launcher. The release archive includes `ps-bash-host`, managed assemblies, native/runtime assets, and metadata beside it. `IpcWorker.EnsureHostReachableAsync` requires the host binary to exist. Both installers can report completion after a version-only check; `install.sh` explicitly ignores a failed version invocation.

The release matrix produces `win-x64`, `linux-x64`, and `osx-arm64`; installer architecture detection also admits combinations for which this workflow produces no asset. That should be a named unsupported-platform error rather than an unexplained download failure.

**Close when:** install the entire verified package into a versioned directory; preserve executable permissions for both programs; switch the entry point only after a real `-c` smoke passes; keep the previous installation recoverable. Test fresh install, upgrade, unsupported RID, failed download, missing host, invalid archive, and rollback using temporary HOME/PATH. Fail installation on smoke failure. See [installation guide](install.md) for the current manual workaround.

### B03 — Asset visibility precedes the test gate

`.github/workflows/publish.yml`: `release-tag` creates a public release for a pushed tag. `build-binaries` needs only `release-tag`, and its `Upload release asset` step uploads each platform archive. The later `publish` job needs both `test` and `build-binaries`, which gates PSGallery/NuGet but does not retract an already uploaded binary if tests fail. A `/releases/latest` installer can therefore encounter a release while it is incomplete or unqualified.

**Close when:** build and test immutable staging artifacts first; run extracted-package smoke tests; only a final job promotes a complete release after every required platform and test gate succeeds. Assert in workflow checks that a failed gate cannot make an asset discoverable to the default installer. Preserve the last good release on failure.

### B04 — Manual release input does not select source

`publish.yml` accepts a manual `version`, derives `tag=v<version>`, and stamps it into binaries. Checkout steps use `actions/checkout@v4` without a tag/SHA derived from that input. A dispatch on a different branch/ref can therefore label those sources as another version. Unlike a tag push, manual dispatch also does not create the release in `release-tag`; it assumes one already exists when uploading.

**Close when:** resolve and verify one immutable commit for the requested tag, check it out in every build/test/publication job, and include that SHA in provenance. Reject nonexistent/mismatched tags before publishing anything. The tested archive digest must identify the same bytes subsequently promoted.

### B05 — Important runtime failures remain advisory at release time

`publish.yml` sets `continue-on-error: true` for Cmdlets.Tests, Shell.Tests, and Differential.Tests. It builds the host but has no explicit Host.Tests execution step. The regular `build.yml` gates Core, security probes, and Cmdlets.Tests, but keeps its broader suite non-blocking and soft-fails the macOS ARM job. The release workflow is separately tag/manual driven and does not verify a successful regular Build run for its exact SHA.

This is a gate defect, not evidence that every advisory test currently fails. The macOS comment records an earlier startup abort; this audit did not reproduce it. Existing staged-package smoke testing is useful, but does not test the actual extracted/downloaded installer output or all interactive/lifecycle behavior.

**Close when:** deterministic host/IPC, cancellation, environment isolation, filesystem security, and supported-platform launch tests gate the exact release SHA. Move legitimately unavailable PTY/oracle cases into a separately provisioned job with explicit skip reasons. Keep the failure signal for supported scenarios blocking rather than soft-failing an entire platform. Exercise the archive after extraction and the installer after installation.

### B06 — A warm execution host is not a durable remote terminal

`IpcTransportFactory` accepts local `pipe:` and `unix:` schemes. Interactive `Program` installs `ParentDeathWatcher`; the launcher owns the PTY via `PtySpawner`. Framed `Connection` cancels abandoned work after client disconnect. `SessionAnchorWatcher` shortens daemon idle life when its ancestor session ends. These are sensible shell cleanup semantics; changing them globally would risk orphaning ordinary agent invocations.

The reviewed PsBash CLI/specs do not define a machine catalog, SSH bootstrap/trust flow, durable terminal discovery/attach, authoritative workspace snapshots, multiple-client input arbitration, agent attention, or headless orchestration API.

**Close when:** assign these responsibilities explicitly to a session product or a separate managed-session mode. Let its server own live PTYs/processes independently of any viewer; retain current invocation cancellation behavior for ordinary `-c`. Validate all R journeys before describing the product as a Herdr competitor. Do not substitute increasing the idle timeout for persistence.

### B07 — Warm worker count is not execution concurrency

`SdkWorker._globalExecGate` serializes both execution entry points because process environment and working directory are global. `WorkerPool` documents that isolated runspaces are not parallel command execution. Independent session anchors normally use separate hosts; the concern is commands intentionally routed to the same daemon, including via `PSBASH_SESSION` or an explicit endpoint.

**Impact:** a long-running command can delay other commands sharing that daemon. Watchdog termination of a poisoned daemon is also a failure boundary larger than one command. No latency benchmark was run in this review.

**Close when:** the session product isolates execution environments/processes and provides per-session fairness/cancellation. Existing `PSBASH_PER_INVOCATION=1` offers process isolation for command invocations at a cold-start cost; it is not durable session management. Do not remove the gate without replacing the process-global state model. Acceptance: a long command in session A cannot prevent session B from reaching its prompt, receiving input, or cancelling its own command.

### B08 — Private operation and history deletion need a contract

`InteractiveShell` creates `~/.psbash/history.db`; `LineEditor.RecordCommandAsync` passes full command text and cwd to `IHistoryStore`; `SqliteHistoryStore.RecordAsync` stores them. The reviewed path has no private-session/leading-space filter before persistence, and `IHistoryStore` exposes record/search/suggestions without deletion. `PSBASH_HOME` changes location, not the recording policy. This is conventional local-shell storage, but is insufficiently specified for synchronized or remotely managed sessions.

**Defensive action:** avoid typing secrets as literal command arguments; use the tool's protected credential input. Treat history, SQLite WAL/SHM files, `.corrupt` recovery copies, transcripts, and exported diagnostics as sensitive. AI assistance is opt-in and sends the current input to an external provider when enabled.

**Close when:** document and implement private mode before capture, inspect/delete controls, retention and export policy, ownership/permissions, and clear separation between per-host records. State what can and cannot be erased from backups/WAL/provider logs. Do not promise automatic redaction finds every secret. Failure to open history must leave a usable shell with visible degraded-persistence feedback. See J06 and R10.

## Existing defenses and limits

| Boundary | Existing evidence | What it protects; practical limit |
|---|---|---|
| Local IPC access | `NamedPipeTransport.BuildPipeSecurity`, `Runtime/PsBashRuntimeDirectory.cs`, `UnixSocketTransport.ListenAsync` | Windows ACLs and canonical Unix private directory/socket permissions restrict local access. Explicit endpoint overrides require their own review; these are not remote authentication or multi-user authorization. |
| Malformed IPC | `HostProtocol.MaxLineBytes`, request-read deadline in `Connection` | Bounds individual frames and initial requests. Does not establish aggregate/session quotas for a future remote gateway. |
| Parser/resource exhaustion | `NestingGuard`, brace-expansion bound, `HostRegexTimeout` | Rejects excessive nesting/expansion and limits pathological regex matches. These do not sandbox executable shell code. |
| Stuck execution | `StuckCommandWatchdog`, `HostLog`, client-disconnect monitoring | Prevents a single abandoned command from holding the shared gate forever. Host termination is recovery, not preservation of another live job. |
| Process identity | Host metadata/build validation; PID plus start-time session anchors | Reduces stale-process reuse errors. Transport encryption, machine trust, and action authorization remain separate concerns. |
| AI assistance | `InteractiveShell` requires `PSBASH_AI_ENABLE`; `PSBASH_AI_DISABLE` wins; review loop | Default-off egress and explicit command review. A classifier/review UI cannot make an arbitrary generated command safe. |
| Package contents | `scripts/smoke-archive.ps1` checks host, SMA assembly, output and version | Catches missing runtime assets in staging. It does not prove the installer preserves them or that publication waited for tests. |
| Archive names | `TryResolveWithinDest`, `ExtractLink` | Rejects direct rooted/`..` names and directly escaping archive link targets. Existing filesystem redirects remain open under B01. |

Future remote execution must enforce server-side authorization for input, stop, export, file access, port forwarding, and administrative changes. A viewer selection or UI-only restriction is not an authorization boundary. Namespace identifiers by machine, server generation, and session; bind each mutating request to that target. Use authenticated SSH with explicit host trust for initial remote scope; do not expose the local IPC protocol as an unauthenticated network service. These are proposed defenses, not implemented claims.

## Competitive contract

Herdr publicly describes server-owned agent terminals and machine aggregation. Its detailed docs distinguish live detach/reattach from restart reconstruction, and describe per-machine routing, compatibility negotiation, and ambiguous remote command outcomes. Those are useful acceptance baselines; this review did not test the competitor. The opportunity for the proposed experience is a workspace organized around work and attention, explicit execution location, actionable recovery, and typed results alongside a fully usable terminal.

Sources inspected 2026-10-18: [product overview](https://herdr.dev/), [session state and restore](https://herdr.dev/docs/session-state/), [connecting machines](https://herdr.dev/docs/connecting-machines/), [agent status](https://herdr.dev/docs/agents/). These are vendor descriptions, not independent validation. No star/install counts or parity assertions are used as evidence.

## Verification performed

1. `tman test-proj src/PsBash.Host.Tests --filter "FullyQualifiedName~SdkWorkerEnvironmentTests|FullyQualifiedName~ConnectionClientDisconnectTests|FullyQualifiedName~SessionAnchorWatcherTests|FullyQualifiedName~LifecycleScaleAndFaultTests"`: solution build succeeded with zero warnings/errors; **31 passed, 1 skipped, 0 failed**, 54 s test duration. Skip: `CommandNotFound_WslWindowsPath_HintsOncePerHost`, platform-specific WSL test.
2. `tman test-proj src/PsBash.Core.Tests --filter "FullyQualifiedName~HostProtocolLargeFrameTests|FullyQualifiedName~HostOwnershipTests|FullyQualifiedName~RestrictedTokenTests|FullyQualifiedName~HostMetadataTests"`: solution build succeeded with zero warnings/errors; **37 passed, 0 skipped, 0 failed**, 3 s test duration. These selected transport/ownership checks do not establish a complete security assessment.
3. `pwsh -NoProfile -File artifacts/production-audit/Probe-TarContainment.ps1`: current-checkout supervised build succeeded; extraction returned `0` and wrote the marker through the pre-existing junction. This confirms B01 remains open.
4. `wsl.exe -d Ubuntu-24.04 -e bash /mnt/c/Users/andyb/work/core/ps-bash/artifacts/production-audit/probe-tar-oracle.sh`: GNU tar returned `2` and refused the corresponding symlink-ancestor write.

Probe fixtures are disposable local artifacts, not portable regression tests or release gates. No live release, profile modification, real remote deployment, macOS runtime, full xUnit/Pester suite, endurance run, or GUI interaction was exercised. Passing the selected tests does not close any finding automatically.

## Remediation order and release evidence

1. Runtime/filesystem owner: close B01 and add platform-specific containment regressions.
2. Packaging/release owner: close B02–B05; prove downloaded installs work and failed tests cannot expose new assets.
3. Product/session owner: resolve repository responsibility, choose the first supported local/remote platform matrix, and accept R01–R05 as one vertical slice before adding collaboration or cloud access.
4. Runtime/session owner: close shared-state, private-history, bounded-buffer, and recovery contracts before managing multiple remote workloads.
5. Product/QA owner: record each journey's test, environment, result, limitations, and date in the journey ledger. A story without failure/recovery evidence remains unaccepted.

No issue tracker tasks, commits, releases, or pushes were created by this review.

## Remediation status (updated same day)

| ID | Status | Change |
|---|---|---|
| B01 | Fixed, regression-tested | `InvokeBashTarCommand` refuses any existing symlink/junction below the destination (and a link at the final path), nonzero exit; tests in `InvokeBashTarCommandTests`. Link-swap races are narrowed (re-check after directory creation), not eliminated. |
| B02 | Fixed, not run against a live release | `install.sh`/`install.ps1` stage, digest-check, smoke a real command, install into a versioned directory, keep the previous version. |
| B03 | Fixed in workflow, unexercised | Assets upload only in the final `release` job after build and test gates; digest re-verified there. |
| B04 | Fixed in workflow, unexercised | `release-tag` resolves the tag to one SHA that every job checks out; missing tag fails first; the hand-published `release` trigger was removed. |
| B05 | Mostly fixed | Cmdlets and a new Host.Tests step block; Shell and Differential block on Linux, advisory elsewhere. |
| B06, B07 | Open | Product scope decisions. |
| B08 | Fixed (retention open) | Leading-space / `PSBASH_HISTORY_PRIVATE` capture filter, degraded-history warning, `history` listing, `history -d ID`, `history -c` with real erasure. Retention policy remains open. |
