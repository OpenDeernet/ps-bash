## Imported from the Oils spec tests (ysh-regex-api.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Invalid sh operation on eggex
var pat = / d+ /
#pat[invalid]=1
pat[invalid]+=1
## stdout:
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
