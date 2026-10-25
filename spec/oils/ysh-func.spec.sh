## Imported from the Oils spec tests (ysh-func.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Too many args
func f(x) { return (x + 1) }

= f(0, 1)
## stdout:
## status: 2
## timeout: 10

#### Too few args
func f(x) { return (x + 1) }

= f()
## stdout:
## status: 2
## timeout: 10

#### Positional args

func f(x, y, ...rest) {
  echo "pos $x $y"
  echo rest @rest
}

call f(1, 2, 3, 4)

# This is an error
#call f(1, 2, m=2, n=3)
## stdout:
## status: 2
## timeout: 10

#### named args
func f(; x=3) {
  echo x=$x
}

call f()

call f(x=4)
## stdout:
## status: 2
## timeout: 10

#### Named args with ...rest
func f(; x=3, ...named) {
  echo x=$x
  pp test_ (named)
}

call f()

call f(x=4)

call f(x=4, y=5)
## stdout:
## status: 2
## timeout: 10

#### Spread/splat of named args: f(...more)

func f(; x, y) {
  echo "$x $y"
}

call f(; x=9, y=10)

var args = {x: 3, y: 4}

call f(; ...args)
## stdout:
## status: 2
## timeout: 10

#### Multiple spreads

func f(...pos; ...named) {
  pp test_ (pos)
  pp test_ (named)
}

var a = [1,2,3]
var d = {m: 'spam', n: 'no'}
var e = {p: 5, q: 6}

call f(...a, ...a; ...d, ...e)
## stdout:
## status: 2
## timeout: 10

#### Proc-style return in a func is error
func t() { return 0 }

= t()
## stdout:
## status: 2
## timeout: 10

#### Typed return in a proc is error
proc t() { return (0) }

= t()
## stdout:
## status: 2
## timeout: 10

#### Redefining functions is allowed
func f() { return (0) }
func f() { return (1) }
## stdout:
## status: 2
## timeout: 10

#### Functions can redefine vars
var f = 0
func f() { return (1) }
pp test_ (f)
## stdout:
## status: 2
## timeout: 10

#### Param binding semantics
# value
var x = 'foo'

func f(x) {
  setvar x = 'bar'
}

pp test_ (x)
pp test_ (f(x))
pp test_ (x)

# reference
var y = ['a', 'b', 'c']

func g(y) {
  setvar y[0] = 'z'
}

pp test_ (y)
pp test_ (g(y))
pp test_ (y)
## stdout:
## status: 2
## timeout: 10

#### Recursive functions
func fib(n) {
  # TODO: add assert n > 0
  if (n < 2) {
    return (n)
  }

  return (fib(n - 1) + fib(n - 2))
}

json write (fib(10))
## stdout:
## status: 2
## timeout: 10

#### Varadic arguments, no other args
func f(...args) {
pp test_ (args)
}

call f()
call f(1)
call f(1, 2)
call f(1, 2, 3)
## stdout:
## status: 2
## timeout: 10

#### Varadic arguments, other args
func f(a, b, ...args) {
pp test_ ([a, b, args])
}

call f(1, 2)
call f(1, 2, 3)
call f(1, 2, 3, 4)
## stdout:
## status: 2
## timeout: 10

#### Varadic arguments, too few args
func f(a, b, ...args) {
  = [a, b, args]
}

call f(1)
## stdout:
## status: 2
## timeout: 10

#### Userland max
func mymax (...args) {
  if (len(args) === 0) {
    error 'Requires 1 arg'
  } elif (len(args) === 1) {
    # TODO: assert List
    var mylist = args[0]
    var max = mylist[0]

    for item in (mylist) {
      if (item > max) {
        setvar max = item
      }
    }

    return (max)
  } elif (len(args) === 2) {
    if (args[0] >= args[1]) {
      return (args[0])
    } else {
      return (args[1])
    }
  } else {
    # max(1, 2, 3) doesn't work in YSH, but does in Python
    error 'too many'
  }
}

= mymax(5,6)  # => 6
= mymax([5,6,7])  # => 7
= mymax(5,6,7,8)  # error
## stdout:
## status: 2
## timeout: 10

#### We can store funcs in dictionaries
func dog_speak() {
  echo "Woof"
}

func dog_type() {
  return ("DOG")
}

const Dog = {
  speak: dog_speak,
  type: dog_type,
}

func cat_speak() {
  echo "Meow"
}

func cat_type() {
  return ("CAT")
}

const Cat = {
  speak: cat_speak,
  type: cat_type,
}

# First class "modules"!
const animals = [Dog, Cat]
for animal in (animals) {
  var type = animal.type()
  echo This is a $type
  call animal.speak()
}
## stdout:
## status: 2
## timeout: 10

#### Funcs are closures (capture their environment)

func makeFunc() {
  var x = 42
  func inner() {
    echo "x = $x"
  }
  setvar x += 1
  return (inner)
}

const f = makeFunc()
call f()
## stdout:
## status: 2
## timeout: 10
