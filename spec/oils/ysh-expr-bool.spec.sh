## Imported from the Oils spec tests (ysh-expr-bool.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### not operator behaves like Python

# consistent with if statement, ternary if, and, or

pp test_ (not "s")
pp test_ (not 3)
pp test_ (not 4.5)
pp test_ (not {})
pp test_ (not [])
pp test_ (not false)
pp test_ (not true)
## stdout:
## status: 2
## timeout: 10

#### not, and, or

var a = not true
echo $a
var b = true and false
echo $b
var c = true or false
echo $c
## STDOUT:



## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### or BashArray, or BashAssoc
declare -a array=(1 2 3)
pp test_ (array or 'yy')

declare -A assoc=([k]=v)
pp test_ (assoc or 'zz')
## stdout:
## status: 2
## timeout: 10

#### x if b else y
var b = true
var i = 42
var t = i+1 if b else i-1
echo $t
var f = i+1 if false else i-1
echo $f
## STDOUT:


## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
