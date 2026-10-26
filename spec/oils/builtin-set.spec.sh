## Imported from the Oils spec tests (builtin-set.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### can continue after unknown option
#
# TODO: this is the posix special builtin logic?
# dash and mksh make this a fatal error no matter what.

set -o errexit
set -o STRICT || true # unknown option
echo hello
## stdout: hello
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set with both options and argv
set -o errexit a b c
echo "$@"
false
echo done
## stdout: a b c
## status: 1
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### nounset with "$@"
set a b c
set -u  # shouldn't touch argv
echo "$@"
## stdout: a b c
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set -u -- clears argv
set a b c
set -u -- # shouldn't touch argv
echo "$@"
## STDOUT:

## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set -u -- x y z
set a b c
set -u -- x y z
echo "$@"
## stdout: x y z
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### reset option with long flag
set -o errexit
set +o errexit
echo "[$unset]"
## stdout: []
## status: 0
## timeout: 10

#### reset option with short flag
set -u 
set +u
echo "[$unset]"
## stdout: []
## status: 0
## timeout: 10

#### set -eu (flag parsing)
set -eu 
echo "[$unset]"
echo status=$?
## stdout:
## status: 1
## timeout: 10

#### set -o lists options
# NOTE: osh doesn't use the same format yet.
set -o | grep -o noexec
## stdout: noexec
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set - - and so forth
set a b
echo "$@"

set - a b
echo "$@"

set -- a b
echo "$@"

set - -
echo "$@"

set -- --
echo "$@"

# note: zsh is different, and yash is totally different
## STDOUT:
a b
a b
a b
-
--
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set - leading single dash is ignored, turns off xtrace verbose (#2364)

show_options() {
  case $- in
    *v*) echo verbose-on ;;
  esac
  case $- in
    *x*) echo xtrace-on ;;
  esac
}

set -x -v
show_options
echo

set - a b c
echo "$@"
show_options
echo

# dash that's not leading is not special
set x - y z
echo "$@"
## STDOUT:
verbose-on
xtrace-on

a b c

x - y z
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set - + and + -
set - +
echo "$@"

set + -
echo "$@"
## STDOUT:
+
+
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set -a exports variables
set -a
FOO=bar
BAZ=qux
printenv.py FOO BAZ
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set +a stops exporting
set -a
FOO=exported
set +a
BAR=not_exported
printenv.py FOO BAR
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set -o allexport (long form)
set -o allexport
VAR1=value1
set +o allexport
VAR2=value2
printenv.py VAR1 VAR2
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-builtin-set builtin-set (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
