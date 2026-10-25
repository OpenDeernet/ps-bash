## Imported from the Oils spec tests (assign.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Env value doesn't persist
FOO=foo printenv.py FOO
echo -$FOO-
## stdout: --
## status: 0
## timeout: 10

#### Env value with equals
FOO=foo=foo printenv.py FOO
## stdout:
## status: 127
## timeout: 10

#### Env binding can use preceding bindings, but not subsequent ones
# This means that for ASSIGNMENT_WORD, on the RHS you invoke the parser again!
# Could be any kind of quoted string.
FOO="foo" BAR="[$FOO][$BAZ]" BAZ=baz printenv.py FOO BAR BAZ
## stdout:
## status: 127
## timeout: 10

#### Env value with two quotes
FOO='foo'"adjacent" printenv.py FOO
## stdout:
## status: 127
## timeout: 10

#### Env value with escaped <
FOO=foo\<foo printenv.py FOO
## stdout:
## status: 127
## timeout: 10

#### FOO=foo echo [foo]
FOO=foo echo "[$foo]"
## stdout: []
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### FOO=foo fun
fun() {
  echo "[$FOO]"
}
FOO=foo fun
## stdout: [foo]
## status: 0
## timeout: 10

#### Multiple temporary envs on the stack
g() {
  echo "$F" "$G1" "$G2"
  echo '--- g() ---'
  P=p printenv.py F G1 G2 A P
}
f() {
  # NOTE: G1 doesn't pick up binding f, but G2 picks up a.
  # I don't quite understand why this is, but bash and OSH agree!
  G1=[$f] G2=[$a] g
  echo '--- f() ---'
  printenv.py F G1 G2 A P
}
a=A
F=f f
## STDOUT:
f [] [A]
--- g() ---
--- f() ---
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Escaped = in command name
# foo=bar is in the 'spec/bin' dir.
foo\=bar
## stdout:
## status: 127
## timeout: 10

#### Env binding not allowed before compound command
# bash gives exit code 2 for syntax error, because of 'do'.
# dash gives 0 because there is stuff after for?  Should really give an error.
# mksh gives acceptable error of 1.
FOO=bar for i in a b; do printenv.py $FOO; done
## stdout:
## status: 2
## timeout: 10

#### Trying to run keyword 'for'
FOO=bar for
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Empty env binding
EMPTY= printenv.py EMPTY
## stdout:
## status: 127
## timeout: 10

#### Assignment doesn't do word splitting
words='one two'
a=$words
argv.py "$a"
## stdout:
## status: 127
## timeout: 10

#### Assignment doesn't do glob expansion
touch _tmp/z.Z _tmp/zz.Z
a=_tmp/*.Z
argv.py "$a"
## stdout:
## status: 127
## timeout: 10

#### Env binding in readonly/declare is NOT exported!  (pitfall)

# All shells agree on this, but it's very confusing behavior.
FOO=foo readonly v=$(printenv.py FOO)
echo "v=$v"

# bash has probems here:
FOO=foo readonly v2=$FOO
echo "v2=$v2"
## STDOUT:
v=
v2=
## END
## status: 0
## timeout: 10

#### assignments / array assignments not interpreted after 'echo'
a=1 echo b[0]=2 c=3
# zsh interprets [0] as some kind of glob
## stdout: b[0]=2 c=3
## status: 0
## timeout: 10

#### dynamic local variables (and splitting)
f() {
  local "$1"  # Only x is assigned here
  echo x=\'$x\'
  echo a=\'$a\'

  local $1  # x and a are assigned here
  echo x=\'$x\'
  echo a=\'$a\'
}
f 'x=y a=b'
# osh and zsh don't do word splitting
## STDOUT:
x='y a=b'
a=''
x='y'
a='b'
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### readonly x= gives empty string (regression)
readonly x=
argv.py "$x"
## stdout:
## status: 127
## timeout: 10

#### 'local x' does not set variable
set -o nounset
f() {
  local x
  echo $x
}
f
## stdout:
## status: 1
## timeout: 10

#### 'local -a x' does not set variable
set -o nounset
f() {
  local -a x
  echo $x
}
f
## stdout:
## status: 1
## timeout: 10

#### 'local x' and then array assignment
f() {
  local x
  x[3]=foo
  echo ${x[3]}
}
f
## stdout: foo
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### 'declare -A' and then dict assignment
declare -A foo
key=bar
foo["$key"]=value
echo ${foo["bar"]}
## stdout: value
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### declare in an if statement
# bug caught by my feature detection snippet in bash-completion
if ! foo=bar; then
  echo BAD
fi
echo $foo
if ! eval 'spam=eggs'; then
  echo BAD
fi
echo $spam
## STDOUT:
bar
eggs
## END
## status: 0
## timeout: 10

#### Modify a temporary binding
# (regression for bug found by Michael Greenberg)
f() {
  echo "x before = $x"
  x=$((x+1))
  echo "x after  = $x"
}
x=5 f
## STDOUT:
x before = 5
x after  = 6
## END
## status: 0
## timeout: 10

#### Reveal existence of "temp frame" (All shells disagree here!!!)
f() {
  echo "x=$x"

  x=mutated-temp  # mutate temp frame
  echo "x=$x"

  # Declare a new local
  local x='local'
  echo "x=$x"

  # Unset it
  unset x
  echo "x=$x"
}

x=global
x=temp-binding f
echo "x=$x"
## STDOUT:
x=temp-binding
x=mutated-temp
x=local
x=
x=global
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Test above without 'local' (which is not POSIX)
f() {
  echo "x=$x"

  x=mutated-temp  # mutate temp frame
  echo "x=$x"

  # Unset it
  unset x
  echo "x=$x"
}

x=global
x=temp-binding f
echo "x=$x"
## STDOUT:
x=temp-binding
x=mutated-temp
x=global
x=global
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Using ${x-default} after unsetting local shadowing a global
f() {
  echo "x=$x"
  local x='local'
  echo "x=$x"
  unset x
  echo "- operator = ${x-default}"
  echo ":- operator = ${x:-default}"
}
x=global
f
## STDOUT:
x=global
x=local
- operator = default
:- operator = default
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Using ${x-default} after unsetting a temp binding shadowing a global
f() {
  echo "x=$x"
  local x='local'
  echo "x=$x"
  unset x
  echo "- operator = ${x-default}"
  echo ":- operator = ${x:-default}"
}
x=global
x=temp-binding f
## STDOUT:
x=temp-binding
x=local
- operator = default
:- operator = default
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### static assignment doesn't split
words='a b c'
export ex=$words
glo=$words
readonly ro=$words
argv.py "$ex" "$glo" "$ro"
## stdout:
## status: 127
## timeout: 10

#### aliased assignment doesn't split
shopt -s expand_aliases || true
words='a b c'
alias e=export
alias r=readonly
e ex=$words
r ro=$words
argv.py "$ex" "$ro"
## stdout:
## status: 127
## timeout: 10

#### assignment using dynamic keyword (splits in most shells, not in zsh/osh)
words='a b c'
e=export
r=readonly
$e ex=$words
$r ro=$words
argv.py "$ex" "$ro"

# zsh and OSH are smart
## stdout:
## status: 127
## timeout: 10

#### assignment using dynamic var names doesn't split
words='a b c'
arg_ex=ex=$words
arg_ro=ro=$words

# no quotes, this is split of course
export $arg_ex
readonly $arg_ro

argv.py "$ex" "$ro"

arg_ex2=ex2=$words
arg_ro2=ro2=$words

# quotes, no splitting
export "$arg_ex2"
readonly "$arg_ro2"

argv.py "$ex2" "$ro2"
## stdout:
## status: 127
## timeout: 10

#### readonly $x where x='b c'
one=a
two='b c'
readonly $two $one
a=new
echo status=$?
b=new
echo status=$?
c=new
echo status=$?

# in OSH and zsh, this is an invalid variable name

# most shells make two variable read-only
## STDOUT:
status=1
status=1
status=1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### readonly a=(1 2) no_value c=(3 4) makes 'no_value' readonly
readonly a=(1 2) no_value c=(3 4)
no_value=x
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### export a=1 no_value c=2
no_value=foo
export a=1 no_value c=2
printenv.py no_value
## stdout:
## status: 127
## timeout: 10

#### local a=loc $var c=loc
var='b'
b=global
echo $b
f() {
  local a=loc $var c=loc
  argv.py "$a" "$b" "$c"
}
f
## stdout: global
## status: 127
## timeout: 10

#### redirect after assignment builtin (eval redirects after evaluating arguments)

# See also: spec/redir-order.test.sh (#2307)
# The $(stdout_stderr.py) is evaluated *before* the 2>/dev/null redirection

readonly x=$(stdout_stderr.py) 2>/dev/null
echo done
## stdout: done
## status: 0
## timeout: 10

#### redirect after command sub (like case above but without assignment builtin)
echo stdout=$(stdout_stderr.py) 2>/dev/null
## stdout: stdout=
## status: 0
## timeout: 10

#### redirect after bare assignment
x=$(stdout_stderr.py) 2>/dev/null
echo done
## stdout: done
## status: 0
## timeout: 10
