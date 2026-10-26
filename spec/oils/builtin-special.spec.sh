## Imported from the Oils spec tests (builtin-special.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Non-special builtins CAN be redefined as functions
test -n "$BASH_VERSION" && set -o posix
true() {
  echo 'true func'
}
true hi
echo status=$?
## STDOUT:
true func
status=0
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-special builtin-special (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
