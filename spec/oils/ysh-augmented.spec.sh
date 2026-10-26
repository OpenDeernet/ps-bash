## Imported from the Oils spec tests (ysh-augmented.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Augmented assignment doesn't work on List

# I suppose the logic is that string and array concat is ++
#
# I wonder if a ++= operator makes sense?

shopt -s parse_at simple_word_eval
var x = :| a 'b c' |
argv.py @x

setvar x += :| d e |  # fatal error
argv.py @x
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Augmented assignment respects command_sub_errexit


var x = '42'
setvar x += $(echo 3)
echo x=$x

setvar x += $(echo 3; false)
echo x=$x
## STDOUT:
x=
x=
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Augmented assignment with integers
var x = 1 + 2 * 3
echo x=$x

setvar x += 4 * 1
echo x=$x
## STDOUT:
x=
x=
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Augmented assignment on string changes to Int Float

var x = '42'
pp test_ (x)

setvar x += 4 * 1
pp test_ (x)

setvar x += '9'
pp test_ (x)

setvar x = '42'
setvar x /= 4
pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### Augmented assignment with floats

var x = 42

setvar x += 1.5
echo $x

setvar x += '1.5'
echo $x

setvar x += '3'
echo $x
## STDOUT:



## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Int/Float augmented += -= *= /=

var x = 0

setvar x = 10
setvar x -= 3
echo x=$x

setvar x = 10
setvar x *= 3
echo x=$x

var x = 0
setvar x = 10
setvar x /= 2
echo x=$x
## STDOUT:
x=
x=
x=
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Int Augmented //= %= **= and bitwise ops

var x = 0

setvar x = 10
setvar x //= 3
echo x=$x

setvar x = 10
setvar x %= 3
echo x=$x

setvar x = 10
setvar x **= 3
echo x=$x

echo
echo bitwise

setvar x  = 0b1111
setvar x &= 0b0101
echo x=$x

setvar x  = 0b1000
setvar x |= 0b0111
echo x=$x

setvar x = 0b1010
setvar x ^= 0b1001
echo x=$x

echo
echo shift

setvar x = 0b1000
setvar x <<= 1
echo x=$x

setvar x = 0b1000
setvar x >>= 1
echo x=$x
## STDOUT:
x=
x=
x=

bitwise
x=
x=
x=

shift
## END
## status: 127
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Augmented assignment of List

shopt -s parse_at

var mylist = :| 32 42 |

setvar mylist[0] -= 1
echo @mylist

setvar mylist[1] //= 2
echo @mylist

setvar mylist[1] /= 2
echo @mylist
## STDOUT:
@mylist
@mylist
@mylist
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### List with nonexistent elemnt
var L = [42]
setvar L[99] += 1
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Augmented assignment doesn't work with multiple LHS

var x = 3
var y = 4
setvar x, y += 2
echo $x $y
## STDOUT:

## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-augmented ysh-augmented (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
