## Absorbed from Differential.Tests/PipelineStageSubshellTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_BraceGroupStage_DoesNotLeakAssignment
x=1; { x=2; echo out; } | cat; echo "x=$x"
## STDOUT:
out
x=1
## END
## status: 0

#### Differential_FirstStageBraceGroup_DoesNotLeakAssignment
x=1; { x=2; echo a; echo b; } | sort; echo "x=$x"
## STDOUT:
a
b
x=1
## END
## status: 0

#### Differential_WhileReadStage_DoesNotLeakLoopVariable
y=none; printf 'a\nb\n' | while read l; do y=$l; done; echo "y=$y"
## stdout: y=none
## status: 0

#### Differential_ForLoopStage_DoesNotLeakVariable
n=0; for i in 1 2 3; do n=$i; echo $i; done | cat; echo "n=$n"
## STDOUT:
1
2
3
n=0
## END
## status: 0

#### Differential_IfStage_DoesNotLeakVariable
z=0; if true; then z=9; echo hit; fi | cat; echo "z=$z"
## STDOUT:
hit
z=0
## END
## status: 0

#### Differential_BraceGroupStage_StillWritesItsOutputThroughThePipe
{ echo one; echo two; } | grep two
## stdout: two
## status: 0
