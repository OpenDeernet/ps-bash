## Imported from the Oils spec tests (ysh-json.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### usage errors

json read zz
echo status=$?

json write
## stdout: status=127
## status: 127
## timeout: 10

#### json write STRING
shopt --set parse_proc

json write ('foo')
var s = 'foo'
json write (s)
## stdout:
## status: 2
## timeout: 10

#### json write ARRAY
json write (:|foo.cc foo.h|)
json write (['foo.cc', 'foo.h'], space=0)
## stdout:
## status: 2
## timeout: 10

#### json write Dict
json write ({k: 'v', k2: [4, 5]})

json write ([{k: 'v', k2: 'v2'}, {}])
## stdout:
## status: 2
## timeout: 10

#### json write space=0, space=4
shopt --set parse_proc

var mydict = {name: "bob", age: 30}

json write (mydict, space=0)
json write (mydict, space=4)
## stdout:
## status: 2
## timeout: 10

#### json write in command sub
shopt -s oil:all  # for echo
var mydict = {name: "bob", age: 30}
json write (mydict)
var x = $(json write (mydict))
echo $x
## stdout:
## status: 2
## timeout: 10

#### json read passed invalid args

# EOF
json read
echo status=$?

json read 'z z'
echo status=$?

json read a b c
echo status=$?
## STDOUT:
status=127
status=127
status=127
## END
## status: 0
## timeout: 10

#### json read uses $_reply var

# space before true
echo ' true' | json read
json write (_reply)
## stdout:
## status: 2
## timeout: 10

#### json read then json write

# BUG with space before true
echo '{"name": "bob", "age": 42, "ok": true}' | json read
json write (_reply)

echo '{"name": "bob", "age": 42, "ok":true}' | json read
json write (_reply)

echo '{"name": {}, "age": {}, "x":-1, "y": -0}' | json read
json write (_reply)
## stdout:
## status: 2
## timeout: 10

#### json read at end of pipeline (relies on lastpipe)
echo '{"age": 43}' | json read (&y)
pp cell_ y
## stdout:
## status: 2
## timeout: 10

#### invalid JSON
echo '{' | json read (&y)
echo pipeline status = $?
pp test_ (y)
## stdout:
## status: 2
## timeout: 10

#### Extra data after valid JSON

# Trailing space is OK
echo '42  ' | json read
echo num space $?

echo '{}  ' | json read
echo obj space $?

echo '42 # comment' | json8 read
echo num comment $?

echo '{}   # comment ' | json8 read
echo obj comment $?

echo '42]' | json read
echo num bracket $?

echo '{}]' | json read
echo obj bracket $?
## STDOUT:
num space 127
obj space 127
num comment 127
obj comment 127
num bracket 127
obj bracket 127
## END
## status: 0
## timeout: 10

#### json write expression
json write ([1,2,3], space=0)
echo status=$?

json write (5, 6)  # to many args
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### json write evaluation error

#var block = ^(echo hi)
#json write (block) 
#echo status=$?

# undefined var
json write (a) 
echo 'should have failed'
## stdout:
## status: 2
## timeout: 10

#### json write of List in cycle

var L = [1, 2, 3]
setvar L[0] = L
pp test_ (L)

json write (L)
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### json write of Dict in cycle

var d = {}
setvar d.k = d

pp test_ (d)

json write (d)
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### json write of List/Dict referenced twice (bug fix)

var mylist = [1,2,3]
var mydict = {foo: "bar"}

var top = {k: mylist, k2: mylist, k3: mydict, k4: mydict}

# BUG!
json write (top, space=0)
## stdout:
## status: 2
## timeout: 10

#### json read doesn't accept u'' or b'' strings

json read <<EOF
{"key": u'val'}
EOF
echo status=$?

#pp test_ (_reply)

json read <<EOF
{"key": b'val'}
EOF
echo status=$?
## STDOUT:
status=127
status=127
## END
## status: 0
## timeout: 10

#### json read doesn't accept comments, but json8 does

json8 read <<EOF
{  # comment
  "key":  # zz
  b'val',  # yy
  "k2": "v2"  #
}
EOF
echo status=$?

json8 write (_reply)

json read <<EOF
{"key": "val"}  # comment
EOF
echo status=$?
## stdout: status=127
## status: 2
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### json write emits Unicode replacement char for binary data \yff

json write ([3, "foo", $'-\xff\xfe---\xfd=']) > tmp.txt

# Round trip it for good measure
json read < tmp.txt

json write (_reply)
## stdout:
## status: 2
## timeout: 10

#### json8 accepts j"" prefix, but json doesn't

var msg = r'j"foo\nbar"'

echo "$msg" | json read
echo json=$?
echo

echo "$msg" | json8 read
echo json8=$?
pp test_ (_reply)
echo

var msg = r'j"\u0041"'
echo "$msg" | json8 read
echo json8=$?
pp test_ (_reply)
## STDOUT:
json=127

json8=127
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### json8 write emits b'' strings for binary data \yff

json8 write ([3, "foo", $'-\xff\xfe-\xfd='])
## stdout:
## status: 2
## timeout: 10

#### json8 write bytes vs unicode string

u=$'mu \u03bc \x01 \" \\ \b\f\n\r\t'
u2=$'\x01\x1f'  # this is a valid unicode string

b=$'\xff'  # this isn't valid unicode

json8 write (u)
json8 write (u2)

json8 write (b)
## stdout:
## status: 2
## timeout: 10

#### JSON \/ escapes supported

msg='"\/"'

echo "$msg" | python3 -c 'import json, sys; print(json.load(sys.stdin))'

echo "$msg" | json read
echo reply=$_reply

j8="b'\\/'"
echo "$msg" | json read
echo reply=$_reply
## STDOUT:
/
reply=
reply=
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### JSON string can have unescaped ' and J8 string can have unescaped "

json read <<EOF
"'"
EOF

pp test_ (_reply)

json8 read <<EOF
u'"'
EOF

pp test_ (_reply)
## stdout:
## status: 2
## timeout: 10

#### J8 supports superfluous \" escapes, but JSON doesn't support \' escapes

json8 read <<'EOF'
b'\"'
EOF
echo reply=$_reply

json8 read <<'EOF'
b'\'\'\b\f\n\r\t\"\\'
EOF
pp test_ (_reply)

# Suppress traceback
python3 -c 'import json, sys; print(json.load(sys.stdin))' 2>/dev/null <<'EOF'
"\'"
EOF
echo python3=$?

json read <<'EOF'
"\'"
EOF
echo json=$?
## stdout: reply=
## status: 2
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Escaping uses \u0001 in "", but \u{1} in b''

s1=$'\x01'
s2=$'\x01\xff\x1f'  # byte string

json8 write (s1)
json8 write (s2)
## stdout:
## status: 2
## timeout: 10

#### json8 read

echo '{ }' | json8 read
pp test_ (_reply)

echo '[ ]' | json8 read
pp test_ (_reply)

echo '[42]' | json8 read
pp test_ (_reply)

echo '[true, false]' | json8 read
pp test_ (_reply)

echo '{"k": "v"}' | json8 read
pp test_ (_reply)

echo '{"k": null}' | json8 read
pp test_ (_reply)

echo '{"k": 1, "k2": 2}' | json8 read
pp test_ (_reply)

echo "{u'k': {b'k2': null}}" | json8 read
pp test_ (_reply)

echo '{"k": {"k2": "v2"}, "k3": "backslash \\ \" \n line 2 \u03bc "}' | json8 read
pp test_ (_reply)

json8 read (&x) <<'EOF'
{u'k': {u'k2': u'v2'}, u'k3': u'backslash \\ \" \n line 2 \u{3bc} '}
EOF
pp test_ (x)
## stdout:
## status: 2
## timeout: 10

#### json8 round trip

var obj = [42, 1.5, null, true, "hi", b'\yff\yfe\b\n""']

json8 write (obj, space=0) > j

cat j

json8 read < j

json8 write (_reply)
## stdout:
## status: 2
## timeout: 10

#### json round trip (regression)

var d = {
  short: '-v', long: '--verbose', type: null, default: '', help: 'Enable verbose logging'
}

json write (d) | json read

pp test_ (_reply)
## stdout:
## status: 2
## timeout: 10

#### round trip: decode surrogate pair and encode

var j = r'"\ud83e\udd26"'
echo $j | json read (&c1)

json write (c1)

var j = r'"\uD83E\uDD26"'
echo $j | json read (&c2)

json write (c2)

# Not a surrogate pair
var j = r'"\u0001\u0002"' 
echo $j | json read (&c3)

json write (c3)

var j = r'"\u0100\u0101\u0102"' 
echo $j | json read (&c4)

json write (c4)
## stdout:
## status: 2
## timeout: 10

#### fromJson() fromJson8()

var m1 = '[42,1.5,null,true,"hi"]'

# JSON8 message
var m2 = '[42,1.5,null,true,"hi",' ++ "u''" ++ ']'

pp test_ (fromJson8(m1))
pp test_ (fromJson(m1))

pp test_ (fromJson8(m2))
pp test_ (fromJson(m2))  # fails
## stdout:
## status: 2
## timeout: 10

#### \yff can't appear in u'' code strings (expr)

var x = b'\yfe' 
write -n -- $x | od -A n -t x1

var x = u'\yfe' 
write -n -- $x | od -A n -t x1
## stdout:
## status: 0
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### \u{dc00} can't be in surrogate range in data

json8 read <<'EOF'
["long string", u'hello \u{d7ff}', "other"]
EOF
echo status=$?

json8 read <<'EOF'
["long string", u'hello \u{d800}', "other"]
EOF
echo status=$?

json8 read <<'EOF'
["long string", u'hello \u{dfff}', "other"]
EOF
echo status=$?

json8 read <<'EOF'
["long string", u'hello \u{e000}', "other"]
EOF
echo status=$?
## STDOUT:
status=127
status=127
status=127
status=127
## END
## status: 0
## timeout: 10

#### Invalid UTF-8 in JSON is rejected

echo $'"\xff"' | json read
echo status=$?

echo $'"\xff"' | json8 read
echo status=$?

echo $'\xff' | json read
echo status=$?

echo $'\xff' | json8 read
echo status=$?
## STDOUT:
status=127
status=127
status=127
status=127
## END
## status: 0
## timeout: 10

#### Invalid JSON in J8 is rejected

json8 read <<EOF
b'$(echo -e -n '\xff')'
EOF
echo status=$?

json8 read <<EOF
u'$(echo -e -n '\xff')'
EOF
echo status=$?
## STDOUT:
status=127
status=127
## END
## status: 0
## timeout: 10

#### '' means the same thing as u''

echo "''" | json8 read
pp test_ (_reply)

echo "'\u{3bc}'" | json8 read
pp test_ (_reply)

echo "'\yff'" | json8 read
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### decode integer larger than 2^32

json=$(( 1 << 33 ))
echo $json

echo $json | json read
pp test_ (_reply)
## stdout: 8589934592
## status: 2
## XFAIL ps-bash gap-oils-ysh-json ysh-json (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Encoding bytes that don't hit UTF8_REJECT immediately (bug fix)

var x = $'\xce'
json8 write (x)
declare -p x
echo

var y = $'\xbc'
json8 write (y)
declare -p y
echo

var z = $'\xf0\x9f\xa4\xff'
json8 write (z)
declare -p z
## stdout:
## status: 2
## timeout: 10

#### NIL8 token in JSON / JSON8

echo "(" | json read
echo status=$?

echo ")" | json8 read
echo status=$?
## STDOUT:
status=127
status=127
## END
## status: 0
## timeout: 10

#### Too many opening [[[ - blocking stack

python2 -c 'print("[" * 10000)' | json read
pp test_ (_reply)

python2 -c 'print("{" * 10000)' | json read
pp test_ (_reply)
## stdout:
## status: 2
## timeout: 10

#### BashArray can be serialized

declare -a empty_array

declare -a array=(x y)
array[5]=z

json write (empty_array)
json write (array)
## stdout:
## status: 2
## timeout: 10

#### BashAssoc can be serialized

declare -A empty_assoc

declare -A assoc=([foo]=bar [42]=43)

json write (empty_assoc)
json write (assoc)
## stdout:
## status: 2
## timeout: 10
