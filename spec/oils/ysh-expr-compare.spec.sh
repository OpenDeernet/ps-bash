## Imported from the Oils spec tests (ysh-expr-compare.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### floatsEqual()

var x = 42.0
pp test_ (floatsEqual(42.0, x))

pp test_ (floatsEqual(42.0, x + 1))
## stdout:
## status: 2
## timeout: 10

#### Non-comparable types in case arms
var myexpr = ^[123]

case (myexpr) {
  (myexpr) { echo 123; }
}
## stdout:
## status: 2
## timeout: 10

#### object identity

var d = {}
var s = 'str'

pp test_ (d is d)
pp test_ (d is not {})
echo

pp test_ (d is s)
pp test_ (d is not s)
## stdout:
## status: 2
## timeout: 10
