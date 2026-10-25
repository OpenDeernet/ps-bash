## Absorbed from Differential.Tests/ScriptModeFixturesTests.cs (scripts only; expectations recorded from bash 5.2).

#### ScriptMode_ExitCode_BareExitN
exit 42
## stdout:
## status: 42

#### ScriptMode_ExitCode_BareExitLarge
exit 127
## stdout:
## status: 127

#### ScriptMode_ExitCode_ExitZero
echo before; exit 0
## stdout: before
## status: 0

#### ScriptMode_ExitCode_ExitInsideFunction
f() { exit 7; }; f; echo should_not_print
## stdout:
## status: 7

#### ScriptMode_SetE_ExplicitExitCode
set -e; exit 3
## stdout:
## status: 3
