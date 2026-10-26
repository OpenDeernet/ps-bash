## Imported from the Oils spec tests (ysh-regex-bytes-chars.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### ERE: 'dot' matches newline

= 'z' ~ /dot/
= b'\n' ~ /dot/
= '' ~ /dot/
## stdout:
## status: 127
## timeout: 10

#### ERE: 'dot' matches code point represented with multiple bytes (mu = 0xce 0xbe)

var pat = / 'a' dot 'b' /

pp test_ ('axb' ~ pat )
# mu character
pp test_ (b'a\yce\ybcb' ~ pat )
pp test_ (b'a\u{3bc}b' ~ pat )

pp test_ ('ab' ~ pat )
pp test_ ('aZZb' ~ pat )
## stdout:
## status: 2
## timeout: 10

#### non-ASCII bytes must be singleton terms, e.g. b'\y7f\yff' is disallowed
var bytes = b'\y7f\yff'
var pat = / [ @bytes ] /
echo $pat
## STDOUT:

## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex-bytes-chars ysh-regex-bytes-chars (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Bytes are denoted \y01 in Eggex char classes (not \x01)

# That is, eggex does have MODES like re.UNICODE
#
# We UNAMBIGUOUSLY accept
# - \y01 or \u{1} - these are the same
# - \yff or \u{ff} - these are DIFFERENT

var pat = / [\y01] /
pp test_ (b'\y01' ~ pat)
pp test_ ('a' ~ pat)
## stdout:
## status: 2
## timeout: 10

#### Code points like \u{3bc} can be matched

var pat = / [\u{3bc}] /
pp test_ (b'a' ~ pat)
pp test_ (b'\u{3bc}' ~ / [\u{3bc}] /)
echo

var pat = / [\u{10ffff}] /
pp test_ (b'a' ~ pat)
pp test_ (b'\u{10ffff}' ~ pat)

#echo "-$pat-"
## stdout:
## status: 2
## timeout: 10

#### Max code point is disallowed at parse time

pp test_ (/ [\u{10ffff}] /)
pp test_ (/ [\u{110000}] /)
## stdout:
## status: 2
## timeout: 10

#### NUL byte can be expressed in Eggex, but not in ERE

$SH <<'EOF'
pp test_ (b'\y01' ~ / [\y01] /)
pp test_ (b'\y00' ~ / [\y00] /)
EOF
echo status=$?

$SH <<'EOF'
pp test_ (b'\y01' ~ / [\u{1}] /)
pp test_ (b'\y00' ~ / [\u{0}] /)
EOF
echo status=$?


# legacy synonym

$SH <<'EOF'
pp test_ (b'\y01' ~ / [\x01] /)
pp test_ (b'\y00' ~ / [\x00] /)
EOF
echo status=$?
## STDOUT:
status=2
status=2
status=2
## END
## status: 0
## timeout: 10
## real-launcher

#### High bytes 0x80 0xff can be matched with plain ERE and LC_ALL=C

export LC_ALL=C

$SH <<'EOF'
var yes = b'foo \yff'
var no = b'foo'

# POSIX ERE string
var ere = b'[\yff]'

pp test_ (yes ~ ere)
pp test_ (no ~ ere)
EOF
## stdout:
## status: 2
## timeout: 10
## real-launcher
