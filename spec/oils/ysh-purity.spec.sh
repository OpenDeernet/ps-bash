## Imported from the Oils spec tests (ysh-purity.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Executor: External Commands not allowed

var cmd = ^(seq 3)

call io->eval(cmd)

call eval(cmd)
## stdout:
## status: 2
## timeout: 10

#### io and vm are not allowed

var cmd = ^(
  = vm.getFrame(-1)
  = vm.id({})

  = io.stdin
)

call io->eval(cmd)
call eval (cmd)
## stdout:
## status: 2
## timeout: 10

#### Globbing not allowed

# TODO: should be @[io.glob('*.txt')]
# That is a bit verbose
var cmd = ^(
  echo *.txt
)

call io->eval(cmd)
call eval(cmd)
## stdout:
## status: 2
## timeout: 10

#### Purely-evaluated code can't set traps for later

# this follows from 'no builtins', but probably good to test

var cmd = ^(
  trap 'echo INT' INT
)

call io->eval(cmd)
call eval(cmd)
## stdout:
## status: 2
## timeout: 10
