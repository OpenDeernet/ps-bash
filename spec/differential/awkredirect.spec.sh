## Absorbed from Differential.Tests/AwkRedirectDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Pipe_Sort_OutputAtExit_BeforeHeldStdout
cd "$(mktemp -d)" && printf 'c\nb\na\n' | awk 'BEGIN{ print "h" } { print | "sort" } END{ print "f" }'
## STDOUT:
h
a
b
c
f
## END
## status: 0

#### Pipe_Sort_ExplicitCloseBeforeFooter
cd "$(mktemp -d)" && printf 'c\nb\na\n' | awk 'BEGIN{ print "h" } { print | "sort" } END{ close("sort"); print "f" }'
## STDOUT:
h
a
b
c
f
## END
## status: 0

#### Pipe_Close_FlushesPendingStdoutFirst
cd "$(mktemp -d)" && awk 'BEGIN{ print "x" | "cat"; print "mid"; close("cat"); print "end" }'
## STDOUT:
mid
x
end
## END
## status: 0

#### Pipe_NumericSort
cd "$(mktemp -d)" && printf '10\n9\n100\n' | awk '{ print | "sort -n" }'
## STDOUT:
9
10
100
## END
## status: 0

#### Pipe_PrintfToSort
cd "$(mktemp -d)" && awk 'BEGIN{ printf "b\na\n" | "sort" }'
## STDOUT:
a
b
## END
## status: 0

#### Pipe_CommaArgsJoinedWithOfs
cd "$(mktemp -d)" && awk 'BEGIN{ print "b", "a" | "cat" }'
## stdout: b a
## status: 0

#### Pipe_Pipeline_SortUniqCount
cd "$(mktemp -d)" && printf 'x\ny\nx\nx\n' | awk '{ print | "sort | uniq -c | sort -rn" }'
## STDOUT:
      3 x
      1 y
## END
## status: 0

#### Pipe_CloseReturnsExitStatusOfGrep
cd "$(mktemp -d)" && awk 'BEGIN{ print "x" | "grep -q x"; print close("grep -q x"); print "y" | "grep -q x"; print close("grep -q x") }'
## STDOUT:
0
1
## END
## status: 0

#### Pipe_CloseOfUnopenedIsMinusOne
cd "$(mktemp -d)" && awk 'BEGIN{ print close("never") }'
## stdout: -1
## status: 0

#### Pipe_ReopenAfterCloseRunsAgain
cd "$(mktemp -d)" && awk 'BEGIN{ print "a" | "sort"; close("sort"); print "b" | "sort" }'
## STDOUT:
a
b
## END
## status: 0

#### Pipe_CommandWritesFile_ThenCat
cd "$(mktemp -d)" && awk 'BEGIN{ print "zeta" | "sort > out.txt"; print "alpha" | "sort > out.txt"; close("sort > out.txt") }'; cat out.txt
## STDOUT:
alpha
zeta
## END
## status: 0

#### Pipe_AndStdoutAlias_ExitOrder
cd "$(mktemp -d)" && awk 'BEGIN{ print "to-sort" | "sort"; print "X" > "/dev/stdout" }'
## STDOUT:
X
to-sort
## END
## status: 0

#### Redirect_TruncateOnFirstOpenThenAppendWhileOpen
awk 'BEGIN{ print "a" > "o"; print "b" > "o" }'
## stdout:
## status: 0

#### Redirect_CloseThenReopenTruncatesAgain
awk 'BEGIN{ f = "o"; print "a" > f; print "b" > f; close(f); print "c" > f }'
## stdout:
## status: 0

#### Redirect_AppendAfterClose_KeepsEarlierContent
awk 'BEGIN{ f = "o"; print "a" > f; close(f); print "b" >> f }'
## stdout:
## status: 0

#### Printf_Redirect_AndAppend
awk 'BEGIN{ printf "%s-%d\n", "a", 3 > "pf"; printf "z\n" >> "pf" }'
## stdout:
## status: 0

#### Printf_ParenthesizedArgs_Redirect
awk 'BEGIN{ printf("%s|%s\n", "a", "b") > "pf"; print("c", "d") > "pp" }'
## stdout:
## status: 0

#### Print_ManyFilesInLoop
awk 'BEGIN{ for (i = 0; i < 3; i++) print i > ("f" i) }'
## stdout:
## status: 0

#### Redirect_TargetIsAConcatenation
awk 'BEGIN{ x = "p"; print "q" > x "3"; print > "p2" 5 }'
## stdout:
## status: 0

#### Redirect_ArgsWithCommaThenTarget
awk 'BEGIN{ print 1, 2 > "p1"; print 3, 4 > "p1" }'
## stdout:
## status: 0

#### Redirect_ParenthesizedComparisonIsNotARedirect
awk 'BEGIN{ print (3 > 2); print (2 > 3); print (1 > 2) ? "A" : "B" }'
## STDOUT:
1
0
B
## END
## status: 0

#### Redirect_DevNullAndStdoutAlias
awk 'BEGIN{ print "x" > "/dev/null"; print "1"; print "2" > "/dev/stdout"; print "3"; print "d" > "-" }'
## STDOUT:
1
2
3
d
## END
## status: 0

#### Redirect_CloseReturnsZeroThenMinusOne
awk 'BEGIN{ print "x" > "f"; print close("f"); print close("f") }'
## STDOUT:
0
-1
## END
## status: 0

#### Redirect_ExitStatusKept_FileStillWritten
awk 'BEGIN{ print "x" > "ex"; exit 3 }'
## stdout:
## status: 3

#### Redirect_UnwritablePathIsFatal_Exit2
awk 'BEGIN{ print "x" > "no/such/dir/f"; print "after" }'
## stdout:
## status: 2

#### Redirect_EmptyNameIsFatal_Exit2
awk 'BEGIN{ print "x" > ""; print "after" }'
## stdout:
## status: 2

#### Redirect_FflushPublishesToGetline
awk 'BEGIN{ f = "fl"; print "x" > f; print fflush(f); print fflush("zz"); getline l < f; print "got[" l "]" }'
## STDOUT:
0
-1
got[x]
## END
## status: 0

#### Redirect_SystemSeesUnclosedFile
awk 'BEGIN{ print "fromawk" > "s.txt"; r = system("cat s.txt"); print "rc", r }'
## STDOUT:
fromawk
rc 0
## END
## status: 0

#### Append_AddsToExistingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'o'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" >> "o"; print "y" >> "o" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./o b2xkCngKeQo=
## END
## status: 0

#### Redirect_AppendAfterClose_KeepsEarlierContent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ f = "o"; print "a" > f; close(f); print "b" >> f }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./o YQpiCg==
## END
## status: 0

#### Redirect_FflushPublishesToGetline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ f = "fl"; print "x" > f; print fflush(f); print fflush("zz"); getline l < f; print "got[" l "]" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
0
-1
got[x]
== exit 0
== fs
D .
F ./fl eAo=
## END
## status: 0

#### Redirect_TargetIsAConcatenation
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ x = "p"; print "q" > x "3"; print > "p2" 5 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./p25 Cg==
F ./p3 cQo=
## END
## status: 0

#### Redirect_CloseReturnsZeroThenMinusOne
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" > "f"; print close("f"); print close("f") }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
0
-1
== exit 0
== fs
D .
F ./f eAo=
## END
## status: 0

#### Redirect_TruncateOnFirstOpenThenAppendWhileOpen
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "a" > "o"; print "b" > "o" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./o YQpiCg==
## END
## status: 0

#### Print_NoArgs_RedirectWritesRecord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'a 1
b 2
a 3
' > 'data'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk '{ print > "na" }' data
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./data YSAxCmIgMgphIDMKCg==
F ./na YSAxCmIgMgphIDMKCg==
## END
## status: 0

#### Redirect_CloseThenGetlineReadsBack
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'a 1
b 2
a 3
' > 'data'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk '{ print NR > "nr.out" } END{ close("nr.out"); while ((getline l < "nr.out") > 0) print "r:" l }' data
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r:1
r:2
r:3
r:4
== exit 0
== fs
D .
F ./data YSAxCmIgMgphIDMKCg==
F ./nr.out MQoyCjMKNAo=
## END
## status: 0

#### Redirect_UnwritablePathIsFatal_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" > "no/such/dir/f"; print "after" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
## END
## status: 0

#### Redirect_ExitStatusKept_FileStillWritten
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" > "ex"; exit 3 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 3
== fs
D .
F ./ex eAo=
## END
## status: 0

#### Redirect_ParenthesizedComparisonIsNotARedirect
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print (3 > 2); print (2 > 3); print (1 > 2) ? "A" : "B" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
0
B
== exit 0
== fs
D .
## END
## status: 0

#### Print_ManyFilesInLoop
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ for (i = 0; i < 3; i++) print i > ("f" i) }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f0 MAo=
F ./f1 MQo=
F ./f2 Mgo=
## END
## status: 0

#### Printf_ParenthesizedArgs_Redirect
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ printf("%s|%s\n", "a", "b") > "pf"; print("c", "d") > "pp" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./pf YXxiCg==
F ./pp YyBkCg==
## END
## status: 0

#### Printf_AppendToLogFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'a 1
b 2
a 3
' > 'data'
printf '%s\n' 'start' > 'log'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk '{ printf "%s\n", $2 >> "log" }' data
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./data YSAxCmIgMgphIDMKCg==
F ./log c3RhcnQKMQoyCjMKCg==
## END
## status: 0

#### Redirect_ArgsWithCommaThenTarget
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print 1, 2 > "p1"; print 3, 4 > "p1" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./p1 MSAyCjMgNAo=
## END
## status: 0

#### Redirect_TruncatesPreExistingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'o'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "new" > "o" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./o bmV3Cg==
## END
## status: 0

#### Redirect_EmptyNameIsFatal_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" > ""; print "after" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
## END
## status: 0

#### Redirect_AppendThenTruncateOperator_SameStreamKeepsAppending
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'old' > 'g'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "1" >> "g"; print "2" > "g" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./g b2xkCjEKMgo=
## END
## status: 0

#### Redirect_SystemSeesUnclosedFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "fromawk" > "s.txt"; r = system("cat s.txt"); print "rc", r }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
fromawk
rc 0
== exit 0
== fs
D .
F ./s.txt ZnJvbWF3awo=
## END
## status: 0

#### Printf_Redirect_AndAppend
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ printf "%s-%d\n", "a", 3 > "pf"; printf "z\n" >> "pf" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./pf YS0zCnoK
## END
## status: 0

#### Redirect_DevNullAndStdoutAlias
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ print "x" > "/dev/null"; print "1"; print "2" > "/dev/stdout"; print "3"; print "d" > "-" }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
2
3
d
== exit 0
== fs
D .
## END
## status: 0

#### Print_SplitIntoFilesByFirstField
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'a 1
b 2
a 3
' > 'data'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk '{ print $2 > ($1 ".txt") }' data
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./.txt Cg==
F ./a.txt MQozCg==
F ./b.txt Mgo=
F ./data YSAxCmIgMgphIDMKCg==
## END
## status: 0

#### Redirect_CloseThenReopenTruncatesAgain
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{ f = "o"; print "a" > f; print "b" > f; close(f); print "c" > f }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./o Ywo=
## END
## status: 0
