## Absorbed from Differential.Tests/XargsBasenameDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Xargs_NoCommand_DefaultsToEcho
printf 'a b c\n' | xargs
## stdout: a b c
## status: 0

#### Xargs_NoCommand_MultipleLines_DefaultsToEcho
printf 'a\nb c\n' | xargs
## stdout: a b c
## status: 0

#### Xargs_DashI_WholeLinePreservesBlanks
printf 'a b\nc d\n' | xargs -I{} echo '[{}]'
## STDOUT:
[a b]
[c d]
## END
## status: 0

#### Xargs_DashLowerI_DefaultBraces
printf 'a b\nc\n' | xargs -i echo '[{}]'
## STDOUT:
[a b]
[c]
## END
## status: 0

#### Xargs_DashLowerIAttached
printf 'a b\n' | xargs -iX echo '[X]'
## stdout: [a b]
## status: 0

#### Xargs_DashI_BatchingStillWholeLine
printf 'x y\n' | xargs -I{} -n 1 echo '[{}]'
## stdout: [x y]
## status: 0

#### Xargs_Default_DoubleQuotedTokenStaysOneItem
printf 'a "b c" d\n' | xargs -n 1 echo
## STDOUT:
a
b c
d
## END
## status: 0

#### Xargs_Default_BackslashEscapedSpace
printf 'a\\ b\n' | xargs -n 1 echo
## stdout: a b
## status: 0

#### Xargs_ExitCode_ChildFailure_Is123
printf 'x\n' | xargs -n 1 awk 'BEGIN{exit 3}' 2>/dev/null; echo $?
## stdout: 123
## status: 0

#### Xargs_ExitCode_ChildExit255_Is124
printf 'x\n' | xargs -n 1 awk 'BEGIN{exit 255}' 2>/dev/null; echo $?
## stdout: 124
## status: 0

#### Basename_TwoOperands_Suffix
basename /a/b.txt .txt
## stdout: b
## status: 0

#### Basename_TwoOperands_SuffixNotPresent
basename /a/b.txt .log
## stdout: b.txt
## status: 0

#### Basename_TwoOperands_SuffixEqualsName
basename /a/b.txt b.txt
## stdout: b.txt
## status: 0

#### Basename_DashA
basename -a /a/b.txt /x/y.txt
## STDOUT:
b.txt
y.txt
## END
## status: 0

#### Basename_DashS_ImpliesAll
basename -s .txt /a/b.txt /x/y.txt
## STDOUT:
b
y
## END
## status: 0
