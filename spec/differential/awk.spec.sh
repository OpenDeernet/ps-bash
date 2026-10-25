## Absorbed from Differential.Tests/AwkDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Awk_PrintWholeLine
printf 'a b c\n' | awk '{print}'
## stdout: a b c
## status: 0

#### Awk_PrintDollar0
printf 'a b c\n' | awk '{print $0}'
## stdout: a b c
## status: 0

#### Awk_FieldAccess
printf 'a b c\n' | awk '{print $2}'
## stdout: b
## status: 0

#### Awk_MultiFieldPrint
printf 'a b c\n' | awk '{print $1, $3}'
## stdout: a c
## status: 0

#### Awk_NF
printf 'a b c d\n' | awk '{print NF}'
## stdout: 4
## status: 0

#### Awk_NR
printf 'x\ny\nz\n' | awk '{print NR, $0}'
## STDOUT:
1 x
2 y
3 z
## END
## status: 0

#### Awk_FieldSepColon
printf 'a:b:c\n' | awk -F: '{print $2}'
## stdout: b
## status: 0

#### Awk_LastField_NF
printf 'a b c\n' | awk '{print $NF}'
## stdout: c
## status: 0

#### Awk_Begin
printf '' | awk 'BEGIN{print "start"}'
## stdout: start
## status: 0

#### Awk_End_NR
printf 'a\nb\n' | awk 'END{print NR}'
## stdout: 2
## status: 0

#### Awk_BeginBodyEnd
printf 'a\nb\n' | awk 'BEGIN{print "s"} {print} END{print "e"}'
## STDOUT:
s
a
b
e
## END
## status: 0

#### Awk_PatternRegex
printf 'foo\nbar\nbaz\n' | awk '/ba/{print}'
## STDOUT:
bar
baz
## END
## status: 0

#### Awk_PatternNumericCompare
printf '1\n5\n10\n' | awk '$1 > 3 {print}'
## STDOUT:
5
10
## END
## status: 0

#### Awk_PatternNrEquals
printf 'a\nb\nc\n' | awk 'NR==2{print}'
## stdout: b
## status: 0

#### Awk_VarFlag
printf '' | awk -v x=5 'BEGIN{print x}'
## stdout: 5
## status: 0

#### Awk_Arithmetic
printf '2 3\n' | awk '{print $1 + $2}'
## stdout: 5
## status: 0

#### Awk_StringConcat
printf 'a b\n' | awk '{print $1 $2}'
## stdout: ab
## status: 0

#### Awk_SumAccumulate
printf '1\n2\n3\n' | awk '{s+=$1} END{print s}'
## stdout: 6
## status: 0

#### Awk_Length
printf 'hello\n' | awk '{print length($0)}'
## stdout: 5
## status: 0

#### Awk_Substr
printf 'hello\n' | awk '{print substr($0,2,3)}'
## stdout: ell
## status: 0

#### Awk_Toupper
printf 'abc\n' | awk '{print toupper($0)}'
## stdout: ABC
## status: 0

#### Awk_Tolower
printf 'ABC\n' | awk '{print tolower($0)}'
## stdout: abc
## status: 0

#### Awk_Index
printf 'hello\n' | awk '{print index($0,"ll")}'
## stdout: 3
## status: 0

#### Awk_Printf
printf 'a\n' | awk '{printf "%s-%s\n", $1, "x"}'
## stdout: a-x
## status: 0

#### Awk_Sub
printf 'aaa\n' | awk '{sub(/a/,"b"); print}'
## stdout: baa
## status: 0

#### Awk_Gsub
printf 'aaa\n' | awk '{gsub(/a/,"b"); print}'
## stdout: bbb
## status: 0

#### Awk_Split
printf 'a,b,c\n' | awk '{n=split($0,arr,","); print n, arr[1], arr[3]}'
## stdout: 3 a c
## status: 0

#### Awk_Ofs
printf 'a b\n' | awk 'BEGIN{OFS="-"} {print $1, $2}'
## stdout: a-b
## status: 0

#### Awk_IfElse
printf '1\n5\n' | awk '{if ($1>3) print "big"; else print "small"}'
## STDOUT:
small
big
## END
## status: 0
