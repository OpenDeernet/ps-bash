## Imported from the Oils spec tests (ysh-cmd-lang.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Redirect failure is either fatal or can be checked

# TODO: this fails, but there's no way to check it
#
# We can have shopt -s redir_errexit in YSH then?
# Can you catch the error?

{ echo 1; echo 2 } > /

echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-cmd-lang ysh-cmd-lang (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
