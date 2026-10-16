# Tiered test runner: risk spikes

**2026-10-16.** Measurements behind the tiered runner (`src/PsBash.TestRunner`): a fast pass with
light isolation, then a strict rerun of whatever failed. Linux (WSL2, 6 cores, load 3-6) unless
noted. Every number below was measured; estimates are marked.

## Where the full suite's time went

Before: `tman test` could not finish inside its 45 min cap. Per project (`dotnet test`):

| Project | Tests | Wall | Cause |
|---|---|---|---|
| Cmdlets | 8,172 | 6.0 min | 170 tests spawning nested `ps-bash -c` (awk getline/system, sed `e`, xargs) = 694 s summed |
| Differential | 1,842 | 8.8 min | ~0.5 s per test: one `ps-bash -c` each |
| Shell | 723 | 6-11 min | interactive/PTY tests cold-starting hosts, 15 s prompt waits |
| Canary | 38 | 4.3 min | 25 AllModes tests ran all modes then skipped (~6 s each, zero assertions) |

The unit cost under all of it: a warm Debug `ps-bash -c 'echo hi'` took ~375 ms
(`PSBASH_TRACE_LAUNCH=1`: runtime start 80, transpile 100, local host check 70, connect+send 45,
host execution 65). perf: 48% libcoreclr, 40% libclrjit. ReadyToRun did not help (~320 ms); the
AOT launcher does the round trip in ~45 ms. `tman test` now runs the suite against an AOT launcher
(23.7 min the first time, Shell 10.8 -> 4.5 min, Differential 8.8 -> 5.1 min).

## Risk 1: process-wide state

Bash variables live in `$env:` and the working directory is `Environment.CurrentDirectory`, both
process-global, so `SdkWorker` serializes command execution behind a static gate. One process
runs one command at a time. Parallelism has to come from processes, not threads.

## Risk 2: hosting xUnit in-process

`AssemblyRunner.WithoutAppDomain` from xunit.runner.utility 2.9.3, started as
`dotnet exec --depsfile <test>.deps.json --runtimeconfig <test>.runtimeconfig.json
PsBash.TestRunner.dll <test>.dll` (the vstest testhost trick; the runner resolves its own
xunit.runner.utility from its directory). Cmdlets.Tests: 8,123 passed / 0 failed / 54 skipped,
300 s against `dotnet test`'s 324 s: fixtures, SkippableFact and the PowerShell SDK behave the same.
Open: `dotnet test` reported 8,118 passed for the same build (5 fewer; probably theory-row
enumeration, not yet explained). The runner must run with the test assembly's directory as cwd: run
from the repo root, a Differential test wrote `f.txt` there.

## Risk 3: reset cost

`SharedPwshFixture.Reset` (Cmdlets, before each of ~3,100 runspace tests) cost 35 ms against
0.95 ms for the `sed` call it guarded. Same effects as a constant script with a `foreach`
statement and a baseline set built once: ~3 ms. Landed; Cmdlets summed test time 774 -> 688 s.

## Risk 4: Differential's ps-bash side

It already uses one warm daemon per fixture (`BashOracleFixture`, `PSBASH_PER_INVOCATION=0`), so
an in-process launcher path is not where its time goes. A warm daemon still served sequential
commands at 160-190 ms each: about every third command found the pool empty and waited 200-280 ms
for a runspace rebuild (`PSBASH_POOL_DIAG=1`).

## Rejected: reverting a runspace instead of rebuilding it

Snapshot the fresh runspace (globals, dictionary contents, functions, aliases, modules, drives,
location, lookup hooks), revert to it on release, discard when dirty. Correctness held (leak and
dirty-detection tests passed), but the revert took 175-230 ms, the same as a rebuild: walking the
psm1's hundreds of functions and aliases through the providers costs what defining them does. A
cheaper revert needs session-state internals PowerShell does not expose. Removed, not kept as an
opt-in.

## Product bugs found on the way (fixed, each with a regression test)

- Linux: no warm daemon reuse without `PSBASH_SESSION`. The session key embedded .NET's
  `Process.StartTime`, which each process derives from its own boot-time estimate (0.3-5 ms apart
  across readers), so every `ps-bash -c` keyed a new endpoint. Now `/proc/<pid>/stat` starttime.
- Linux: a SIGKILLed host still a zombie was reported "still running but dropped the connection".
- Unix sockets: 30 concurrent launchers overflowed a backlog of 16 and one failed with exit 125
  (EAGAIN, which .NET reports as `WouldBlock`). Backlog 512 plus a bounded connect retry.
- Core.Tests: a static runtime-directory override leaked a 0777 root into parallel tests.
- Canary: AllModes tests skipped everywhere; in-process modes reported exit 1 for any stderr.
