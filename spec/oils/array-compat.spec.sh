## Imported from the Oils spec tests (array-compat.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Assignment Causes Array Decay
set -- x y z
argv.py "[$@]"
var="[$@]"
argv.py "$var"
## stdout:
## status: 127
## timeout: 10

#### Array Decay with IFS
IFS=x
set -- x y z
var="[$@]"
argv.py "$var"
## stdout:
## status: 127
## timeout: 10

#### User arrays decay
declare -a a b
a=(x y z)
b="${a[@]}"  # this collapses to a string
c=("${a[@]}")  # this preserves the array
c[1]=YYY  # mutate a copy -- doesn't affect the original
argv.py "${a[@]}"
argv.py "${b}"
argv.py "${c[@]}"
## stdout:
## status: 127
## timeout: 10

#### strict_array: $array is not valid in OSH, is ${array[0]} in ksh/bash
shopt -s strict_array

a=(1 '2 3')
echo $a
## stdout: 1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### strict_array: ${array} is not valid in OSH, is ${array[0]} in ksh/bash
shopt -s strict_array

a=(1 '2 3')
echo ${a}
## stdout: 1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Assign to array index without initialization
a[5]=5
a[6]=6
echo "${a[@]}" ${#a[@]}
## stdout: 5 6 2
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### a[40] grows array
a=(1 2 3)
a[1]=5
a[40]=30  # out of order
a[10]=20
echo "${a[@]}" "${#a[@]}"  # length is 1
## stdout: 1 5 3 20 30 5
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### array decays to string when comparing with [[ a = b ]]
a=('1 2' '3 4')
s='1 2 3 4'  # length 2, length 4
echo ${#a[@]} ${#s}
[[ "${a[@]}" = "$s" ]] && echo EQUAL
## STDOUT:
2 7
EQUAL
## END
## status: 0
## timeout: 10

#### ++ on a whole array increments the first element (disallowed with strict_array)
shopt -s strict_array

a=(1 10)
(( a++ ))  # doesn't make sense
echo "${a[@]}"
## stdout: 2 10
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Apply vectorized operations on ${a[*]}
a=('-x-' 'y-y' '-z-')

# This does the prefix stripping FIRST, and then it joins.
argv.py "${a[*]#-}"
## stdout:
## status: 127
## timeout: 10
