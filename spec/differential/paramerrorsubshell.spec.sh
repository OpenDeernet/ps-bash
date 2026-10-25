## Absorbed from Differential.Tests/ParamErrorSubshellTests.cs (scripts only; expectations recorded from bash 5.2).

#### Subshell_EndsOnlyTheSubshell
( echo ${x:?missing} ) 2>/dev/null; echo "after rc=$?"
## stdout: after rc=1
## status: 0

#### Subshell_SetVariable_PassesThrough
z=ok; ( echo ${z:?never} ); echo "rc=$?"
## STDOUT:
ok
rc=0
## END
## status: 0

#### Subshell_EmptyAndColonless
e=''; ( echo ${e:?empty} ) 2>/dev/null; echo "a=$?"; ( echo [${e?set-but-empty}] ) 2>/dev/null; echo "b=$?"; ( echo ${u?unset} ) 2>/dev/null; echo "c=$?"
## STDOUT:
a=1
[]
b=0
c=1
## END
## status: 0

#### Subshell_OutputBeforeTheError_IsKept
( echo one; echo ${x:?two}; echo three ) 2>/dev/null; echo "rc=$?"
## STDOUT:
one
rc=1
## END
## status: 0
