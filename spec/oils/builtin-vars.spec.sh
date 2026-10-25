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

#### Unset nonexistent variable
unset ZZZ
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### Unset readonly variable
# dash and zsh abort the whole program.   OSH doesn't?
readonly R=foo
unset R
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### Unset a function without -f
f() {
  echo foo
}
f
unset f
f
## stdout: foo
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Unset has dynamic scope
f() {
  unset foo
}
foo=bar
echo foo=$foo
f
echo foo=$foo
## STDOUT:
foo=bar
foo=
## END
## status: 0
## timeout: 10

#### Unset and scope (bug #653)
unlocal() { unset "$@"; }

level2() {
  local hello=yy

  echo level2=$hello
  unlocal hello
  echo level2=$hello
}

level1() {
  local hello=xx

  level2

  echo level1=$hello
  unlocal hello
  echo level1=$hello

  level2
}

hello=global
level1

# bash, mksh, yash agree here.
## STDOUT:
level2=yy
level2=xx
level1=xx
level1=global
level2=yy
level2=global
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unset of local reveals variable in higher scope

# OSH has a RARE behavior here (matching yash and mksh), but at least it's
# consistent.

x=global
f() {
  local x=foo
  echo x=$x
  unset x
  echo x=$x
}
f
## STDOUT:
x=foo
x=
## END
## status: 0
## timeout: 10

#### Unset invalid variable name
unset %
echo status=$?
# dash does a hard failure!
## stdout: status=0
## status: 0
## timeout: 10
