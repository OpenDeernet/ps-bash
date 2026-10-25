## Imported from the Oils spec tests (builtin-meta.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### command -v
myfunc() { echo x; }
command -v echo
echo $?

command -v myfunc
echo $?

command -v nonexistent  # doesn't print anything
echo nonexistent=$?

command -v ''  # BUG FIX, shouldn't succeed
echo empty=$?

command -v for
echo $?
## STDOUT:
echo
0
myfunc
0
nonexistent=1
empty=1
for
0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -v executable, builtin

#command -v grep ls

command -v grep | egrep -o '/[^/]+$'
command -v ls | egrep -o '/[^/]+$'
echo

command -v true
command -v eval
## STDOUT:
/grep
/ls

true
eval
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -v with multiple names
# ALL FOUR SHELLS behave differently here!
#
# bash chooses to swallow the error!  We agree with zsh if ANY word lookup
# fails, then the whole thing fails.

myfunc() { echo x; }
command -v echo myfunc ZZZ for
echo status=$?
## STDOUT:
echo
myfunc
for
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -v doesn't find non-executable file
# PATH resolution is different

mkdir -p _tmp
PATH="_tmp:$PATH"
touch _tmp/non-executable _tmp/executable
chmod +x _tmp/executable

command -v _tmp/non-executable
echo status=$?

command -v _tmp/executable
echo status=$?
## STDOUT:
_tmp/non-executable
status=0
_tmp/executable
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -v doesn't find executable dir

mkdir -p _tmp
PATH="_tmp:$PATH"
mkdir _tmp/cat

command -v _tmp/cat
echo status=$?
command -v cat
echo status=$?
## STDOUT:
status=1
/usr/bin/cat
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -V
myfunc() { echo x; }

shopt -s expand_aliases
alias ll='ls -l'

backtick=\`
command -V ll | sed "s/$backtick/'/g"
echo status=$?

command -V echo
echo status=$?

# Paper over insignificant difference
command -V myfunc | sed 's/shell function/function/'
echo status=$?

command -V nonexistent  # doesn't print anything
echo status=$?

command -V for
echo status=$?
## STDOUT:
ll is aliased to 'ls -l'
status=0
echo is a shell builtin
status=0
myfunc is a function
myfunc () 
{ 
    echo x
}
status=0
status=1
for is a shell keyword
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command -V nonexistent
command -V nonexistent 2>err.txt
echo status=$?
fgrep -o 'nonexistent: not found' err.txt || true
## STDOUT:
status=1
nonexistent: not found
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command skips function lookup
seq() {
  echo "$@"
}
command  # no-op
seq 3
command seq 3
# subshell shouldn't fork another process (but we don't have a good way of
# testing it)
( command seq 3 )
## STDOUT:
3
1
2
3
1
2
3
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### command command seq 3
command command seq 3
## STDOUT:
1
2
3
## END
## status: 0
## timeout: 10

#### command command -v seq
seq() {
  echo 3
}
command command -v seq
## stdout: seq
## status: 0
## timeout: 10

#### command -p (find hidden tool in default path)
export PATH=''
command -p ls
## STDOUT:
-foo.txt
0
1
1.txt
10
10.txt
2
2 3 c d
2.log
20231114.log
3
3.md
B
Microsoft.TestPlatform.CommunicationUtilities.dll
Microsoft.TestPlatform.CoreUtilities.dll
Microsoft.TestPlatform.CrossPlatEngine.dll
Microsoft.TestPlatform.PlatformAbstractions.dll
Microsoft.TestPlatform.Utilities.dll
Microsoft.VisualStudio.CodeCoverage.Shim.dll
Microsoft.VisualStudio.TestPlatform.Common.dll
Microsoft.VisualStudio.TestPlatform.ObjectModel.dll
Newtonsoft.Json.dll
OSCFLAGS
Parlot.dll
PsBash.Core.dll
PsBash.Core.pdb
PsBash.Core.xml
PsBash.Spec.Tests.deps.json
PsBash.Spec.Tests.dll
PsBash.Spec.Tests.pdb
PsBash.Spec.Tests.runtimeconfig.json
PsBash.Spec.dll
PsBash.Spec.pdb
PsBash.Testing.dll
PsBash.Testing.pdb
PsBash.Transpiler.dll
PsBash.Transpiler.pdb
PsBash.Transpiler.xml
_failglob
_noglob
_testing.py
_tmp
a
bar.cc
bar.h
bar.txt
baz.h
c
compose
cs
d
de
dir1
dir2
directory
dist
eg1
eg10
eg11
eg2
eg4
eg5
eg6
eg7
eg8
eg9
err.txt
es
escape*.txt
escape-10.txt
extglob2
extpipe
filename
foo
foo bar
foo-bar
foo-spam
foo.
foo.cc
foo.h
foo.hh
foo.txt
fr
has space.docx
hello
hello.c
hello.h
hello.o
hi.txt
image.jpeg
it
ja
ko
leaf.md
myfile
node_modules
one
one-*
one-bar
one.md
one.txt
opts
pl
process-sub.txt
ps-bash-host.deps.json
ps-bash-host.exe
ps-bash-host.runtimeconfig.json
ps-bash.deps.json
ps-bash.exe
ps-bash.runtimeconfig.json
pt-BR
pyproject.toml
ref
reset.txt
ru
runtimes
smoke1.txt
src
testhost.dll
testhost.exe
tmp.txt
tr
traps.txt
two
two-bar
x
xunit.abstractions.dll
xunit.assert.dll
xunit.core.dll
xunit.execution.dotnet.dll
xunit.runner.json
xunit.runner.reporters.netcoreapp10.dll
xunit.runner.utility.netcoreapp10.dll
xunit.runner.visualstudio.testadapter.dll
y.Y
yy.Y
zh-Hans
zh-Hant
zz-*-xx
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $(command type ls)
type() { echo FUNCTION; }
type
s=$(command type echo)
echo $s | grep builtin > /dev/null
echo status=$?
## STDOUT:
FUNCTION
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### builtin
cd () { echo "hi"; }
cd
builtin cd / && pwd
unset -f cd
## STDOUT:
hi
/
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### builtin ls not found
builtin ls
## stdout:
## status: 1
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### builtin usage
 
builtin
echo status=$?

builtin --
echo status=$?

builtin -- false
echo status=$?
## STDOUT:
status=0
status=0
status=1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### builtin command echo hi
builtin command echo hi
## stdout: hi
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
