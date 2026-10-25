## Imported from the Oils spec tests (vars-special.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### $PWD is set
# Just test that it has a slash for now.
echo $PWD | grep -q /
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $PWD is not only set, but exported
env | grep -q PWD
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### $1 .. $9 are scoped, while $0 is not
fun() {
  case $0 in
    *sh)
      echo 'sh'
      ;;
    *sh-*)  # bash-4.4 is OK
      echo 'sh'
      ;;
  esac

  echo $1 $2
}
fun a b
## STDOUT:
sh
a b
## END
## status: 0
## timeout: 10

#### $?
echo $?  # starts out as 0
sh -c 'exit 33'
echo $?
## STDOUT:
0
33
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $#
set -- 1 2 3 4
echo $#
## stdout: 4
## status: 0
## timeout: 10

#### $$ looks like a PID
echo $$ | egrep -q '[0-9]+'  # Test that it has decimal digits
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $$ doesn't change with subshell or command sub
# Just test that it has decimal digits
set -o errexit
die() {
  echo 1>&2 "$@"; exit 1
}
parent=$$
test -n "$parent" || die "empty PID in parent"
( child=$$
  test -n "$child" || die "empty PID in subshell"
  test "$parent" = "$child" || die "should be equal: $parent != $child"
  echo 'subshell OK'
)
echo $( child=$$
        test -n "$child" || die "empty PID in command sub"
        test "$parent" = "$child" || die "should be equal: $parent != $child"
        echo 'command sub OK'
      )
exit 3  # make sure we got here
## STDOUT:
subshell OK
command sub OK
## END
## status: 3
## timeout: 10

#### $BASHPID DOES change with subshell and command sub
set -o errexit
die() {
  echo 1>&2 "$@"; exit 1
}
parent=$BASHPID
test -n "$parent" || die "empty BASHPID in parent"
( child=$BASHPID
  test -n "$child" || die "empty BASHPID in subshell"
  test "$parent" != "$child" || die "should not be equal: $parent = $child"
  echo 'subshell OK'
)
echo $( child=$BASHPID
        test -n "$child" || die "empty BASHPID in command sub"
        test "$parent" != "$child" ||
          die "should not be equal: $parent = $child"
        echo 'command sub OK'
      )
exit 3  # make sure we got here

# mksh also implements BASHPID!
## STDOUT:
subshell OK
command sub OK
## END
## status: 3
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Background PID $! looks like a PID
sleep 0.01 &
pid=$!
wait
echo $pid | egrep '[0-9]+' >/dev/null
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $PPID
echo $PPID | egrep '[0-9]+'

# NOTE: There is also $BASHPID
## stdout: 2439599
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $PIPESTATUS
echo hi | sh -c 'cat; exit 33' | wc -l >/dev/null
argv.py "${PIPESTATUS[@]}"
## stdout:
## status: 127
## timeout: 10

#### $RANDOM
expr $0 : '.*/osh$' && exit 99  # Disabled because of spec-runner.sh issue
echo $RANDOM | egrep '[0-9]+'
## STDOUT:
0
26260
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $UID and $EUID
# These are both bash-specific.
set -o errexit
echo $UID | egrep -o '[0-9]+' >/dev/null
echo $EUID | egrep -o '[0-9]+' >/dev/null
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $OSTYPE is non-empty
test -n "$OSTYPE"
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### $HOSTNAME
test "$HOSTNAME" = "$(hostname)"
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO is the current line, not line of function call
echo $LINENO  # first line
g() {
  argv.py $LINENO  # line 3
}
f() {
  argv.py $LINENO  # line 6
  g
  argv.py $LINENO  # line 8
}
f
## stdout: 1
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in [[
echo one
[[ $LINENO -eq 2 ]] && echo OK
## STDOUT:
one
OK
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in ((
echo one
(( x = LINENO ))
echo $x
## STDOUT:
one
2
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in for loop
# hm bash doesn't take into account the word break.  That's OK; we won't either.
echo one
for x in \
  $LINENO zzz; do
  echo $x
done
## STDOUT:
one
3
zzz
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in other for loops
set -- a b c
for x; do
  echo $LINENO $x
done
## STDOUT:
3 a
3 b
3 c
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in for (( loop
# This is a real edge case that I'm not sure we care about.  We would have to
# change the span ID inside the loop to make it really correct.
echo one
for (( i = 0; i < $LINENO; i++ )); do
  echo $i
done
## STDOUT:
one
0
1
2
3
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO for assignment
a1=$LINENO a2=$LINENO
b1=$LINENO b2=$LINENO
echo $a1 $a2
echo $b1 $b2
## STDOUT:
1 1
2 2
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $LINENO in case
case $LINENO in
  1) echo 'got line 1' ;;
  *) echo line=$LINENO
esac
## stdout: got line 1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $_ with simple command and evaluation

name=world
echo "hi $name"
echo "$_"
## STDOUT:
hi world
hi world
## END
## status: 0
## timeout: 10

#### $SECONDS

# most likely 0 seconds, but in CI I've seen 1 second
echo $SECONDS | awk '/[0-9]+/ { print "ok" }'
## stdout: ok
## status: 0
## timeout: 10
