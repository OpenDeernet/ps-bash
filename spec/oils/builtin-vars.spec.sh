## Imported from the Oils spec tests (builtin-vars.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Export sets a global variable
# Even after you do export -n, it still exists.
f() { export GLOBAL=X; }
f
echo $GLOBAL
printenv.py GLOBAL
## stdout: X
## status: 127
## timeout: 10

#### Export sets a global variable that persists after export -n
f() { export GLOBAL=X; }
f
echo $GLOBAL
printenv.py GLOBAL
export -n GLOBAL
echo $GLOBAL
printenv.py GLOBAL
## STDOUT:
X
X
## END
## status: 127
## timeout: 10

#### export -n undefined is ignored
set -o errexit
export -n undef
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### export -n foo=bar not allowed
foo=old
export -n foo=new
echo status=$?
echo $foo
## STDOUT:
status=0
new
## END
## status: 0
## timeout: 10

#### Export a global variable and unset it
f() { export GLOBAL=X; }
f
echo $GLOBAL
printenv.py GLOBAL
unset GLOBAL
echo g=$GLOBAL
printenv.py GLOBAL
## STDOUT:
X
g=
## END
## status: 127
## timeout: 10

#### Export existing global variables
G1=g1
G2=g2
export G1 G2
printenv.py G1 G2
## stdout:
## status: 127
## timeout: 10

#### Export existing local variable
f() {
  local L1=local1
  export L1
  printenv.py L1
}
f
printenv.py L1
## stdout:
## status: 127
## timeout: 10

#### Export a local that shadows a global
V=global
f() {
  local V=local1
  export V
  printenv.py V
}
f
printenv.py V  # exported local out of scope; global isn't exported yet
export V
printenv.py V  # now it's exported
## stdout:
## status: 127
## timeout: 10
