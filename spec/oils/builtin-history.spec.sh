## Imported from the Oils spec tests (builtin-history.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### history usage

history not-a-number
echo status=$?

history 3 too-many
echo status=$?
## STDOUT:
status=1
status=1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
