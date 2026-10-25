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
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
