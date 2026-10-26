## Imported from the Oils spec tests (ysh-regex.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Repeat {1,3} etc.
var pat = null

setvar pat = /d{2}/
echo $pat
setvar pat = /d{1,3}/
echo $pat
setvar pat = /d{1,}/
echo $pat
setvar pat = /d{,3}/
echo $pat
## STDOUT:




## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Alternation and sequence
var pat = ''
setvar pat = /s d+ | w*/
echo $pat
setvar pat = /s d+ or w*/
echo $pat
## STDOUT:


## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### [!d] can't be negated because it's a literal character
setvar pat = / [ !d 'z' ] /
echo $pat
## STDOUT:

## END
## status: 0
## timeout: 10

#### [!digit] can't be negated in POSIX ERE (but yes in Perl)
var pat = null
setvar pat = / [ !digit 'z' ] /
echo $pat
## STDOUT:

## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Operator chars in char classes (bash-like)

pat='[-]'
[[ '-' =~ $pat ]] && echo hyphen
[[ '\' =~ $pat ]] && echo FAIL

pat='[\]'
[[ '\' =~ $pat ]] && echo backslash
[[ '-' =~ $pat ]] && echo FAIL

pat='[]]'
[[ ']' =~ $pat ]] && echo 'right bracket'
[[ '[' =~ $pat ]] && echo FAIL

pat='[[]'
[[ '[' =~ $pat ]] && echo 'left bracket'
[[ ']' =~ $pat ]] && echo FAIL

pat='[.]'
[[ '.' =~ $pat ]] && echo period
[[ '\' =~ $pat ]] && echo FAIL

pat='[\^]'
[[ '^' =~ $pat ]] && echo caret
[[ '\' =~ $pat ]] && echo 'no way to have [^]'
## STDOUT:
hyphen
backslash
right bracket
left bracket
period
caret
no way to have [^]
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Multiple digits like [25] are invalid

# synonyms
var pat = /[2 5]/
echo $pat
var pat = /[2 '5']/
echo $pat

var pat = /[25]/
echo $pat
## STDOUT:



## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Negation of digit not allowed

var digits = /[!2]/
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-ysh-regex ysh-regex (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
