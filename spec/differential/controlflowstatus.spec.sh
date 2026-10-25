## Absorbed from Differential.Tests/ControlFlowStatusDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Condition_CommandOutput_Streams
if echo in-if; then echo yes; fi
if ! echo in-not; then echo no; else echo else; fi
if echo a && echo b; then echo both; fi
if false || echo c; then echo or; fi
f(){ echo in-func; return 0; }; if f; then echo func-yes; fi
## STDOUT:
in-if
yes
in-not
else
a
b
both
c
or
in-func
func-yes
## END
## status: 0

#### Condition_ElifRunsOnlyAfterEarlierFailed
if echo c1; false; then echo b1; elif echo c2; true; then echo b2; elif echo c3; then echo b3; fi
## STDOUT:
c1
c2
b2
## END
## status: 0

#### Condition_OutputReachesPipeAndCapture
if echo piped; then echo body; fi | tr a-z A-Z
x=$(if echo captured; then echo body; fi); printf '[%s]\n' "$x"
## STDOUT:
PIPED
BODY
[captured
body]
## END
## status: 0

#### Loop_MultiCommandCondition_StreamsAndParses
n=0; while echo in-while $n; [ $n -lt 2 ]; do n=$((n+1)); done; echo "after rc=$?"
m=0; until echo in-until $m; [ $m -ge 1 ]; do m=$((m+1)); done
## STDOUT:
in-while 0
in-while 1
in-while 2
after rc=0
in-until 0
in-until 1
## END
## status: 0

#### Status_IfWithoutBranchAndLoopEnd
if false; then :; fi; echo "if rc=$?"
while false; do :; done; echo "while rc=$?"
i=0; while [ $i -lt 1 ]; do i=1; false; done; echo "body rc=$?"
## STDOUT:
if rc=0
while rc=0
body rc=1
## END
## status: 0

#### Chain_KeywordForm_KeepsConditionOutput
printf 'a\nb\n' > f.txt; f(){ grep a f.txt || return 1; echo found; }; f
for i in 1 2; do echo "it $i" && continue; echo never; done
## STDOUT:
a
found
it 1
it 2
## END
## status: 0

#### Chain_SeesReturnAndExitStatus
g(){ return 3; }
g || echo "fb rc=$?"
g; echo "g rc=$?"
g && echo nope || echo "and-or rc=$?"
(exit 4) || echo "sub fb"
(exit 0) && echo "sub ok"
h(){ return 0; }; h && echo "h ok"
## STDOUT:
fb rc=3
g rc=3
and-or rc=3
sub fb
sub ok
h ok
## END
## status: 0

#### DeclarationBuiltins_HaveTheirOwnStatus
f2(){ local x=$(false); echo "local rc=$?"; }; f2
export y=$(false); echo "export rc=$?"
declare z=$(echo hi); echo "declare [$z] rc=$?"
declare w=$(false); echo "declare rc=$?"
v=$(false); echo "plain assign rc=$?"
readonly r=$(false); echo "readonly rc=$?"
## STDOUT:
local rc=0
export rc=0
declare [hi] rc=0
declare rc=0
plain assign rc=1
readonly rc=0
## END
## status: 0

#### DeclarationBuiltins_AssignReadableValues
declare x=hello; echo "[$x]"; readonly q=5; echo "[$q]"; declare -i n=2+3; echo "[$n] $((n * 2))"
typeset t=v; echo "[$t]"; declare d="$x-$q"; echo "[$d]"; readonly e=$(echo ro); echo "[$e]"
## STDOUT:
[hello]
[5]
[5] 10
[v]
[hello-5]
[ro]
## END
## status: 0
