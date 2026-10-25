## Absorbed from Differential.Tests/CommandSubstitutionDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_CommandSub_BasicEcho_ExpandsAtRuntime
echo $(echo hello)
## stdout: hello
## status: 0

#### Differential_CommandSub_TrailingNewlineStripped
x=$(printf 'a\n\n'); echo "$x"
## stdout: a
## status: 0

#### Differential_CommandSub_NestedThreeLevels
echo $(echo $(echo deep))
## stdout: deep
## status: 0

#### Differential_CommandSub_PipelineInside
x=$(printf 'line1\nline2\n' | head -1); echo "got: $x"
## stdout: got: line1
## status: 0

#### Differential_ArithSub_LiteralAddition_ProducesInteger
echo $((2 + 3))
## stdout: 5
## status: 0

#### Differential_ArithSub_VsCommandSubSubshell_BothProduceResult
echo $((1+2)) $( echo $((1+2)) )
## stdout: 3 3
## status: 0

#### Differential_ArithSub_CommandSubOperand_ExpandsThenEvaluates
echo $(( $(echo 5) + 60 ))
## stdout: 65
## status: 0

#### Differential_ArithSub_BacktickCommandSubOperand_ExpandsThenEvaluates
echo $(( `echo 7` * 3 ))
## stdout: 21
## status: 0

#### Differential_ArithSub_MultipleCommandSubOperands_AllExpand
n=4; echo $(( $(echo 2) * n + $(echo 3) ))
## stdout: 11
## status: 0

#### Differential_ArithCommand_CommandSubOperand_DrivesExitStatus
if (( $(echo 3) > 2 )); then echo bigger; else echo smaller; fi
## stdout: bigger
## status: 0

#### Differential_CommandSub_InsideDoubleQuotes_NoWordSplit
x="$(echo 'a b')"; echo "$x"
## stdout: a b
## status: 0

#### Differential_CommandSub_EmptyOutput_YieldsEmptyString
x=$(true); echo "[$x]"
## stdout: []
## status: 0

#### Differential_CommandSub_ExitCodeFromFalse_PropagatesViaAssignment
x=$(false); echo $?
## stdout: 1
## status: 0
