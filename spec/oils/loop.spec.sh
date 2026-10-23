## Imported from the Oils spec tests (oils-loop.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### implicit for loop
# This is like "for i in $@".
fun() {
  for i; do
    echo $i
  done
  echo "finished=$i"
}
fun 1 2 3
## STDOUT:
1
2
3
finished=3
## END
## status: 0
## timeout: 10

#### empty for loop (has "in")
set -- 1 2 3
for i in ; do
  echo $i
done
## stdout:
## status: 0
## timeout: 10

#### for loop with invalid identifier
# should be compile time error, but runtime error is OK too
for - in a b c; do
  echo hi
done
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### the word 'in' can be the loop variable

for in in a b c; do
  echo $in
done
echo finished=$in
## STDOUT:
a
b
c
finished=c
## END
## status: 0
## timeout: 10

#### bad arg to break
x=oops
while true; do 
  echo hi
  break $x
  sleep 0.1
done
## stdout: hi
## status: 128
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### too many args to continue
# OSH treats this as a parse error
for x in a b c; do
  echo $x
  # bash breaks rather than continue or fatal error!!!
  continue 1 2 3
done
echo --
a
b
c
--
## STDOUT:
a
--
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### break in condition of loop
while break; do
  echo x
done
echo done
## stdout: done
## status: 0
## timeout: 10

#### break in condition of nested loop
for i in 1 2 3; do
  echo i=$i
  while break; do
    echo x
  done
done
echo done
## STDOUT:
i=1
i=2
i=3
done
## END
## status: 0
## timeout: 10

#### return within eval
f() {
  echo one
  eval 'return'
  echo two
}
f
## stdout: one
## status: 0
## timeout: 10

#### break/continue within eval
# NOTE: This changes things
# set -e
f() {
  for i in $(seq 5); do 
    if test $i = 2; then
      eval continue
    fi
    if test $i = 4; then
      eval break
    fi
    echo $i
  done

  eval 'return'
  echo 'done'
}
f
## STDOUT:
1
3
## END
## status: 0
## timeout: 10

#### multi-level break with argument

# reported in issue #1459

counterA=100
counterB=100

while test "$counterA" -gt 0
do
    counterA=$((counterA - 1))
    while test "$counterB" -gt 0
    do
        counterB=$((counterB - 1))
        if test "$counterB" = 50
        then
            break 2
        fi
    done
done

echo "$counterA"
echo "$counterB"
## STDOUT:
99
50
## END
## status: 0
## timeout: 10

#### multi-level continue

for i in 1 2; do
  for j in a b c; do
    if test $j = b; then
      continue
    fi
    echo $i $j
  done
done

echo ---

for i in 1 2; do
  for j in a b c; do
    if test $j = b; then
      continue 2   # MULTI-LEVEL
    fi
    echo $i $j
  done
done
## STDOUT:
1 a
1 c
2 a
2 c
---
1 a
2 a
## END
## status: 0
## timeout: 10

#### $b break, $c continue, $r return, $e exit

# hm would it be saner to make FATAL builtins called break/continue/etc.?
# On the other hand, this spits out errors loudly.

echo '- break'
b=break
for i in 1 2 3; do
  echo $i
  $b
done

echo '- continue'
c='continue'
for i in 1 2 3; do
  if test $i = 2; then
    $c
  fi
  echo $i
done

r='return'
f() {
  echo '- return'
  for i in 1 2 3; do
    echo $i
    if test $i = 2; then
      $r 99
    fi
  done
}
f
echo status=$?

echo '- exit'
e='exit'
$e 5
echo 'not executed'
## STDOUT:
- break
1
- continue
1
3
- return
1
2
status=99
- exit
## END
## status: 5
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### \break \continue \return \exit

echo '- break'
for i in 1 2 3; do
  echo $i
  \break
done

echo '- continue'
for i in 1 2 3; do
  if test $i = 2; then
    \continue
  fi
  echo $i
done

f() {
  echo '- return'
  for i in 1 2 3; do
    echo $i
    if test $i = 2; then
      \return 99
    fi
  done
}
f
echo status=$?

echo '- exit'
\exit 5
echo 'not executed'
## STDOUT:
- break
1
- continue
1
3
- return
1
2
status=99
- exit
## END
## status: 5
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
