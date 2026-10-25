## Absorbed from Differential.Tests/SubshellScopeDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Subshell_SetE_DoesNotLeakIntoParent
( set -e; true ); false; echo survived; set +e; ( set -e; false; echo not-printed ); echo "sub rc=$?"
## STDOUT:
survived
sub rc=1
## END
## status: 0

#### Subshell_SetE_InsideFunction_LeavesOnlyTheSubshell
f() { ( set -e; false ); echo "fn survived rc=$?"; }; f; set -e; ( set +e; false; echo inner-continues ); echo outer-still-e
## STDOUT:
fn survived rc=1
inner-continues
outer-still-e
## END
## status: 0

#### Subshell_VariablesCdShoptTrap_AreLocal
x=outer; ( x=inner; export X2=1 ); echo "$x [${X2:-unset}]"; ( cd / ); [ "$PWD" != / ] && echo cd-local; ( shopt -s nullglob ); for f in /nonexist-zz/*; do echo "glob $f"; done; ( trap 'echo T' USR1 ); trap -p USR1; echo trap-local
## STDOUT:
outer [unset]
cd-local
glob /nonexist-zz/*
trap-local
## END
## status: 0

#### CommandSub_IsASubshell_ForStateAndExit
w=$(q=zz; echo $q); echo "[$w] [${q:-unset}]"; v=$(exit 4); echo "exit rc=$?"; v=$( set -e; false; echo after ); echo "[$v] rc=$?"
## STDOUT:
[zz] [unset]
exit rc=4
[] rc=1
## END
## status: 0

#### Set_UnsupportedLongOption_IsANoOp
set -o pipefail; echo "rc=$?"; set +o pipefail; echo "rc=$?"; false | true; echo "pipe rc=$?"
## STDOUT:
rc=0
rc=0
pipe rc=0
## END
## status: 0

#### Stderr_UnterminatedRecord_HasNoNewline
printf x >&2; echo y >&2; f=$(mktemp); { printf z >&2; } 2>"$f"; wc -c < "$f"; rm -f "$f"
## stdout: 1
## status: 0
