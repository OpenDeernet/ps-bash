## Imported from the Oils spec tests (ysh-proc-meta.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Mutate __sh_function__

f() { echo sh-func; }
f

setvar __sh_function__.f = 42

f
## STDOUT:
sh-func
sh-func
## END
## status: 0
## timeout: 10

#### with eval builtin command, in global scope

for param in a b {
  eval """
  proc echo_$param(prefix) {
    echo \$prefix $param
  }
  """
  # We need to "escape" the for loop scope
  call setVar("echo_$param", getVar("echo_$param"), global=true)
}

echo_a prefix
echo_b prefix
## stdout:
## status: 2
## timeout: 10

#### with eval builtin command, in local scope

proc p {
  for param in a b {
    eval """
    proc echo_$param(prefix) {
      echo \$prefix $param
    }
    """
    # We need to "escape" the for loop scope
    call setVar("echo_$param", getVar("echo_$param"), global=true)
  }

  # calling globals
  echo_a prefix
  echo_b prefix
}

p

# the global is available
echo_a prefix
## stdout:
## status: 2
## timeout: 10

#### with eval builtin command, reeturning Dict

func genProcs() {
  var result = {}
  for param in a b {
    eval """
    proc echo_$param(prefix) {
      echo \$prefix $param
    }
    """
    setvar result["echo_$param"] = getVar("echo_$param")
  }
  return (result)
}

var procs = genProcs()

# bind to global scope
for name in (procs) {
  call setVar("my_$name", procs[name], global=true)
}

my_echo_a prefix
my_echo_b prefix
## stdout:
## status: 2
## timeout: 10

#### with parseCommand() then io->eval(), in local scope

proc p {
  var result = {}
  for param in a b {
    var s = """
    proc echo_$param (prefix) {
      echo \$prefix $param
    }
    """
    var cmd = parseCommand(s)
    #pp test_ (cmd)
    #pp asdl_ (cmd)

    # note: this creates its own frame, unlike 'eval'
    # call io->eval(cmd)

    var d = io->eval(cmd, to_dict=true)

    # bind my_echo_a globally
    call setVar("my_echo_$param", d["echo_$param"], global=true)
  }

  #= dict(vm.getFrame(0))

  my_echo_a in-proc
  my_echo_b in-proc
}

p

my_echo_a global
my_echo_b global
## stdout:
## status: 2
## timeout: 10

#### with parseCommand() then io->eval(cmd, vars={out_dict: {}})

# This could take the place of evalToDict()?  But evalToDict() is useful in
# Hay?

func genProcs() {
  var vars = {out_dict: {}}
  for param in a b {
    var s = """
    proc echo_$param(prefix) {
      echo \$prefix $param
    }
    setvar out_dict.echo_$param = echo_$param
    """
    var cmd = parseCommand(s)
    call io->eval(cmd, vars=vars)
  }
  return (vars.out_dict)
}

var procs = genProcs()

var my_echo_a = procs.echo_a
var my_echo_b = procs.echo_b

my_echo_a prefix
my_echo_b prefix
## stdout:
## status: 2
## timeout: 10

#### with evalToDict()

func genProcs() {
  var result = {}
  for param in a b {
    var s = """
    # This is defined locally
    proc echo_$param(prefix) {
      echo \$prefix $param
    }
    if false {
      = echo_$param
      var a = 42
      pp frame_vars_
    }
    """
    var cmd = parseCommand(s)

    var d = io->evalToDict(cmd)

    # accumulate
    setvar result["echo_$param"] = d["echo_$param"]
  }
  return (result)
}

var procs = genProcs()

var my_echo_a = procs.echo_a
var my_echo_b = procs.echo_b

my_echo_a prefix
my_echo_b prefix
## stdout:
## status: 2
## timeout: 10
