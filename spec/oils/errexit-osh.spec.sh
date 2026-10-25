## Imported from the Oils spec tests (errexit-osh.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### command sub: errexit is NOT inherited and outer shell keeps going

# This is the bash-specific bug here:
# https://blogs.janestreet.com/when-bash-scripts-bite/
# See inherit_errexit below.
#
# I remember finding a script that relies on bash's bad behavior, so OSH copies
# it.  But you can opt in to better behavior.

set -o errexit
echo $(echo one; false; echo two)  # bash/ash keep going
echo parent status=$?
# dash and mksh: inner shell aborts, but outer one keeps going!
## STDOUT:
one two
parent status=0
## END
## status: 0
## timeout: 10

#### command sub with inherit_errexit only
set -o errexit
shopt -s inherit_errexit || true
echo zero
echo $(echo one; false; echo two)  # bash/ash keep going
echo parent status=$?
## STDOUT:
zero
one
parent status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### strict_errexit and assignment builtins (local, export, readonly ...)
set -o errexit
shopt -s strict_errexit || true
#shopt -s command_sub_errexit || true

f() {
  local x=$(echo hi; false)
  echo x=$x
}

eval 'f'
echo ---
## STDOUT:
x=hi
---
## END
## status: 0
## timeout: 10

#### strict_errexit disallows pipeline
set -o errexit
shopt -s strict_errexit || true

if echo 1 | grep 1; then
  echo one
fi
## STDOUT:
1
one
## END
## status: 0
## timeout: 10

#### strict_errexit allows singleton pipeline
set -o errexit
shopt -s strict_errexit || true

if ! false; then
  echo yes
fi
## stdout: yes
## status: 0
## timeout: 10

#### strict_errexit with && || !
set -o errexit
shopt -s strict_errexit || true

if true && true; then
  echo A
fi

if true || false; then
  echo B
fi

if ! false && ! false; then
  echo C
fi
## STDOUT:
A
B
C
## END
## status: 0
## timeout: 10

#### strict_errexit detects proc in && || !
set -o errexit
shopt -s strict_errexit || true

myfunc() {
  echo 'failing'
  false
  echo 'should not get here'
}

if true && ! myfunc; then
  echo B
fi

if ! myfunc; then
  echo A
fi


# POSIX shell behavior:
## STDOUT:
failing
should not get here
failing
should not get here
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### strict_errexit without errexit proc
myproc() {
  echo myproc
}
myproc || true

# This should be a no-op I guess
shopt -s strict_errexit || true
myproc || true
## STDOUT:
myproc
myproc
## END
## status: 0
## timeout: 10

#### strict_errexit without errexit proc / command sub

# Implementation quirk:
# - The proc check happens only if errexit WAS on and is disabled
# - But 'shopt --unset allow_csub_psub' happens if it was never on

shopt -s strict_errexit || true

p() {
  echo before
  local x
  # This line fails, which is a bit weird, but errexit
  x=$(false)
  echo x=$x
}

if p; then
  echo ok
fi
## STDOUT:
before
x=
ok
## END
## status: 0
## timeout: 10

#### command sub with command_sub_errexit only
set -o errexit
shopt -s command_sub_errexit || true
echo zero
echo $(echo one; false; echo two)  # bash/ash keep going
echo parent status=$?
## STDOUT:
zero
one two
parent status=0
## END
## status: 0
## timeout: 10

#### command sub with inherit_errexit and command_sub_errexit
set -o errexit

# bash implements inherit_errexit, but it's not as strict as OSH.
shopt -s inherit_errexit || true
shopt -s command_sub_errexit || true
echo zero
echo $(echo one; false; echo two)  # bash/ash keep going
echo parent status=$?
## STDOUT:
zero
one
parent status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command sub: last command fails but keeps going and exit code is 0
set -o errexit
echo $(echo one; false)  # we lost the exit code
echo status=$?
## STDOUT:
one
status=0
## END
## status: 0
## timeout: 10

#### global assignment with command sub: middle command fails
set -o errexit
s=$(echo one; false; echo two;)
echo "$s"
# dash and mksh: whole thing aborts!
## STDOUT:
one
two
## END
## status: 0
## timeout: 10

#### global assignment with command sub: last command fails and it aborts
set -o errexit
s=$(echo one; false)
echo status=$?
## stdout:
## status: 1
## timeout: 10

#### local: middle command fails and keeps going
set -o errexit
f() {
  echo good
  local x=$(echo one; false; echo two)
  echo status=$?
  echo $x
}
f
# for dash and mksh, the INNER shell aborts, but the outer one keeps going!
## STDOUT:
good
status=0
one two
## END
## status: 0
## timeout: 10

#### local: last command fails and also keeps going
set -o errexit
f() {
  echo good
  local x=$(echo one; false)
  echo status=$?
  echo $x
}
f
## STDOUT:
good
status=0
one
## END
## status: 0
## timeout: 10

#### local and inherit_errexit / command_sub_errexit
# I've run into this problem a lot.
set -o errexit
shopt -s inherit_errexit || true  # bash option
shopt -s command_sub_errexit || true  # oil option
f() {
  echo good
  local x=$(echo one; false; echo two)
  echo status=$?
  echo $x
}
f
## STDOUT:
good
status=0
one
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### global assignment when last status is failure
# this is a bug I introduced
set -o errexit
x=$(false) || true   # from abuild
[ -n "$APORTSDIR" ] && true
BUILDDIR=${_BUILDDIR-$BUILDDIR}
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### strict_errexit prevents errexit from being disabled in function
set -o errexit
fun() { echo fun; }

fun || true  # this is OK

shopt -s strict_errexit || true

echo 'builtin ok' || true
env echo 'external ok' || true

fun || true  # this fails
## STDOUT:
fun
builtin ok
external ok
fun
## END
## status: 0
## timeout: 10
