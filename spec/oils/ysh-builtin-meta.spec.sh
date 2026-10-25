## Imported from the Oils spec tests (ysh-builtin-meta.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Type objects Bool, Int, Float, etc.

pp test_ (Bool)
pp test_ (Int)
pp test_ (Float)
pp test_ (Str)

pp test_ (List)
pp test_ (Dict)
pp test_ (Obj)
echo

var b = Bool

pp test_ (b is Bool)

# Objects don't have equality, only identity
#pp test_ (b === Bool)

pp test_ (vm.id(b) === vm.id(Bool))
## stdout:
## status: 2
## timeout: 10

#### runproc
shopt --set parse_proc parse_at

f() {
  write -- f "$@"
}
proc p {
  write -- p @ARGV
}
runproc f 1 2
echo status=$?

runproc p 3 4
echo status=$?

runproc invalid 5 6
echo status=$?

runproc
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### pp asdl_

x=42
setvar y = {foo: x}

pp asdl_ (x)
pp asdl_ (y)

pp asdl_ (io.stdin)
## stdout:
## status: 2
## timeout: 10

#### pp gc-stats_

pp gc-stats_
## stdout:
## status: 127
## timeout: 10

#### pp cell_
x=42

pp cell_ x
echo status=$?

pp -- cell_ x
echo status=$?

pp cell_ nonexistent
echo status=$?
## STDOUT:
status=127
status=127
status=127
## END
## status: 0
## timeout: 10

#### pp cell_ on indexed array with hole
declare -a array
array[3]=42
array[5]=99
pp cell_ array
## stdout:
## status: 127
## timeout: 10

#### pp test_ supports BashArray, BashAssoc

declare -a array=(a b c)
pp test_ (array)

array[5]=z
pp test_ (array)

declare -A assoc=([k]=v [k2]=v2)
pp test_ (assoc)

# I think assoc arrays can never null / unset

assoc['k3']=
pp test_ (assoc)
## stdout:
## status: 2
## timeout: 10
