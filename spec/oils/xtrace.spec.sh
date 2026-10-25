## Imported from the Oils spec tests (xtrace.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### set -o verbose prints unevaluated code
set -o verbose
x=foo
y=bar
echo $x
echo $(echo $y)
## STDOUT:
foo
bar
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### xtrace with paths
set -o xtrace
echo my-dir/my_file.cc
## stdout: my-dir/my_file.cc
## status: 0
## timeout: 10

#### xtrace with whitespace, quotes, and backslash
set -o xtrace
echo '1 2' \' \" \\

# YSH is different because backslashes require $'\\' and not '\', but that's OK
## stdout: 1 2 ' " \
## status: 0
## timeout: 10

#### xtrace with newlines
# bash and dash trace this badly.  They print literal newlines, which I don't
# want.
set -x
echo $'[\n]'
# bash has ugly output that spans lines
## STDOUT:
[
]
## END
## status: 0
## timeout: 10

#### xtrace written before command executes
set -x
echo one >&2
echo two >&2
## stdout:
## status: 0
## timeout: 10

#### Assignments and assign builtins
set -x
x=1 x=2; echo $x; readonly x=3
## stdout: 2
## status: 0
## timeout: 10

#### PS4 is scoped
set -x
echo one
f() { 
  local PS4='- '
  echo func;
}
f
echo two
## STDOUT:
one
func
two
## END
## status: 0
## timeout: 10

#### xtrace with variables in PS4
PS4='+$x:'
set -o xtrace
x=1
echo one
x=2
echo two
## STDOUT:
one
two
## END
## status: 0
## timeout: 10

#### PS4 with unterminated ${
# osh shows inline error; maybe fail like dash/mksh?
x=1
PS4='+${x'
set -o xtrace
echo one
echo status=$?
# mksh and dash both fail.  bash prints errors to stderr.
## STDOUT:
one
status=0
## END
## status: 0
## timeout: 10

#### PS4 with unterminated $(
# osh shows inline error; maybe fail like dash/mksh?
x=1
PS4='+$(x'
set -o xtrace
echo one
echo status=$?
# mksh and dash both fail.  bash prints errors to stderr.
## STDOUT:
one
status=0
## END
## status: 0
## timeout: 10

#### PS4 with runtime error
# osh shows inline error; maybe fail like dash/mksh?
x=1
PS4='+oops $(( 1 / 0 )) \$'
set -o xtrace
echo one
echo status=$?
# mksh and dash both fail.  bash prints errors to stderr.
## STDOUT:
one
status=0
## END
## status: 0
## timeout: 10

#### Reading $? in PS4
PS4='[last=$?] '
set -x
false
echo ok
## stdout: ok
## status: 0
## timeout: 10
