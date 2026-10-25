## Imported from the Oils spec tests (assign-extended.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### local -a
# nixpkgs setup.sh uses this (issue #26)
f() {
  local -a array=(x y z)
  argv.py "${array[@]}"
}
f
## stdout:
## status: 127
## timeout: 10

#### declare -a
# nixpkgs setup.sh uses this (issue #26)
declare -a array=(x y z)
argv.py "${array[@]}"
## stdout:
## status: 127
## timeout: 10

#### declare -f exit code indicates function existence
func2=x  # var names are NOT found
declare -f myfunc func2
echo $?

myfunc() { echo myfunc; }
declare -f myfunc func2 > /dev/null
echo $?

func2() { echo func2; }
declare -f myfunc func2 > /dev/null
echo $?
## STDOUT:
1
1
0
## END
## status: 0
## timeout: 10

#### declare -F prints function names
add () { expr 4 + 4; }
div () { expr 6 / 2; }
ek () { echo hello; }
__ec () { echo hi; }
_ab () { expr 10 % 3; }

declare -F
## STDOUT:
declare -f __ec
declare -f _ab
declare -f add
declare -f div
declare -f ek
## END
## status: 0
## timeout: 10

#### declare -p var (exit status)
var1() { echo func; }  # function names are NOT found.
declare -p var1 var2 >/dev/null
echo $?

var1=x
declare -p var1 var2 >/dev/null
echo $?

var2=y
declare -p var1 var2 >/dev/null
echo $?
## STDOUT:
1
1
0
## END
## status: 0
## timeout: 10

#### declare
test_var1=111
readonly test_var2=222
export test_var3=333
declare -n test_var4=test_var1
f1() {
  local test_var5=555
  {
    echo '[declare]'
    declare
    echo '[readonly]'
    readonly
    echo '[export]'
    export
    echo '[local]'
    local
  } | grep -E '^\[|^\b.*test_var.\b'
}
f1
## STDOUT:
[declare]
test_var1=111
test_var2=222
test_var3=333
test_var4=test_var1
test_var5=555
[readonly]
declare -r test_var2="222"
[export]
declare -x test_var3="333"
[local]
declare -- test_var5="555"
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### declare -p
# BUG: bash doesn't output flags with "local -p", which seems to contradict
#   with manual.
test_var1=111
readonly test_var2=222
export test_var3=333
declare -n test_var4=test_var1
f1() {
  local test_var5=555
  {
    echo '[declare]'
    declare -p
    echo '[readonly]'
    readonly -p
    echo '[export]'
    export -p
    echo '[local]'
    local -p
  } | grep -E '^\[|^\b.*test_var.\b'
}
f1
## STDOUT:
[declare]
declare -- test_var1="111"
declare -r test_var2="222"
declare -x test_var3="333"
declare -n test_var4="test_var1"
declare -- test_var5="555"
[readonly]
declare -r test_var2="222"
[export]
declare -x test_var3="333"
[local]
declare -- test_var5="555"
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### typeset -f
# mksh implement typeset but not declare
typeset  -f myfunc func2
echo $?

myfunc() { echo myfunc; }
# This prints the source code.
typeset  -f myfunc func2 > /dev/null
echo $?

func2() { echo func2; }
typeset  -f myfunc func2 > /dev/null
echo $?
## STDOUT:
1
1
0
## END
## status: 0
## timeout: 10

#### myvar=typeset (another form of dynamic assignment)
myvar=typeset
x='a b'
$myvar x=$x
echo $x
## stdout: a
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### dynamic array parsing is not allowed
code='x=(1 2 3)'
typeset -a "$code"  # note: -a flag is required
echo status=$?
argv.py "$x"
# bash allows it
## stdout: status=0
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### dynamic flag in array in assign builtin
typeset b
b=(unused1 unused2)  # this works in mksh

a=(x 'foo=F' 'bar=B')
typeset -"${a[@]}"
echo foo=$foo
echo bar=$bar
printenv.py foo
printenv.py bar

# syntax error in mksh!  But works in bash and zsh.
#typeset -"${a[@]}" b=(spam eggs)
#echo "length of b = ${#b[@]}"
#echo "b[0]=${b[0]}"
#echo "b[1]=${b[1]}"
## STDOUT:
foo=F
bar=B
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### typeset +x
export e=E
printenv.py e
typeset +x e=E2
printenv.py e  # no longer exported
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### typeset +r removes read-only attribute (TODO: documented in bash to do nothing)
readonly r=r1
echo r=$r

# clear the readonly flag.  Why is this accepted in bash, but doesn't do
# anything?
typeset +r r=r2 
echo r=$r

r=r3
echo r=$r


# mksh doesn't allow you to unset

# bash doesn't allow you to unset
## STDOUT:
r=r1
r=r1
r=r1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### function name with /
ble/foo() { echo hi; }
declare -F ble/foo
echo status=$?
## STDOUT:
ble/foo
status=0
## END
## status: 0
## timeout: 10

#### invalid var name
typeset foo/bar
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unset and shell funcs
foo() {
  echo bar
}

foo

declare -F
unset foo
declare -F

foo
## STDOUT:
bar
declare -f foo
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
