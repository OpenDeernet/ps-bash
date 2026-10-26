## Imported from the Oils spec tests (exit-status.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Truncating 'return' status
f() { return 255; }; f
echo status=$?

f() { return 256; }; f
echo status=$?

f() { return 257; }; f
echo status=$?

echo ===

f() { return -1; }; f
echo status=$?

f() { return -2; }; f
echo status=$?


# dash aborts on bad exit code
## STDOUT:
status=255
status=0
status=1
===
status=255
status=254
## END
## status: 0
## XFAIL ps-bash gap-oils-exit-status exit-status (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### If empty command
if ''; then echo TRUE; else echo FALSE; fi
## stdout: FALSE
## status: 0
## XFAIL ps-bash gap-oils-exit-status exit-status (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### If subshell true
if `true`; then echo TRUE; else echo FALSE; fi
## stdout: TRUE
## status: 0
## timeout: 10

#### If subshell true WITH OUTPUT is different
if `sh -c 'echo X; true'`; then echo TRUE; else echo FALSE; fi
## stdout: FALSE
## status: 0
## timeout: 10

#### If subshell true WITH ARGUMENT
if `true` X; then echo TRUE; else echo FALSE; fi
## stdout: FALSE
## status: 0
## XFAIL ps-bash gap-oils-exit-status exit-status (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### If subshell false -- exit code is propagated in a weird way (strict_argv prevents)
if `false`; then echo TRUE; else echo FALSE; fi
## stdout: FALSE
## status: 0
## timeout: 10

#### Exit code when command sub evaluates to empty str, e.g. `false` (#2416)

# OSH had a bug here
`true`; echo $?
`false`; echo $?
$(true); echo $?
$(false); echo $?
echo ---

# OSH and others agree on these
eval true; echo $?
eval false; echo $?
`echo true`; echo $?
`echo false`; echo $?
## STDOUT:
0
1
0
1
---
0
1
0
1
## END
## status: 0
## XFAIL ps-bash gap-oils-exit-status exit-status (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### More test cases with empty argv

true $(false)
echo status=$?

$(exit 42)
echo status=$?

$(exit 42) $(exit 43)
echo status=$?
## STDOUT:
status=0
status=42
status=43
## END
## status: 0
## XFAIL ps-bash gap-oils-exit-status exit-status (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
