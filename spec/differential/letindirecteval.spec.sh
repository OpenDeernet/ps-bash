## Absorbed from Differential.Tests/LetIndirectEvalTests.cs (scripts only; expectations recorded from bash 5.2).

#### Matches_Bash row 1
let "a = 3 * 4"; echo $a
## stdout: 12
## status: 0

#### Matches_Bash row 2
let a=3*4 b=2; echo $a $b
## stdout: 12 2
## status: 0

#### Matches_Bash row 3
let a=5; let a++; echo $a
## stdout: 6
## status: 0

#### Matches_Bash row 4
let "x=0"; echo rc=$?
## stdout: rc=1
## status: 0

#### Matches_Bash row 5
let "x=2"; echo rc=$?
## stdout: rc=0
## status: 0

#### Matches_Bash row 6
i=1; let i+=2 "j=i*2"; echo $i $j
## stdout: 3 6
## status: 0

#### Matches_Bash row 7
a=b; b=val; echo ${!a}
## stdout: val
## status: 0

#### Matches_Bash row 8
a=b; b=val; echo "[${!a}]"; x=zz; echo "[${!x}]"
## STDOUT:
[val]
[]
## END
## status: 0

#### Matches_Bash row 9
a=(p q); echo ${!a[@]}
## stdout: 0 1
## status: 0

#### Matches_Bash row 10
a=b; b=c; eval echo \$$a
## stdout: c
## status: 0

#### Matches_Bash row 11
a=b; b=c; eval echo $a
## stdout: b
## status: 0

#### Matches_Bash row 12
x=1; eval echo $x \$x
## stdout: 1 1
## status: 0

#### Matches_Bash row 13
eval echo a\ b
## stdout: a b
## status: 0
