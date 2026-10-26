## Imported from the Oils spec tests (dbracket.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### [[ glob matching, [[ has no glob expansion
[[ foo.py == *.py ]] && echo true
[[ foo.p  == *.py ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### [[ glob matching with escapes
[[ 'foo.*' == *."*" ]] && echo true
# note that the pattern arg to fnmatch should be '*.\*'
## stdout: true
## status: 0
## timeout: 10

#### equality
[[ '*.py' == '*.py' ]] && echo true
[[ foo.py == '*.py' ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### [[ glob matching with unquoted var
pat=*.py
[[ foo.py == $pat ]] && echo true
[[ foo.p  == $pat ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### [[ regex matching
# mksh doesn't have this syntax of regex matching.  I guess it comes from perl?
regex='.*\.py'
[[ foo.py =~ $regex ]] && echo true
[[ foo.p  =~ $regex ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### [[ regex syntax error
# hm, it doesn't show any error, but it exits 2.
[[ foo.py =~ * ]] && echo true
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [[ has no word splitting
var='one two'
[[ 'one two' == $var ]] && echo true
## stdout: true
## status: 0
## timeout: 10

#### [[ has quote joining
var='one two'
[[ 'one 'tw"o" == $var ]] && echo true
## stdout: true
## status: 0
## timeout: 10

#### [[ empty string is false
[[ 'a' ]] && echo true
[[ ''  ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### && chain
[[ t && t && '' ]] || echo false
## stdout: false
## status: 0
## timeout: 10

#### || chain
[[ '' || '' || t ]] && echo true
## stdout: true
## status: 0
## timeout: 10

#### [[ compound expressions
# Notes on whitespace:
# - 1 and == need space seprating them, but ! and ( don't.
# - [[ needs whitesapce after it, but ]] doesn't need whitespace before it!
[[ ''||! (1 == 2)&&(2 == 2)]] && echo true

# NOTE on the two cases below.  We're comparing
#   (a || b) && c   vs.   a || (b && c)
#
# a = true, b = false, c = false is an example where they are different.
# && and || have precedence inside
## stdout: true
## status: 0
## timeout: 10

#### precedence of && and || inside [[
[[ True || '' && '' ]] && echo true
## stdout: true
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### precedence of && and || in a command context
if test True || test '' && test ''; then
  echo YES
else
  echo "NO precedence"
fi

# http://tldp.org/LDP/abs/html/testconstructs.html#DBLBRACKETS
## stdout: NO precedence
## status: 0
## timeout: 10

#### Octal literals with -eq
shopt -u strict_arith || true
decimal=15
octal=017   # = 15 (decimal)
[[ $decimal -eq $octal ]] && echo true
[[ $decimal -eq ZZZ$octal ]] || echo false
# mksh doesn't implement this syntax for literals.
## STDOUT:
true
false
## END
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Hex literals with -eq
shopt -u strict_arith || true
decimal=15
hex=0x0f    # = 15 (decimal)
[[ $decimal -eq $hex ]] && echo true
[[ $decimal -eq ZZZ$hex ]] || echo false

# TODO: Add tests for this
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions
# When used with [[, the ‘<’ and ‘>’ operators sort lexicographically using the
# current locale. The test command uses ASCII ordering.
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### > on strings
# NOTE: < doesn't need space, even though == does?  That's silly.
[[ b>a ]] && echo true
[[ b<a ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### != on strings
# NOTE: b!=a does NOT work
[[ b != a ]] && echo true
[[ a != a ]] || echo false
## STDOUT:
true
false
## END
## status: 0
## timeout: 10

#### -eq on strings
# This is lame behavior: it does a conversion to 0 first for any string
shopt -u strict_arith || true
[[ a -eq a ]] && echo true
[[ a -eq b ]] && echo true
## STDOUT:
true
true
## END
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [[ compare with literal -f (compare with test-builtin.test.sh)
var=-f
[[ $var == -f ]] && echo true
[[ '-f' == $var ]] && echo true
## STDOUT:
true
true
## END
## status: 0
## timeout: 10

#### [[ with op variable (compare with test-builtin.test.sh)
# Parse error -- parsed BEFORE evaluation of vars
op='=='
[[ a $op a ]] && echo true
[[ a $op b ]] || echo false
## stdout:
## status: 2
## timeout: 10

#### [[ '(' foo ]] is syntax error
[[ '(' foo ]]
echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### empty ! is treated as literal
[[ '!' ]]
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### [[ -z ]] is syntax error
[[ -z ]]
echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [[ -z '>' ]]
[[ -z '>' ]] || echo false  # -z is operator
## stdout: false
## status: 0
## timeout: 10

#### [[ -z '>' a ]] is syntax error
[[ -z '>' -- ]]
echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### test whether ']]' is empty
[[ ']]' ]]
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### [[ ]] is syntax error
[[ ]]
echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [[ && ]] is syntax error
[[ && ]]
echo status=$?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [[ a 3< b ]] doesn't work (bug regression)
[[ a 3< b ]]
echo status=$?
[[ a 3> b ]]
echo status=$?

# Hm these shells use the same redirect trick that OSH used to!
## stdout:
## status: 2
## timeout: 10

#### tilde expansion in [[
HOME=/home/bob
[[ ~ == /home/bob ]]
echo status=$?

[[ ~ == */bob ]]
echo status=$?

[[ ~ == */z ]]
echo status=$?
## STDOUT:
status=0
status=0
status=1
## END
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### more tilde expansion
[[ ~ ]]
echo status=$?
HOME=''
[[ ~ ]]
echo status=$?
[[ -n ~ ]]
echo unary=$?

[[ ~ == ~ ]]
echo status=$?

[[ $HOME == ~ ]]
echo fnmatch=$?
[[ ~ == $HOME ]]
echo fnmatch=$?
## STDOUT:
status=0
status=1
unary=1
status=0
fnmatch=0
fnmatch=0
## END
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### special chars
[[ ^ == ^ ]]
echo caret $?
[[ '!' == ! ]]
echo bang $?
## STDOUT:
caret 0
bang 0
## END
## status: 0
## timeout: 10

#### \(\) in pattern (regression)
if [[ 'foo()' == *\(\) ]]; then echo match1; fi
if [[ 'foo()' == *'()' ]]; then echo match2; fi
if [[ 'foo()' == '*()' ]]; then echo match3; fi

shopt -s extglob

if [[ 'foo()' == *\(\) ]]; then echo match1; fi
if [[ 'foo()' == *'()' ]]; then echo match2; fi
if [[ 'foo()' == '*()' ]]; then echo match3; fi
## STDOUT:
match1
match2
match1
match2
## END
## status: 0
## timeout: 10

#### negative numbers - zero, decimal, octal, hex, base N

[[ -0 -eq 0 ]]; echo zero=$?

[[ -42 -eq -42 ]]; echo decimal=$?

# note: mksh doesn't do octal conversion
[[ -0123 -eq -83 ]]; echo octal=$?

[[ -0xff -eq -255 ]]; echo hex=$?

[[ -64#a -eq -10 ]]; echo baseN=$?
## STDOUT:
zero=0
decimal=0
octal=0
hex=0
baseN=0
## END
## status: 0
## XFAIL ps-bash gap-oils-dbracket dbracket (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
