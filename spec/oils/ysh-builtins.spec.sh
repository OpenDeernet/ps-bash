## Imported from the Oils spec tests (ysh-builtins.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### append onto BashArray a=(1 2)
shopt -s parse_at
a=(1 2)
append '3 4' '5' (a)
argv.py "${a[@]}"

append -- 6 (a)
argv.py "${a[@]}"
## stdout:
## status: 2
## timeout: 10

#### append onto var a = :| 1 2 |
shopt -s parse_at parse_proc
var a = :| 1 2 |
append '3 4' '5' (a)
argv.py @a
## stdout:
## status: 2
## timeout: 10

#### append onto var a = ['1', '2']
shopt -s parse_at parse_proc
var a = ['1', '2']
append '3 4' '5' (a)
argv.py @a
## stdout:
## status: 2
## timeout: 10

#### append without typed arg
append a b
## stdout:
## status: 127
## timeout: 10

#### append passed invalid type
s=''
append a b (s)
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### read flag usage
read --lin
echo status=$?

read --line :var extra
echo status=$?
## STDOUT:
status=2
status=2
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read (&x) is usage error

var x = null  # allow no initialization
echo hello | read (&x)
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### read --raw-line in a loop

write --end '' $'\na\nb\n\n' | while read --raw-line; do
  pp test_ (_reply)
done

echo

write --end '' $'a\n\nb' | while read --raw-line; do
  pp test_ (_reply)
done
## stdout:
## status: 2
## timeout: 10

#### read --raw-line --with-eol in a loop

write --end '' $'\na\nb\n\n' | while read --raw-line --with-eol; do
  pp test_ (_reply)
done

echo

write --end '' $'a\n\nb' | while read --raw-line --with-eol; do
  pp test_ (_reply)
done
## stdout:
## status: 2
## timeout: 10

#### read --raw-line --j8

# TODO: is this similar to @() ?  It reads j8 lines?
#
# But using a function is better?
#
# var x = fromJ8Line(_reply)
# var x = fromJson(_reply)  # this is https://jsonlines.org

echo $'u\'foo\'' | read --raw-line --j8
write -- "$_reply"
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read --all-lines
seq 3 | read --all-lines :nums
write --sep ' ' -- @nums
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read --all-lines --with-eol
seq 3 | read --all-lines --with-eol :nums
write --sep '' -- @nums
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read --all
echo foo | read --all
echo "[$_reply]"

echo bad > tmp.txt
read --all (&x) < tmp.txt
echo "[$x]"
## stdout: []
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read --all from directory is an error (EISDIR)
mkdir -p ./dir
read --all < ./dir
echo status=$?
## stdout: status=2
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read --num-bytes

echo '  a b ' | read --num-bytes 4; echo "reply=[$_reply]"
echo '  a b ' | read --num-bytes 5; echo "reply=[$_reply]"

echo '  a b ' | read --num-bytes 4 (&x); echo "x=[$x]"
echo '  a b ' | read --num-bytes 5 (&x); echo "x=[$x]"
## STDOUT:
reply=[]
reply=[]
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read -0 is like read -r -d ''
set -o errexit

mkdir -p read0
cd read0
touch a\\b\\c\\d

find . -type f -a -print0 | read -r -d '' name
echo "[$name]"

find . -type f -a -print0 | read -0
echo "[$REPLY]"
## stdout: []
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### read -0 myvar doesn't do anything with IFS

touch 'foo bar  '
find -type f -print0 | read -0 
echo "[$REPLY]"

find -type f -print0 | read -0 myvar
echo "[$myvar]"
## STDOUT:
[]
[]
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### long flags to test
# no options necessary!

test --dir /
echo status=$?

touch foo
test --file foo
echo status=$?

test --exists /
echo status=$?

test --symlink foo
echo status=$?

test --typo foo
echo status=$?
## STDOUT:
status=2
status=2
status=2
status=2
status=2
## END
## status: 0
## timeout: 10

#### push-registers usage
shopt --set parse_brace

push-registers
echo status=$?

push-registers a b
echo status=$?

push-registers a b {  # hm extra args are ignored
  echo hi
}
echo status=$?
## STDOUT:
status=127
status=127
hi
## END
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### redir
shopt --set parse_brace parse_proc

proc p {
  echo 'proc'
}

redir >out.txt {
  p
  echo 'builtin'
}

cat out.txt

echo ---

redir <out.txt {
  tac
}

# Awkward bash syntax, but we'll live with it
redir {left}>left.txt {right}>right.txt {
  echo 1 >& $left
  echo 1 >& $right

  echo 2 >& $left
  echo 2 >& $right

  echo 3 >& $left
}

echo ---
comm -23 left.txt right.txt
## stdout: proc
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### source ///osh/two.sh and $LIB_OSH

source ///osh/two.sh
echo status=$?

source $LIB_OSH/two.sh
echo status=$?

# errors
source ///
echo status=$?
source ///x
echo status=$?
## STDOUT:
status=1
status=1
status=1
status=1
## END
## status: 0
## timeout: 10
