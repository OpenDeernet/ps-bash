## Imported from the Oils spec tests (ysh-object.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Object() creates prototype chain

func Rect_area(this) {
  return (this.x * this.y)
}

var Rect = Object(null, {area: Rect_area})

var rect1 = Object(Rect, {x: 3, y: 4})
var rect2 = Object(Rect, {x: 10, y: 20})

# This could change to show the object?
# pp test_ (rect)

# TODO: This should be a bound function
#pp asdl_ (rect)
#pp (rect.area)
#pp (rect->area)

var area1 = rect1.area()
var area2 = rect2.area()

pp test_ ([rect1.x, rect1.y])
echo "area1 = $area1"

pp test_ ([rect2.x, rect2.y])
echo "area2 = $area2"

#pp test_ (rect1.nonexistent)
## stdout:
## status: 2
## timeout: 10

#### prototype()

func Rect_area(this) {
  return (this.x * this.y)
}

var Rect = Object(null, {area: Rect_area})

var obj = Object(Rect, {x: 3, y: 4})

pp test_ (prototype(Rect))
pp test_ (prototype(obj))
## stdout:
## status: 2
## timeout: 10

#### propView()

var obj = Object(null, {x: 3, y: 4})
var props = propView(obj)

pp test_ (props)

# object can be mutated
setvar props.x = 99

pp test_ (props)

var e = propView(null)  # error
## stdout:
## status: 2
## timeout: 10

#### Mutating method must be up the prototype chain, not on the object

func inc(self, n) {
  setvar self.i += n
}
var c = Object(null, {'M/inc': inc, i: 0})

call c->inc(3)
## stdout:
## status: 2
## timeout: 10

#### Copy to Dict with dict(), and mutate

var rect = Object(null, {x: 3, y: 4})
var d = dict(rect)

pp test_ (rect)
pp test_ (d)

setvar rect.x = 99
setvar d.x = 100

pp test_ (rect)
pp test_ (d)
## stdout:
## status: 2
## timeout: 10

#### setvar obj.attr = and += and ...

var rect = Object(null, {x: 3, y: 4})
pp test_ (rect)

setvar rect.y = 99
pp test_ (rect)

setvar rect.y += 3
pp test_ (rect)

setvar rect.x *= 5
pp test_ (rect)
## stdout:
## status: 2
## timeout: 10

#### obj['attr'] not allowed (for now)

var rect = Object(null, {x: 3, y: 4})

pp test_ ([rect['x'], rect['y']])
## stdout:
## status: 2
## timeout: 10

#### setvar obj['attr'] = 3 ?

var rect = Object(null, {x: 3, y: 4})

setvar rect['x'] = 99

pp test_ (rect)

# The reason this is allowed is because setvar does EvalLhsExpr(), which
# handles:
#
# - y_lhs.SubScript -> y_lvalue.Container
# - y_lhs.Attribute -> y_lvalue.Container
#
# So that means obj['x'] is allowed too?
# We could possible add y_lvalue.Container(is_subscript)
## stdout:
## status: 2
## timeout: 10

#### can't encode objects as JSON

var Rect = Object(null, {})

json write (Rect)
echo 'nope'
## stdout:
## status: 2
## timeout: 10

#### invokable Obj must be have prototype containing __invoke__ of value.Proc - type -t

proc p (w; self) {
  pp test_ ([w, self])
}
p a ({x: 5, y: 6})
echo

var methods = Object(null, {__invoke__: p})

var o1 = Object(methods, {})
type -t o1
echo

# errors

var o2 = Object(null, {})
if ! type -t o2 {
  echo 'no prototype'
}

var o3 = Object(Object(null, {}), {})
if ! type -t o3 {
  echo 'no __invoke__ method in prototype'
}

var bad_methods = Object(null, {__invoke__: 42})
var o4 = Object(bad_methods, {})
if ! type -t o4 {
  echo '__invoke__ of wrong type'
}
## stdout:
## status: 2
## timeout: 10

#### Object with longer prototype chain

# prototypal inheritance pattern
var superClassMethods = Object(null, {foo: 'zz'})
var methods = Object(superClassMethods, {foo: 42, bar: [1,2]})
var instance = Object(methods, {foo: 1, bar: 2, x: 3})

pp test_ (instance)
pp value (instance)
## stdout:
## status: 2
## timeout: 10

#### __readonly__ in prototype makes objects readonly

# __readonly__ in first() does not mean anything
var methods = Obj.new({__readonly__: 3}, null)
setvar methods.__readonly__ = true

= methods

var attrs = {x: 42}
var obj = Obj.new(attrs, methods)
= vm.id(attrs)
= vm.id(obj)

# should FAIL
setvar obj.x = 99

# should also fail
setvar obj.x += 99

= obj

# TODO: this should not be a value.Dict() that aliases the obj.d
var alias = first(obj)
= vm.id(alias)

= get(obj, 'x')

# TODO: make these work
= keys(obj)
= values(obj)

# Another case: we can MUTATE the methods, and REMOVE __readonly__?
#
# Or maybe we define some kind of magic freeze()
#
# where there's a special __readonly__?
## stdout:
## status: 2
## timeout: 10
