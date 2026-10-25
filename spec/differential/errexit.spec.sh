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

#### Eq
f() { cat /nofile 2>/dev/null; echo in; }; set -e; if f >/dev/null; then echo yes; fi; f || echo caught; ! f; echo after
## STDOUT:
yes
in
in
after
## END
## status: 0

#### Eq row 2
set -e; x=$(cat /nofile 2>/dev/null; echo in); echo "[$x]"; export Y=$(false); echo after
## STDOUT:
[in]
after
## END
## status: 0

#### Eq row 3
set -e; echo hi | cat /nofile 2>/dev/null; echo never
## stdout:
## status: 1

#### Eq row 4
set -e; f() { return 2; }; f; echo never
## stdout:
## status: 2

#### Eq row 5
set -e; (cat /nofile 2>/dev/null; echo in); echo never
## stdout:
## status: 1

#### Eq row 6
f() { false; echo in-f; }; g() { f; echo in-g; }; set -e; g && echo ok; echo after
## STDOUT:
in-f
in-g
ok
after
## END
## status: 0

#### Eq row 7
set -e; if true; then echo t; fi; for i in 1 2; do echo i=$i; cat /nofile 2>/dev/null; done; echo never
## STDOUT:
t
i=1
## END
## status: 1

#### Eq row 8
set -e; set +e; cat /nofile 2>/dev/null; echo after
## stdout: after
## status: 0

#### Eq row 9
set -e; f() { if false; then :; fi; }; g() { i=0; while [ $i -lt 2 ]; do i=$((i+1)); done; }; f; g; echo after
## stdout: after
## status: 0

#### Eq row 10
set -e; case a in a) echo arm; { cat /nofile 2>/dev/null; echo in; };; esac; echo never
## stdout: arm
## status: 1

#### Eq row 11
set -e; echo a; cat /nofile 2>/dev/null; echo never
## stdout: a
## status: 1

#### Eq row 12
set -e; cat /nofile 2>/dev/null || true; false && true; cat /nofile 2>/dev/null || cat /nofile 2>/dev/null || echo third; echo after
## STDOUT:
third
after
## END
## status: 0

#### Eq row 13
set -e; cat /nofile 2>/dev/null || exit 4; echo never
## stdout:
## status: 4

#### Eq row 14
f() { cat /nofile 2>/dev/null; echo in; }; set -e; f; echo never
## stdout:
## status: 1

#### Eq row 15
set -e; x=$(cat /nofile 2>/dev/null); echo never
## stdout:
## status: 1

#### Eq row 16
set -e; { false && true; }; for i in 1; do false && true; done; echo after
## stdout: after
## status: 0

#### Eq row 17
set -e; true && cat /nofile 2>/dev/null; echo never
## stdout:
## status: 1

#### Eq row 18
set -e; if cat /nofile 2>/dev/null; then :; elif cat /nofile 2>/dev/null; then :; fi; while cat /nofile 2>/dev/null; do :; done; until true; do :; done; echo after
## stdout: after
## status: 0

#### Eq row 19
set -e; cat /nofile 2>/dev/null || echo fallback; for i in 1 2; do [ $i = 2 ] && break; echo i=$i; done; echo after
## STDOUT:
fallback
i=1
after
## END
## status: 0

#### Eq row 20
set -e; ! cat /nofile 2>/dev/null; cat /nofile 2>/dev/null | cat; false | true; echo after
## stdout: after
## status: 0

#### Eq row 21
set -e; cat /nofile 2>/dev/null & wait; echo after
## stdout: after
## status: 0
