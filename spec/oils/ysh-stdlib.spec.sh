## Imported from the Oils spec tests (ysh-stdlib.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### smoke test for two.sh

source --builtin osh/two.sh

log 'hi'

shopt --unset errexit
forkwait { die "bad" }
echo status=$?
## stdout: status=127
## status: 0
## XFAIL ps-bash gap-oils-ysh-stdlib ysh-stdlib (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
