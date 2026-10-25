## Imported from the Oils spec tests (ysh-convert.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### bool() more
var a = bool( :|| )
var b = bool( :|foo| )
write $a $b
## stdout:
## status: 2
## timeout: 10

#### float() overflow / underflow

var a = float("1.2")
var b = float("3.4")

var c = float("42.1e500")
var d = float("-42.1e500")

write $a $b $c $d
## stdout:
## status: 2
## timeout: 10

#### dict() converts from BashAssoc to Dict
declare -A foo
foo=([a]=1 [b]=2 [c]=3)

json write (type(foo))
json write (dict(foo))
## stdout:
## status: 2
## timeout: 10
