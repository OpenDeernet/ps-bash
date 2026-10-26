## Imported from the Oils spec tests (ysh-user-feedback.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### !== operator
var a = 'bar'

if (a !== 'foo') {
  echo 'not equal'
}

if (a !== 'bar') {
  echo 'should not get here'
}

# NOTE: a !== foo is idiomatic)
if ("$a" !== 'bar') {
  echo 'should not get here'
}
## stdout:
## status: 2
## timeout: 10

#### elif bug
if (true) {
  echo A
} elif (true) {
  echo B
} elif (true) {
  echo C
} else {
  echo else
}
## stdout:
## status: 2
## timeout: 10

#### readonly in loop: explains why const doesn't work
shopt --unset no_osh_builtins

# TODO: Might want to change const in YSH
# bash actually prevents assignment and prints a warning, DOH.

seq 3 | while read -r line; do
  readonly stripped=${line//1/x}
  #declare stripped=${line//1/x}
  echo $stripped
done
## STDOUT:
x
x
x
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-user-feedback ysh-user-feedback (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Eggex bug in a loop

# https://oilshell.zulipchat.com/#narrow/stream/121540-oil-discuss/topic/A.20list.20of.20feedback
for i in @(seq 2) {
  # BUG: This crashes here, but NOT when extracted!  Bad.
  var pat = / 'test' word+ /
  if ("test$i" ~ pat) {
    echo yes
  }
}
## stdout:
## status: 2
## timeout: 10

#### Append object onto Array
var e = []

# %() is also acceptable, but we prefer Python-like [] for objects.
# %() is more for an array of strings
# var e = %()

for i in @(seq 2) {
  var o = {}
  setvar o[i] = "Test $i"

  # push builtin is only for strings

  call e->append(o)
}

json write (e)
## stdout:
## status: 2
## timeout: 10

#### var in both branches of if (Julian)

# remove static check?

proc scopetest(; var) {
  if (var === 2) {
    var tmp = "hello"
    write $tmp
  } else {
    var tmp = "world"
    write $tmp
  }
}

scopetest (1)
scopetest (2)
## stdout:
## status: 2
## timeout: 10

#### Modify for loop variable with var or setvar? (Machine Stops)

proc do-var {
  for x in a b {
    echo $x
    var x = 'zz'
    echo $x
  }
}

proc do-setvar {
  for x in a b {
    echo $x
    setvar x = 'zz'
    echo $x
  }
}

do-var
echo
do-setvar
## stdout:
## status: 2
## timeout: 10
