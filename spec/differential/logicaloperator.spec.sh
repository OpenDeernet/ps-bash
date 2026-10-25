## Absorbed from Differential.Tests/LogicalOperatorDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_AndOr_BasicAnd_BothSucceed
true && echo yes
## stdout: yes
## status: 0

#### Differential_AndOr_And_ShortCircuitOnFailure
false && echo nope
## stdout:
## status: 1

#### Differential_AndOr_BasicOr_FallbackOnFailure
false || echo fallback
## stdout: fallback
## status: 0

#### Differential_AndOr_Or_ShortCircuitOnSuccess
true || echo nope
## stdout:
## status: 0

#### Differential_AndOr_MixedChain_LeftAssociative
false && echo a || echo b
## stdout: b
## status: 0

#### Differential_AndOr_MixedChain_FirstArmSucceeds
true && echo a || echo b
## stdout: a
## status: 0

#### Differential_Not_NegatesFalseAndChainsAnd
! false && echo yes
## stdout: yes
## status: 0

#### Differential_Not_NegatesPipelineExitCode
! echo x | grep y; echo $?
## stdout: 0
## status: 0

#### Differential_AndOr_ExitCodeAfterSuccessfulChain
true && true; echo $?
## stdout: 0
## status: 0

#### Differential_AndOr_ExitCodeAfterFailedLastArm
true && false; echo $?
## stdout: 1
## status: 0

#### Differential_AndOr_SetE_FalseOrTrueSurvives
set -e; false || true; echo survived
## stdout: survived
## status: 0

#### Differential_AndOr_TestExprAndBraceGroup
[ 1 -eq 1 ] && { echo in_block; }
## stdout: in_block
## status: 0

#### Differential_AndOr_ThreeCommandChain_Recovers
true && false || echo recovered
## stdout: recovered
## status: 0

#### Differential_AndOr_CdInChain_ChangesWorkingDir
dir=$(pwd); cd ..; cd "$dir" && echo back
## stdout: back
## status: 0
