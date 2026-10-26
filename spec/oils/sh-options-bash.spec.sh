## Imported from the Oils spec tests (sh-options-bash.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### SHELLOPTS is readonly
SHELLOPTS=x
echo status=$?

# Setting a readonly variable in osh is a hard failure.
## stdout: status=1
## status: 0
## XFAIL ps-bash gap-oils-sh-options-bash sh-options-bash (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### SHELLOPTS and BASHOPTS are non-empty

# 2024-06 - tickled by Samuel testing Gentoo

if test -v SHELLOPTS; then
  echo 'shellopts is set'
fi
if test -v BASHOPTS; then
	echo 'bashopts is set'
fi

# bash: braceexpand:hashall etc.

echo shellopts ${SHELLOPTS:?} > /dev/null
echo bashopts ${BASHOPTS:?} > /dev/null
## STDOUT:
shellopts is set
bashopts is set
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options-bash sh-options-bash (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -s progcomp hostcomplete are stubs (bash-completion)

shopt -s progcomp hostcomplete
echo status=$?

shopt -u progcomp hostcomplete
echo status=$?
## STDOUT:
status=0
status=0
## END
## status: 0
## timeout: 10
