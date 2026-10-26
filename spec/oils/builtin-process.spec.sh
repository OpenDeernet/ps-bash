## Imported from the Oils spec tests (builtin-process.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### exec builtin
exec echo hi
## stdout: hi
## status: 0
## timeout: 10

#### exec builtin with redirects
exec 1>&2
echo 'to stderr'
## stdout:
## status: 0
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### exec builtin accepts --
exec -- echo hi
## stdout: hi
## status: 0
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### exec -- 2>&1
exec -- 3>&1
echo stdout 1>&3
## stdout: stdout
## status: 0
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### exec -a sets argv[0]
exec -a FOOPROC sh -c 'echo $0'
## stdout: FOOPROC
## status: 0
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Exit out of function
f() { exit 3; }
f
exit 4
## stdout:
## status: 3
## timeout: 10

#### Exit builtin with invalid arg
exit invalid
# Rationale: runtime errors are 1
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Exit builtin with too many args
# This is a parse error in OSH.
exit 7 8 9
echo status=$?
## stdout: status=1
## status: 0
## XFAIL ps-bash gap-oils-builtin-process builtin-process (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
