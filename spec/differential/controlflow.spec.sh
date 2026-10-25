## Absorbed from Differential.Tests/ControlFlowDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_If_CompoundAndCondition
if true && true; then echo both; else echo not; fi
## stdout: both
## status: 0

#### Differential_If_CompoundOrCondition
if false || true; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_If_CompoundAndConditionFirstFails
if false && true; then echo yes; else echo no; fi
## stdout: no
## status: 0

#### Differential_If_CompoundAndConditionBoolExpr
if [ 1 -eq 1 ] && [ 2 -eq 2 ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_If_PlainCommandConditionFails
if false; then echo yes; else echo no; fi
## stdout: no
## status: 0

#### Differential_If_ElifChainWithTestExpr
x=2; if [ "$x" -eq 1 ]; then echo one; elif [ "$x" -eq 2 ]; then echo two; else echo other; fi
## stdout: two
## status: 0

#### Differential_For_BraceRangeExpansion
for i in {1..3}; do echo $i; done
## STDOUT:
1
2
3
## END
## status: 0

#### Differential_For_BreakExitsEarly
n=0; for x in a b c; do n=$((n+1)); if [ $n -eq 2 ]; then break; fi; echo $x; done
## stdout: a
## status: 0

#### Differential_For_CStyle
for ((i=0; i<3; i++)); do echo $i; done
## STDOUT:
0
1
2
## END
## status: 0

#### Differential_Until_BasicLoop
n=0; until [ $n -ge 3 ]; do echo $n; n=$((n+1)); done
## STDOUT:
0
1
2
## END
## status: 0

#### Differential_While_ContinueSkipsIteration
n=0; while [ $n -lt 4 ]; do n=$((n+1)); if [ $n -eq 2 ]; then continue; fi; echo $n; done
## STDOUT:
1
3
4
## END
## status: 0

#### Differential_Function_ReturnSetsExitCode
f() { return 42; }; f; echo $?
## stdout: 42
## status: 0

#### Differential_Function_ArgExpansion
greet() { echo "$# args: $1 $2"; }; greet hello world
## stdout: 2 args: hello world
## status: 0

#### Differential_Function_Recursion
fact() { if [ $1 -le 1 ]; then echo 1; return; fi; prev=$(fact $(($1-1))); echo $(($1*prev)); }; fact 4
## stdout: 24
## status: 0

#### Differential_For_ContinueSkipsIteration
for i in 1 2 3 4 5; do if [ $i -eq 3 ]; then continue; fi; echo $i; done
## STDOUT:
1
2
4
5
## END
## status: 0

#### Differential_While_FalseCondition_ZeroIterations
while false; do echo body; done; echo $?
## stdout: 0
## status: 0

#### Differential_Function_LocalScopeIsolation
x=outer; f() { local x=inner; echo $x; }; f; echo $x
## STDOUT:
inner
outer
## END
## status: 0
