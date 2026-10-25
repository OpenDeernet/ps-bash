## Imported from the Oils spec tests (append.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Append string to string
s='abc'
s+=d
echo $s
## stdout: abcd
## status: 0
## timeout: 10

#### Append array to array
a=(x y )
a+=(t 'u v')
argv.py "${a[@]}"
## stdout:
## status: 127
## timeout: 10

#### Append string to undefined variable

s+=foo
echo s=$s

# bash and mksh agree that this does NOT respect set -u.
# I think that's a mistake, but += is a legacy construct, so let's copy it.

set -u

t+=foo
echo t=$t
t+=foo
echo t=$t
## STDOUT:
s=foo
t=foo
t=foofoo
## END
## status: 0
## timeout: 10

#### Append to array to undefined variable

y+=(c d)
argv.py "${y[@]}"
## stdout:
## status: 127
## timeout: 10

#### error: s+=(my array)
s='abc'
s+=(d e f)
argv.py "${s[@]}"
## stdout:
## status: 127
## timeout: 10

#### error: myarray+=s

# They treat this as implicit index 0.  We disallow this on the LHS, so we will
# also disallow it on the RHS.
a=(x y )
a+=z
argv.py "${a[@]}"
## stdout:
## status: 127
## timeout: 10

#### typeset s+=(my array)
typeset s='abc'
echo $s

typeset s+=(d e f)
echo status=$?
argv.py "${s[@]}"
## STDOUT:
abc
status=0
## END
## status: 127
## timeout: 10

#### error: typeset myarray+=s
typeset a=(x y)
argv.py "${a[@]}"
typeset a+=s
argv.py "${a[@]}"
## stdout:
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### error: append used like env prefix
# This should be an error in other shells but it's not.
A=a
A+=a printenv.py A
## stdout:
## status: 127
## timeout: 10

#### myarray[1]+=s - Append to element
# They treat this as implicit index 0.  We disallow this on the LHS, so we will
# also disallow it on the RHS.
a=(x y )
a[1]+=z
argv.py "${a[@]}"
## stdout:
## status: 127
## timeout: 10

#### myarray[-1]+=s - Append to last element
# Works in bash, but not mksh.  It seems like bash is doing the right thing.
# a[-1] is allowed on the LHS.  mksh doesn't have negative indexing?
a=(1 '2 3')
a[-1]+=' 4'
argv.py "${a[@]}"
## stdout:
## status: 127
## timeout: 10
