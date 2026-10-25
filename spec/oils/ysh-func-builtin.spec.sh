## Imported from the Oils spec tests (ysh-func-builtin.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### join()
var x = :|a b 'c d'|

var y = join(x)
argv.py $y

var z = join(x, ":")
argv.py $z
## stdout:
## status: 2
## timeout: 10

#### @[split(x)] respects IFS
setvar IFS = ":"
var x = "one:two:three"
argv.py @[split(x)]
## stdout:
## status: 2
## timeout: 10

#### @[maybe(x)]
setvar empty = ''
setvar x = 'X'
argv.py a @[maybe(empty)] @[maybe(x)] b

setvar n = null
argv.py a @[maybe(n)] b
## stdout:
## status: 2
## timeout: 10

#### maybe() on invalid type is fatal error

# not allowed
setvar marray = :||
argv.py a @[maybe(marray)] b
echo done
## stdout:
## status: 2
## timeout: 10

#### split() on invalid type is fatal error
var myarray = :| --all --long |
write -- @[myarray]
write -- @[split(myarray)]
## stdout:
## status: 2
## timeout: 10

#### @[glob(x)]

# empty glob
write -- A @[glob('__nope__')] B
echo ___

touch -- a.z b.z -.z
write -- @[glob('?.z')]
echo ___

# add it back
shopt --unset no_dash_glob
write -- @[glob('?.z')]
## stdout:
## status: 2
## timeout: 10

#### shSplit() respects IFS

var s = ' aa a bb b   '

argv.py @[shSplit(s)]

setvar IFS = 'a'

argv.py @[shSplit(s)]

setvar IFS = 'b'

argv.py @[shSplit(s)]
## stdout:
## status: 2
## timeout: 10
