## Absorbed from Differential.Tests/ColonAndBangTestDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### ColonTrueFalse_Builtins row 2
: a b c; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 3
x=; : ${x:=5}; echo $x
## stdout: 5
## status: 0

#### ColonTrueFalse_Builtins row 4
: > /dev/null; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 7
while :; do echo once; break; done
## stdout: once
## status: 0

#### ColonTrueFalse_Builtins row 8
if :; then echo yes; fi
## stdout: yes
## status: 0

#### ColonTrueFalse_Builtins row 9
: --help; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 10
true --help; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 11
false --help; echo rc=$?
## stdout: rc=1
## status: 0

#### ColonTrueFalse_Builtins row 12
true x y; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 13
false x y; echo rc=$?
## stdout: rc=1
## status: 0

#### ColonTrueFalse_Builtins row 14
echo hi | :; echo rc=$?
## stdout: rc=0
## status: 0

#### ColonTrueFalse_Builtins row 15
: && echo and; false || :; echo rc=$?
## STDOUT:
and
rc=0
## END
## status: 0

#### BangOperand_Tests row 1
[ ! = ! ]; echo $?
## stdout: 0
## status: 0

#### BangOperand_Tests row 2
[ ! != ! ]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 3
[ ! ]; echo $?
## stdout: 0
## status: 0

#### BangOperand_Tests row 4
[ ! ! ]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 5
[ ! a ]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 6
[ ! '' ]; echo $?
## stdout: 0
## status: 0

#### BangOperand_Tests row 7
[ ! = x ]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 8
[ x = ! ]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 9
[ ! -a ! ]; echo $?
## stdout: 0
## status: 0

#### BangOperand_Tests row 10
[ ! -o ! ]; echo $?
## stdout: 0
## status: 0

#### BangOperand_Tests row 11
[[ ! a ]]; echo $?
## stdout: 1
## status: 0

#### BangOperand_Tests row 12
[[ ! -z x ]]; echo $?
## stdout: 0
## status: 0

#### Eq
: $(echo side >&2) 2>&1; echo rc=$?
## stdout: rc=0
## status: 0

#### Eq row 2
false; : ; echo rc=$?
## stdout: rc=0
## status: 0

#### Eq row 3
:; echo rc=$?
## stdout: rc=0
## status: 0
