## Imported from the Oils spec tests (ysh-string.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### single quoted -- implicit and explicit raw
var x = 'foo bar'
echo $x
setvar x = r'foo bar'  # Same string
echo $x
setvar x = r'\t\n'  # This is raw
echo $x
## STDOUT:



## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Implicit raw string '\t\n' is a syntax error because backslash is ambiguous
var x = ' \t\n '
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Multiline ''' \t ''' is a also syntax error because backslash is ambiguous
var y = ''' \t '''
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $"foo $x" to make "foo $x" explicit

var x = $"bar"

# expression mode
var y = $"foo $x"
echo "$y"

# command mode
if test "$y" = $"foo $x"; then
  echo equal
fi
## STDOUT:

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### J8-style u'' and b'' strings in expression mode

var x = u'\u{3bc}'
var y = b'\yff'


write --end '' -- $x | od -A n -t x1
write --end '' -- $y | od -A n -t x1
## stdout:
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### J8-style u'' and b'' strings in command mode

write --end '' -- u'\u{3bc}' | od -A n -t x1
write --end '' -- b'\yff' | od -A n -t x1

# TODO: make this be illegal
# echo u'hello \u03bc'
## stdout:
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### J8-style multi-line strings u''' b''' in command mode

write --end '' -- u'''
  --
  \u{61}
  --
  '''
write --end '' -- b'''
--
\y62
--
'''

# Should be illegal?
#echo u'hello \u03bc'
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Double Quoted
var name = 'World'
var g = "Hello $name"

echo "Hello $name"
echo $g
## STDOUT:
Hello 

## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Multiline strings with '' and ""

var single = '
  single
'

var x = 42
var double = "
  double $x
"

echo $single
echo $double
## STDOUT:


## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Special rule for <<< ''' and <<< """ - no extra newline

read --all <<< unquoted
pp test_ (_reply)

read --all <<< 'single with newline'
pp test_ (_reply)

read --all <<< "double with newline"
pp test_ (_reply)

read --all <<< u'j8 with newline'
pp test_ (_reply)

echo

read --all <<< '''
multi
single
'''
pp test_ (_reply)

read --all <<< """
multi
double
"""
pp test_ (_reply)

read --all <<< u'''
multi
j8
'''
pp test_ (_reply)
## stdout:
## status: 2
## timeout: 10

#### """ and $""" in Expression Mode

var line1 = """line1"""
echo line1=$line1
var line2 = """
line2"""
echo line2=$line2

var two = 2
var three = 3
var x = """
  one "
  two = $two ""
   three = $three
  """
echo "[$x]"

var i = 42
var x = """
  good
 bad $i
  """
echo "[$x]"

# alias
var x = $"""
  good
 bad $i
  """
echo "[$x]"
## STDOUT:
line1=
line2=
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ''' in Expression Mode

var two = 2
var three = 2

var x = r''' 
  two = $two '
  three = $three ''
   \u{61}
  '''
echo "[$x]"

var x = u''' 
  two = $two '
  three = $three ''
   \u{61}
  '''
echo "[$x]"

var x = b''' 
  two = $two '
  three = $three ''
   \u{61} \y61
  '''
echo "[$x]"
## stdout: []
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### """ and $""" in Command Mode

var two=2
var three=3

echo --
echo """
  one "
  two = $two ""
  three = $three
  """

# optional $ prefix
echo --
echo $"""
  one "
  two = $two ""
  three = $three
  """

echo --
tac <<< """
  one "
  two = $two ""
  three = $three
  """
## STDOUT:
--

  one 
--
  one 

## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ''' in Command Mode

echo --
echo '''
  two = $two
  '
  '' '
  \u{61}
  '''
## STDOUT:
--

  two = $two
  
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ''' in Here Doc

tac <<< '''
  two = $two
  '
  '' '
  \u{61}
  '''
## STDOUT:
  
  two = $two

## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### here doc with quotes

# This has 3 right double quotes

cat <<EOF
"hello"
""
"""
EOF
## STDOUT:
"hello"
""
"""
## END
## status: 0
## timeout: 10

#### triple quoted and implicit concatenation

# Should we allow this?  Or I think it's possible to make it a syntax error

echo '''
single
'''zz

echo """
double
"""zz
## STDOUT:

single
zz

double
zz
## END
## status: 0
## timeout: 10

#### str.find()

var mystr = 'abcaz'

assert [1 === mystr.find('b')]
assert [4 === mystr.find('z')]
# test with chars taking up two bytes
assert [2 === 'абаба'.find('б')]
assert [6 === 'абаба'.find('б', start=3)]
assert [-1 === 'абаба'.find('б', start=3, end=5)]
assert [6 === 'абаба'.find('б', start=3, end=8)]
assert [0 === 'абаба'.find('')]
assert [2 === 'абаба'.find('', start=2, end=7)]
assert [-1 === 'абаба'.find('a')] # different alphabet
assert [-1 === 'abc'.find('', start=7, end=8)]
# test negative indices
assert [3 === mystr.find('a', start=-3, end=-1)]
## stdout:
## status: 2
## timeout: 10

#### str.findLast()
var mystr = 'abcaz'
assert [-1 === 'абаба'.findLast('a')] # different alphabet
assert [4 === 'ababa'.findLast('a')]
assert [3 === 'ababa'.findLast('b')]
assert [6 === 'абаба'.findLast('б')]
assert [-1 === 'абаба'.findLast('б', start=3, end=6)]
assert [2 === 'абаба'.findLast('б', start=2, end=6)]
assert [6 ==='абаба'.findLast('б', start=2, end=8)]
assert [10 === 'абаба'.findLast('')]
assert [8 === 'абаба'.findLast('', start=2, end=8)]
assert [-1 === 'abc'.findLast('', start=7, end=8)]
# test negative indices
assert [3 === mystr.findLast('a', start=-3, end=-1)]
## stdout:
## status: 2
## timeout: 10

#### str.contains()

var mystr = 'abcaz'

assert [true === mystr.contains('b')]
assert [true === mystr.contains('z')]
assert [false === mystr.contains('y')]
# test with chars taking up two bytes
assert [true === 'абаба'.contains('б')]
assert [true === 'абаба'.contains('аб')]
assert [true === 'абаба'.contains('')]
assert [false === 'абаба'.contains('a')]
assert [false === 'абаба'.contains('бабаба')]
## stdout:
## status: 2
## timeout: 10

#### strcmp()

assert [-1 === strcmp('a', 'z')]
assert [-1 === strcmp('a', 'b')]
assert [-1 === strcmp('a', 'aa')]
assert [0 === strcmp('a', 'a')]
assert [1 === strcmp('aa', 'a')]
assert [1 === strcmp('b', 'a')]
assert [1 === strcmp('z', 'a')]
## stdout:
## status: 2
## timeout: 10
