## Imported from the Oils spec tests (blog2.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### -a
[ -a ]
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### -a -a
[ -a -a ]
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### -a -a -a
[ -a -a -a ]
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### -a -a -a -a
[ -a -a -a -a ]
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### -a -a -a -a -a
[ -a -a -a -a -a ]
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### -a -a -a -a -a -a
[ -a -a -a -a -a -a ]
echo status=$?
## stdout: status=2
## status: 0
## XFAIL ps-bash gap-oils-blog2 blog2 (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### -a -a -a -a -a -a -a
[ -a -a -a -a -a -a -a ]
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### -a -a -a -a -a -a -a -a
[ -a -a -a -a -a -a -a -a ]
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10
