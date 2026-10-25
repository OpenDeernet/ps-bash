## Imported from the Oils spec tests (ysh-builtin-module.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### use builtin usage

use
echo no-arg=$?

use foo
echo one-arg=$?

use --extern foo
echo extern=$?

use --bad-flag
echo bad-flag=$?

use too many
echo too-many=$?

use ///no-builtin
echo no-builtin=$?
## STDOUT:
no-arg=127
one-arg=127
extern=127
bad-flag=127
too-many=127
no-builtin=127
## END
## status: 0
## timeout: 10

#### use --extern is a no-op, for static analysis

use --extern grep sed awk
echo status=$?

use --extern zzz
echo status=$?
## STDOUT:
status=127
status=127
## END
## status: 0
## timeout: 10

#### user can inspect __modules__ cache

echo 'TODO: Dict view of realpath() string -> Obj instance'
## stdout: TODO: Dict view of realpath() string -> Obj instance
## status: 0
## timeout: 10

#### use foo.ysh --all-provided

echo TODO
## stdout: TODO
## status: 0
## timeout: 10

#### use foo.ysh --all-for-testing

echo TODO
## stdout: TODO
## status: 0
## timeout: 10
