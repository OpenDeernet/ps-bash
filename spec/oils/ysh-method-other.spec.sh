## Imported from the Oils spec tests (ysh-method-other.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Command.sourceCode() on Expr: ^(echo 1; echo 2)

var cmd = ^(echo 1; echo 2; false)

var src = cmd.sourceCode()

assert [null === src]

# Test passing it
proc p ( ; ; ; block) {
  pp test_ (block)
  assert [null === block.sourceCode()]
}

p ( ; ; cmd)
## stdout:
## status: 2
## timeout: 10

#### Command.sourceCode() works in nested blocks

shopt --unset no_osh_builtins  # allow alias builtin

proc p ( ; ; ; block) {
  var src = block.sourceCode()

  pp test_ (src.code_str)

  call io->eval(block)
}


shopt --unset no_parse_backticks
shopt --unset no_parse_sh_arith
shopt --set expand_aliases

p { 
  echo foo
}

p { 
  #a[0]=`echo foo`
  echo foo
  p { 
    #a[inner]=`echo foo`
    echo inner
  }
}
## stdout:
## status: 2
## timeout: 10
