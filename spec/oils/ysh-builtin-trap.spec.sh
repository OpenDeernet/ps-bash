## Imported from the Oils spec tests (ysh-builtin-trap.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### trap --remove INT EXIT

trap --add INT EXIT HUP {
  echo one
  echo two
}
trap -p > traps.txt
wc -l traps.txt
echo ---

trap --remove INT EXIT
trap -p > traps.txt
wc -l traps.txt
echo ---

trap --add EXIT { echo 'exit' }
## STDOUT:
one
two
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-trap ysh-builtin-trap (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### trap block arg is a not a closure - like cd and other builtins

# e.g. We're not using ctx_EnclosedFrame in RunTrapsOnExit() and in the signal
# handlers.  It's more similar to OSH.

var x = 'global'

proc register {
  var x = 'local'
  trap --add EXIT {
     echo "x = $x"
  }
}

register
## stdout: x = 
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-trap ysh-builtin-trap (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### trap --ignore INT USR1

trap --ignore INT USR1
trap -p
## stdout:
## status: 0
## XFAIL ps-bash gap-oils-ysh-builtin-trap ysh-builtin-trap (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### trap --ignore removes hooks (like trap -)

trap --ignore EXIT
echo done
## stdout: done
## status: 0
## XFAIL ps-bash gap-oils-ysh-builtin-trap ysh-builtin-trap (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### trap --ignore with uncatchable STOP signal

# YSH is stricter and returns an error, which triggers errexit
trap --ignore STOP
echo done
## stdout: done
## status: 0
## timeout: 10
