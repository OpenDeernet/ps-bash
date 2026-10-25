## Absorbed from Differential.Tests/AwkGetlineDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Getline_Plain_NextRecordIdiom
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'NR==1{getline; print}' f
## stdout: b
## status: 0

#### Getline_Plain_AfterPattern
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk '/b/{getline; print}' f
## stdout: c
## status: 0

#### Getline_Var_PairedLines_OddCount
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk '{getline nxt; print $0, nxt}' f
## STDOUT:
a b
c b
## END
## status: 0

#### Getline_Plain_UpdatesNrFnrNf
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'NR==1{getline; print NR, FNR, NF, $0}' f
## stdout: 2 2 1 b
## status: 0

#### Getline_Var_UpdatesNrFnrNotNf
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'NR==1{getline v; print NR, FNR, NF, $0, v}' f
## stdout: 2 2 1 a b
## status: 0

#### Getline_InBegin_FirstRecord
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{getline; print "B:" $0, NR} {print "M:" $0}' f
## STDOUT:
B:a 1
M:b
M:c
## END
## status: 0

#### GetlineFile_WhileLoopCount
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk '{ while ((getline line < "f") > 0) n++ } END{print n}' f
## stdout: 3
## status: 0

#### GetlineFile_SetsRecordNf_NotNr
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ getline < "f"; print $0, NF, NR }'
## stdout: a 1 0
## status: 0

#### GetlineFile_Var_NextLinePerCall
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ getline a < "f"; getline b < "f"; print a b }'
## stdout: ab
## status: 0

#### GetlineFile_CloseRewinds
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ f = "f"; getline a < f; getline b < f; close(f); getline c < f; print a b c }'
## stdout: aba
## status: 0

#### GetlineFile_MissingIsMinusOne
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ print (getline x < "nope") }'
## stdout: -1
## status: 0

#### GetlineFile_UnparenthesizedInCondition
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ while (getline line < "f" > 0) n++; print n }'
## stdout: 3
## status: 0

#### GetlineFile_ConcatenationBindsAfterFileOperand
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ x = getline < "f" "zz"; print x }'
## stdout: 1zz
## status: 0

#### GetlineFile_StdinDash
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && echo piped | awk 'BEGIN{ getline x < "-"; print "got", x }'
## stdout: got piped
## status: 0

#### GetlineCmd_Var
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN { "echo hi" | getline x; print x }'
## stdout: hi
## status: 0

#### GetlineCmd_Record_SetsNf_NotNr
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN { "echo x y z" | getline; print $2, NF, NR }'
## stdout: y 3 0
## status: 0

#### GetlineCmd_WhileLoopSeq
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{while(("seq 3" | getline l) > 0) s+=l; print s}'
## stdout: 6
## status: 0

#### GetlineCmd_UnparenthesizedInCondition
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ while ("echo a; echo b" | getline > 0) n++; print n }'
## stdout: 2
## status: 0

#### GetlineCmd_ConcatenatedCommand
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ "echo " "zz" | getline q; print q }'
## stdout: zz
## status: 0

#### GetlineCmd_StreamReusedUntilClosed
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ c = "echo 1; echo 2"; c | getline a; c | getline b; close(c); c | getline d; print a, b, d }'
## stdout: 1 2 1
## status: 0

#### GetlineCmd_EofThenReopen
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ x = "echo a" | getline y; print x, y; x = "echo a" | getline y; print x; close("echo a"); x = "echo a" | getline y; print x }'
## STDOUT:
1 a
0
1
## END
## status: 0

#### Close_Command_ExitStatus
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ "exit 3" | getline; print close("exit 3"); print close("exit 3") }'
## STDOUT:
3
-1
## END
## status: 0

#### Close_Unopened_MinusOne
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ print close("never") }'
## stdout: -1
## status: 0

#### System_OutputOrderAndStatus
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && awk 'BEGIN{ print "before"; system("echo sys"); print "after"; print system("exit 2") }'
## STDOUT:
before
sys
after
2
## END
## status: 0

#### Getline_Stdin_BeginThenMainLoop
cd "$(mktemp -d)" && printf 'a\nb\nc\n' > f && printf 'x\ny\n' > g && printf 'a\nb\nc\n' | awk 'BEGIN{ getline; print "B:" $0 } { print "M:" $0 } END{ print NR }'
## STDOUT:
B:a
M:b
M:c
3
## END
## status: 0
