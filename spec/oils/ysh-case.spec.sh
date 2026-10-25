## Imported from the Oils spec tests (ysh-case.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### case syntax, one line
const x = "header.h"
case (x) {
  *.h | *.cc { echo C++ }
  *.py       { echo Python }
}

# not recommended, but it works
case (x) { header.h { echo header.h } * { echo other } }
## stdout:
## status: 2
## timeout: 10

#### case syntax, multiline
const x = "hello.py"
case (x) {
  *.h | *.cc {
    echo C++
    echo 2; echo 3
  }
  *.py {
    echo \
      Python
  }
}
## stdout:
## status: 2
## timeout: 10

#### case syntax, simple expressions
const x = 3
case (x) {
  (3) { echo three }
  (4) { echo four }
}
## stdout:
## status: 2
## timeout: 10

#### case syntax, complex expressions
const x = 3
case (x) {
  (1 + 2) { echo three }
  (2 + 2) { echo four }
}
## stdout:
## status: 2
## timeout: 10

#### case semantics, no match
const x = 2
case (x) {
  (3) { echo three }
  (4) { echo four }
}
## stdout:
## status: 2
## timeout: 10

#### eggex as case arm
const x = "main.cc"
case (x) {
  / dot* '.py' / {
    echo Python
  }
  / dot* ('.cc' | '.h') / {
   echo C++
  }
}
## stdout:
## status: 2
## timeout: 10

#### eggex respects flags
const x = 'MAIN.PY'
case (x) {
  / dot* '.py' ; i / {
    echo Python
  }
  / dot* ('.cc' | '.h') / {
   echo C++
  }
}
## stdout:
## status: 2
## timeout: 10

#### empty case statement
const x = ""
case (x) { }
## stdout:
## status: 2
## timeout: 10

#### typed args
const x = "0"
case (x) {
  (0) { echo int }
  ("0") { echo string }
}
## stdout:
## status: 2
## timeout: 10

#### else case pattern
var x = 123
case (x) {
  (else) { echo else matches all }
  (123) { echo unreachable }
}
## stdout:
## status: 2
## timeout: 10

#### expression evaluation shortcuts
var x = 123
case (x) {
  (x) | (y) { echo no error }
}
## stdout:
## status: 2
## timeout: 10

#### expression evaluation order
var x = 123
case (x) {
  (y) | (x) { echo no error }
}
## stdout:
## status: 2
## timeout: 10

#### word evaluation shortcuts
var x = "abc"
case (x) {
  $x | $y { echo no error }
}
## stdout:
## status: 2
## timeout: 10

#### word evaluation order
var x = "abc"
case (x) {
  $y | $x { echo no error }
}
## stdout:
## status: 2
## timeout: 10

#### only one branch is evaluated
var x = "42"
case (x) {
  ('42') { echo a }
  42 { echo b }
  / '42' / { echo c }
  (Str(40 + 2)) { echo d }

  # even errors are ignored
  (42 / 0) { echo no error }
}
## stdout:
## status: 2
## timeout: 10

#### stop on errors
var x = "42"
case (x) {
  (42 / 0) { echo no error }

  ('42') { echo a }
  42 { echo b }
  / '42' / { echo c }
  (Str(40 + 2)) { echo d }
}
## stdout:
## status: 2
## timeout: 10
