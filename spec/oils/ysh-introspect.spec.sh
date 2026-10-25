## Imported from the Oils spec tests (ysh-introspect.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### getFrame()

var fr = vm.getFrame(0)
pp test_ (fr)
var d = dict(fr)
pp test_ (d.ARGV)
echo

proc p1 {
  var p1_var = 'x'
  p2
}

proc p2 {
  echo 'p2 frame -1'
  var fr = vm.getFrame(-1)
  var d = dict(fr)

  pp test_ (fr)
  pp test_ (d)
  pp test_ (keys(d))
  echo

  echo 'p2 frame -2'
  setvar fr = vm.getFrame(-2)
  setvar d = dict(fr)

  pp test_ (fr)
  pp test_ (keys(d))
  echo
}

p1

var fr = vm.getFrame(99)  # fails
## stdout:
## status: 2
## timeout: 10

#### bindFrame()

var frag = ^(echo $i)

# TODO: should be fragment
pp test_ (frag)

var cmd = bindFrame(frag, vm.getFrame(0))

pp test_ (cmd)
## stdout:
## status: 2
## timeout: 10

#### FUNCNAME BASH_LINENO BASH_SOURCE not available with YSH functions

func g(x) {
  echo ${FUNCNAME[@]}
  echo ${BASH_LINENO[@]}
  echo ${BASH_SOURCE[@]}
}

func f(x) {
  return (g(x))
}

# We can allow it in procs -- there's no cost to doing so? 

proc p {
  call f(42)
}

p
## stdout:
## status: 2
## timeout: 10
