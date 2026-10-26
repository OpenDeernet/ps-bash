## Imported from the Oils spec tests (prompt.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### \[\] are non-printing
PS1='\[foo\]\$'
echo "${PS1@P}"
## stdout: foo$
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### literal escapes
PS1='\a\e\r\n'
echo "${PS1@P}"
## STDOUT:


## END
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### special case for $
# NOTE: This might be broken for # but it's hard to tell since we don't have
# root.  Could inject __TEST_EUID or something.
PS1='$'
echo "${PS1@P}"
PS1='\$'
echo "${PS1@P}"
PS1='\\$'
echo "${PS1@P}"
PS1='\\\$'
echo "${PS1@P}"
PS1='\\\\$'
echo "${PS1@P}"
## STDOUT:
$
$
$
\$
\$
## END
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### PS1 evaluation order
x='\'
y='h'
PS1='$x$y'
echo "${PS1@P}"
## stdout: \h
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \1004
PS1='\1004$'
echo "${PS1@P}"
## stdout: @4$
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \001 octal literals are supported
PS1='[\045]'
echo "${PS1@P}"
## stdout: [%]
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \555 is beyond max octal byte of \377 and wrapped to m
PS1='\555$'
echo "${PS1@P}"
## stdout: m$
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \x55 hex literals not supported
PS1='[\x55]'
echo "${PS1@P}"
## stdout: [\x55]
## status: 0
## timeout: 10

#### Single backslash
PS1='\'
echo "${PS1@P}"
## stdout: \
## status: 0
## timeout: 10

#### Escaped backslash
PS1='\\'
echo "${PS1@P}"
## stdout: \
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \0001 octal literals are not supported
PS1='[\0455]'
echo "${PS1@P}"
## stdout: [%5]
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \u0001 unicode literals not supported
PS1='[\u0001]'
USER=$(whoami)
test "${PS1@P}" = "[${USER}0001]"
echo status=$?
## stdout: status=0
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### constant string
PS1='$ '
echo "${PS1@P}"
## stdout: $ 
## status: 0
## timeout: 10

#### hostname

# NOTE: This test is not hermetic.  On my machine the short and long host name
# are the same.

PS1='\h '
test "${PS1@P}" = "$(hostname -s) "  # short name
echo status=$?
PS1='\H '
test "${PS1@P}" = "$(hostname) "
echo status=$?
## STDOUT:
status=0
status=0
## END
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \j for number of jobs
set -m # enable job control
PS1='foo \j bar'
echo "${PS1@P}" | egrep -q 'foo 0 bar'
echo matched=$?
sleep 5 &
echo "${PS1@P}" | egrep -q 'foo 1 bar'
echo matched=$?
kill %%
fg
echo "${PS1@P}" | egrep -q 'foo 0 bar'
echo matched=$?
## STDOUT:
matched=0
matched=0
sleep 5
matched=0
## END
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \! for history number
set -o history # enable history
PS1='foo \! bar'
history -c # clear history
echo "${PS1@P}" | egrep -q "foo 1 bar"
echo matched=$?
echo "_${PS1@P}" | egrep -q "foo 3 bar"
echo matched=$?
## STDOUT:
matched=0
matched=0
## END
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \# for command number
PS1='foo \# bar'
prev_cmd_num="$(echo "${PS1@P}" | egrep -o 'foo [0-9]+ bar' | sed -E 's/foo ([0-9]+) bar/\1/')"
echo "${PS1@P}" | egrep -q "foo $((prev_cmd_num + 1)) bar"
echo matched=$?
## stdout: matched=0
## status: 0
## XFAIL ps-bash gap-oils-prompt prompt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
