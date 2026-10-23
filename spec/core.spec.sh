## Seed corpus: core shell semantics. Expectations are recorded from bash 5.2 (PSBASH_SPEC_RECORD=1), never hand-written.

#### echo and quoting
echo "a  b" 'c  d' e\ f
## stdout: a  b c  d e f
## status: 0

#### parameter default and alternate
unset x; echo "${x:-d}" "${x:+a}"; x=1; echo "${x:-d}" "${x:+a}"
## STDOUT:
d 
1 a
## END
## status: 0

#### quoted array expands one word per element
a=("x y" z); for i in "${a[@]}"; do echo "[$i]"; done
## STDOUT:
[x y]
[z]
## END
## status: 0

#### arithmetic
echo $((2+3*4)) $((7/2)) $((7%3))
## stdout: 14 3 1
## status: 0

#### case with variable pattern
p=b; case b in $p) echo hit;; *) echo miss;; esac
## stdout: hit
## status: 0

#### getopts cluster
set -- -ab -c val x; while getopts ab:c: o; do echo "$o=$OPTARG"; done; echo $OPTIND
## STDOUT:
a=
b=-c
3
## END
## status: 0

#### associative array
declare -A m=([k1]=v1 [k2]=v2); echo "${m[k1]}" "${#m[@]}"
## stdout: v1 2
## status: 0

#### printf %q
printf '%q\n' 'a b'
## stdout: a\ b
## status: 0

#### status of failure
false; echo $?
## stdout: 1
## status: 0

#### pipeline status of last command
echo hi | cat; echo $?
## STDOUT:
hi
0
## END
## status: 0

#### set -f disables globbing
set -f; echo *; set +f
## stdout: *
## status: 0

#### subshell param error ends only subshell
( : "${nope:?boom}" ) 2>/dev/null; echo after
## stdout: after
## status: 0

#### unset of a readonly variable fails and keeps the value
readonly v=1; unset v 2>/dev/null; echo $? $v
## stdout: 1 1
## status: 0

#### unset of a normal variable succeeds
w=1; unset w; echo $? "${w-gone}"
## stdout: 0 gone
## status: 0
