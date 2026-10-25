## Imported from the Oils spec tests (ysh-method-io.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### captureStdout() is like $()

proc p {
  var captured = 'captured'
  var cmd = ^(echo one; echo $captured)
  
  var stdout = io.captureStdout(cmd)
  pp test_ (stdout)
}

p
## stdout:
## status: 2
## timeout: 10

#### captureStdout() failure

var c = ^(echo one; false; echo two)

# Hm this prints a message, but no stack trace
# Should make it fail I think

try {
  var x = io.captureStdout(c)
}
# This has {"code": 3} because it's an expression error.  Should probably
pp test_ (_error)

var x = io.captureStdout(c)
## stdout:
## status: 2
## timeout: 10

#### io->eval() is like eval builtin

var c = ^(echo one; echo two)
var status = io->eval(c)

# doesn't return anything
echo status=$status
## stdout:
## status: 2
## timeout: 10

#### captureAll() is like $() but captures stderr and status

proc p {
  var captured = 'captured'
  var cmd = ^(
    echo stdout
    echo stderr >&2
    echo $captured
    echo $captured >&2
    printf '\000'
    exit 42
  )

  var result = io.captureAll(cmd)
  pp test_ (result)
}

p
## stdout:
## status: 2
## timeout: 10

#### captureAll() doesn't fail

var c = ^(shopt --unset verbose_errexit; echo out; echo err >&2; false; echo two)

# Hm this prints a message, but no stack trace
# Should make it fail I think

try {
  var x = io.captureAll(c)
}
# This has {"code": 3} because it's an expression error.  Should probably
pp test_ (_error)
pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### io->eval() with failing command - caller must handle

var c = ^(echo one; false; echo two)

try {
  call io->eval(c)
}
pp test_ (_error)

call io->eval(c)
## stdout:
## status: 2
## timeout: 10

#### io->eval() with exit

var c = ^(echo one; exit; echo two)

try {
  call io->eval(c)
}
echo 'we do not get here'
pp test_ (_error)
## stdout:
## status: 2
## timeout: 10

#### io.glob() respects shell filters
touch -- .gitignore -foo.txt foo.txt foo.md

#GLOBIGNORE='*.md'

pp test_ (io.glob('*'))

shopt -s dotglob
shopt --unset no_dash_glob
pp test_ (io.glob('*'))

# This meandes dotglob, no_dash_glob
GLOBIGNORE='*.md'
pp test_ (io.glob('*'))
## stdout:
## status: 2
## timeout: 10

#### io.libcGlob() does not respect shell filters
touch -- .gitignore -foo.txt foo.txt

pp test_ (io.libcGlob('*'))

# NO effect
shopt -s dotglob
shopt --unset no_dash_glob
pp test_ (io.libcGlob('*'))

GLOBIGNORE='*.md'
pp test_ (io.libcGlob('*'))
## stdout:
## status: 2
## timeout: 10
