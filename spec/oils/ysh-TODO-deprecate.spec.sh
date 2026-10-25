## Imported from the Oils spec tests (ysh-TODO-deprecate.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### %() array literal

shopt --set parse_at

var x = %(one two)
echo @x
## stdout:
## status: 2
## timeout: 10

#### source ///osh/two.sh rather than source --builtin osh/two.sh

source --builtin osh/two.sh
echo status=$?
## stdout: status=2
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### OILS_VERSION, not OIL_VERSION

if test -n "$OIL_VERSION"; then
  echo OIL
fi
## stdout:
## status: 0
## timeout: 10

#### Dict => keys()
var en2fr = {}
setvar en2fr["hello"] = "bonjour"
setvar en2fr["friend"] = "ami"
setvar en2fr["cat"] = "chat"
pp test_ (en2fr => keys())
## stdout:
## status: 2
## timeout: 10

#### evalInFrame() and evalToDict()

var cmd = ^(echo hi)

call io->evalInFrame(cmd, vm.getFrame(-1))

var d = io->evalToDict(cmd)
pp test_ (d)
## stdout:
## status: 2
## timeout: 10

#### \x7e was the legacy syntax for \y7e

pp test_ ('~' ~ / [\x7e] /)  # should be INVALID

pp test_ ('~' ~ / [\y7e] /)
## stdout:
## status: 2
## timeout: 10

#### glob() function should be retired in favor of io.glob()

touch -- foo
pp test_ (glob('*'))
## stdout:
## status: 2
## timeout: 10
