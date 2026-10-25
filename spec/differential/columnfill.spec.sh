## Absorbed from Differential.Tests/ColumnFillDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Numbers_Width40
seq 1 10 | column -c 40 | cat -A
## STDOUT:
1^I3^I5^I7^I9$
2^I4^I6^I8^I10$
## END
## status: 0

#### Numbers_Width40_FillRows
seq 1 10 | column -c 40 -x | cat -A
## STDOUT:
1^I2^I3^I4^I5$
6^I7^I8^I9^I10$
## END
## status: 0

#### Numbers_DefaultWidth80
seq 1 40 | column | cat -A
## STDOUT:
1^I5^I9^I13^I17^I21^I25^I29^I33^I37$
2^I6^I10^I14^I18^I22^I26^I30^I34^I38$
3^I7^I11^I15^I19^I23^I27^I31^I35^I39$
4^I8^I12^I16^I20^I24^I28^I32^I36^I40$
## END
## status: 0

#### Numbers_HundredFillRows
seq 1 100 | column -x -c 80 | cat -A
## STDOUT:
1^I2^I3^I4^I5^I6^I7^I8^I9^I10$
11^I12^I13^I14^I15^I16^I17^I18^I19^I20$
21^I22^I23^I24^I25^I26^I27^I28^I29^I30$
31^I32^I33^I34^I35^I36^I37^I38^I39^I40$
41^I42^I43^I44^I45^I46^I47^I48^I49^I50$
51^I52^I53^I54^I55^I56^I57^I58^I59^I60$
61^I62^I63^I64^I65^I66^I67^I68^I69^I70$
71^I72^I73^I74^I75^I76^I77^I78^I79^I80$
81^I82^I83^I84^I85^I86^I87^I88^I89^I90$
91^I92^I93^I94^I95^I96^I97^I98^I99^I100$
## END
## status: 0

#### Words_WideCell_OnePerLine
printf '%s\n' apple banana cherry date elderberry fig grape honeydew kiwi lemon | column -c 30 | cat -A
## STDOUT:
apple$
banana$
cherry$
date$
elderberry$
fig$
grape$
honeydew$
kiwi$
lemon$
## END
## status: 0

#### EntryWiderThanWidth
printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa b c | column -c 40 | cat -A
## STDOUT:
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$
b$
c$
## END
## status: 0

#### ExactFit
printf '%s\n' aaaa bbbb cccc dddd | column -c 19 | cat -A
## STDOUT:
aaaa^Icccc$
bbbb^Idddd$
## END
## status: 0

#### BlankLinesDropped
printf 'a\n\nb\n\n\nc\n' | column -c 40 | cat -A
## stdout: a^Ib^Ic$
## status: 0

#### BlankLinesKept
printf 'a\n\nb\n\nc\n' | column -c 40 -L | cat -A
## stdout: a^I^Ib^I^Ic$
## status: 0

#### MixedWidths_ColumnMajor
printf '%s\n' a bbbbbbbbbbbbbb cc d eeeeeeeeee ff g hhhh | column -c 60 | cat -A
## STDOUT:
a^I^Id^I^Ig$
bbbbbbbbbbbbbb^Ieeeeeeeeee^Ihhhh$
cc^I^Iff$
## END
## status: 0

#### MixedWidths_RowMajor
printf '%s\n' a bbbbbbbbbbbbbb cc d eeeeeeeeee ff g hhhh | column -c 60 -x | cat -A
## STDOUT:
a^I^Ibbbbbbbbbbbbbb^Icc$
d^I^Ieeeeeeeeee^Iff$
g^I^Ihhhh$
## END
## status: 0

#### Utf8Entries
printf '%s\n' héllo wörld ñandú ünï cøde | column -c 30 | cat -A
## STDOUT:
hM-CM-)llo^IM-CM-1andM-CM-:^IcM-CM-8de$
wM-CM-6rld^IM-CM-<nM-CM-/$
## END
## status: 0

#### WideCjkEntries
printf '%s\n' 日本語 中文 한국어 abc def ghi | column -c 30 | cat -A
## STDOUT:
M-fM-^WM-%M-fM-^\M-,M-hM-*M-^^^IM-mM-^UM-^\M-jM-5M--M-lM-^VM-4^Idef$
M-dM-8M--M-fM-^VM-^G^Iabc^Ighi$
## END
## status: 0

#### SeparatorAndOutputSeparatorIgnored
printf 'a:b\nc:d\ne\n' | column -s: -o '|' -c 40 | cat -A
## stdout: a:b^Ic:d^Ie$
## status: 0

#### WidthZeroAndOne
seq 1 3 | column -c 0 | cat -A; seq 1 3 | column -c 1 | cat -A
## STDOUT:
1$
2$
3$
1$
2$
3$
## END
## status: 0

#### BundledXc
seq 1 12 | column -xc 20 | cat -A
## STDOUT:
1^I2$
3^I4$
5^I6$
7^I8$
9^I10$
11^I12$
## END
## status: 0

#### LongOptions
seq 1 12 | column --fillrows --output-width=20 | cat -A
## STDOUT:
1^I2$
3^I4$
5^I6$
7^I8$
9^I10$
11^I12$
## END
## status: 0

#### EmptyInput
printf '' | column -c 20 | cat -A
## stdout:
## status: 0

#### TableIgnoresWidth
printf 'a b\nc d\n' | column -c 40 -t | cat -A
## STDOUT:
a  b$
c  d$
## END
## status: 0

#### Error_TableAndFillRows
printf 'a b\n' | column -t -x
## stdout:
## status: 1

#### Error_WidthNotANumber
echo a | column -c x
## stdout:
## status: 1

#### Error_WidthNegative
echo a | column -c -5
## stdout:
## status: 1

#### Error_WidthTooLarge
echo a | column -c 4294967296
## stdout:
## status: 1

#### Numbers_ColumnsEnvironment
seq 1 40 > n40
COLUMNS=60 column n40 | cat -A
## STDOUT:
1^I7^I13^I19^I25^I31^I37$
2^I8^I14^I20^I26^I32^I38$
3^I9^I15^I21^I27^I33^I39$
4^I10^I16^I22^I28^I34^I40$
5^I11^I17^I23^I29^I35$
6^I12^I18^I24^I30^I36$
## END
## status: 0

#### Numbers_OptionBeatsColumnsEnvironment
seq 1 40 > n40
COLUMNS=60 column -c 30 n40 | cat -A
## STDOUT:
1^I15^I29$
2^I16^I30$
3^I17^I31$
4^I18^I32$
5^I19^I33$
6^I20^I34$
7^I21^I35$
8^I22^I36$
9^I23^I37$
10^I24^I38$
11^I25^I39$
12^I26^I40$
13^I27$
14^I28$
## END
## status: 0

#### FileOperands
seq 1 12 > nums
column -c 20 nums nums | cat -A
## STDOUT:
1^I1$
2^I2$
3^I3$
4^I4$
5^I5$
6^I6$
7^I7$
8^I8$
9^I9$
10^I10$
11^I11$
12^I12$
## END
## status: 0

#### Same
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 3 | column -c 0 | cat -A; seq 1 3 | column -c 1 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1$
2$
3$
1$
2$
3$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '' | column -c 20 | cat -A
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
F ./none 
## END
## status: 0

#### Same row 3
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' aaaa bbbb cccc dddd | column -c 19 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa^Icccc$
bbbb^Idddd$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 4
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n\nb\n\n\nc\n' | column -c 40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a^Ib^Ic$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 5
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
echo a | column -c 4294967296
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./none 
## END
## status: 0

#### Same row 6
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 12 | column --fillrows --output-width=20 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I2$
3^I4$
5^I6$
7^I8$
9^I10$
11^I12$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 7
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n\nb\n\nc\n' | column -c 40 -L | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a^I^Ib^I^Ic$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 8
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
echo a | column -c -5
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./none 
## END
## status: 0

#### Numbers_OptionBeatsColumnsEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
seq 1 40 > n40
} >/dev/null 2>&1
echo '== stdout'
{ :
COLUMNS=60 column -c 30 n40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I15^I29$
2^I16^I30$
3^I17^I31$
4^I18^I32$
5^I19^I33$
6^I20^I34$
7^I21^I35$
8^I22^I36$
9^I23^I37$
10^I24^I38$
11^I25^I39$
12^I26^I40$
13^I27$
14^I28$
== exit 0
== fs
D .
F ./n40 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAKMjEKMjIKMjMKMjQKMjUKMjYKMjcKMjgKMjkKMzAKMzEKMzIKMzMKMzQKMzUKMzYKMzcKMzgKMzkKNDAK
## END
## status: 0

#### Same row 9
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
echo a | column -c x
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./none 
## END
## status: 0

#### Same row 10
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' a bbbbbbbbbbbbbb cc d eeeeeeeeee ff g hhhh | column -c 60 -x | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a^I^Ibbbbbbbbbbbbbb^Icc$
d^I^Ieeeeeeeeee^Iff$
g^I^Ihhhh$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 11
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' 日本語 中文 한국어 abc def ghi | column -c 30 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
M-fM-^WM-%M-fM-^\M-,M-hM-*M-^^^IM-mM-^UM-^\M-jM-5M--M-lM-^VM-4^Idef$
M-dM-8M--M-fM-^VM-^G^Iabc^Ighi$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 12
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 100 | column -x -c 80 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I2^I3^I4^I5^I6^I7^I8^I9^I10$
11^I12^I13^I14^I15^I16^I17^I18^I19^I20$
21^I22^I23^I24^I25^I26^I27^I28^I29^I30$
31^I32^I33^I34^I35^I36^I37^I38^I39^I40$
41^I42^I43^I44^I45^I46^I47^I48^I49^I50$
51^I52^I53^I54^I55^I56^I57^I58^I59^I60$
61^I62^I63^I64^I65^I66^I67^I68^I69^I70$
71^I72^I73^I74^I75^I76^I77^I78^I79^I80$
81^I82^I83^I84^I85^I86^I87^I88^I89^I90$
91^I92^I93^I94^I95^I96^I97^I98^I99^I100$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 13
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a b\n' | column -t -x
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./none 
## END
## status: 0

#### Same row 14
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 10 | column -c 40 -x | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I2^I3^I4^I5$
6^I7^I8^I9^I10$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 15
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' a bbbbbbbbbbbbbb cc d eeeeeeeeee ff g hhhh | column -c 60 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a^I^Id^I^Ig$
bbbbbbbbbbbbbb^Ieeeeeeeeee^Ihhhh$
cc^I^Iff$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 16
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' héllo wörld ñandú ünï cøde | column -c 30 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
hM-CM-)llo^IM-CM-1andM-CM-:^IcM-CM-8de$
wM-CM-6rld^IM-CM-<nM-CM-/$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 17
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a:b\nc:d\ne\n' | column -s: -o '|' -c 40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a:b^Ic:d^Ie$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### FileOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
seq 1 12 > nums
} >/dev/null 2>&1
echo '== stdout'
{ :
column -c 20 nums nums | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I1$
2^I2$
3^I3$
4^I4$
5^I5$
6^I6$
7^I7$
8^I8$
9^I9$
10^I10$
11^I11$
12^I12$
== exit 0
== fs
D .
F ./nums MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIK
## END
## status: 0

#### Numbers_ColumnsEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
seq 1 40 > n40
} >/dev/null 2>&1
echo '== stdout'
{ :
COLUMNS=60 column n40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I7^I13^I19^I25^I31^I37$
2^I8^I14^I20^I26^I32^I38$
3^I9^I15^I21^I27^I33^I39$
4^I10^I16^I22^I28^I34^I40$
5^I11^I17^I23^I29^I35$
6^I12^I18^I24^I30^I36$
== exit 0
== fs
D .
F ./n40 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAKMjEKMjIKMjMKMjQKMjUKMjYKMjcKMjgKMjkKMzAKMzEKMzIKMzMKMzQKMzUKMzYKMzcKMzgKMzkKNDAK
## END
## status: 0

#### Same row 18
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' apple banana cherry date elderberry fig grape honeydew kiwi lemon | column -c 30 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
apple$
banana$
cherry$
date$
elderberry$
fig$
grape$
honeydew$
kiwi$
lemon$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 19
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 12 | column -xc 20 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I2$
3^I4$
5^I6$
7^I8$
9^I10$
11^I12$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 20
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa b c | column -c 40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$
b$
c$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 21
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 10 | column -c 40 | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I3^I5^I7^I9$
2^I4^I6^I8^I10$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 22
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a b\nc d\n' | column -c 40 -t | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a  b$
c  d$
== exit 0
== fs
D .
F ./none 
## END
## status: 0

#### Same row 23
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > none
} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 40 | column | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1^I5^I9^I13^I17^I21^I25^I29^I33^I37$
2^I6^I10^I14^I18^I22^I26^I30^I34^I38$
3^I7^I11^I15^I19^I23^I27^I31^I35^I39$
4^I8^I12^I16^I20^I24^I28^I32^I36^I40$
== exit 0
== fs
D .
F ./none 
## END
## status: 0
