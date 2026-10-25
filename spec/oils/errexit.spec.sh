## Imported from the Oils spec tests (errexit.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### errexit aborts early
set -o errexit
false
echo done
## stdout:
## status: 1
## timeout: 10

#### errexit for nonexistent command
set -o errexit
nonexistent__ZZ
echo done
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### errexit aborts early on pipeline
set -o errexit
echo hi | grep nonexistent
echo two
## stdout:
## status: 1
## timeout: 10

#### errexit with { }
# This aborts because it's not part of an if statement.
set -o errexit
{ echo one; false; echo two; }
## stdout: one
## status: 1
## timeout: 10

#### errexit with if and { }
set -o errexit
if { echo one; false; echo two; }; then
  echo three
fi
echo four
## STDOUT:
one
two
three
four
## END
## status: 0
## timeout: 10

#### errexit with ||
set -o errexit
echo hi | grep nonexistent || echo ok
## stdout: ok
## status: 0
## timeout: 10

#### errexit with &&
set -o errexit
echo ok && echo hi | grep nonexistent 
## stdout: ok
## status: 1
## timeout: 10

#### errexit test && -- from gen-module-init
set -o errexit
test "$mod" = readline && echo "#endif"
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### errexit test && and fail
set -o errexit
test -n X && false
echo status=$?
## stdout:
## status: 1
## timeout: 10

#### errexit and loop
set -o errexit
for x in 1 2 3; do
  test $x = 2 && echo "hi $x"
done
## stdout: hi 2
## status: 1
## timeout: 10

#### errexit and brace group { }
set -o errexit
{ test no = yes && echo hi; }
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### errexit and time { }
set -o errexit
time false
echo status=$?
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### errexit with !
set -o errexit
echo one
! true
echo two
! false
echo three
## STDOUT:
one
two
three
## END
## status: 0
## timeout: 10

#### errexit with ! and ;
# AST has extra Sentence nodes; there was a REGRESSION here.
set -o errexit; echo one; ! true; echo two; ! false; echo three
## STDOUT:
one
two
three
## END
## status: 0
## timeout: 10

#### errexit with while/until
set -o errexit
while false; do
  echo ok
done
until false; do
  echo ok  # do this once then exit loop
  break
done
## stdout: ok
## status: 0
## timeout: 10

#### errexit with (( ))
# from http://mywiki.wooledge.org/BashFAQ/105, this changed between versions.
# ash says that 'i++' is not found, but it doesn't exit.  I guess this is the 
# subshell problem?
set -o errexit
i=0
(( i++ ))
echo done
## stdout:
## status: 1
## timeout: 10

#### while loop - redirect failure checked

# bash 5.2 fixed bash 4.4 bug: this is now checked

# case from
# https://lists.gnu.org/archive/html/bug-bash/2020-05/msg00066.html

set -o errexit

while read line; do
 echo $line
done < not_exist.txt   

echo status=$?
echo 'should not get here'
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### errexit and compound command with redirect, ending with && (regression)
set -o errexit

found=0
while read -r line; do
  test "$line" = key && found=1
done <<EOF
key
other
EOF
echo while found=$found

for x in a b; do
  test "$x" = a && echo "for $x"
done > /dev/null
echo for status=$?

{ test no = yes && echo hi; } < /dev/null
echo brace status=$?

if true; then
  test no = yes && echo hi
fi > /dev/null
echo if status=$?

case x in
  x) test no = yes && echo hi ;;
esac < /dev/null
echo case status=$?

# A failure that is not exempt still exits
{ echo one; false; echo two; } < /dev/null
echo bad
## STDOUT:
while found=1
for status=1
brace status=1
if status=1
case status=1
one
## END
## status: 1
## timeout: 10

#### set -e enabled in function (regression)
foo() {
  set -e
  false
  echo "should be executed"
}
#foo && true
#foo || true

if foo; then
  true
fi

echo "should be executed"
## STDOUT:
should be executed
should be executed
## END
## status: 0
## timeout: 10

#### set -e in function #2
foo() {
  set -e
  false
  echo "should be executed"
}
! foo

echo "should be executed"
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Command sub exit code is lost
echo ft $(false) $(true)
echo status=$?

set -o errexit
shopt -s inherit_errexit || true

# This changes it
#shopt -s command_sub_errexit || true

echo f $(date %x)
echo status=$?

# compare with 
# x=$(date %x)         # FAILS
# local x=$(date %x)   # does NOT fail

echo ft $(false) $(true)
echo status=$?
## STDOUT:
ft
status=0
f
status=0
ft
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
