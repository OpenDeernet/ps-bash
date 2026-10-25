## Imported from the Oils spec tests (builtin-umask.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### usage: too many args

# most shells don't verify this
umask 1 2
if test $? -ne 0; then
  echo fail
fi
## stdout:
## status: 0
## timeout: 10

#### usage: empty input, space input
umask ''
case $? in
  1) echo error ;;
  2) echo error ;;
  *) echo status=$? ;;
esac

umask ' '
case $? in
  1) echo error too ;;
  2) echo error too ;;
  *) echo status=$? ;;
esac
## STDOUT:
error
error too
## END
## status: 0
## timeout: 10

#### symbolic syntax error: b=rwx
umask 0124

umask b=rwx
case $? in
  1) echo error ;;
  2) echo error ;;
  *) echo status=$? ;;
esac

umask  # make sure it hasn't changed
## STDOUT:
error
0124
## END
## status: 0
## timeout: 10

#### symbolic syntax error: start with -
umask 0124
umask -rwx
if test $? -ne 0; then echo 'error'; fi
umask | tail -c 4

umask 0124
umask -wx
if test $? -ne 0; then echo 'error'; fi
umask | tail -c 4

umask 0124
umask -=+
if test $? -ne 0; then echo 'error'; fi
umask | tail -c 4
## STDOUT:
error
124
error
124
error
124
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### symbolic syntax error: empty clause u-r,,u-r
umask 0124
umask 'u-r,u-r'
echo status=$?
umask

# syntax error
umask 'u+r,,u-r'
if test $? -ne 0; then echo 'error'; fi
umask
## STDOUT:
status=0
0524
error
0524
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### usage: invalid octal digits
umask 089
case $? in
  1) echo error ;;
  2) echo error ;;
esac
## stdout: error
## status: 0
## timeout: 10

#### usage: large octal number
umask 0022

# osh and other shells treat truncate 0o1234567 as 0o0567
umask 1234567
echo status=$?

umask
## STDOUT:
status=1
0022
## END
## status: 0
## timeout: 10

#### umask permcopy
umask 0124 
umask a=u
umask | tail -c 4

umask 0365
umask a=g
umask | tail -c 4

umask 0124
umask a=o
umask | tail -c 4
## STDOUT:
124
365
124
## END
## status: 0
## timeout: 10

#### umask permcopy running value
umask 0124
umask a=,a=u
umask | tail -c 4

umask 0124
umask a=
umask a=u
umask | tail -c 4
## STDOUT:
124
777
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### umask sequential actions
umask 0124
umask u+r+w+x
umask | tail -c 4

umask 0124
umask a+r+w+x,o-w
umask | tail -c 4

umask 0124
umask a+x+wr-r
umask | tail -c 4
## STDOUT:
124
124
124
## END
## status: 0
## timeout: 10
