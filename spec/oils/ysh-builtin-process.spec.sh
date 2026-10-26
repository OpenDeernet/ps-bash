## Imported from the Oils spec tests (ysh-builtin-process.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### fork and forkwait usage  errors
shopt --set oil:upgrade
shopt --unset errexit

fork
echo status=$?

fork extra
echo status=$?

fork extra {
  echo hi
}
echo status=$?

#

forkwait
echo status=$?

forkwait extra
echo status=$?

forkwait extra {
  echo hi
}
echo status=$?
## STDOUT:
status=127
status=127
hi
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-process ysh-builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### forkwait
shopt --set oil:upgrade
shopt --unset errexit

old=$PWD

forkwait {
  cd /
  echo hi
  exit 42
}
echo status=$?
if test "$old" = "$PWD"; then
  echo ok
fi
## stdout: hi
## status: 42
## XFAIL ps-bash gap-oils-ysh-builtin-process ysh-builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### fork
shopt --set oil:upgrade
shopt --unset errexit

old=$PWD

fork {
  cd /
  echo hi
  sleep 0.01 
  exit 42
}
#echo status=$?  race condition

wait -n
echo status=$?

if test "$old" = "$PWD"; then
  echo ok
fi
## stdout: hi
## status: 42
## XFAIL ps-bash gap-oils-ysh-builtin-process ysh-builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
