## Imported from the Oils spec tests (array-sparse.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### test length
sp=(x y z)

sp[5]=z

echo len=${#sp[@]}

sp[10]=z

echo len=${#sp[@]}
## STDOUT:
len=4
len=5
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### +=
sp1[10]=a
sp1[20]=b
sp1[99]=c
typeset -p sp1 | sed 's/"//g'
sp1+=(1 2 3)
typeset -p sp1 | sed 's/"//g'
## STDOUT:
declare -a sp1=([10]=a [20]=b [99]=c)
declare -a sp1=([10]=a [20]=b [99]=c [100]=1 [101]=2 [102]=3)
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### a[i]=v
sp1[10]=a
sp1[20]=b
sp1[30]=c
typeset -p sp1 | sed 's/"//g'
sp1[10]=X
sp1[25]=Y
sp1[90]=Z
typeset -p sp1 | sed 's/"//g'
## STDOUT:
declare -a sp1=([10]=a [20]=b [30]=c)
declare -a sp1=([10]=X [20]=b [25]=Y [30]=c [90]=Z)
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unset -v a[i]
a=(1 2 3 4 5 6 7 8 9)
typeset -p a
unset -v "a[1]"
typeset -p a
unset -v "a[9]"
typeset -p a
unset -v "a[0]"
typeset -p a
## STDOUT:
declare -a a=([0]="1" [1]="2" [2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")
declare -a a=([0]="1" [2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")
declare -a a=([0]="1" [2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")
declare -a a=([2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ((sp[i])) and ((sp[i]++))
a=(1 2 3 4 5 6 7 8 9)
unset -v 'a[2]' 'a[3]' 'a[7]'

echo $((a[0]))
echo $((a[1]))
echo $((a[2]))
echo $((a[3]))
echo $((a[7]))

echo $((a[1]++))
echo $((a[2]++))
echo $((a[3]++))
echo $((a[7]++))

echo $((++a[1]))
echo $((++a[2]))
echo $((++a[3]))
echo $((++a[7]))

echo $((a[1] = 100, a[1]))
echo $((a[2] = 100, a[2]))
echo $((a[3] = 100, a[3]))
echo $((a[7] = 100, a[7]))
## STDOUT:
1
2
0
0
0
2
0
0
0
4
2
2
2
100
100
100
100
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ${a[@]}
a=(v{0,1,2,3,4,5,6,7,8,9})
unset -v 'a[2]' 'a[3]' 'a[4]' 'a[7]'

argv.py "${a[@]}"
argv.py "abc${a[@]}xyz"
## stdout:
## status: 127
## timeout: 10

#### ${a[@]-unset}, ${a[@]:-empty}, etc.
a1=()
a2=("")
a3=("" "")

echo "a1 unset: [${a1[@]-unset}]"
echo "a1 empty: [${a1[@]:-empty}]"
echo "a2 unset: [${a2[@]-unset}]"
echo "a2 empty: [${a2[@]:-empty}]"
echo "a3 unset: [${a3[@]-unset}]"
echo "a3 empty: [${a3[@]:-empty}]"
## STDOUT:
a1 unset: [unset]
a1 empty: [empty]
a2 unset: []
a2 empty: [empty]
a3 unset: [ ]
a3 empty: [ ]
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ${a-}
a1=()
a2=("" "")
a3=(foo bar)

echo "$a1, ${a1-(unset)}, ${a1:-(empty)};"
echo "$a2, ${a2-(unset)}, ${a2:-(empty)};"
echo "$a3, ${a3-(unset)}, ${a3:-(empty)};"
## STDOUT:
, (unset), (empty);
, , (empty);
foo, foo, foo;
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### "${a[*]}"
a=(v{0,1,2,3,4,5,6,7,8,9})
unset -v 'a[3]' 'a[4]' 'a[7]' 'a[9]'

echo "${a[*]}"
IFS=
echo "${a[*]}"
IFS=/
echo "${a[*]}"
## STDOUT:
v0 v1 v2 v5 v6 v8
v0v1v2v5v6v8
v0/v1/v2/v5/v6/v8
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
