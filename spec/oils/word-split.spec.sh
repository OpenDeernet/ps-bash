## Imported from the Oils spec tests (word-split.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### IFS is scoped
IFS=b
word=abcd
f() { local IFS=c; argv.py $word; }
f
argv.py $word
## stdout:
## status: 127
## timeout: 10

#### Tilde sub is not split, but var sub is
HOME="foo bar"
argv.py ~
argv.py $HOME
## stdout:
## status: 127
## timeout: 10

#### Word splitting
a="1 2"
b="3 4"
argv.py $a"$b"
## stdout:
## status: 127
## timeout: 10

#### Word splitting 2
a="1 2"
b="3 4"
c="5 6"
d="7 8"
argv.py $a"$b"$c"$d"

# Has tests on differences between  $*  "$*"  $@  "$@"
# http://stackoverflow.com/questions/448407/bash-script-to-receive-and-repass-quoted-parameters
## stdout:
## status: 127
## timeout: 10

#### $*
fun() { argv.py -$*-; }
fun "a 1" "b 2" "c 3"
## stdout:
## status: 127
## timeout: 10

#### "$*"
fun() { argv.py "-$*-"; }
fun "a 1" "b 2" "c 3"
## stdout:
## status: 127
## timeout: 10

#### $@
# How does this differ from $* ?  I don't think it does.
fun() { argv.py -$@-; }
fun "a 1" "b 2" "c 3"
## stdout:
## status: 127
## timeout: 10

#### "$@"
fun() { argv.py "-$@-"; }
fun "a 1" "b 2" "c 3"
## stdout:
## status: 127
## timeout: 10

#### empty argv
argv.py 1 "$@" 2 $@ 3 "$*" 4 $* 5
## stdout:
## status: 127
## timeout: 10

#### $* with empty IFS
set -- "1 2" "3  4"

IFS=
argv.py $*
argv.py "$*"
## stdout:
## status: 127
## timeout: 10

#### Word elision with space
s1=' '
argv.py $s1
## stdout:
## status: 127
## timeout: 10

#### Word elision with non-whitespace IFS
# Treated differently than the default IFS.  What is the rule here?
IFS='_'
char='_'
space=' '
empty=''
argv.py $char
argv.py $space
argv.py $empty
## stdout:
## status: 127
## timeout: 10

#### Leading/trailing word elision with non-whitespace IFS
# This behavior is weird.
IFS=_
s1='_a_b_'
argv.py $s1
## stdout:
## status: 127
## timeout: 10

#### Leading ' ' vs leading ' _ '
# This behavior is weird, but all shells agree.
IFS='_ '
s1='_ a  b _ '
s2='  a  b _ '
argv.py $s1
argv.py $s2
## stdout:
## status: 127
## timeout: 10

#### Multiple non-whitespace IFS chars.
IFS=_-
s1='a__b---c_d'
argv.py $s1
## stdout:
## status: 127
## timeout: 10

#### IFS with whitespace and non-whitepace.
# NOTE: Three delimiters means two empty words in the middle.  No elision.
IFS='_ '
s1='a_b _ _ _ c  _d e'
argv.py $s1
## stdout:
## status: 127
## timeout: 10

#### empty $@ and $* is elided
fun() { argv.py 1 $@ $* 2; }
fun
## stdout:
## status: 127
## timeout: 10

#### unquoted empty arg is elided
empty=""
argv.py 1 $empty 2
## stdout:
## status: 127
## timeout: 10

#### unquoted whitespace arg is elided
space=" "
argv.py 1 $space 2
## stdout:
## status: 127
## timeout: 10

#### empty literals are not elided
space=" "
argv.py 1 $space"" 2
## stdout:
## status: 127
## timeout: 10

#### no splitting when IFS is empty
IFS=""
foo="a b"
argv.py $foo
## stdout:
## status: 127
## timeout: 10

#### default value can yield multiple words
argv.py 1 ${undefined:-"2 3" "4 5"} 6
## stdout:
## status: 127
## timeout: 10

#### default value can yield multiple words with part joining
argv.py 1${undefined:-"2 3" "4 5"}6
## stdout:
## status: 127
## timeout: 10

#### default value with unquoted IFS char
IFS=_
argv.py 1${undefined:-"2_3"x_x"4_5"}6
## stdout:
## status: 127
## timeout: 10

#### IFS empty doesn't do splitting
IFS=''
x=$(python2 -c 'print(" a b\tc\n")')
argv.py $x
## stdout:
## status: 127
## timeout: 10

#### IFS unset behaves like $' \t\n'
unset IFS
x=$(python2 -c 'print(" a b\tc\n")')
argv.py $x
## stdout:
## status: 127
## timeout: 10

#### IFS='\'
# NOTE: OSH fails this because of double backslash escaping issue!
IFS='\'
s='a\b'
argv.py $s
## stdout:
## status: 127
## timeout: 10

#### IFS='\ '
# NOTE: OSH fails this because of double backslash escaping issue!
# When IFS is \, then you're no longer using backslash escaping.
IFS='\ '
s='a\b \\ c d\'
argv.py $s
## stdout:
## status: 127
## timeout: 10

#### IFS characters are glob metacharacters
IFS='* '
s='a*b c'
argv.py $s

IFS='?'
s='?x?y?z?'
argv.py $s

IFS='['
s='[x[y[z['
argv.py $s
## stdout:
## status: 127
## timeout: 10

#### Trailing space
argv.py 'Xec  ho '
argv.py X'ec  ho '
argv.py X"ec  ho "
## stdout:
## status: 127
## timeout: 10

#### Empty IFS (regression for bug)
IFS=
echo ["$*"]
set a b c
echo ["$*"]
## STDOUT:
[]
[abc]
## END
## status: 0
## XFAIL ps-bash gap-oils-word-split word-split (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Unset IFS (regression for bug)
set a b c
unset IFS
echo ["$*"]
## stdout: [a b c]
## status: 0
## XFAIL ps-bash gap-oils-word-split word-split (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### IFS=o (regression for bug)
IFS=o
echo hi
## stdout: hi
## status: 0
## timeout: 10

#### IFS and joining arrays
IFS=:
set -- x 'y z'
argv.py "$@"
argv.py $@
argv.py "$*"
argv.py $*
## stdout:
## status: 127
## timeout: 10

#### IFS and joining arrays by assignments
IFS=:
set -- x 'y z'

s="$@"
argv.py "$s"

s=$@
argv.py "$s"

s="$*"
argv.py "$s"

s=$*
argv.py "$s"

# bash and mksh agree, but this doesn't really make sense to me.
# In OSH, "$@" is the only real array, so that's why it behaves differently.



# TODO:
# - unquoted args of whitespace are not elided (when IFS = null)
# - empty quoted args are kept
#
# - $* $@ with empty IFS
# - $* $@ with custom IFS
#
# - no splitting when IFS is empty
# - word splitting removes leading and trailing whitespace

# TODO: test framework needs common setup

# Test IFS and $@ $* on all these
## stdout:
## status: 127
## timeout: 10

#### TODO
empty=""
space=" "
AB="A B"
X="X"
Yspaces=" Y "
## stdout:
## status: 0
## timeout: 10

#### IFS='' with $@ and $* (bug #627)
set -- a 'b c'
IFS=''
argv.py at $@
argv.py star $*

# zsh agrees
## stdout:
## status: 127
## timeout: 10
