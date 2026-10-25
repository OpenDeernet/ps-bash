## Absorbed from Differential.Tests/ExprDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Expr_Colon_GroupCapture
expr abc123 : '\([a-z]*\)'
## stdout: abc
## status: 0

#### Expr_Colon_MatchLength_BreOperators
expr foo : 'fo\{2\}'; expr abc123 : '[a-z]\+'; expr 'a|b' : 'a|b'
## STDOUT:
3
3
3
## END
## status: 0

#### Expr_Match_BarePlusIsLiteral
expr match abc123 '[a-z]+'; expr match abc123 '[a-z]\+'
## STDOUT:
0
3
## END
## status: 0

#### Expr_Colon_GroupNoMatch_PrintsEmpty
expr abc : '\([0-9]*\)x'; echo "[$(expr abc : '\(z\)')]"
## STDOUT:

[]
## END
## status: 0

#### Expr_ZeroOrEmptyResult_ExitsOne
expr 1 - 1; echo rc=$?; expr abc : z; echo rc=$?; expr abc : '\(z\)'; echo rc=$?; expr 2 + 3; echo rc=$?
## STDOUT:
0
rc=1
0
rc=1

rc=1
5
rc=0
## END
## status: 0

#### Expr_Colon_PunctClass
expr 'x!' : 'x[[:punct:]]'
## stdout: 2
## status: 0
