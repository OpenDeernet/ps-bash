## Imported from the Oils spec tests (builtin-read.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### read line from here doc

# NOTE: there are TABS below
read x <<EOF
A		B C D E
FG
EOF
echo "[$x]"
## stdout: [A		B C D E]
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read /dev/null
read -n 1 </dev/null
echo $?
## stdout: 1
## status: 0
## timeout: 10

#### read with zero args
echo | read
echo status=$?
## stdout: status=0
## status: 0
## timeout: 10

#### read builtin with no newline returns status 1

# This is odd because the variable is populated successfully.  OSH/YSH might
# need a separate put reading feature that doesn't use IFS.

echo -n ZZZ | { read x; echo status=$?; echo $x; }
## STDOUT:
status=1
ZZZ
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read builtin splits value across multiple vars
# NOTE: there are TABS below
read x y z <<EOF
A		B C D E 
FG
EOF
echo "[$x/$y/$z]"
## stdout: [A/B/C D E]
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read builtin with too few variables
set -o errexit
set -o nounset  # hm this doesn't change it
read x y z <<EOF
A B
EOF
echo /$x/$y/$z/
## stdout: /A/B//
## status: 0
## timeout: 10

#### read -n with invalid arg
read -n not_a_number
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### read without args uses $REPLY, no splitting occurs (without -n)

# mksh and zsh implement splitting with $REPLY, bash/ash don't

echo '  a b  ' | (read; echo "[$REPLY]")
echo '  a b  ' | (read myvar; echo "[$myvar]")

echo '  a b  \
  line2' | (read; echo "[$REPLY]")
echo '  a b  \
  line2' | (read myvar; echo "[$myvar]")

# Now test with -r
echo '  a b  \
  line2' | (read -r; echo "[$REPLY]")
echo '  a b  \
  line2' | (read -r myvar; echo "[$myvar]")
## STDOUT:
[  a b  ]
[a b]
[  a b    line2]
[a b    line2]
[  a b  \]
[a b  \]
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read multiple vars spanning many lines
read x y << 'EOF'
one-\
two three-\
four five-\
six
EOF
argv.py "$x" "$y" "$z"
## stdout:
## status: 127
## timeout: 10

#### read with IFS=$'\n'
# The leading spaces are stripped if they appear in IFS.
IFS=$(echo -e '\n')
read var <<EOF
  a b c
  d e f
EOF
echo "[$var]"
## stdout: [  a b c]
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read with IFS=''
IFS=''
read x y <<EOF
  a b c d
EOF
echo "[$x|$y]"
## stdout: [  a b c d|]
## status: 0
## timeout: 10

#### dynamic scope used to set vars
f() {
  read head << EOF
ref: refs/heads/dev/andy
EOF
}
f
echo $head
## stdout: ref: refs/heads/dev/andy
## status: 0
## timeout: 10

#### read -d : (colon-separated records)
printf a,b,c:d,e,f:g,h,i | {
  IFS=,
  read -d : v1
  echo "v1=$v1"
  read -d : v1 v2
  echo "v1=$v1 v2=$v2"
  read -d : v1 v2 v3
  echo "v1=$v1 v2=$v2 v3=$v3"
}
## STDOUT:
v1=a,b,c
v1=d v2=e,f
v1=g v2=h v3=i
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read -d '' (null-separated records)
printf 'a,b,c\0d,e,f\0g,h,i' | {
  IFS=,
  read -d '' v1
  echo "v1=$v1"
  read -d '' v1 v2
  echo "v1=$v1 v2=$v2"
  read -d '' v1 v2 v3
  echo "v1=$v1 v2=$v2 v3=$v3"
}
## STDOUT:
v1=a,b,c
v1=d v2=e,f
v1=g v2=h v3=i
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read -rd
read -rd '' var <<EOF
foo
bar
EOF
echo "$var"
## STDOUT:
foo
bar
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read -d when there's no delimiter
{ read -d : part
  echo $part $?
  read -d : part
  echo $part $?
} <<EOF
foo:bar
EOF
## STDOUT:
foo 0
bar 1
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read -t -0.5 is invalid
# bash appears to just take the absolute value?

read -t -0.5 < /dev/null
echo $?
## stdout: 1
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### read -u syntax error
read -u -3
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### read usage
read -n -1
echo status=$?
# zsh gives a fatal error?  seems inconsistent
## stdout: status=1
## status: 0
## timeout: 10

#### read with smooshed args
echo hi | { read -rn1 var; echo var=$var; }
## stdout: var=h
## status: 0
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### "backslash + newline" should be swallowed regardless of "-d <delim>"

printf '%s\n' 'a b\' 'c d' | (read; argv.py "$REPLY")
printf '%s\n' 'a b\,c d'   | (read; argv.py "$REPLY")
printf '%s\n' 'a b\' 'c d' | (read -d ,; argv.py "$REPLY")
printf '%s\n' 'a b\,c d'   | (read -d ,; argv.py "$REPLY")

# mksh/zsh swallows "backslash + delim" instead.
['a bc d']
['a b,c d']
['a b\nc d']
['a bc d']
## stdout:
## status: 127
## XFAIL ps-bash gap-oils-builtin-read builtin-read (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### IFS='x ' read a b: trailing spaces (with max_split)
echo 'hello world  test   ' | (read a b; argv.py "$a" "$b")
echo '-- IFS=x --'
IFS='x '
echo 'a ax  x  '     | (read a b; argv.py "$a" "$b")
echo 'a ax  x  x'    | (read a b; argv.py "$a" "$b")
echo 'a ax  x  x  '  | (read a b; argv.py "$a" "$b")
echo 'a ax  x  x  a' | (read a b; argv.py "$a" "$b")
## stdout: -- IFS=x --
## status: 127
## timeout: 10

#### IFS='x ' incomplete backslash
echo ' a b \' | (read a; argv.py "$a")
echo ' a b \' | (read a b; argv.py "$a" "$b")
IFS='x '
echo $'a ax  x    \\\nhello' | (read a b; argv.py "$a" "$b")
## stdout:
## status: 127
## timeout: 10

#### IFS='\ ' and backslash escaping
IFS='\ '
echo "hello\ world  test" | (read a b; argv.py "$a" "$b")
IFS='\'
echo "hello\ world  test" | (read a b; argv.py "$a" "$b")
# In mksh/zsh, IFS='\' is stronger than backslash escaping
## stdout:
## status: 127
## timeout: 10

#### max_split and backslash escaping
echo 'Aa b \ a\ b' | (read a b; argv.py "$a" "$b")
echo 'Aa b \ a\ b' | (read a b c; argv.py "$a" "$b" "$c")
echo 'Aa b \ a\ b' | (read a b c d; argv.py "$a" "$b" "$c" "$d")
## stdout:
## status: 127
## timeout: 10

#### IFS=x read a b <<< xxxxxx
IFS='x '
echo x     | (read a b; argv.py "$a" "$b")
echo xx    | (read a b; argv.py "$a" "$b")
echo xxx   | (read a b; argv.py "$a" "$b")
echo xxxx  | (read a b; argv.py "$a" "$b")
echo xxxxx | (read a b; argv.py "$a" "$b")
echo '-- spaces --'
echo 'x    ' | (read a b; argv.py "$a" "$b")
echo 'xx   ' | (read a b; argv.py "$a" "$b")
echo 'xxx  ' | (read a b; argv.py "$a" "$b")
echo 'xxxx ' | (read a b; argv.py "$a" "$b")
echo 'xxxxx' | (read a b; argv.py "$a" "$b")
echo '-- with char --'
echo 'xa    ' | (read a b; argv.py "$a" "$b")
echo 'xax   ' | (read a b; argv.py "$a" "$b")
echo 'xaxx  ' | (read a b; argv.py "$a" "$b")
echo 'xaxxx ' | (read a b; argv.py "$a" "$b")
echo 'xaxxxx' | (read a b; argv.py "$a" "$b")
['', '']
['', 'x']
['', 'xx']
['', 'xxx']
['', 'xxxx']
-- spaces --
['', '']
['', 'x']
['', 'xx']
['', 'xxx']
['', 'xxxx']
-- with char --
['', 'a']
['', 'ax']
['', 'axx']
['', 'axxx']
['', 'axxxx']
## STDOUT:
-- spaces --
-- with char --
## END
## status: 127
## timeout: 10

#### read and "\ "

IFS='x '
check() { echo "$1" | (read a b; argv.py "$a" "$b"); }

echo '-- xs... --'
check 'x '
check 'x \ '
check 'x \ \ '
check 'x \ \ \ '
echo '-- xe... --'
check 'x\ '
check 'x\ \ '
check 'x\ \ \ '
check 'x\  '
check 'x\  '
check 'x\    '

# check 'xx\ '
# check 'xx\ '

-- xs... --
['', '']
['', '']
['', '']
['', '']
-- xe... --
['', '']
['', '']
['', '']
['', '']
['', '']
['', '']
## STDOUT:
-- xs... --
-- xe... --
## END
## status: 127
## timeout: 10

#### read bash bug
IFS='x '
echo 'x\  \ ' | (read a b; argv.py "$a" "$b")
['', '  ']
['', '']
['', ' ']
## stdout:
## status: 127
## timeout: 10
