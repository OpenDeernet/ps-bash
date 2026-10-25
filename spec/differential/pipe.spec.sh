## Absorbed from Differential.Tests/PipeDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_Pipe_TwoStage_EchoWcW
echo "hello world" | wc -w
## stdout: 2
## status: 0

#### Differential_Pipe_ThreeStage_PrintfGrepWcL
printf 'a\nb\nc\n' | grep b | wc -l
## stdout: 1
## status: 0

#### Differential_Pipe_WithArgs_PrintfSort
printf 'b\na\nc\n' | sort
## STDOUT:
a
b
c
## END
## status: 0

#### Differential_Pipe_InCondition_GrepQMatches
echo "hello" | grep -q hello && echo yes || echo no
## stdout: yes
## status: 0

#### Differential_Pipe_InCondition_GrepQNoMatch
echo "world" | grep -q hello && echo yes || echo no
## stdout: no
## status: 0

#### Differential_Pipe_ExitCode_LastCmdWins_PipefailOff
false | true; echo $?
## stdout: 0
## status: 0

#### Differential_Pipe_ObjectPreservation_GrepThenSort
printf 'apple\nbanana\ncherry\n' | grep a | sort
## STDOUT:
apple
banana
## END
## status: 0

#### Differential_Pipe_FourStage_SortHeadTr
printf 'c\nb\na\n' | sort | head -n 2 | tr a-z A-Z
## STDOUT:
A
B
## END
## status: 0

#### Differential_Pipe_FeedWhileLoop
printf 'a\nb\nc\n' | while read line; do echo "got:$line"; done
## STDOUT:
got:a
got:b
got:c
## END
## status: 0

#### Differential_Pipe_ForLoopOutputIntoSort
for d in b a c; do echo "$d"; done | sort
## STDOUT:
a
b
c
## END
## status: 0

#### Differential_Pipe_BraceGroupOutputIntoSort
{ echo b; echo a; } | sort
## STDOUT:
a
b
## END
## status: 0
