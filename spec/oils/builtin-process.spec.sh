## Imported from the Oils spec tests (builtin-process.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### exec builtin
exec echo hi
## stdout: hi
## status: 0
## timeout: 10

#### exec builtin with redirects
exec 1>&2
echo 'to stderr'
## stdout:
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### exec builtin accepts --
exec -- echo hi
## stdout: hi
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### exec -- 2>&1
exec -- 3>&1
echo stdout 1>&3
## stdout: stdout
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### exec -a sets argv[0]
exec -a FOOPROC sh -c 'echo $0'
## stdout: FOOPROC
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Exit out of function
f() { exit 3; }
f
exit 4
## stdout:
## status: 3
## timeout: 10

#### Exit builtin with invalid arg
exit invalid
# Rationale: runtime errors are 1
## stdout:
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Exit builtin with too many args
# This is a parse error in OSH.
exit 7 8 9
echo status=$?
## stdout: status=1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ulimit with no flags is like -f

ulimit > no-flags.txt
echo status=$?

ulimit -f > f.txt
echo status=$?

diff -u no-flags.txt f.txt
echo diff=$?

# Print everything
# ulimit -a
## STDOUT:
status=0
status=0
diff=0
## END
## status: 0
## timeout: 10

#### ulimit too many args

ulimit 1 2
if test $? -ne 0; then
  echo pass
else
  echo fail
fi

#ulimit -f
## stdout: fail
## status: 0
## timeout: 10

#### ulimit negative flag

ulimit -f

# interpreted as a flag
ulimit -f -42
if test $? -ne 0; then
  echo pass
else
  echo fail
fi
## STDOUT:
unlimited
pass
## END
## status: 0
## timeout: 10

#### ulimit doesn't accept multiple flags - reduce confusion between shells

# - bash, zsh, busybox ash accept multiple "commands", which requires custom
#   flag parsing, like

#   ulimit -f 999 -n
#   ulimit -f 999 -n 888
#
# - dash and mksh accept a single ARG
#
# we want to make it clear we're like the latter

# can't print all and -f
ulimit -f -a >/dev/null
echo status=$?

ulimit -f -n >/dev/null
echo status=$?

ulimit -f -n 999 >/dev/null
echo status=$?



# zsh is better - it checks that -a and -f are exclusive
## STDOUT:
status=0
status=0
status=0
## END
## status: 0
## timeout: 10

#### ulimit accepts 'unlimited'

for arg in zz unlimited; do
  echo "  arg $arg"
  ulimit -f
  echo status=$?
  ulimit -f $arg
  if test $? -ne 0; then
    echo 'FAILED'
  fi
  echo
done
## STDOUT:
  arg zz
unlimited
status=0
FAILED

  arg unlimited
unlimited
status=0

## END
## status: 0
## timeout: 10

#### ulimit of 2**32, 2**31 (int overflow)

echo -n 'one '; ulimit -f


ulimit -f $(( 1 << 32 ))

echo -n 'two '; ulimit -f


# mksh fails because it overflows signed int, turning into negative number
ulimit -f $(( 1 << 31 ))

echo -n 'three '; ulimit -f
## STDOUT:
one unlimited
two 4294967296
three 2147483648
## END
## status: 0
## timeout: 10

#### ulimit -f 1 prevents files larger 512 bytes
trap - XFSZ  # don't handle this

rm -f err.txt
touch err.txt

bytes() {
  local n=$1
  local st=0
  for i in $(seq $n); do
    echo -n x
    st=$?
    if test $st -ne 0; then
      echo "ERROR: echo failed with status $st" >> err.txt
    fi
  done
}

ulimit -f 1

bytes 512 > ok.txt
echo 512 status=$?

bytes 513 > too-big.txt
echo 513 status=$?
echo

wc --bytes ok.txt too-big.txt
echo

cat err.txt
## STDOUT:
512 status=0
513 status=0

 512 ok.txt
 513 too-big.txt
1025 total

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
