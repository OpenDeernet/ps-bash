## Imported from the Oils spec tests (ysh-bytecode.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### bytecode

func __b__hi(n) {
  var x = n + 1
  var y = n + 2

  setvar y = x + y

  = y
}

call __b__hi(42)
## stdout:
## status: 2
## timeout: 10
