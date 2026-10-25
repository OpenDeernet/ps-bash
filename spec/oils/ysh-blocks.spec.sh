## Imported from the Oils spec tests (ysh-blocks.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### block arg as typed expression

shopt -s oil:all

# literal
cd /tmp (; ; ^(echo $PWD))

const myblock = ^(echo $PWD)
cd /tmp (; ; myblock)
## stdout:
## status: 2
## timeout: 10

#### Pass invalid typed args

cd /tmp (42)  # should be a block
## stdout:
## status: 2
## timeout: 10

#### Pass too many typed args

cd /tmp (1, 2)
## stdout:
## status: 2
## timeout: 10

#### 'builtin' and 'command' with block
shopt --set oil:upgrade
builtin cd / {
  echo "builtin $PWD"
}
command cd / {
  echo "command $PWD"
}
## stdout: builtin /tmp/tmp.RdNX1t8Lae
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Consistency: Exit Status and Blocks
shopt --set parse_brace

cd / {
  false 
}
echo cd=$?

shopt --unset errexit {
  false
}
echo shopt=$?

shvar FOO=foo {
  echo "  FOO=$FOO"
  false
}
echo shvar=$?

try {
  false
}
echo try=$?
## stdout:
## status: 2
## timeout: 10

#### Block with Bare Assignments

# oil:all has parse_equals
# is there any way to turn on parse_equals only in config blocks?
# but we don't know what's a block ahead of time
# I think we would have to check at runtime.  Look at VarChecker

shopt --set oil:all

proc Rule(s ; ; ; b) {
  echo "rule $s"
}

proc myrules(name) { 
  Rule $name-python { 
    kind = 'python'
  }

  Rule $name-cc {
    kind = 'cc'  # should NOT conflict
  }
}

myrules foo
myrules bar
## stdout:
## status: 2
## timeout: 10

#### Proc that doesn't take a block
shopt --set parse_brace parse_proc parse_paren

proc task(name ; ; ; b = null) {
  echo "task name=$name"
  if (b) {
    call io->eval(b)
    return 33
  } else {
    echo 'no block'
    return 44
  }
}

task spam
echo status=$?

echo

task foo {
  echo 'running'
  echo 'block'
}
echo status=$?
## stdout:
## status: 2
## timeout: 10
