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

#### help oils-err-12 (case insensitive)

# note that the topics are lower-casedo

help oils-err-12 | grep -o 'catalog.html#oils-err-12'
echo status=$?

help OILS-ERR-12 | grep -o 'catalog.html#oils-err-12'
echo status=$?

# these are bad

# help oils-err-zz
# echo status=$?

# help OILS-ERR-zz
# echo status=$?
## STDOUT:
status=1
status=1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
