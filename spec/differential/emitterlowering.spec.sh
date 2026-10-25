## Absorbed from Differential.Tests/EmitterLoweringDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_WhileRead_IfsColonSplitsFields
printf 'root:x\nbin:y\n' | while IFS=: read -r a b; do echo "$a-$b"; done
## STDOUT:
root-x
bin-y
## END
## status: 0

#### Differential_Read_IfsCommaSplitsFields
IFS=, read -r a b c <<< '1,2,3'; echo "$a|$b|$c"
## stdout: 1|2|3
## status: 0

#### Differential_BraceGroupPipeTarget_ReceivesStdin
echo hi | { read y; echo y=$y; }
## stdout: y=hi
## status: 0

#### Differential_RegexMatch_PopulatesBashRematch
s=ab; [[ $s =~ (a)(b) ]]; echo "${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
## stdout: ab
## status: 0

#### Differential_TrapExit_FiresOnNormalEnd
trap 'echo bye' EXIT; echo main
## STDOUT:
main
bye
## END
## status: 0

#### Differential_TrapExit_FiresOnExitN
trap 'echo bye' EXIT; echo main; exit 3
## STDOUT:
main
bye
## END
## status: 3

#### Differential_TrapExit_FiresUnderErrexit
set -e; trap 'echo bye' EXIT; false; echo after
## stdout: bye
## status: 1
