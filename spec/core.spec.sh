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

#### declare -i evaluates later assignments
declare -i n=2+3; n=n+1; n=n*2; echo $n
## stdout: 12
## status: 0

#### plain variable keeps the text
m=2+3; m=m+1; echo $m
## stdout: m+1
## status: 0

#### trap ERR runs on a failing statement
trap 'echo err' ERR; false; echo done
## STDOUT:
err
done
## END
## status: 0

#### trap ERR is not run for a condition or a non-final && operand
trap 'echo err' ERR; if false; then :; fi; false && true; ! false; echo done
## stdout: done
## status: 0

#### trap ERR sees the failing status
trap 'echo "rc=$?"' ERR; (exit 3); echo after
## STDOUT:
rc=3
after
## END
## status: 0

#### trap ERR cleared
trap 'echo err' ERR; trap - ERR; false; echo done
## stdout: done
## status: 0

#### extglob alternation in case
shopt -s extglob
case abc in @(abc|x)) echo y;; *) echo n;; esac
case abd in @(abc|x)) echo y;; *) echo n;; esac
## STDOUT:
y
n
## END
## status: 0

#### extglob negation and repetition in [[ ]]
shopt -s extglob
[[ foo.c == !(*.h) ]] && echo notheader
[[ aaa == +(a) ]] && echo plus
[[ ab == ?(a)b ]] && echo opt
## STDOUT:
notheader
plus
opt
## END
## status: 0
