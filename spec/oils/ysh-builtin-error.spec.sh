## Imported from the Oils spec tests (ysh-builtin-error.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### error builtin adds named args as properties on _error Dict

try {
  error 'bad' (code=99)
}
pp test_ (_error)

# Note: myData co
try {
  error 'bad' (code=99, myData={spam:'eggs'})
}
pp test_ (_error)

try {
  error 'bad' (code=99, message='cannot override')
}
pp test_ (_error)
## stdout:
## status: 2
## timeout: 10

#### Errors within multiple functions
func inverse(x) {
  if (x === 0) {
    error '0 does not have an inverse'  # default status is 1
  }

  return (1 / x)
}

func invertList(list) {
  var result = []
  for item in (list) {
    call result->append(inverse(item))
  }
  return (result)
}

= invertList([1, 2, 0])
## stdout:
## status: 2
## timeout: 10

#### default error code is 10
error 'some error'
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-builtin-error ysh-builtin-error (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Impact of errors on var declaration
func alwaysError() {
  error "it's an error" (status=100)
}

try {
  var mylist = [1 + 2, alwaysError()]

  echo this will never be printed
}
= mylist  # undefined! status becomes 1
## stdout:
## status: 2
## timeout: 10

#### error code should be an integer
error 'error' (code='a string?')
## stdout:
## status: 2
## timeout: 10

#### Error code should be named arg, not positional
error msg (100)
## stdout:
## status: 2
## timeout: 10

#### error cannot take word args
error uh-oh ('error', status=1)
## stdout:
## status: 2
## timeout: 10

#### error requires arguments
error
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-builtin-error ysh-builtin-error (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### error cannot have a code of 0
error ('error', code=0)
## stdout:
## status: 2
## timeout: 10

#### Handle _error.code

proc failing {
  error 'failed' (code=99)
}

try {
  failing
}
if (_error.code === 99) {
  echo PASS
}

try {
  failing
}
case (_error.code) {
  (0)    { echo success }
  (1)    { echo one }
  (else) { echo CASE PASS }
}
## stdout:
## status: 2
## timeout: 10

#### failed builtin  usage

set +o errexit

try { echo ok }

failed (42)
echo status=$?

try { echo ok }

# Too many args
failed a b
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### failed builtin

try {
  echo hi
}
if failed {
  echo 'should not get here'
} else {
  echo 'ok 1'
}

try {
  #test -n ''

  # Hm json read sets the regular error
  # Should we raise error.Structured?
  #json read <<< '{'

  var x = fromJson('{')

  # Hm the error is in a SUBPROCESS HERE
  #echo '{' | json read
}
if failed {
  echo 'ok 2'
} else {
  echo 'should not get here'
}
## stdout: hi
## status: 2
## XFAIL ps-bash gap-oils-ysh-builtin-error ysh-builtin-error (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
