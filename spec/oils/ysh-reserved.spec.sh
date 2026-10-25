## Imported from the Oils spec tests (ysh-reserved.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Standalone generator expression
var x = (i+1 for i in 1:3)
# This is NOT a list.  TODO: This test is overspecified.
pp cell_ x | grep -o '<generator'
write status=$?
## stdout:
## status: 2
## timeout: 10

#### List comprehension (deferred)
shopt -s oil:all

var n = [i*2 for i in range(5)]
write --sep ' ' @n

# TODO: Test this
#var n = [i*2 for i,j in range(5)]

var even = [i*2 for i in range(5) if i % 2 === 0]
write --sep ' ' @even
## stdout:
## status: 2
## timeout: 10

#### Lambda not implemented
const f = |x| x + 1
## stdout:
## status: 127
## timeout: 10

#### Anonymous function expression not implemented (Tea)

# Note: this results in a expr.Lambda node.  But it's not parsed.

const f = func(x) {
  myfunc(x)
  return x + 1
}
## stdout:
## status: 2
## timeout: 10
