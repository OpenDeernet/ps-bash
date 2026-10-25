## Imported from the Oils spec tests (ysh-bin.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Array func
write @[split('foo bar')]
## stdout:
## status: 2
## timeout: 10
