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
