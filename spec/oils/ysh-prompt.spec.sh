## Imported from the Oils spec tests (ysh-prompt.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### promptVal() with $ and w

var x = io.promptVal('$')

# We're not root, so it should be $
echo x=$x

var x = io.promptVal('w')

assert [x === $(pwd)]
echo pass
## stdout:
## status: 2
## timeout: 10

#### promptVal('w') respects ENV.HOME

# ENV not set in spec tests
var x = io.promptVal('w')
assert [x.startsWith('/')]

# now set it
setglobal ENV.HOME = '/home'

var x = io.promptVal('w')
assert [x.startsWith('~')]
## stdout:
## status: 2
## timeout: 10

#### promptVal() with invalid chars

# \D{} will be supported with date and time functions
var x = io.promptVal('D')
echo x=$x

# something else
var x = io.promptVal('/')
echo x=$x

var x = io.promptVal('ZZ')
echo x=$x
## stdout:
## status: 2
## timeout: 10
