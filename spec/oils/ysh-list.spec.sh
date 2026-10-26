## Imported from the Oils spec tests (ysh-list.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### shell array :| a 'b c' |
shopt -s parse_at
var x = :| a 'b c' |
var empty = :||
argv.py / @x @empty /
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-list ysh-list (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Shell arrays support tilde detection, static globbing, brace detection
shopt -s parse_at simple_word_eval
touch {foo,bar}.py

# could this also be __defaults__.HOME or DEF.HOME?
setglobal ENV.HOME = '/home/bob'
no_dynamic_glob='*.py'

var x = :| ~/src *.py {andy,bob}@example.com $no_dynamic_glob |
argv.py @x
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-list ysh-list (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Mutate List entries, a[42] a['42'] allowed

var a = :| 2 3 4 |

setvar a[1] = 1
pp test_ (a)

setvar a['2'] += 5
pp test_ (a)

# Can be int-looking string
setvar a['2'] = 99
pp test_ (a)

# Not allowed
setvar a['zz'] = 101
## stdout:
## status: 2
## timeout: 10

#### Can print type of List with pp

var b = :|true|  # this is a string
pp test_ (b)

# = b

var empty = :||
pp test_ (empty)

# = empty
## stdout:
## status: 2
## timeout: 10

#### splice and stringify array
shopt --set parse_at
shopt --unset no_osh_builtins

var x = :| 'a b' c |

declare -a array=( @x )

argv.py "${array[@]}"  # should work

echo -$array-  # fails because of strict_arraywith type error

echo -$x-  # fails with type error
## STDOUT:
--
--
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-list ysh-list (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
