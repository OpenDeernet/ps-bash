## Absorbed from Differential.Tests/QuotedArrayArgsTests.cs (scripts only; expectations recorded from bash 5.2).

#### Array_BesideOtherArg
c=(a b c); printf '[%s]' "${c[@]}" z; echo
## stdout: [a][b][c][z]
## status: 0

#### Positional_BesideOtherArg
set -- 'x y' z; printf '[%s]' "$@" end; echo
## stdout: [x y][z][end]
## status: 0

#### EmptyArray_ContributesNothing
e=(); printf '[%s]' "${e[@]}" end; echo
## stdout: [end]
## status: 0

#### Array_Alone
c=(a b c); printf '[%s]' "${c[@]}"; echo
## stdout: [a][b][c]
## status: 0

#### ForList_Flattens
c=(a b c); for i in "${c[@]}" q; do echo -n "<$i>"; done; echo
## stdout: <a><b><c><q>
## status: 0

#### ArrayLiteral_Flattens
c=(a 'b b' c); d=("${c[@]}" w); echo "${#d[@]}"; f=(${c[@]} m); echo "${#f[@]}"; g=({1..3} n); echo "${#g[@]}"
## STDOUT:
4
5
4
## END
## status: 0

#### StarJoined_StaysOneWord
c=(a b c); printf '[%s]' "${c[*]}" z; echo
## stdout: [a b c][z]
## status: 0
