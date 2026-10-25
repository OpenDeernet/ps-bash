## Imported from the Oils spec tests (ysh-bugs.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Catch AttributeError

var s = 'foo'
echo s=$s
var t = s.bad()
echo 'should not get here'
## stdout: s=
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### More Command sub paren parsing

write $( var mylist = ['for']; for x in (mylist) { echo $x } )

write $( echo while; while (false) { write hi } )

write $( if (true) { write 'if' } )

write $( if (false) { write 'if' } elif (true) { write 'elif' } )
## stdout:
## status: 2
## timeout: 10

#### Do && || with YSH constructs make sense/

# I guess there's nothing wrong with this?
#
# But I generally feel && || are only for
#
# test --file x && test --file y

var x = []
true && call x->append(42)
false && call x->append(43)
pp test_ (x)

func amp() {
  true && return (42)
}

func pipe() {
  false || return (42)
}

pp test_ (amp())
pp test_ (pipe())
## stdout:
## status: 2
## timeout: 10

#### shvar then replace - bug #1986 context manager crash

shvar FOO=bar {
  for x in (1 ..< 500) {
    var Q = "hello"
    setvar Q = Q=>replace("hello","world")
  }
}
#echo $Q
echo hi
## stdout:
## status: 2
## timeout: 10

#### proc with IFS= read -r line - dynamic scope - issue #2012

# 2024-10 - FIXED by the new Env Obj!  Because in YSH, 'line' is NOT created in
# TEMP stack frame - we use the ENCLOSED frame, and it fixes it.

proc p {
	read -r line
  write $line
}

proc p-ifs {
	IFS= read -r line
  write $line
}

#set -x

echo zz | p

echo yy | p-ifs
## stdout:
## status: 2
## timeout: 10

#### Crash in parsing case on EOF condition - issue #2037

var WEIGHT = ${1:-}
case (WEIGHT) {
  "-" { echo "got nothing" }
  (else) { echo $WEIGHT
}
## stdout:
## status: 2
## timeout: 10

#### Crash due to incorrect of context manager rooting - issue #1986

proc p {
  var s = "hi"
  for q in (1..<50) {
    shvar Q="whatever" {
      setvar s = "." ++ s
    }
  }
}

for i in (1..<10) {
  p
}

if false {
  echo 'testing for longer'
  for i in (1 ..< 1000) {
    p
  }
}
## stdout:
## status: 2
## timeout: 10

#### bad assertion when pretty printing

pp value (__builtins__) > /dev/null
echo status=$?
## stdout:
## status: 2
## timeout: 10

#### Another "stealing stdin" issue with spec tests

proc where2(; pred) {
  for line in (io.stdin) {
    pp test_ (line)
  }
}

seq 5 | where2 [_line ~== 2 or _line ~== 4]

#{ echo 1; echo 2; } | where2 [_line ~== 2 or _line ~== 4]

# empty lines here get put on stdin
## stdout:
## status: 2
## timeout: 10

#### Iterating over io.stdin multiple times (#2356)

echo u'a\nb' | for i, line in (io.stdin) { echo $i: $line; break }
echo u'c\nd' | for i, line in (io.stdin) { echo $i: $line }
## stdout:
## status: 2
## timeout: 10

#### Long boolean flags can't have attached values

# This currently works, but I think --json and --j8 are enough?

write --json=0 hi
write --json=F hi
write --json=False hi
write --json=false hi
echo

write --json=1 hi
write --json=T hi
write --json=True hi
write --json=true hi

# typo bug
write --json=Talse hi
## STDOUT:

## END
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
