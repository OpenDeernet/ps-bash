## Imported from the Oils spec tests (sh-usage.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### exit with explicit arg
exit 42
## stdout:
## status: 42
## timeout: 10

#### exit with no args
false
exit
## stdout:
## status: 1
## XFAIL ps-bash gap-oils-sh-usage sh-usage (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Other flag parsers are not affected by - rule

# -c is special, with quit_parsing_flags

echo 'foo-bar' | { read -d -; echo reply=$REPLY; }
## stdout: reply=foo
## status: 0
## XFAIL ps-bash gap-oils-sh-usage sh-usage (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
