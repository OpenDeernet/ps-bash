## Imported from the Oils spec tests (ysh-old.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Empty array and assignment builtin (regression)
shopt --unset no_osh_builtins

# Bug happens with shell arrays too
empty=()
declare z=1 "${empty[@]}"
echo z=$z
## stdout: z=1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
