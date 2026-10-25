## Absorbed from Differential.Tests/TrNewlineCaptureDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### NewlineTouchingTables_StreamWithExactBytes row 1
seq 1 3 | tr -d '\n'; echo '|'
## stdout: 123|
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 2
seq 1 3 | tr '\n' ,; echo '|'
## stdout: 1,2,3,|
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 3
printf 'a\nb\n' | tr '\n' ' '; echo '|'
## stdout: a b |
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 4
printf 'a\n\n\nb\n' | tr -s '\n'; echo '|'
## STDOUT:
a
b
|
## END
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 5
printf 'a\n\n\nb\n' | tr -s '\n' ' '; echo '|'
## stdout: a b |
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 6
printf 'a\nb' | tr -d '\n'; echo '|'
## stdout: ab|
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 7
printf 'a\nb\n' | tr '\n' ' ' | wc -c
## stdout: 4
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 8
printf 'one two\nthree\n' | tr -cs 'a-z' '\n'; echo '|'
## STDOUT:
one
two
three
|
## END
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 9
printf 'a b\n' | tr ' ' '\n'; echo '|'
## STDOUT:
a
b
|
## END
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 10
printf 'a\nb\n' | tr '\n' x | tr x '\n'; echo '|'
## STDOUT:
a
b
|
## END
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 11
yes | tr '\n' x | head -c 5; echo '|'
## stdout: yxyxy|
## status: 0

#### NewlineTouchingTables_StreamWithExactBytes row 12
yes abc | tr -d '\n' | head -c 7; echo '|'
## stdout: abcabca|
## status: 0

#### CommandSubstitution_GluesExactRecords row 1
x=$(printf 'a\nb\n' | tr '\n' ,); echo "[$x]"
## stdout: [a,b,]
## status: 0

#### CommandSubstitution_GluesExactRecords row 2
x=$(seq 1 3 | tr -d '\n'); echo "[$x]"
## stdout: [123]
## status: 0

#### CommandSubstitution_GluesExactRecords row 3
x=$(seq 1 3 | tr '\n' ' '); echo "[$x]"
## stdout: [1 2 3 ]
## status: 0

#### CommandSubstitution_GluesExactRecords row 4
echo $(printf 'a\nb\n' | tr '\n' ,)
## stdout: a,b,
## status: 0

#### CommandSubstitution_GluesExactRecords row 5
echo "$(printf 'a\n\n\nb\n' | tr -s '\n' ' ')|"
## stdout: a b |
## status: 0

#### CommandSubstitution_GluesExactRecords row 6
x=$(printf a; printf b); echo "[$x]"
## stdout: [ab]
## status: 0

#### CommandSubstitution_GluesExactRecords row 7
x=$(printf 'x\n'; echo y); echo "[$x]"
## STDOUT:
[x
y]
## END
## status: 0

#### CommandSubstitution_GluesExactRecords row 8
x=$(printf 'a\nb\n'; echo c); echo "[$x]"
## STDOUT:
[a
b
c]
## END
## status: 0

#### CommandSubstitution_GluesExactRecords row 9
x=$(echo -n a; echo b); echo "[$x]"
## stdout: [ab]
## status: 0

#### CommandSubstitution_GluesExactRecords row 10
x=$(echo -n a; echo -n b); echo "[$x]"
## stdout: [ab]
## status: 0

#### CommandSubstitution_GluesExactRecords row 11
x=$(printf 'k=v\n' | tr '=' '\n'); echo "[$x]"
## STDOUT:
[k
v]
## END
## status: 0
