## Imported from the Oils spec tests (ysh-methods.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### => operator for pure computation is allowed (may be mandatory later)

# later we may make it mandatory

if ("abc" => startsWith("a")) {
  echo yes
}

var mylist = [1, 2, 3]

# This one should be ->
call mylist->pop()
echo 'ok'
## stdout:
## status: 2
## timeout: 10

#### Str => startsWith(), no args
= 'abc' => startsWith()
## stdout:
## status: 2
## timeout: 10

#### Str => startsWith(), too many args
= 'abc' => startsWith('extra', 'arg')
## stdout:
## status: 2
## timeout: 10

#### Str => endsWith(), no args
= 'abc' => endsWith()
## stdout:
## status: 2
## timeout: 10

#### Str => endsWith(), too many args
= 'abc' => endsWith('extra', 'arg')
## stdout:
## status: 2
## timeout: 10

#### Str => trim(), too many args
= 'mystr' => trim('extra', 'args')
## stdout:
## status: 2
## timeout: 10

#### Str => trimStart(), too many args
= 'mystr' => trimStart('extra', 'args')
## stdout:
## status: 2
## timeout: 10

#### Str => trimEnd(), too many args
= 'mystr' => trimEnd('extra', 'args')
## stdout:
## status: 2
## timeout: 10

#### Str => trim*(), zero-codepoints are not NUL-terminators
json write (b' \y00 ' => trim())
json write (b' \y00 ' => trimStart())
json write (b' \y00 ' => trimEnd())
## stdout:
## status: 2
## timeout: 10

#### Str => split(sep), non-empty str sep
pp test_ ('a,b,c'.split(','))
pp test_ ('aa'.split('a'))
pp test_ ('a<>b<>c<d'.split('<>'))
pp test_ ('a;b;;c'.split(';'))
pp test_ (''.split('foo'))
## stdout:
## status: 2
## timeout: 10

#### Str => split(sep), eggex sep
pp test_ ('a,b;c'.split(/ ',' | ';' /))
pp test_ ('aa'.split(/ dot /))
pp test_ ('a<>b@@c<d'.split(/ '<>' | '@@' /))
pp test_ ('a b  cd'.split(/ space+ /))
pp test_ (''.split(/ dot /))
## stdout:
## status: 2
## timeout: 10

#### Str => split(sep, count), non-empty str sep
pp test_ ('a,b,c'.split(',', count=-1))
pp test_ ('a,b,c'.split(',', count=-2))  # Any negative count means "ignore count"
pp test_ ('aa'.split('a', count=1))
pp test_ ('a<>b<>c<d'.split('<>', count=10))
pp test_ ('a;b;;c'.split(';', count=2))
pp test_ (''.split('foo', count=3))
pp test_ ('a,b,c'.split(',', count=0))
pp test_ (''.split(',', count=0))
## stdout:
## status: 2
## timeout: 10

#### Str => split(sep, count), eggex sep
pp test_ ('a,b;c'.split(/ ',' | ';' /, count=-1))
pp test_ ('aa'.split(/ dot /, count=1))
pp test_ ('a<>b@@c<d'.split(/ '<>' | '@@' /, count=50))
pp test_ ('a b  c'.split(/ space+ /, count=0))
pp test_ (''.split(/ dot /, count=1))
## stdout:
## status: 2
## timeout: 10

#### Str => split(), non-ascii
pp test_ ('🌞🌝🌞🌝🌞'.split('🌝'))
pp test_ ('🌞🌝🌞🌝🌞'.split(/ '🌝' /))
## stdout:
## status: 2
## timeout: 10

#### Str.lines()

var empty = u''
pp test_ (empty.lines())

var one = u'\n'
pp test_ (one.lines())

var two = u'\n\n'
pp test_ (two.lines())

var three = u'one\ntwo\nthree'  # no trailing newline
pp test_ (three.lines())

var foo = u'foo'  # no trailing newline
pp test_ (foo.lines())

echo

var s = u'foo\nbar\n'
pp test_ (s.lines())

var z = b'foo\y00bar\y00'
pp test_ (z.lines(eol=\y00))

var r = u'foo\r\nbar\r\n'
pp test_ (r.lines(eol=u'\r\n'))

echo

pp test_ (empty.lines(eol=\y00))
pp test_ (z.lines())
pp test_ (r.lines())
## stdout:
## status: 2
## timeout: 10

#### Separation of -> attr and () calling
const check = "abc" => startsWith
pp test_ (check("a"))
## stdout:
## status: 2
## timeout: 10

#### Bound methods, receiver value/reference semantics
var is_a_ref = { "foo": "bar" }
const f = is_a_ref => keys
pp test_ (f())
setvar is_a_ref["baz"] = 42
pp test_ (f())

var is_a_val = "abc"
const g = is_a_val => startsWith
pp test_ (g("a"))
setvar is_a_val = "xyz"
pp test_ (g("a"))
## stdout:
## status: 2
## timeout: 10

#### List->clear()
var empty = []
var items = [1, 2, 3]

call empty->clear()
call items->clear()

pp test_ (empty)
pp test_ (items)
## stdout:
## status: 2
## timeout: 10

#### List => indexOf()
var items = [1, '2', 3, { 'a': 5 }]

json write (items => indexOf('a'))
json write (items => indexOf(1))
json write (items => indexOf('2'))
json write (items => indexOf({'a': 5}))
## stdout:
## status: 2
## timeout: 10

#### List => lastIndexOf()
var items = ['a', 'b', 'c', 'b', 'a']

json write (items => lastIndexOf('a'))
json write (items => lastIndexOf('b'))
json write (items => lastIndexOf('c'))
json write (items => lastIndexOf('d'))
## stdout:
## status: 2
## timeout: 10

#### List->reverse()

var empty = []

var a = [0]
var b = [2, 1, 3]
var c = :| hello world |

call empty->reverse()
call a->reverse()
call b->reverse()
call c->reverse()

pp test_ (empty)
pp test_ (a)
pp test_ (b)
pp test_ (c)
## stdout:
## status: 2
## timeout: 10

#### List->reverse() from iterator
var x = list(0 ..< 3)
call x->reverse()
write @x
## stdout:
## status: 2
## timeout: 10
