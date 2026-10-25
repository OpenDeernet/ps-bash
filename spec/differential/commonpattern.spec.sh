## Absorbed from Differential.Tests/CommonPatternDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### VarFollowedByText_StaysOneWord
f=report; echo $f.txt $f:x ${f}x ${f}.txt $f.$f pre$f.txt; echo "[${f}x] [${f}_bak] [${f}1] [$f?]"; x="${f}suffix"; echo "$x"
## STDOUT:
report.txt report:x reportx report.txt report.report prereport.txt
[reportx] [report_bak] [report1] [report?]
reportsuffix
## END
## status: 0

#### VarFollowedByText_FileOperands
cd "$(mktemp -d)" || exit 1; f=report; touch $f.bak && cp $f.bak $f.copy && ls
## STDOUT:
report.bak
report.copy
## END
## status: 0

#### EmptyOperand_RmNeverTouchesCwd
cd "$(mktemp -d)" || exit 1; touch canary; mkdir sub; rm -rf ''; echo rc=$?; rm -rf "$nope"; echo rc=$?; rm ''; echo rc=$?; ls
## STDOUT:
rc=0
rc=0
rc=1
canary
sub
## END
## status: 0

#### BreakContinueReturn_InRedirectedReadLoop
cd "$(mktemp -d)" || exit 1; printf 'a\nb\nc\n' > in.txt
while read -r l; do [ "$l" = b ] && break; echo "1 $l"; done < in.txt; echo 1-after
while read -r l; do [ "$l" = b ] && continue; echo "2 $l"; done < in.txt; echo 2-after
printf 'a\nb\n' | while read -r l; do [ "$l" = b ] && break; echo "3 $l"; done; echo 3-after
s=$'x\ny\nz'; while read -r l; do [ "$l" = y ] && break; echo "4 $l"; done <<< "$s"; echo 4-after
f() { while read -r l; do [ "$l" = b ] && return 7; echo "5 $l"; done < in.txt; echo never; }; f; echo "5 rc=$?"
for i in 1 2; do while read -r l; do [ "$l" = b ] && break 2; echo "6 $i $l"; done < in.txt; done; echo 6-after
## STDOUT:
1 a
1-after
2 a
2 c
2-after
3 a
3-after
4 x
4-after
5 a
5 rc=7
6 1 a
6-after
## END
## status: 0

#### BreakContinueN_InNestedLoops
for i in 1 2; do for j in a b; do echo "$i$j"; break 2; done; done; echo after
for i in 1 2 3; do for j in a b; do [ $j = a ] && continue 2; echo no; done; echo never; done; echo after2
for i in 1 2; do case $i in 1) continue ;; esac; echo "case-continue $i"; done
for i in 1 2 3; do case $i in 2) break ;; esac; echo "case-break $i"; done; echo after3
## STDOUT:
1a
after
after2
case-continue 2
case-break 1
after3
## END
## status: 0

#### Source_OutputAndPositionalParameters
cd "$(mktemp -d)" || exit 1; printf 'echo "lib says [$1]"\nX=1\n' > lib.sh
set -- a b; . ./lib.sh; echo "X=$X 1=$1"; source ./lib.sh p q; echo "after-args 1=$1 2=$2"
## STDOUT:
lib says [a]
X=1 1=a
lib says [p]
after-args 1=a 2=b
## END
## status: 0

#### Source_StreamsOutputInOrder_NestedArgsAndReturn
cd "$(mktemp -d)" || exit 1; printf 'echo 1\necho 2 >&2\necho 3\n' > order.sh
source ./order.sh 2>&1
printf 'echo "lib [$1] [$#]"\nf() { echo "f [$1]"; }\n' > lib.sh
set -- a b; source ./lib.sh p -x; echo "after-args 1=$1 #=$#"
printf 'echo "outer [$1]"\nsource ./lib.sh inner\necho "outer-again [$1]"\n' > nest.sh
source ./nest.sh OUT; echo "after-nest 1=$1"; f z
printf 'echo r1\nreturn 4\necho never\n' > ret.sh; source ./ret.sh; echo "ret rc=$?"
g() { source ./lib.sh G; echo "in-g 1=$1"; }; g H
source ./lib.sh | tr a-z A-Z
## STDOUT:
1
2
3
lib [p] [2]
after-args 1=a #=2
outer [OUT]
lib [inner] [1]
outer-again [OUT]
after-nest 1=a
f [z]
r1
ret rc=4
lib [G] [1]
in-g 1=H
LIB [A] [2]
## END
## status: 0

#### CaseAndTest_AreCaseSensitive_NocasematchToggles
x=abc
case $x in A*) echo 1-yes ;; *) echo 1-no ;; esac
case ABC in abc) echo 2-yes ;; *) echo 2-no ;; esac
[[ $x == A* ]] && echo 3-yes || echo 3-no
[[ abc == ABC ]] && echo 4-yes || echo 4-no
[[ $x != A* ]] && echo 5-ne-true || echo 5-ne-false
[ abc = ABC ] && echo 6-yes || echo 6-no
[ abc = 'a*' ] && echo 7-yes || echo 7-no
case $x in [A-Z]*) echo 8-class ;; *) echo 8-no ;; esac
case abc in *) echo 9-star-first ;; abc) echo 9-literal ;; esac
shopt -s nocasematch
case $x in A*) echo 10-nocase ;; *) echo 10-no ;; esac
[[ $x == ABC ]] && echo 11-nocase || echo 11-no
[ abc = ABC ] && echo 12-yes || echo 12-no
shopt -u nocasematch
[[ $x == A* ]] && echo 13-yes || echo 13-no
case 'a[b' in 'a[b') echo 14-bracket ;; *) echo 14-no ;; esac
## STDOUT:
1-no
2-no
3-no
4-no
5-ne-true
6-no
7-no
8-no
9-star-first
10-nocase
11-nocase
12-no
13-no
14-bracket
## END
## status: 0

#### DoubleBracket_UnquotedExpansionRhs_IsAPattern
A=abc; B='a*'; P='a?c'; D='a[b]c'; E='@(x|abc)'; S='a*'
[[ $A == $B ]] && echo 1-yes || echo 1-no
[[ $A == "$B" ]] && echo 2-yes || echo 2-no
[[ $A != $B ]] && echo 3-yes || echo 3-no
[[ $A == ${P} ]] && echo 4-yes || echo 4-no
[[ $A == $D ]] && echo 5-yes || echo 5-no
[[ $A == $E ]] && echo 6-yes || echo 6-no
[[ 'a*b' == "$S"b ]] && echo 7-yes || echo 7-no
[[ axb == "$S"b ]] && echo 8-yes || echo 8-no
[[ $A == $B"x" ]] && echo 9-yes || echo 9-no
C=ABC; [[ $A == $C ]] && echo 10-yes || echo 10-no
shopt -s nocasematch; [[ $A == $C ]] && echo 11-yes || echo 11-no; shopt -u nocasematch
I='$(echo hi)'; [[ '$(echo hi)' == $I ]] && echo 12-yes || echo 12-no
J="a'b"; [[ "a'b" == $J ]] && echo 13-yes || echo 13-no
K='a\*'; [[ 'a*' == $K ]] && echo 14-yes || echo 14-no; [[ ab == $K ]] && echo 15-yes || echo 15-no
## STDOUT:
1-yes
2-no
3-no
4-yes
5-yes
6-yes
7-yes
8-no
9-no
10-no
11-yes
12-yes
13-yes
14-yes
15-no
## END
## status: 0

#### DoubleBracket_TmpPaths_CompareAsBashSpellsThem
p=/tmp/x; q='/tmp/*'
[[ /tmp/x == /tmp/x ]] && echo 1-yes || echo 1-no
[[ /tmp/x == $p ]] && echo 2-yes || echo 2-no
[[ /tmp/x == $q ]] && echo 3-yes || echo 3-no
[[ /tmp/x == "$p" ]] && echo 4-yes || echo 4-no
[[ /tmp/x != /tmp/x ]] && echo 5-yes || echo 5-no
[[ /tmpx == /tmp* ]] && echo 6-yes || echo 6-no
cd /tmp || exit 1
[[ $PWD == /tmp ]] && echo 7-yes || echo 7-no
[[ $PWD == /tmp* ]] && echo 8-yes || echo 8-no
[[ $PWD == /var* ]] && echo 9-yes || echo 9-no
## STDOUT:
1-yes
2-yes
3-yes
4-yes
5-no
6-yes
7-yes
8-yes
9-no
## END
## status: 0
