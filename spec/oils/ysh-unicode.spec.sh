## Imported from the Oils spec tests (ysh-unicode.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### JSON \uXXXX\uYYYY as max code point - can't go above

py-decode() {
  python2 -c 'import json, sys; print json.load(sys.stdin).encode("utf-8")'
}

to-hex() {
  od -A n -t x1
}

max='"\udbff\udfff"'

# incrementing by one gives invalid surrogates
# the encoding is "tight"
# too_big='"\udc00\udfff"'

echo "$max" | py-decode | to-hex

echo "$max" | json read
echo "$_reply" | to-hex
## stdout:  0a
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Parsing data - J8 rejects \u{110000}

json8 read <<EOF
u'\u{110000}'
EOF
echo status=$?
## stdout: status=127
## status: 0
## timeout: 10

#### Parsing source code - YSH rejects \u{110000}

# Sanity check first: Python interpreter DOES check big code points,
# whereas shells don't

max=$(python2 -c 'print u"\U0010ffff".encode("utf-8")')
echo status max=$?

too_big=$(python2 -c 'print u"\U00110000".encode("utf-8")')
echo status too_big=$?

#echo py max=$max
#echo py too_big=$too_big

# python2 -c 'import sys; c = sys.argv[1].decode("utf-8"); print len(c)' "$ok"
# python2 -c 'import sys; c = sys.argv[1].decode("utf-8"); print len(c)' "$too_big"

var max = u'\u{10ffff}'
pp test_ (max)

var too_big = u'\u{110000}'
pp test_ (too_big)  # should not get here

# These are errors too
var max = b'\u{10ffff}'
var too_big = b'\u{110000}'
## STDOUT:
status max=127
status too_big=127
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### JSON and J8 reject encoded string above max code point

max=$(bash <<'EOF'
echo $'\U0010ffff'
EOF
)

# bash allows the bad one
too_big=$(bash <<'EOF'
echo $'\U00110000'
EOF
)

# JSON string

echo '"'$max'"' | json read
echo status=$?
#pp test_ (_reply)

# Need to propagate the reason here

echo '"'$too_big'"' | json read
echo status=$?
#pp test_ (_reply)


# J8 string

echo "u'"$max"'" | json8 read
echo status=$?
#pp test_ (_reply)

echo "u'"$too_big"'" | json8 read
echo status=$?
#pp test_ (_reply)
## STDOUT:
status=127
status=127
status=127
status=127
## END
## status: 0
## timeout: 10
