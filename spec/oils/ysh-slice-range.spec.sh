## Imported from the Oils spec tests (ysh-slice-range.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### precedence of 1:3 vs comparison

# This test exposed nondeterminism in CPython itself!  Gah.  Is this because of
# the hashing?
# Python xrange objects probably shouldn't even be comparable!
#
# = 1..3 < 1..4
# >>> xrange(1,3)  < xrange(1,4)
# False
# >>> xrange(1,3)  < xrange(1,4)
# True

= 1..<3
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### precedence of 1:3 vs bitwise operator
= 3..<3|4
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### subscript and slice :| 1 2 3 4 |
var myarray = :|1 2 3 4|
pp test_ (myarray[1])
pp test_ (myarray[1:3])

echo 'implicit'
pp test_ (myarray[:2])
pp test_ (myarray[2:])

echo 'out of bounds'
pp test_ (myarray[:5])
pp test_ (myarray[-5:])

# Stride not supported
#= myarray[1:4:2]

# Now try omitting some
#= myarray[1:4:2]
## stdout:
## status: 2
## timeout: 10

#### Range end points can be int-looking Strings

pp test_ (list('3' ..< '6'))

var i = '5'

pp test_ (list(i ..< 7))
pp test_ (list(3 ..< i))

var i = '-5'

pp test_ (list(i ..< -3))
pp test_ (list(-7 ..< i))

# Not allowed
pp test_ ('a' ..< 'z')
## stdout:
## status: 2
## timeout: 10

#### Slice indices can be int-looking strings

var a = list(0..<10)
#pp test_ (a)

pp test_ (a['3': '6'])

var i = '5'

pp test_ (a[i : 7])
pp test_ (a[3 : i])

var i = '-5'

pp test_ (a[i : -3])
pp test_ (a[-7 : i])

# Not allowed
pp test_ (a['a' : 'z'])
## stdout:
## status: 2
## timeout: 10

#### subscript and slice of List
var mylist = [1,2,3,4]
pp test_ (mylist[1])
pp test_ (mylist[1:3])

echo 'implicit'
pp test_ (mylist[:2])
pp test_ (mylist[2:])
## stdout:
## status: 2
## timeout: 10

#### expressions and negative indices
var myarray = :|1 2 3 4 5|
pp test_ (myarray[-1])
pp test_ (myarray[-4:-2])

echo 'implicit'
pp test_ (myarray[:-2])
pp test_ (myarray[-2:])
## stdout:
## status: 2
## timeout: 10

#### Copy with a[:]
var a = [1,2,3]
var b = a[:]
pp test_ (b)
## stdout:
## status: 2
## timeout: 10

#### Slices with Multiple Dimensions (for TSV8?)

qtt pretty :mytable <<< '''
name  age:Int
alice 42
bob   31
carol 20
'''

# Cut off the first two rows
var t1 = mytable[2:, :]
= t1

var t2 = mytable[:2, 3:4]
= t2

var t3 = mytable[:2, %(name age)]
= t3
## stdout:
## status: 2
## timeout: 10

#### Closed ranges

for x in (1..=2) {
  echo $x
}

= 1..=2
## stdout:
## status: 2
## timeout: 10
