## Imported from the Oils spec tests (word-eval.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Evaluation of constant parts
argv.py bare 'sq'
## stdout:
## status: 127
## timeout: 10

#### Evaluation of each part
#set -o noglob
HOME=/home/bob
str=s
array=(a1 a2)
argv.py bare 'sq' ~ $str "-${str}-" "${array[@]}" $((1+2)) $(echo c) `echo c`
## stdout:
## status: 127
## timeout: 10

#### Word splitting
s1='1 2'
s2='3 4'
s3='5 6'
argv.py $s1$s2 "$s3"
## stdout:
## status: 127
## timeout: 10

#### Word joining
set -- x y z
s1='1 2'
array=(a1 a2)
argv.py $s1"${array[@]}"_"$@"
## stdout:
## status: 127
## timeout: 10

#### Word elision
s1=''
argv.py $s1 - "$s1"
## stdout:
## status: 127
## timeout: 10

#### Default values -- more cases
argv.py ${undef:-hi} ${undef:-'a b'} "${undef:-c d}" "${un:-"e f"}" "${un:-'g h'}"
## stdout:
## status: 127
## timeout: 10

#### Globbing after splitting
mkdir -p _tmp
touch _tmp/foo.gg _tmp/bar.gg _tmp/foo.hh
pat='_tmp/*.hh _tmp/*.gg'
argv.py $pat
## stdout:
## status: 127
## timeout: 10

#### Globbing escaping
mkdir -p _tmp
touch '_tmp/[bc]ar.mm' # file that looks like a glob pattern
touch _tmp/bar.mm _tmp/car.mm
argv.py '_tmp/[bc]'*.mm - _tmp/?ar.mm
## stdout:
## status: 127
## timeout: 10
