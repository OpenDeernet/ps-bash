## Absorbed from Differential.Tests/ExpansionRedirectEnvDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### ForList_CommandSubstitution_WordSplits row 1
for f in $(echo a b c); do echo "<$f>"; done
## STDOUT:
<a>
<b>
<c>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 2
for f in $(seq 3); do echo "<$f>"; done
## STDOUT:
<1>
<2>
<3>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 3
for f in $(printf 'a\nb\n'); do echo "<$f>"; done
## STDOUT:
<a>
<b>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 4
for f in `echo a b`; do echo "<$f>"; done
## STDOUT:
<a>
<b>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 5
for f in "$(echo a b)"; do echo "<$f>"; done
## stdout: <a b>
## status: 0

#### ForList_CommandSubstitution_WordSplits row 6
for f in $(echo); do echo "<$f>"; done; echo end
## stdout: end
## status: 0

#### ForList_CommandSubstitution_WordSplits row 7
for f in $(echo '   '); do echo "<$f>"; done; echo end
## stdout: end
## status: 0

#### ForList_CommandSubstitution_WordSplits row 8
for f in x $(echo a b) y; do echo "<$f>"; done
## STDOUT:
<x>
<a>
<b>
<y>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 9
for f in $(echo a b) $(echo c d); do echo "<$f>"; done
## STDOUT:
<a>
<b>
<c>
<d>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 10
a='x y'; for w in $a z; do echo "<$w>"; done
## STDOUT:
<x>
<y>
<z>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 11
a='x y'; for w in z $a; do echo "<$w>"; done
## STDOUT:
<z>
<x>
<y>
## END
## status: 0

#### ForList_CommandSubstitution_WordSplits row 12
for f in $(echo '  a   b  '); do echo "<$f>"; done
## STDOUT:
<a>
<b>
## END
## status: 0

#### ForList_CommandSubstitution_HonoursIfs row 1
IFS=:; for p in $(echo a:b c); do echo "<$p>"; done
## STDOUT:
<a>
<b c>
## END
## status: 0

#### ForList_CommandSubstitution_HonoursIfs row 2
IFS=:; for p in $(echo a::b:); do echo "<$p>"; done
## STDOUT:
<a>
<>
<b>
## END
## status: 0

#### ForList_CommandSubstitution_HonoursIfs row 3
IFS=: ; for p in $(echo ' a : b '); do echo "<$p>"; done
## STDOUT:
< a >
< b >
## END
## status: 0

#### ForList_CommandSubstitution_HonoursIfs row 4
IFS=; for p in $(echo a b); do echo "<$p>"; done
## stdout: <a b>
## status: 0

#### Operand_CommandSubstitution_WordSplits row 1
printf '[%s]' $(echo a b); echo
## stdout: [a][b]
## status: 0

#### Operand_CommandSubstitution_WordSplits row 2
printf '[%s]' $(echo); echo
## stdout: []
## status: 0

#### Operand_CommandSubstitution_WordSplits row 3
printf '[%s]' "$(echo a b)"; echo
## stdout: [a b]
## status: 0

#### Operand_CommandSubstitution_WordSplits row 4
printf '[%s]' $(printf 'a\nb\n') c; echo
## stdout: [a][b][c]
## status: 0

#### Operand_CommandSubstitution_WordSplits row 5
echo $(echo a    b)
## stdout: a b
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 1
seq 1 40 | COLUMNS=60 column
## STDOUT:
1	7	13	19	25	31	37
2	8	14	20	26	32	38
3	9	15	21	27	33	39
4	10	16	22	28	34	40
5	11	17	23	29	35
6	12	18	24	30	36
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 2
seq 1 40 | COLUMNS=20 column | head -3
## STDOUT:
1	21
2	22
3	23
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 3
echo x | FOO=1 env | grep FOO
## stdout: FOO=1
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 4
echo x | FOO=1 cat; echo "[$FOO]"
## STDOUT:
x
[]
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 5
FOO=outer; echo x | FOO=1 env | grep '^FOO='; echo "after=$FOO"
## STDOUT:
FOO=1
after=outer
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 6
printf 'b\na\n' | LC_ALL=C sort
## STDOUT:
a
b
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 7
printf 'b\na\n' | LC_ALL=C sort | head -1
## stdout: a
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 8
echo x | A=1 B=2 env | grep -E '^(A|B)=' | sort
## STDOUT:
A=1
B=2
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 9
echo hi | FOO=1 true; echo rc=$?
## stdout: rc=0
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 10
echo hi | FOO=1 grep -c hi; echo "[$FOO]"
## STDOUT:
1
[]
## END
## status: 0

#### PipeTarget_EnvPrefix_AppliesToThatStageOnly row 11
echo a b | FOO=$(echo v) env | grep '^FOO='
## stdout: FOO=v
## status: 0

#### EnvPrefix_StandaloneAndOnLaterStage row 1
FOO=1 env | grep '^FOO='; echo "[$FOO]"
## STDOUT:
FOO=1
[]
## END
## status: 0

#### EnvPrefix_StandaloneAndOnLaterStage row 2
env | FOO=1 grep -c '^FOO='
## stdout: 0
## status: 1

#### PipeTarget_SplitOperand_StillReceivesPipeInput row 1
x=b; printf 'a\nb\n' | grep $x
## stdout: b
## status: 0

#### PipeTarget_SplitOperand_StillReceivesPipeInput row 2
printf 'a\nb\n' | grep $(echo b)
## stdout: b
## status: 0

#### PipeTarget_SplitOperand_StillReceivesPipeInput row 3
printf 'a\nb\n' | grep "$(echo b)"
## stdout: b
## status: 0

#### PipeTarget_SplitOperand_StillReceivesPipeInput row 4
printf 'a\nb\nc\n' | grep -v $(echo b)
## STDOUT:
a
c
## END
## status: 0

#### Operand_CommandSubstitutionResultIsGlobExpanded
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '1' > 'x'
printf '%s\n' '2' > 'y'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '[%s]' $(echo '*'); echo
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[x][y]
== exit 0
== fs
D .
F ./x MQo=
F ./y Mgo=
## END
## status: 0

#### BareRedirect_CreatesFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
> f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a QQo=
F ./f 
## END
## status: 0

#### True_RedirectAppend_Creates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
true >> f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a QQo=
F ./f 
## END
## status: 0

#### Colon_RedirectFailure_FlipsOrChain
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
: 2>/dev/null > nodir/f || echo failed; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
failed
rc=0
== exit 0
== fs
D .
F ./a QQo=
## END
## status: 0

#### ForList_CommandSubstitutionGlobWithoutMatchStaysLiteral
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '1' > 'x'
} >/dev/null 2>&1
echo '== stdout'
{ :
for f in $(echo 'q*'); do echo "<$f>"; done
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
<q*>
== exit 0
== fs
D .
F ./x MQo=
## END
## status: 0

#### Colon_RedirectOut_CreatesFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
: > f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a QQo=
F ./f 
## END
## status: 0

#### False_RedirectOut_CreatesFileAndFails
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
false > f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
F ./a QQo=
F ./f 
## END
## status: 0

#### Colon_NoSpace_RedirectOut_Truncates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old content' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
:>f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./f 
## END
## status: 0

#### True_RedirectOut_Truncates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
true > f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./f 
## END
## status: 0

#### Colon_RedirectOut_TruncatesExistingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old content' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
: > f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./f 
## END
## status: 0

#### ForList_CommandSubstitutionResultIsGlobExpanded
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '1' > 'x'
printf '%s\n' '2' > 'y'
} >/dev/null 2>&1
echo '== stdout'
{ :
for f in $(echo '*'); do echo "<$f>"; done
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
<x>
<y>
== exit 0
== fs
D .
F ./x MQo=
F ./y Mgo=
## END
## status: 0

#### BareRedirect_Append_CreatesAndKeeps
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'stays' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
>> new; >> keep; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./keep c3RheXMK
F ./new 
## END
## status: 0

#### Colon_RedirectAppend_CreatesAndKeepsContent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'stays' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
: >> new; : >> keep; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./keep c3RheXMK
F ./new 
## END
## status: 0

#### Colon_RedirectInMissingDirectory_FailsWithStatus1
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
{ : > nodir/f; } 2>/dev/null; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
F ./a QQo=
## END
## status: 0

#### Colon_RedirectSuccess_DoesNotTakeOrBranch
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
: > f || echo failed; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a QQo=
F ./f 
## END
## status: 0

#### Colon_RedirectToDevNull_CreatesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
: > /dev/null; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a QQo=
## END
## status: 0

#### Echo_RedirectInMissingDirectory_FailsWithStatus1
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
{ echo hi > nodir/f; } 2>/dev/null; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
F ./a QQo=
## END
## status: 0

#### Colon_TwoRedirects_OpensBoth
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
: > a > b; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./a 
F ./b 
## END
## status: 0

#### True_RedirectInMissingDirectory_FailsWithStatus1
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
{ true >> nodir/f; } 2>/dev/null; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
F ./a QQo=
## END
## status: 0

#### BareRedirect_TruncatesExistingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
> f; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
== exit 0
== fs
D .
F ./f 
## END
## status: 0
