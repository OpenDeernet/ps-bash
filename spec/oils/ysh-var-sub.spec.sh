## Imported from the Oils spec tests (ysh-var-sub.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### ${x|html}
x='echo hi 2>&1'
echo "${x|html}"
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ${x %05d}
x=3
printf '%05d\n' "$x"
echo ${x %05d}
## stdout: 00003
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ${.myproc builtin sub}

proc myproc() {
  echo "$@"
}

echo ${.myproc builtin sub}
## stdout:
## status: 2
## timeout: 10
