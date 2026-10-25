## Imported from the Oils spec tests (case_.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Case statement
case a in
  a) echo A ;;
  *) echo star ;;
esac

for x in a b; do
  case $x in
    # the pattern is DYNAMIC and evaluated on every iteration
    $x) echo loop ;;
    *) echo star ;;
  esac
done
## STDOUT:
A
loop
loop
## END
## status: 0
## timeout: 10

#### Case statement with ;;&
# ;;& keeps testing conditions
# NOTE: ;& and ;;& are bash 4 only, not on Mac
case a in
  a) echo A ;;&
  *) echo star ;;&
  *) echo star2 ;;
esac
## STDOUT:
A
star
star2
## END
## status: 0
## timeout: 10

#### Case statement with ;&
# ;& ignores the next condition.  Why would that be useful?

for x in aa bb cc dd zz; do
  case $x in
    aa) echo aa ;&
    bb) echo bb ;&
    cc) echo cc ;;
    dd) echo dd ;;
  esac
  echo --
done
## STDOUT:
aa
bb
cc
--
bb
cc
--
cc
--
dd
--
--
## END
## status: 0
## timeout: 10

#### Case with empty condition
case $empty in
  ''|foo) echo match ;;
  *) echo no ;;
esac
## stdout: match
## status: 0
## timeout: 10

#### Match a literal with a glob character
x='*.py'
case "$x" in
  '*.py') echo match ;;
esac
## stdout: match
## status: 0
## timeout: 10

#### Match a literal with a glob character with a dynamic pattern
x='b.py'
pat='[ab].py'
case "$x" in
  $pat) echo match ;;
esac
## stdout: match
## status: 0
## timeout: 10

#### Quoted literal in glob pattern
x='[ab].py'
pat='[ab].py'
case "$x" in
  "$pat") echo match ;;
esac
## stdout: match
## status: 0
## timeout: 10

#### Multiple Patterns Match
x=foo
result='-'
case "$x" in
  f*|*o) result="$result X"
esac
echo $result
## stdout: - X
## status: 0
## timeout: 10

#### Pattern ? matches 1 code point (many bytes), but not multiple code points

# These two code points form a single character.
two_code_points="__$(echo $'\u0061\u0300')__"

# U+0061 is A, and U+0300 is an accent.  
#
# (Example taken from # https://blog.golang.org/strings)
#
# However ? in bash/zsh only counts CODE POINTS.  They do NOT take into account
# this case.

for s in '__a__' '__μ__' "$two_code_points"; do
  case $s in
    __?__)
      echo yes
      ;;
    *)
      echo no
  esac
done
## STDOUT:
yes
yes
no
## END
## status: 0
## timeout: 10

#### matching every byte against itself

# Why does OSH on the CI machine behave differently?  Probably a libc bug fix
# I'd guess?

sum=0

# note: NUL byte crashes OSH!
for i in $(seq 1 255); do
  hex=$(printf '%x' "$i")
  c="$(printf "\\x$hex")"  # command sub quirk: \n or \x0a turns into empty string

  #echo -n $c | od -A n -t x1
  #echo ${#c}

  case "$c" in
    # Newline matches empty string somehow.  All shells agree.  I guess
    # fnmatch() ignores trailing newline?
    #'')   echo "[empty i=$i hex=$hex c=$c]" ;;
    "$c") sum=$(( sum + 1 )) ;;
    *)   echo "[bug i=$i hex=$hex c=$c]" ;;
  esac
done

echo sum=$sum
## stdout: sum=255
## status: 0
## timeout: 10

#### case \n bug regression

case
in esac
## stdout:
## status: 2
## timeout: 10
