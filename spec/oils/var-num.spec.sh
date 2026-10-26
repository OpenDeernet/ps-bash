## Imported from the Oils spec tests (var-num.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### In function
myfunc() {
  echo $1 ${2}
}
myfunc a b c d
## stdout: a b
## status: 0
## timeout: 10

#### Normal and braced
$SH -c 'echo $0 $1 ${2}' a b c d
## stdout: a b c
## status: 0
## timeout: 10
## real-launcher

#### $0 with -c
$SH -c 'echo $0' | grep -o 'sh$'
## stdout: sh
## status: 0
## timeout: 10
## real-launcher

#### $0 with stdin
echo 'echo $0' | $SH | grep -o 'sh$'
## stdout: sh
## status: 0
## timeout: 10
## real-launcher

#### $0 with -i
echo 'echo $0' | $SH -i | grep -o 'sh$'
## stdout: sh
## status: 0
## timeout: 10
## real-launcher

#### $0 with filename
s=dollar0
echo 'echo $0' > $s
chmod +x $s
$SH $s
## stdout: dollar0
## status: 0
## timeout: 10
## real-launcher

#### $@ with filename
s=dollar0
echo 'echo $@' > $s
chmod +x $s
$SH $s a b c
## stdout: a b c
## status: 0
## timeout: 10
## real-launcher
