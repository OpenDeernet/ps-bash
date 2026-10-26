## Imported from the Oils spec tests (ysh-builtin-eval.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### eval builtin does not take a literal block - can restore this later

var b = ^(echo obj)
call io->eval (b)

call io->eval (^(echo command literal))

# Doesn't work because it's a positional arg
eval { echo block }
## stdout:
## status: 2
## timeout: 10

#### Eval a block within a proc
proc run (;;; block) {
  call io->eval(block)
}

run {
  echo 'In a block!'
}
## stdout:
## status: 2
## timeout: 10

#### Eval block created by calling a proc
proc lazy-block ( ; out; ; block) {
  call out->setValue(block)
}

var myglobal = 0

lazy-block (&my_block) {
  json write (myglobal)
}

call io->eval(my_block)
setvar myglobal = 1
call io->eval(my_block)
## stdout:
## status: 2
## timeout: 10

#### io->eval with argv bindings
call io->eval(^(echo "$@"), pos_args=:| foo bar baz |)
call io->eval(^(pp test_ (:| $1 $2 $3 |)), pos_args=:| foo bar baz |)
## stdout:
## status: 2
## timeout: 10

#### eval lines with argv bindings
proc my-split (;;; block) {
  while read --raw-line {
    var cols = split(_reply)
    call io->eval(block, pos_args=cols)
  }
}

printf 'a b\nc d\n' | my-split {
  echo "$2 $1"
}

printf 'a b\nc d\n' | my-split {
  var mylocal = 'mylocal'
  echo "$2 $1 $mylocal"
}

# Now do the same thing inside a proc
proc p {
  printf 'a b\nc d\n' | my-split {
    var local2 = 'local2'
    echo "$2 $1 $local2"
  }
}

echo
p
## stdout:
## status: 2
## timeout: 10

#### eval lines with var bindings

proc my-split (;;; block) {
  while read --raw-line {
    var cols = split(_reply)
    call io->eval(block, vars={_line: _reply, _first: cols[0]})
  }
}

printf 'a b\nc d\n' | my-split {
  var mylocal = 'mylocal'
  echo "$_line | $_first $mylocal"
}

# Now do the same thing inside a proc
proc p {
  printf 'a b\nc d\n' | my-split {
    var local2 = 'local2'
    echo "$_line | $_first $local2"
  }
}

echo
p
## stdout:
## status: 2
## timeout: 10

#### eval with custom dollar0
var b = ^(write $0)
call io->eval(b, dollar0="my arg0")
## stdout:
## status: 2
## timeout: 10

#### eval with vars bindings
var myVar = "abc"
call io->eval(^(pp test_ (myVar)))
call io->eval(^(pp test_ (myVar)), vars={ 'myVar': '123' })

# eval doesn't modify it's environment
call io->eval(^(pp test_ (myVar)))
## stdout:
## status: 2
## timeout: 10

#### dynamic binding names and mutation
proc foreach (binding, in_; list ;; block) {
  if (in_ !== "in") {
    error 'Must use the "syntax" `foreach <binding> in (<expr>) { ... }`'
  }

  for item in (list) {
    call io->eval(block, vars={ [binding]: item })
  }
}

var mydicts = [{'a': 1}, {'b': 2}, {'c': 3}]
foreach mydict in (mydicts) {
  var mylocal = 'z'
  setvar mydict.z = mylocal

  pp test_ (mydict)
  setvar mydict.d = 0
}
echo

for d in (mydicts) {
  pp test_ (d)
}
## stdout:
## status: 2
## timeout: 10

#### binding procs in the eval-ed namespace
proc __flag (short, long) {
  echo "flag $short $long"
}

proc __arg (name) {
  echo "arg $name"
}

proc parser (; spec ;; block) {
  call io->eval(block, vars={ 'flag': __flag, 'arg': __arg })
}

parser (&spec) {
  flag -h --help
  arg file
}

# but flag/arg are unavailable outside of `parser`
# _error.code = 127 is set on "command not found" errors

try { flag }
if (_error.code !== 127) { error 'expected failure' }

try { arg }
if (_error.code !== 127) { error 'expected failure' }
## stdout:
## status: 2
## timeout: 10

#### vars initializes the variable frame, but does not remember it
var vars = { 'foo': 123 }
call io->eval(^(var bar = 321;), vars=vars)
pp test_ (vars)
## stdout:
## status: 2
## timeout: 10

#### eval pos_args must be strings
call io->eval(^(true), pos_args=[1, 2, 3])
## stdout:
## status: 2
## timeout: 10

#### eval with vars follows same scoping as without

proc local-scope {
  var myVar = "foo"
  call io->eval(^(echo $myVar), vars={ someOtherVar: "bar" })
  call io->eval(^(echo $myVar))
}

# In global scope
var myVar = "baz"
call io->eval(^(echo $myVar), vars={ someOtherVar: "bar" })
call io->eval (^(echo $myVar))

local-scope
## stdout:
## status: 2
## timeout: 10

#### eval 'mystring' vs. call io->eval(myblock)

eval 'echo plain'
echo plain=$?
var b = ^(echo plain)
call io->eval(b)
echo plain=$?

echo

# This calls main_loop.Batch(), which catches
# - error.Parse
# - error.ErrExit
# - error.FatalRuntime - glob errors, etc.?

try {
  eval 'echo one; false; echo two'
}
pp test_ (_error)

# This calls CommandEvaluator.EvalCommand(), as blocks do

var b = ^(echo one; false; echo two)
try {
  call io->eval(b)
}
pp test_ (_error)
## STDOUT:
plain
plain=0
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-eval ysh-builtin-eval (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### io->eval(to_dict=true) - local and global

var g = 'global'

# in the global frame
var d = io->eval(^(var foo = 42; var bar = g;), to_dict=true)
pp test_ (d)

# Same thing in a local frame
proc p (myparam) {
  var mylocal = 'local'
  # TODO: ^() needs to capture
  var cmd = ^(
    var foo = 42
    var g = "-$g"
    var p = "-$myparam"
    var L = "-$mylocal"
  )
  var d = io->eval(cmd, to_dict=true)
  pp test_ (d)
}
p param
## stdout:
## status: 2
## timeout: 10

#### io->eval(to_dict=true) with dollar0, pos_args, vars - dict ordering bug

# TODO: mycpp/gc_dict.h should preserve insertion order, in the presence of
# deletions, like CPython

proc Dict ( ; out; ; block) {
  var d = io->eval(block, dollar0='zero', pos_args=:|a b c|,
                   vars={X: 'X', _Y: '_Y'}, to_dict=true)
  call out->setValue(d)
}

var global = 'global'

Dict (&d) {
  foo = global
  z = $0
  one = $1
  two = ${2}
  three = "+$3"
  # Note: X does NOT appear in the output, ctx_Eval makes it work.
  x = X
  y = _Y
}

json write (d)
#pp test_ (d)
## stdout:
## status: 2
## timeout: 10

#### io->eval(to_dict=true) with in_captured_frame=true

proc Dict ( ; out; ; block) {
  var d = io->eval(block, dollar0='zero', pos_args=:|a b c|,
                   vars={X: 'X', _Y: '_Y'}, in_captured_frame=true, to_dict=true)
  call out->setValue(d)
}

var global = 'global'

func makeDict() {
  var var_in_p_frame = 'p'

  Dict (&d) {
    foo = global
    z = $0
    one = $1
    two = ${2}
    three = "+$3"
    # Note: X does NOT appear in the output, ctx_Eval makes it work.
    x = X
    y = _Y
  }

  return (d)
}

var d = makeDict()
json write (d)
## stdout:
## status: 2
## timeout: 10

#### parseCommand then io->eval(to_dict=true) - in global scope

var g = 'global'
var cmd = parseCommand('var x = 42; echo hi; var y = g')
#var cmd = parseCommand('echo hi')

pp test_ (cmd)
#pp asdl_ (cmd)

var d = io->eval(cmd, to_dict=true)

pp test_ (d)
## stdout:
## status: 2
## timeout: 10

#### parseCommand with syntax error

try {
  var cmd = parseCommand('echo >')
}
pp test_ (_error)
## stdout:
## status: 2
## timeout: 10

#### Dict (&d) { ... } converts frame to dict

proc Dict ( ; out; ; block) {
  var d = io->eval(block, to_dict=true)
  call out->setValue(d)
}

# it can read f

var myglobal = 'global'
var k = 'k-shadowed'
var k2 = 'k2-shadowed'

Dict (&d) {
  bare = 42

  # uh these find the wrong one
  # This is like redeclaring the one above, but WITHOUT the static error
  # HM HM HM
  var k = 'k-block'
  setvar k = 'k-block-mutated'

  # Finds the global, so not checked
  setvar k2 = 'k2-block'

  # This one is allowed
  setvar k3 = 'k3'

  # do we allow this?
  setvar myglobal = 'global'
}

pp test_ (d)


# Same problem as Hay test cases!
const c = 99

Dict (&d2) {
  const c = 101
}

pp test_ (d2)

exit

# restored to the shadowed values
echo k=$k
echo k2=$k2

proc p {
  Dict (&d) {
    var k = 'k-proc'
    setvar k = 'k-proc-mutated'

    # Not allowed STATICALLY, because o fproc check
    #setvar k2 = 'k2-proc'  # local, so it's checked
  }
}
## stdout:
## status: 2
## timeout: 10

#### block in Dict (&d) { ... } can read from outer scope

proc Dict ( ; out; ; block) {
  var d = io->eval(block, to_dict=true)
  call out->setValue(d)
}

func f() {
  var x = 42

  Dict (&d) {
    y = x + 1  # x is from outer scope
  }
  return (d)
}

var mydict = f()

pp test_ (mydict)
## stdout:
## status: 2
## timeout: 10

#### Dict (&d) and setvar

proc Dict ( ; out; ; block) {
  echo "Dict proc global outer=$outer"
  var d = io->eval(block, to_dict=true)

  #pp frame_vars_

  #echo "Dict outer2=$outer2"
  call out->setValue(d)
}

var outer = 'xx'

Dict (&d) {
  # new variable in the front frame
  outer2 = 'outer2'

  echo "inside Dict outer=$outer"
  setvar outer = 'zz'

  setvar not_declared = 'yy'

  #echo 'inside Dict block'
  #pp frame_vars_
}

pp test_ (d)
echo "after Dict outer=$outer"

echo


# Now do the same thing inside a proc

proc p {
  var outer = 'p-outer'

  Dict (&d) {
    p = 99
    setvar outer = 'p-outer-mutated'
  }

  pp test_ (d)
  echo "[p] after Dict outer=$outer"
}

p

echo "after p outer=$outer"
## stdout:
## status: 2
## timeout: 10

#### Dict (&d) and setglobal

proc Dict ( ; out; ; block) {
  var d = io->eval(block, to_dict=true)
  call out->setValue(d)
}

var g = 'xx'

Dict (&d) {
  setglobal g = 'zz'

  a = 42
  pp frame_vars_
}
echo

pp test_ (d)
echo g=$g

#pp frame_vars_
## stdout:
## status: 2
## timeout: 10

#### bindings created shvar persist, which is different than eval(to_dict=true)

var a = 'a'
shvar IFS=: a='b' {
  echo a=$a
  inner=z
  var inner2 = 'z'
}
echo a=$a
echo inner=$inner 
echo inner2=$inner2
## stdout: a=
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-eval ysh-builtin-eval (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### io->eval with in_captured_frame=true can express cd builtin

proc my-cd (new_dir; ; ; block) {
  pushd $new_dir >/dev/null

  if (0) {
    # Get calling frame.  (The top-most frame, this one, has index -1)
    # This idiom does NOT work with modules
    var calling_frame = vm.getFrame(-2)
    call io->evalInFrame(block, calling_frame)
  } else {
    #call io->evalInCapturedFrame(block)
    call io->eval(block, in_captured_frame=true)
  }

  popd >/dev/null
}

var i = 42
my-cd /tmp {
  echo $PWD
  var my_pwd = PWD
  var j = i + 1
}
echo "my_pwd=$my_pwd"
echo "j = $j"
## stdout:
## status: 2
## timeout: 10

#### eval should have a sandboxed mode

proc p (;;; block) {
  var this = 42

  # like --eval-pure, and like func?
  with-pure {
    # Do we still use io->eval?
    call io->eval(block)
  }

  # Or maybe we have free functions, like func/eval
  # There is no with-pure
  call eval(cmd)
  var d = eval(cmd, to_dict=true)

  eval-pure --dump d {
    var d = {}
  }
}

p {
  echo $this
}
## stdout:
## status: 2
## timeout: 10

#### io->evalExpr() with vars, dollar0, pos_args

var ex = ^["$0 $1 $2 " ++ myvar]

var vars = {myvar: 'hello'}
var s = io->evalExpr(ex, dollar0='z', pos_args=:|a b c|, vars=vars)

echo $s

proc my-where (; pred) {
  # note: for line in (io.stdin) is messed up by spec test framework

  while read --raw-line (&line) {
    var vars = {_line: line}
    #= line
    var b = io->evalExpr(pred, vars=vars)
    if (b) {
      echo $line
    }
  }
}


seq 5 | my-where [_line ~== 2 or _line ~== 4]
echo ---

seq 5 10 | my-where [_line % 2 === 1]
## stdout:
## status: 2
## timeout: 10
