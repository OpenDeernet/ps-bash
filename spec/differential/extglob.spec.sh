## Absorbed from Differential.Tests/ExtGlobDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### ExtGlob_DoubleBracket_AllOperators
shopt -s extglob
for s in '' a aa ab abab b; do [[ $s == ?(a) ]] && printf q; [[ $s == *(ab) ]] && printf s; [[ $s == +(ab) ]] && printf p; [[ $s == @(a|b) ]] && printf a; [[ $s != @(a|b) ]] && printf n; echo "|$s"; done
## STDOUT:
qsn|
qa|a
n|aa
spn|ab
spn|abab
a|b
## END
## status: 0

#### ExtGlob_Negation_ExactSplitSemantics
shopt -s extglob
for p in 'a:!(a)*' 'ab:!(a)b' 'b:!(a)b' 'ab:@(a)!(c)' 'ac:@(a)!(c)' 'foo.log.txt:!(*.log)' 'foo.log:!(*.log)' 'zoo:!(f*|b*)' 'foo:!(f*|b*)'; do s=${p%%:*}; pat=${p#*:}; eval "[[ \$s == $pat ]]" && echo "1 $p" || echo "0 $p"; done
## STDOUT:
1 a:!(a)*
0 ab:!(a)b
1 b:!(a)b
1 ab:@(a)!(c)
0 ac:@(a)!(c)
1 foo.log.txt:!(*.log)
0 foo.log:!(*.log)
1 zoo:!(f*|b*)
0 foo:!(f*|b*)
## END
## status: 0

#### ExtGlob_QuotedEscapedNestedAndClasses
shopt -s extglob
[[ 'a)' == @('a)'|z) ]] && echo q1; [[ 'x(y' == @(x\(y) ]] && echo q2; [[ 'a|b' == @('a|b') ]] && echo q3; [[ axc == @(a@(b|x)c) ]] && echo q4; [[ file.c == *.@(c|h) ]] && echo q5; [[ file.o == *.@(c|h) ]] || echo q6; [[ A == @(a) ]] || echo q7; [[ 7 == @([[:digit:]]) ]] && echo q8; [[ b == @([!a-c]) ]] || echo q9
## STDOUT:
q1
q2
q3
q4
q5
q6
q7
q8
q9
## END
## status: 0

#### ExtGlob_CasePatterns
shopt -s extglob
for w in b c foo.log foo.txt xyz 'x(y' A; do case $w in @(a|b)) echo "$w arm1" ;; @(x\(y)) echo "$w esc" ;; !(*.log|xyz|A)) echo "$w arm2" ;; *) echo "$w default" ;; esac; done
## STDOUT:
b arm1
c arm2
foo.log default
foo.txt arm2
xyz default
x(y esc
A default
## END
## status: 0

#### Eq
!(false); echo "rc=$?"; if !(false); then echo neg; fi; x=1; [[ $x == !(2) ]] && echo pat
## STDOUT:
rc=0
neg
pat
## END
## status: 0

#### Eq row 2
shopt -s extglob
v=aaa.tar.gz; echo "${v#+(a)}|${v##+(a)}|${v#*(a)}|${v##*(a).}"; echo "${v%.@(gz|bz2)}|${v%%.@(tar|gz)*}|${v%?(.gz)}|${v%%?(.gz)}"; echo "${v#!(a)}|${v##!(z)}|${v%!(z)}|${v%%!(z)}"; echo "${v/+(a)/X}|${v//@(a|z)/Y}|${v/!(a)/N}"; w=foo.log.txt; echo "${w%.!(txt)}|${w%%.!(log)}"
## STDOUT:
aa.tar.gz|.tar.gz|aaa.tar.gz|tar.gz
aaa.tar|aaa|aaa.tar.gz|aaa.tar
aaa.tar.gz||aaa.tar.gz|
X.tar.gz|YYY.tYr.gY|N
foo|foo
## END
## status: 0
