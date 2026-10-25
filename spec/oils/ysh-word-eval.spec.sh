## Imported from the Oils spec tests (ysh-word-eval.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### echo $x for various types
const mybool = true
const myint = 42
const myfloat = 3.14

echo $mybool
echo $myint
echo $myfloat
## STDOUT:



## END
## status: 0
## timeout: 10
