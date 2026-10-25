## Absorbed from Differential.Tests/ErrexitDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Errexit_FailingChildProcess_ExitsWithItsStatus
set -e; bash -c 'exit 3'; echo never
## stdout:
## status: 3

#### Errexit_TestAndArithStatements_Exit
set -e; echo a; [ -f /nofile ]; echo never
## stdout: a
## status: 1

#### Errexit_SubshellOfFailedList_Exits
set -e; (false && true); echo never
## stdout:
## status: 1

#### TestAndArithCommands_AcceptTrailingRedirects
[[ 1 -eq 1 ]] 2>/dev/null; echo a; (( 1 )) >/dev/null; echo b; [[ x == y ]] 2>/dev/null || echo no; (( 0 )) 2>/dev/null || echo zero; f=$(mktemp); [[ -n $f ]] > "$f"; wc -c < "$f"; rm -f "$f"
## STDOUT:
a
b
no
zero
0
## END
## status: 0

#### Nounset_DefaultForms_AreNotChecked
set -u; echo [${u1:-d}] [${u2-d}] [${u3+x}]; echo after
## STDOUT:
[d] [d] []
after
## END
## status: 0

#### Nounset_PlusU_TurnsItOff
set -u; set +u; echo [$undefined_var_x]; echo after
## STDOUT:
[]
after
## END
## status: 0

#### Noclobber_RefusesOverwriteButAllowsForceAndAppend
cd "$(mktemp -d)"; echo a > f; set -C; { echo b > f; } 2>/dev/null; echo s=$?; echo c >| f; echo d >> f; echo n > g; cat f g; set +C; echo e > f; cat f
## STDOUT:
s=1
c
d
n
e
## END
## status: 0

#### Noclobber_OptionNameForm_And_NewFileAllowed
cd "$(mktemp -d)"; set -o noclobber; echo a > f; { echo b > f; } 2>/dev/null; echo s=$?; cat f
## STDOUT:
s=1
a
## END
## status: 0
