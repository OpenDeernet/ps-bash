## Imported from the Oils spec tests (sh-options.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### $- with pipefail
set -o pipefail -o nounset
echo $-
## stdout: huB
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### $- and more options
set -efuC
o=$-
[[ $o == *e* ]]; echo yes
[[ $o == *f* ]]; echo yes
[[ $o == *u* ]]; echo yes
[[ $o == *C* ]]; echo yes
## STDOUT:
yes
yes
yes
yes
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set -o vi/emacs
set -o vi
echo $?
set -o emacs
echo $?
## STDOUT:
0
0
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### vi and emacs are mutually exclusive
show() {
  shopt -o -p | egrep 'emacs$|vi$'
  echo ___
};
show

set -o emacs
show

set -o vi
show
## STDOUT:
set +o emacs
set +o vi
___
set -o emacs
set +o vi
___
set +o emacs
set -o vi
___
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### nounset
echo "[$unset]"
set -o nounset
echo "[$unset]"
echo end  # never reached
## stdout: []
## status: 1
## timeout: 10

#### -u is nounset
echo "[$unset]"
set -u
echo "[$unset]"
echo end  # never reached
## stdout: []
## status: 1
## timeout: 10

#### -n for no execution (useful with --ast-output)
# NOTE: set +n doesn't work because nothing is executed!
echo 1
set -n
echo 2
set +n
echo 3
# osh doesn't work because it only checks -n in bin/oil.py?
## stdout: 1
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### pipefail
# NOTE: the sleeps are because osh can fail non-deterministically because of a
# bug.  Same problem as PIPESTATUS.
{ sleep 0.01; exit 9; } | { sleep 0.02; exit 2; } | { sleep 0.03; }
echo $?
set -o pipefail
{ sleep 0.01; exit 9; } | { sleep 0.02; exit 2; } | { sleep 0.03; }
echo $?
## STDOUT:
0
2
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -p prints 'shopt' options
shopt -p nullglob
shopt -s nullglob
shopt -p nullglob
## STDOUT:
shopt -u nullglob
shopt -s nullglob
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### noclobber off
set -o errexit

echo foo > can-clobber
echo status=$?
set +C

echo foo > can-clobber
echo status=$?
set +o noclobber

echo foo > can-clobber
echo status=$?
cat can-clobber
## STDOUT:
status=0
status=0
status=0
foo
## END
## status: 0
## timeout: 10

#### noclobber on

rm -f no-clobber
set -C

echo foo > no-clobber
echo create=$?

echo overwrite > no-clobber
echo overwrite=$?

echo force >| no-clobber
echo force=$?

cat no-clobber
## STDOUT:
create=0
overwrite=1
force=0
force
## END
## status: 0
## timeout: 10

#### set without args lists variables
__GLOBAL=g
f() {
  local __mylocal=L
  local __OTHERLOCAL=L
  __GLOBAL=mutated
  set | grep '^__'
}
g() {
  local __var_in_parent_scope=D
  f
}
g
## STDOUT:
__GLOBAL=mutated
__OTHERLOCAL=L
__mylocal=L
__var_in_parent_scope=D
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set without args and array variables
declare -a __array
__array=(1 2 '3 4')
set | grep '^__'
## stdout: __array=([0]="1" [1]="2" [2]="3 4")
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### set without args and assoc array variables (not in OSH)
typeset -A __assoc
__assoc['k e y']='v a l'
__assoc[a]=b
set | grep '^__'
## stdout: __assoc=([a]="b" ["k e y"]="v a l" )
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -q
shopt -q nullglob
echo nullglob=$?

# set it
shopt -s nullglob

shopt -q nullglob
echo nullglob=$?

shopt -q nullglob failglob
echo nullglob,failglob=$?

# set it
shopt -s failglob
shopt -q nullglob failglob
echo nullglob,failglob=$?
## STDOUT:
nullglob=1
nullglob=0
nullglob,failglob=1
nullglob,failglob=0
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -q invalid
shopt -q invalidZZ
echo invalidZZ=$?
## stdout: invalidZZ=1
## status: 0
## timeout: 10

#### shopt -s strict:all
n=2

show-strict() {
  shopt -p | grep 'strict_' | head -n $n
  echo -
}

show-strict
shopt -s strict:all
show-strict
shopt -u strict_argv
show-strict
## STDOUT:
-
-
-
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt allows for backward compatibility like bash

# doesn't have to be on, but just for testing
set -o errexit

shopt -p nullglob || true  # bash returns 1 here?  Like -q.

# This should set nullglob, and return 1, which can be ignored
shopt -s nullglob strict_OPTION_NOT_YET_IMPLEMENTED 2>/dev/null || true
echo status=$?

shopt -p nullglob || true
## STDOUT:
shopt -u nullglob
status=0
shopt -s nullglob
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### shopt -p -o validates option names
shopt -p -o errexit invalid nounset
echo status=$?
## STDOUT:
set +o errexit
set +o nounset
status=1
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### stubbed out bash options
shopt -s ignore_shopt_not_impl
for name in foo autocd cdable_vars checkwinsize; do
  shopt -s $name
  echo $?
done
## STDOUT:
1
0
0
0
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### no-ops not shown by shopt -p

shopt -p | grep xpg
echo --
## STDOUT:
shopt -u xpg_echo
--
## END
## status: 0
## XFAIL ps-bash gap-oils-sh-options sh-options (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
