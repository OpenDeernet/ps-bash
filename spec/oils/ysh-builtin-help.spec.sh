## Imported from the Oils spec tests (ysh-builtin-help.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### help topic not found

help zz
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### help topics that print URLs

help command-sub | grep -o chap-word-lang.html
echo status=$?

help read | grep -o chap-builtin-cmd.html
echo status=$?
## STDOUT:
status=1
status=1
## END
## status: 0
## timeout: 10

