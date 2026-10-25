## Imported from the Oils spec tests (ysh-proc.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Open proc (any number of args)
shopt --set parse_proc

proc f {
  var x = 42
  return $x
}
# this gets called with 3 args then?
f a b c
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### Closed proc with no args, passed too many
shopt --set parse_proc

proc f() {
  return 42
}
f
echo status=$?

f a b  # status 2
## stdout:
## status: 2
## timeout: 10

#### Proc with default args
shopt --set parse_proc

proc f(x='foo') {
  echo x=$x
}
f
## stdout:
## status: 2
## timeout: 10

#### Proc name-with-hyphen
shopt --set parse_proc parse_at

proc name-with-hyphen {
  echo @ARGV
}
name-with-hyphen x y z
## stdout: @ARGV
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### proc returning wrong type
shopt --set parse_proc

# this should print an error message
proc f {
  var a = %(one two)
  return $a
}
f
## stdout:
## status: 2
## timeout: 10

#### proc returning invalid string
shopt --set parse_proc

# this should print an error message
proc f {
  var s = 'not an integer status'
  return $s
}
f
## stdout:
## status: 2
## timeout: 10

#### 'return' doesn't accept expressions
proc p {
  return 1 + 2
}
p
## stdout:
## status: 2
## timeout: 10

#### Nested proc is allowed
shopt --set parse_proc

proc f {
  proc g {
    echo 'G'
  }
  g
}
f
g  # g is defined in the local scope of f
## stdout: G
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### declare -f -F only prints shell functions
shopt --set parse_proc

myfunc() {
  echo hi
}

proc myproc {
  echo hi
}

declare -F
echo ---

declare -F myproc
echo status=$?

declare -f myproc
echo status=$?
## stdout: hi
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
