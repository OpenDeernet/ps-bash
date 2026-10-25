## Imported from the Oils spec tests (ysh-assign.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### proc static check: const can't be mutated
proc f {
  const x = 'local'
  echo x=$x
  setvar x = 'mutated'
  echo x=$x
}
## STDOUT:
x=
x=
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### top level: var can be redefined by var/const
var x = "global"
echo x=$x
f() {
  var x = "local"
  echo x=$x
}
f
var x = "g2"
echo x=$x
const x = 'now-const'
echo x=$x
const x = 'oops'
echo x=$x
## STDOUT:
x=
x=
x=
x=
x=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### setvar mutates local
proc f {
  var x = 'local'
  echo x=$x
  setvar x = 'mutated'
  echo x=$x
}

var x = 'global'
echo x=$x
f
echo x=$x
## STDOUT:
x=
x=
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### top level: setvar creates global
setvar x = 'global'
echo x=$x
setvar x = 'g2'
echo x=$x
## STDOUT:
x=
x=
## END
## status: 0
## timeout: 10

#### top level: setvar mutates var
var x = 1
setvar x = 42  # this is allowed
echo $x
setvar y = 50  # error because it's not declared
echo $y
## STDOUT:


## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### setglobal
f() {
  var x = 'local'
  echo x=$x
  setglobal x = 'mutated'
}
var x = 'global'
echo x=$x
f
echo x=$x
## STDOUT:
x=
x=
x=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### setglobal of undeclared var is allowed
var x = 'XX'
echo x=$x
setglobal x = 'xx'
echo x=$x

# fatal error
setglobal y = 'YY'
## STDOUT:
x=
x=
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### var a, b  does implicit null init

var x
var a, b

var c: Int, d: Int

echo $x $a $b $c $d
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### var x, y = f()

# The syntax consistent with JavaScript would be
# var x = 1, y = 2;

var x, y = 1, 2
echo "x=$x y=$y"

func f() {
  # this syntax would be nice, but is illegal
  # return (3, 4)
  return ([3, 4])
}

var a, b = f()
echo "a=$a b=$b"
## stdout: x= y=
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### const x, y = f()

func f() {
  # this syntax would be nice, but is illegal
  # return (3, 4)
  return ([3, 4])
}


const a, b = f()
echo "a=$a b=$b"

setvar a = 9  # error
## stdout:
## status: 2
## timeout: 10

#### setvar x, y = 1, 2

# Python doesn't allow you to have annotation on each variable!
# https://www.python.org/dev/peps/pep-0526/#where-annotations-aren-t-allowed
var x Int = 3
var y Int = 4
echo "x=$x y=$y"

setvar x, y = 1, 9
echo "x=$x y=$y"

setvar y, x = x, y
echo "x=$x y=$y"

setvar x, y = x*2, x*3
echo "x=$x y=$y"
## STDOUT:
x= y=
x= y=
x= y=
x= y=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### setvar to swap List and Dict elements
var x = [1, 2, 3]
echo @x

setvar x[0], x[1] = x[1], x[0]

echo @x

var d = {int: 42}

setvar x[0], d.int = d.int, x[0]

echo @x
json write (d)
## STDOUT:
@x
@x
@x
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### circular dict - TODO 2023-06 REGRESS
var d = {name: 'foo'}
pp test_ (d)

setvar d['name'] = 123
pp test_ (d)

setvar d['name'] = 'mystr'
pp test_ (d)

setvar d['name'] = d
pp test_ (d)

# This used to print ...
## stdout:
## status: 2
## timeout: 10

#### circular list - TODO 2023-06 REGRESS
var L = [1,2,3]
= L
#setvar L[0] = L
#= L
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
