## Imported from the Oils spec tests (smoke.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### builtin
echo hi
## stdout: hi
## status: 0
## timeout: 10

#### command sub
echo $(expr 3)
## stdout: 3
## status: 0
## timeout: 10

#### command sub with builtin
echo $(echo hi)
## stdout: hi
## status: 0
## timeout: 10

#### pipeline
hostname | wc -l
## stdout: 1
## status: 0
## timeout: 10

#### pipeline with builtin
echo hi | wc -l
## stdout: 1
## status: 0
## timeout: 10

#### and-or chains
echo 1 && echo 2 || echo 3 && echo 4
echo --
false || echo A
false || false || echo B
false || false || echo C && echo D || echo E
## STDOUT:
1
2
4
--
A
B
C
D
## END
## status: 0
## timeout: 10

#### here doc with var
v=one
tac <<EOF
$v
"two
EOF
## STDOUT:
"two
one
## END
## status: 0
## timeout: 10

#### here doc without var
tac <<"EOF"
$v
"two
EOF
## STDOUT:
"two
$v
## END
## status: 0
## timeout: 10

#### here doc with builtin
read var <<EOF
value
EOF
echo "var = $var"
## stdout: var = value
## status: 0
## timeout: 10

#### Redirect with builtin
echo hi > hi.txt
cat hi.txt
## stdout: hi
## status: 0
## timeout: 10

#### Here doc with redirect
cat <<EOF >smoke1.txt
one
two
EOF
wc -c smoke1.txt
## stdout: 8 smoke1.txt
## status: 0
## timeout: 10

#### "$@" "$*"
fun () {
  argv.py "$@" "$*"
}
fun "a b" "c d"
## stdout:
## status: 127
## timeout: 10

#### $@ $*
fun() {
  argv.py $@ $*
}
fun "a b" "c d"
## stdout:
## status: 127
## timeout: 10

#### failed command
ls /nonexistent-zzZZ
## stdout:
## status: 2
## timeout: 10

#### subshell
(echo 1; echo 2)
## STDOUT:
1
2
## END
## status: 0
## timeout: 10

#### for loop
for i in a b c
do
  echo $i
done
## STDOUT:
a
b
c
## END
## status: 0
## timeout: 10

#### vars
a=5
echo $a ${a} "$a ${a}"
## stdout: 5 5 5 5
## status: 0
## timeout: 10
