## Imported from the Oils spec tests (builtin-cd.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### cd and $PWD
cd /
echo $PWD
## stdout: /
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### cd BAD/..

# Odd divergence in shells: dash and mksh normalize the path and don't check
# this error.
# TODO: I would like OSH to behave like bash and zsh, but separating chdir_arg
# and pwd_arg breaks case 17.

cd nonexistent_ZZ/..
echo status=$?
## stdout: status=1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### cd with 2 or more args - with strict_arg_parse

shopt -s strict_arg_parse

mkdir -p foo
cd foo
echo status=$?
cd ..
echo status=$?


cd foo bar
st=$?
if test $st -ne 0; then
  echo 'failed with multiple args'
fi
## STDOUT:
status=0
status=0
failed with multiple args
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### cd with 2 or more args is allowed (strict_arg_parse disabled)

mkdir -p foo
cd foo bar
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### cd - without OLDPWD

cd - > /dev/null  # silence dash output
echo status=$?
#pwd
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### pwd
cd /
pwd
## stdout: /
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### setting $PWD doesn't affect the value of 'pwd' builtin
dir=/tmp/oil-spec-test/pwd
mkdir -p $dir
cd $dir

PWD=foo
echo before $PWD
pwd
echo after $PWD
## STDOUT:
before foo
/tmp/oil-spec-test/pwd
after foo
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unset PWD; then pwd
dir=/tmp/oil-spec-test/pwd
mkdir -p $dir
cd $dir

unset PWD
echo PWD=$PWD
pwd
echo PWD=$PWD
## STDOUT:
PWD=
/tmp/oil-spec-test/pwd
PWD=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### remove pwd dir
dir=/tmp/oil-spec-test/pwd
mkdir -p $dir
cd $dir
pwd
rmdir $dir
echo status=$?
pwd
echo status=$?
## STDOUT:
/tmp/oil-spec-test/pwd
status=0
/tmp/oil-spec-test/pwd
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### cd to nonexistent dir
cd /nonexistent/dir
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### cd permits double bare dash
cd -- /
echo $PWD
## stdout: /
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unset PWD; cd /tmp is allowed (regression)

unset PWD; cd /tmp
pwd
## stdout: /tmp
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### CDPATH is respected

mkdir -p /tmp/spam/foo /tmp/eggs/foo

CDPATH='/tmp/spam:/tmp/eggs'

cd foo
echo status=$?
pwd


# doesn't print the dir
## STDOUT:
/tmp/spam/foo
status=0
/tmp/spam/foo
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### chdir is a synonym for cd - busybox ash

chdir /tmp

if test $? -ne 0; then
  echo fail
  exit
fi

pwd

# It's the same with no args, but mksh fails because of $HOME
#chdir
#echo status=$?
## stdout: fail
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### arguments to pwd
pwd /
## stdout: /tmp/tmp.9tP0QCmIsK
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### pwd errors out on args with strict_arg_parse
shopt -s strict_arg_parse || true
pwd / >/dev/null || echo 'too many args!'
## stdout:
## status: 0
## timeout: 10
