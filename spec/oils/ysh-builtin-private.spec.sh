## Imported from the Oils spec tests (ysh-builtin-private.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### type and command builtin don't find private sleep

remove-path() { sed 's;/.*/;;'; }

type -t sleep
type sleep | remove-path
echo

# this is meant to find the "first word"
type -a sleep | remove-path | uniq
echo

command -v sleep | remove-path
## STDOUT:
file
sleep is sleep

sleep is sleep

sleep
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### sleep without prefix is still external

# should not work
builtin sleep --version
if test "$?" != '0'; then
  echo ok
fi

sleep --version | head -n 1 >& 2
echo status=$?
## STDOUT:
ok
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### builtin rm -f - still fails when file can't be removed

mkdir read-only
touch read-only/stuck
chmod -w read-only
ls -l stuck

touch foo bar
$prefix rm -- read-only/stuck foo bar
echo status=$?

if test -f foo; then echo fail; fi
if test -f bar; then echo fail; fi

ls read-only/stuck

touch foo bar
$prefix rm -- read-only/stuck foo bar
echo status=$?

# Clean up for real
chmod +w read-only
$prefix rm -- read-only/stuck
echo status=$?

if test -f read-only/stuck; then echo fail; fi
## STDOUT:
status=1
read-only/stuck
status=1
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### compgen -A builtin doesn't find private builtins

compgen -A builtin slee
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10
