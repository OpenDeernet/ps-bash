## Imported from the Oils spec tests (ysh-expr.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### command sub $(echo hi)
var x = $(echo hi)
var y = $(echo '')
# Make sure we can operate on these values
echo x=${x:-default} y=${y:-default}
## stdout: x=default y=default
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Set $HOME using 'var' (i.e. YSH string var in word evaluator)
var HOME = "foo"
echo $HOME
echo ~
## STDOUT:
/home/beagle
/home/beagle
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Use shell var in YSH expression
x='abc'
var length = len(x)  # length in BYTES, unlike ${#x}
echo $length
## stdout:
## status: 2
## timeout: 10

#### YSH var used with shell arithmetic
var w = "3"
echo lt=$(( w < 4 ))
echo gt=$(( w > 4 ))

var z = 3
echo lt=$(( z < 4 ))
echo gt=$(( z > 4 ))
## STDOUT:
lt=1
gt=0
lt=1
gt=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### double quoted
var foo = "bar"
var x = "-$foo-${foo}-${undef:-default}-"
echo $x
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### double quoted respects strict_array
shopt -s strict:all
declare -a a=(one two three)
var x = "-${a[@]}-"
echo $x
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### simple var sub $name $0 $1 $? etc.
( exit 42 )
var status = $?
echo status=$status

set -- a b c
var one = $1
var two = $2
echo $one $two

var named = "$one"  # equivalent to 'one'
echo named=$named
## STDOUT:
status=

named=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### braced var sub ${x:-default}

# without double quotes

var b = ${foo:-default}
echo $b
var c = ${bar:-"-$b-"}
echo $c

var d = "${bar:-"-$c-"}"  # another one
echo $d
## STDOUT:



## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### braced var sub respects strict_array
set -- a b c
var x = ${undef:-"$@"}
echo $x
shopt -s strict_array
setvar x = ${undef:-"$@"}
echo $x
## STDOUT:


## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### obj=>method() - remove?
var s = 'hi'

# TODO: This does a bound method thing we probably don't want
var s2 = s=>upper()
echo $s2
## stdout:
## status: 2
## timeout: 10

#### s->upper does NOT work, should be s.upper() or =>
var s = 'hi'
var method = s->upper
echo $method
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### d.key
var d = {name: 'andy'}
var x = d.name
echo $x
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### can't use ++ on integers
var x = 12 ++ 3
echo $x
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### can't do mystr ++ mylist
= ["s"] + "t"
## stdout:
## status: 127
## timeout: 10

#### No list comprehension in ^[]

var mylist = ^[x for x in y]  
pp test_ (io->evalExpr(mylist))
## stdout:
## status: 2
## timeout: 10

#### expression literals, evaluation failure
var e = ^[1 / 0]
call io->evalExpr(e)
## stdout:
## status: 2
## timeout: 10
