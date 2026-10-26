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
