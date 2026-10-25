## Imported from the Oils spec tests (temp-binding.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Temp bindings with local

f() {
  local x=x
  tmp='' local tx=tx

  # Hm both y and ty persist in bash/zsh
  eval 'local y=y'
  tmp='' eval 'local ty=ty'

  # Why does this have an effect in OSH?  Oh because 'unset' is a special
  # builtin
  if true; then
    x='X' unset x
    tx='TX' unset tx
    y='Y' unset y
    ty='TY' unset ty
  fi

  #unset y
  #unset ty

  echo x=$x
  echo tx=$tx
  echo y=$y
  echo ty=$ty
}

f
## STDOUT:
x=x
tx=tx
y=y
ty=ty
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### FOO=bar $unset - temp binding, then empty argv from unquoted unset var (#2411)
foo=alive! $unset
echo $foo
## stdout: alive!
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
