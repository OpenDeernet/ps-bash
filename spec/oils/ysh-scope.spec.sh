## Imported from the Oils spec tests (ysh-scope.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### SetValue scope and shopt --unset dynamic_scope
shopt --set parse_proc

f() {
  x=f
}

proc p {
  var x = 'p'
}

demo() {
  local x=stack
  echo x=$x
  echo ---

  f
  echo f x=$x

  x=stack
  p
  echo p x=$x

  shopt --unset dynamic_scope
  x=stack
  f
  echo funset x=$x
}

x=global
demo

echo ---
echo x=$x
## stdout:
## status: 2
## timeout: 10

#### read scope
set -o errexit

read-x() {
  echo dynamic-scope | read x
}
demo() {
  local x=42
  echo x_before=$x
  read-x
  echo x_after=$x
}
demo
echo x=$x

echo ---

# Now 'read x' creates a local variable
shopt --unset dynamic_scope
demo
echo x=$x
## STDOUT:
x_before=42
x_after=42
x=
---
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-scope ysh-scope (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### printf -v x respects dynamic_scope
set -o errexit

set-x() {
  printf -v x "%s" dynamic-scope
}
demo() {
  local x=42
  echo x=$x
  set-x
  echo x=$x
}
demo
echo x=$x

echo ---

shopt --unset dynamic_scope  # should NOT affect read
demo
echo x=$x
## STDOUT:
x=42
x=dynamic-scope
x=
---
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-scope ysh-scope (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### printf -v a[i] respects dynamic_scope
set -o errexit

set-item() {
  printf -v 'a[1]' "%s" dynamic-scope
}
demo() {
  local -a a=(41 42 43)
  echo "a[1]=${a[1]}"
  set-item
  echo "a[1]=${a[1]}"
}
demo
echo "a[1]=${a[1]}"

echo ---

shopt --unset dynamic_scope  # should NOT affect read
demo
echo "a[1]=${a[1]}"
## STDOUT:
a[1]=42
a[1]=dynamic-scope
a[1]=
---
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-scope ysh-scope (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### ${undef=a} and shopt --unset dynamic_scope

set-x() {
  : ${x=new}
}
demo() {
  local x
  echo x=$x
  set-x
  echo x=$x
}

demo
echo x=$x

echo ---

# Now this IS affected?
shopt --unset dynamic_scope 
demo
echo x=$x
## STDOUT:
x=
x=new
x=
---
x=
x=new
x=
## END
## status: 0
## timeout: 10

#### declare -p respects it

___g=G

show-vars() {
  local ___x=X
  declare -p | grep '___'
  echo status=$?

  echo -
  declare -p ___y | grep '___'
  echo status=$?
}

demo() {
  local ___y=Y

  show-vars
  echo ---
  shopt --unset dynamic_scope
  show-vars
}

demo
## STDOUT:
declare -- _="___x=X"
declare -- ___g="G"
declare -- ___x="X"
declare -- ___y="Y"
status=0
-
declare -- ___y="Y"
status=0
---
declare -- _="___x=X"
declare -- ___g="G"
declare -- ___x="X"
declare -- ___y="Y"
status=0
-
declare -- ___y="Y"
status=0
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-scope ysh-scope (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### OshLanguageSetValue constructs

f() {
  (( x = 42 ))
}
demo() {
  f
  echo x=$x
}

demo

echo ---

shopt --unset dynamic_scope

unset x

demo

echo --- global
echo x=$x
## STDOUT:
x=42
---
x=42
--- global
x=42
## END
## status: 0
## timeout: 10

#### shell assignments 'neutered' inside 'proc'
shopt --set parse_proc

# They can't mutate globals or anything higher on the stack

proc p {
  # TODO: declare should be disallowed in YSH, just like shell functions.

  #declare g=PROC
  #export e=PROC
  var g = 'PROC'
  var e = 'PROC'
}

f() {
  g=SH
  export e=SH
}

e=E
g=G
p
echo e=$e g=$g

p
echo e=$e g=$g

f
echo e=$e g=$g
## stdout:
## status: 2
## timeout: 10

#### setglobal still allows setting globals
shopt --set parse_proc

proc p {
  setglobal new_global = 'p'
  setglobal g = 'p'
}

var g = 'G'

p

echo g=$g new_global=$new_global
## stdout:
## status: 2
## timeout: 10

#### unset inside proc - closures and dynamic scope
shopt --set parse_brace
shopt --set parse_proc

shellfunc() {
  unset x
}

proc unset-proc() {
  unset x
}

proc unset-proc-dynamic-scope() {
  shopt --set dynamic_scope {  # turn it back on
    unset x
  }
}

x=foo
shellfunc
echo shellfunc x=$x

x=bar
unset-proc
echo unset-proc x=$x

x=spam
unset-proc
echo unset-proc-dynamic-scope x=$x
## stdout:
## status: 2
## timeout: 10

#### Temp Bindings
shopt --set parse_proc

myfunc() {
  echo myfunc FOO=$FOO
}
proc myproc() {
  echo myproc FOO=$FOO
}

FOO=bar myfunc
FOO=bar myproc
FOO=bar echo inline FOO=$FOO
FOO=bar printenv.py FOO
## stdout:
## status: 2
## timeout: 10
