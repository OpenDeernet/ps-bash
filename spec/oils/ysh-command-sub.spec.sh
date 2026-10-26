## Imported from the Oils spec tests (ysh-command-sub.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Conflict with extglob @( can be avoided with ,(

shopt -s extglob

[[ foo.py == @(*.sh|*.py) ]]
echo status=$?

# Synonym.  This is a syntax error in bash.
[[ foo.py == ,(*.sh|*.py) ]]
echo status=$?
## stdout: status=0
## status: 2
## XFAIL ps-bash gap-oils-ysh-command-sub ysh-command-sub (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### split command sub @() in expression mode
shopt --set parse_proc parse_at

var x = @(seq 3)

write -- @x
## stdout:
## status: 2
## timeout: 10

#### split command sub @() in command mode

shopt -s parse_at
write -- @(seq 3)

echo --
IFS=x
x=axbxxc
argv.py $x

# This construct behaves the same with simple_word_eval on
# Not affected by IFS
echo --
shopt -s simple_word_eval
write -- @(seq 3)

echo --
argv.py @(echo $x)
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-command-sub ysh-command-sub (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### @() decodes J8 Lines

# syntax errors - TODO: document this in doc/chap-errors

# - syntax error in J8 string (bad escape, no closing quote)
# - extra text after line
# - unquoted line isn't valid UTF-8

var b = @(
  # unquoted: spaces stripped at beginning and end
  echo '  unquoted "" word  '

  # empty line is ignored
  echo

  # Not allowed, since unquoted lines should be UTF-8
  #echo $'binary \xff';

  echo '  " json \u03bc " '
  echo '  j" json j prefix \u03bc " '
  echo " u' j8 u \\u{3bc} ' "
  echo " b' j8 b \\u{3bc} ' "

  # no prefix is like u''
  echo "  ' j8 no prefix \\u{3bc} ' "
)

json write (b)
## stdout:
## status: 2
## timeout: 10

#### for loop using @(seq $n)
shopt -s oil:upgrade

for x in @(seq 3) {
  echo "[$x]"
}
for x in @(seq 3) {
  argv.py z @[glob("[$x]")]
}
## stdout:
## status: 2
## timeout: 10

#### @() can't start in the middle of the word
shopt -s extglob  # this makes it match in bash
shopt -s oil:upgrade

# This is currently a RUNTIME error when simple_word_eval is on

touch foo.py
echo f@(*.py)
## stdout: foo.py
## status: 0
## timeout: 10

#### @() can't have any tokens after it
shopt -s oil:upgrade

write -- @(seq 2)
write -- @(seq 3)x
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-command-sub ysh-command-sub (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
