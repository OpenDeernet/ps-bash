## Absorbed from Differential.Tests/SeedDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_SimpleEcho_QuotingPreserved
echo 'hello world'
## stdout: hello world
## status: 0

#### Differential_VariableExpansion_BraceForms
x=1; echo "${x:-default}" "${#x}"
## stdout: 1 1
## status: 0

#### Differential_Pipes_TwoStage
printf 'a\nb\nc\n' | sort -r | head -n 2
## STDOUT:
c
b
## END
## status: 0

#### Differential_ExitCodePropagation_PipefailOff
false | true; echo $?
## stdout: 0
## status: 0

#### Differential_CommandSubstitution_NestedQuoting
echo "today is $(date +%Y)"
## stdout: today is 2026
## status: 0
