## Imported from the Oils spec tests (ysh-builtin-shopt.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### shopt supports long flags
shopt -p nullglob

shopt --set nullglob
shopt -p nullglob

shopt --unset nullglob
shopt -p nullglob

echo ---
## STDOUT:
shopt -u nullglob
shopt -u nullglob
shopt -u nullglob
---
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt supports 'set' options
shopt -p errexit

shopt --set errexit
false

echo should not get here
## stdout: should not get here
## status: 0
## timeout: 10

#### shopt --unset errexit { }
shopt --set oil:all

echo one

shopt --unset errexit {
  echo two
  false
  echo three
}

false
echo 'should not get here'
## STDOUT:
one
two
three
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -p works correctly inside block
shopt --set parse_brace

shopt -p | grep inherit_errexit
shopt --set inherit_errexit {
  shopt -p | grep inherit_errexit
}
## STDOUT:
shopt -u inherit_errexit
shopt -u inherit_errexit
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt --set GROUP { }
shopt --set parse_brace

shopt -p | grep errexit
echo ---

shopt --set oil:all {
  #false
  #echo status=$?
  shopt -p | grep errexit
}
echo ---

shopt --set oil:upgrade {
  shopt -p | grep errexit
}
echo ---

shopt --set strict:all {
  shopt -p | grep errexit
}

# TODO: shopt --table should show the error value
## STDOUT:
shopt -u inherit_errexit
---
shopt -u inherit_errexit
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt and block status
shopt --set oil:all

shopt --unset errexit {
  false
}
# this is still 0, even though last command was 1
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### shopt usage error
shopt --set oil:all

echo one
shopt --set a {
  echo two
}
echo status=$?
## STDOUT:
one
two
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -p

shopt -p errexit
shopt -p nullglob

echo --
shopt -p strict:all | head -n 3

echo --
shopt --set strict:all
shopt -p strict:all | head -n 3
## STDOUT:
shopt -u nullglob
--
--
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### TODO: all options as a table

shopt --table

# This is unlike shopt -p because

# 1) It shows ALL options, not just 'shopt' options
# 2) It shows it in QTT format?

# opt_name Str   value Bool
# errexit        true
# nounset        false
#
# Could also be T and F?  JSON is more obvious
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-shopt ysh-builtin-shopt (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
