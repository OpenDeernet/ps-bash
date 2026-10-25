## Imported from the Oils spec tests (var-num.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### In function
myfunc() {
  echo $1 ${2}
}
myfunc a b c d
## stdout: a b
## status: 0
## timeout: 10
