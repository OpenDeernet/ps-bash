## Imported from the Oils spec tests (ysh-expr-arith.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Unary Operations

var a = ~1

var b = -1
var c = -2.3

var d = not true


write -- $a $b $c $d
## stdout:
## status: 1
## XFAIL ps-bash gap-oils-ysh-expr-arith ysh-expr-arith (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Unary plus on integers and floats

var a = +1
var b = +42
var c = +2.5

var d = -10
var e = +d

write -- $a $b $c $e
## stdout:
## status: 1
## XFAIL ps-bash gap-oils-ysh-expr-arith ysh-expr-arith (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### unary plus and minus combined

var a = +-5
var b = -+5
var c = +(-3)

write -- $a $b $c
## stdout:
## status: 2
## timeout: 10

#### unary minus on strings
json write (-3)
json write (-'4')
json write (-'5.5')

# Not accepted
json write (-'abc')
## stdout:
## status: 2
## timeout: 10

#### unary plus on strings
json write (+3)
json write (+'4')
json write (+'5.5')

# Not accepted
json write (+'abc')
## stdout:
## status: 2
## timeout: 10

#### unary ~ complement on strings
json write (~0)
json write (~'1')
json write (~' 2 ')
# Not accepted
json write (~'3.5')
## stdout:
## status: 2
## timeout: 10

#### unary ~ doesn't work on bool
= ~false
## stdout:
## status: 127
## timeout: 10

#### unary ~ doesn't work on float
= ~1.0
## stdout:
## status: 127
## timeout: 10

#### unary - applied to bool is not allowed
= ~false
## stdout:
## status: 127
## timeout: 10

#### Integer literals
var d = 123
var b = 0b11
var o = 0o123
var h = 0xff
echo $d $b $o $h
## STDOUT:

## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-expr-arith ysh-expr-arith (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Integer literals with underscores
const dec = 65_536
const bin = 0b0001_0101
const oct = 0o001_755
const hex = 0x0001_000f

echo SHELL
echo $dec
echo $bin
echo $oct
echo $hex
const x = 1_1 + 0b1_1 + 0o1_1 + 0x1_1
echo sum $x

# This works under Python 3.6, but the continuous build has earlier versions
if false; then
  echo ---
  echo PYTHON

  python3 -c '
  print(65_536)
  print(0b0001_0101)
  print(0o001_755)
  print(0x0001_000f)

  # Weird syntax
  print("sum", 1_1 + 0b1_1 + 0o1_1 + 0x1_1)
  '
fi
## STDOUT:
SHELL




sum
## END
## status: 0
## timeout: 10

#### Exponentiation with **
var x = 2**3
echo $x

var y = 2.0 ** 3.0  # NOT SUPPORTED
echo 'should not get here'
## STDOUT:

should not get here
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-expr-arith ysh-expr-arith (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Float Division
pp test_ (5/2)
pp test_ (-5/2)
pp test_ (5/-2)
pp test_ (-5/-2)

echo ---

var x = 9
setvar x /= 2
pp test_ (x)

var x = -9
setvar x /= 2
pp test_ (x)

var x = 9
setvar x /= -2
pp test_ (x)

var x = -9
setvar x /= -2
pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### Integer Division (rounds toward zero)
pp test_ (5//2)
pp test_ (-5//2)
pp test_ (5//-2)
pp test_ (-5//-2)

echo ---

var x = 9
setvar x //= 2
pp test_ (x)

var x = -9
setvar x //= 2
pp test_ (x)

var x = 9
setvar x //= -2
pp test_ (x)

var x = -9
setvar x //= -2
pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### Bitwise logical
var a = 0b0101 & 0b0011
echo $a
var b = 0b0101 | 0b0011
echo $b
var c = 0b0101 ^ 0b0011
echo $c
var d = ~b
echo $d
## STDOUT:




## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-expr-arith ysh-expr-arith (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Shift operators
var a = 1 << 4
echo $a
var b = 16 >> 4
echo $b
## stdout:
## status: 127
## timeout: 10
