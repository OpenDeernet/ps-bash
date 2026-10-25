## Absorbed from Differential.Tests/UnquotedArrayArgTests.cs (scripts only; expectations recorded from bash 5.2).

#### Expands_To_Words row 1
a=(x y z); echo ${a[@]} x
## stdout: x y z x
## status: 0

#### Expands_To_Words row 2
a=(x y z); echo x ${a[*]}
## stdout: x x y z
## status: 0

#### Expands_To_Words row 3
a=(x y z); echo ${a[@]} ${#a[@]} ${!a[@]}
## stdout: x y z 3 0 1 2
## status: 0

#### Expands_To_Words row 4
a=(x y z); echo ${a[@]} ${a[@]}
## stdout: x y z x y z
## status: 0

#### Expands_To_Words row 5
a=('p q' r); echo ${a[@]} x
## stdout: p q r x
## status: 0

#### Expands_To_Words row 6
a=(); echo ${a[@]} x
## stdout: x
## status: 0

#### Expands_To_Words row 7
a=(x y z); echo ${a[@]:1} x
## stdout: y z x
## status: 0

#### Expands_To_Words row 8
a=(x y z); echo ${!a[@]} x
## stdout: 0 1 2 x
## status: 0

#### Expands_To_Words row 9
a=(x y z); echo ${a[@]}
## stdout: x y z
## status: 0

#### Expands_To_Words row 10
a=(x y z); printf '[%s]' ${a[@]} end; echo
## stdout: [x][y][z][end]
## status: 0

#### Expands_To_Words row 11
a=(x y); for i in ${a[@]} z; do echo $i; done
## STDOUT:
x
y
z
## END
## status: 0

#### Expands_To_Words row 12
a=('p q' r); echo "${a[@]}" x
## stdout: p q r x
## status: 0

#### Expands_To_Words row 13
echo {1..5} {a..e} {5..1..2}
## stdout: 1 2 3 4 5 a b c d e 5 3 1
## status: 0

#### Expands_To_Words row 14
echo {1..3} y
## stdout: 1 2 3 y
## status: 0

#### Expands_To_Words row 15
echo x{a,b}y z {1..2}
## stdout: xay xby z 1 2
## status: 0

#### Expands_To_Words row 16
echo {1..3}
## stdout: 1 2 3
## status: 0

#### Expands_To_Words row 17
printf '[%s]' {a,b} {c,d}; echo
## stdout: [a][b][c][d]
## status: 0
