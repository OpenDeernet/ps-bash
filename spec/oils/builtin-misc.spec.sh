## Imported from the Oils spec tests (builtin-misc.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### history builtin usage
history
echo status=$?
history +5  # hm bash considers this valid
echo status=$?
history -5  # invalid flag
echo status=$?
history f 
echo status=$?
history too many args
echo status=$?
## STDOUT:
status=0
status=0
status=2
status=1
status=1
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-misc builtin-misc (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### time pipeline
time echo hi | wc -c
## stdout: 3
## status: 0
## timeout: 10

#### shift
set -- 1 2 3 4
shift
echo "$@"
shift 2
echo "$@"
## STDOUT:
2 3 4
4
## END
## status: 0
## timeout: 10

#### Shifting too far
set -- 1
shift 2
## stdout:
## status: 1
## timeout: 10

#### Invalid shift argument
shift ZZZ
## stdout:
## status: 1
## timeout: 10
