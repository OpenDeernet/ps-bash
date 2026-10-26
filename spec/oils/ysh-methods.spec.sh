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

#### read-lines can be built on top of read --all and Str.lines()

proc read-lines (; out) {
  read --all 
  call out->setValue(_reply.lines())
}

seq 4 7 > tmp.txt

read-lines (&x) < tmp.txt

pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### Dict => values()
var en2fr = {}
setvar en2fr["hello"] = "bonjour"
setvar en2fr["friend"] = "ami"
setvar en2fr["cat"] = "chat"
pp test_ (en2fr => values())
## stdout:
## status: 2
## timeout: 10

#### Dict -> erase()
var book = {title: "The Histories", author: "Herodotus"}
call book->erase("author")
pp test_ (book)
# confirm method is idempotent
call book->erase("author")
pp test_ (book)
## stdout:
## status: 2
## timeout: 10

#### Dict -> clear()
var book = {title: "The Histories", author: "Herodotus"}
call book->clear()
pp test_ (book)
# confirm method is idempotent
call book->clear()
pp test_ (book)
## stdout:
## status: 2
## timeout: 10

#### Dict -> get()
var book = {title: "Hitchhiker's Guide", published: 1979}
pp test_ (book => get("title", ""))
pp test_ (book => get("published", 0))
pp test_ (book => get("author", ""))
## stdout:
## status: 2
## timeout: 10

#### Dict -> inc() with ints
var histogram = {a: 1979}

call histogram->inc('a', 3)
assert [{"a": 1982} === histogram]

call histogram->inc('b', 3)
assert [{"a": 1982, "b": 3} === histogram]
## stdout:
## status: 2
## timeout: 10

#### Dict -> inc() with invalid value
var d = {k: 'foo'}
call d->inc('k', 42)
## stdout:
## status: 2
## timeout: 10

#### Dict -> inc() with floats
var histogram = {a: 2.5}
call histogram->inc('a', 2)
pp test_ (histogram)
call histogram->inc('a', 3.5)
pp test_ (histogram)
call histogram->inc('b', 3.5)
pp test_ (histogram)
call histogram->inc('b', 2)
pp test_ (histogram)
call histogram->inc('c', 1)
pp test_ (histogram)
call histogram->inc('c', 3.0)
pp test_ (histogram)

var d = {k: 'foo'}
call d->inc('k', 42.14)
## stdout:
## status: 2
## timeout: 10

#### Dict -> append()
var mydict = {a: [1]}
call mydict->append('a', 2)
assert [{"a": [1,2]} === mydict]
call mydict->append('a', 'b')
assert [{"a": [1,2,'b']} === mydict]
call mydict->append('b', 1)
assert [{"a": [1,2,'b'], "b": [1]} === mydict]
call mydict->append('c', [1,2])

# list of lists
assert [{"a": [1,2,'b'], "b": [1], "c": [[1,2]]} === mydict]
## stdout:
## status: 2
## timeout: 10

#### Dict -> append() with invalid value
var d = {k: 'foo'}
call d->append('k', 'bar')
## stdout:
## status: 2
## timeout: 10

#### Dict -> update()
var d = {a: 2, b: 3}
var alias = d
var other = {a: 42}
call d->update(other)
assert [{a: 42, b: 3} === d]
assert [{a: 42, b: 3} === alias]
## stdout:
## status: 2
## timeout: 10

#### concat operator (++) on dicts
var d = {a: 2, b: 3}
var other = {a: 42}
assert [{a: 42, b: 3} === d ++ other]
# old dict is untouched - shallow copy was done
assert [{a: 2, b: 3} === d]
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-methods ysh-methods (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
