## Imported from the Oils spec tests (var-op-patsub.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Pattern replacement
v=abcde
echo ${v/c*/XX}
## stdout: abXX
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Pattern replacement on unset variable
echo -${v/x/y}-
echo status=$?
set -o nounset  # make sure this fails
echo -${v/x/y}-
## STDOUT:
--
status=0
## END
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Replace is longest match
# If it were shortest, then you would just replace the first <html>
s='begin <html></html> end'
echo ${s/<*>/[]}
## stdout: begin [] end
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### When LC_ALL=C, pattern ? doesn't match multibyte character
export LC_ALL='C'

s='_μ_ and _μ_'

# ? should match one char

echo ${s//_?_/foo}  # all
echo ${s/#_?_/foo}  # left
echo ${s/%_?_/foo}  # right
echo

a='_x_ and _y_'

echo ${a//_?_/foo}  # all
echo ${a/#_?_/foo}  # left
echo ${a/%_?_/foo}  # right
## STDOUT:
_μ_ and _μ_
_μ_ and _μ_
_μ_ and _μ_

foo and foo
foo and _y_
_x_ and foo
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### ${x/^} regression
x=abc
echo ${x/^}
echo ${x/!}

y=^^^
echo ${y/^}
echo ${y/!}

z=!!!
echo ${z/^}
echo ${z/!}

s=a^b!c
echo ${s/a^}
echo ${s/b!}
## STDOUT:
abc
abc
^^
^^^
!!!
!!
b!c
a^c
## END
## status: 0
## timeout: 10

#### \(\) in pattern (regression)

# Not extended globs
x='foo()' 
echo 1 ${x//*\(\)/z}
echo 2 ${x//*\(\)/z}
echo 3 ${x//\(\)/z}
echo 4 ${x//*\(\)/z}
## STDOUT:
1 z
2 z
3 fooz
4 z
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### patsub with single quotes and hyphen in character class (regression)

# from Crestwave's bf.bash

program='^++--hello.,world<>[]'
program=${program//[^'><+-.,[]']} 
echo $program
## stdout: ++--.,<>[]
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### patsub with [^]]

# This is a PARSING divergence.  In OSH we match [], rather than using POSIX
# rules!

pat='[^]]'
s='ab^cd^'
echo ${s//$pat/z}
## stdout: ab^cd^
## status: 0
## timeout: 10

#### [a-z] Invalid range end is syntax error
x=fooz
pat='[z-a]'  # Invalid range.  Other shells don't catch it!
#pat='[a-y]'
echo ${x//$pat}
echo status=$?
## STDOUT:
fooz
status=0
## END
## status: 0
## timeout: 10

#### Pattern is empty $foo$bar -- regression for infinite loop

x=-foo-

echo ${x//$foo$bar/bar}


# feels like memory unsafety in ZSH
## stdout: -foo-
## status: 0
## timeout: 10

#### ${x//~homedir/}

path=~/git/oilshell

# ~ expansion occurs
#echo path=$path

echo ${path//~/z}

echo ${path/~/z}
## STDOUT:
z/git/oilshell
z/git/oilshell
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
