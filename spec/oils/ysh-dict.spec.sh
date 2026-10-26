## Imported from the Oils spec tests (ysh-dict.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### "in" and "not in" on Dicts

var d = {spam: 42, eggs: []}

var b = 'spam' in d
echo $b

var b = 'zz' in d
echo $b

var b = 'zz' not in d
echo $b

var L = [1, 2, 3]
var b = 3 in L  # not allowed!

echo should not get here
## STDOUT:



should not get here
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-dict ysh-dict (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Dict literal with string keys
var d = {'sq': 123}
var v = d['sq']
echo $v

var x = "q"
var d2 = {"d$x": 456}
var v2 = d2["dq"]
echo $v2
## STDOUT:


## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-dict ysh-dict (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### keys(d), values(d), get(d, key)

var d = {a: 42, b: 99}

pp test_ (keys(d))
pp test_ (values(d))

pp test_ (get(d, 'a', 'default'))
pp test_ (get(d, 'key', 'default'))
## stdout:
## status: 2
## timeout: 10

#### get() has default null

var d = {a: 42}

pp test_ (get(d, 'b'))
## stdout:
## status: 2
## timeout: 10
