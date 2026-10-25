## Absorbed from Differential.Tests/BuiltinArgsDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Echo_BuiltinOptionScan row 1
echo -n -e 'a\tb'; echo '|'
## stdout: a	b|
## status: 0

#### Echo_BuiltinOptionScan row 2
echo -ne 'a\tb'; echo '|'
## stdout: a	b|
## status: 0

#### Echo_BuiltinOptionScan row 3
echo -en x; echo '|'
## stdout: x|
## status: 0

#### Echo_BuiltinOptionScan row 4
echo -nx; echo '|'
## STDOUT:
-nx
|
## END
## status: 0

#### Echo_BuiltinOptionScan row 5
echo -- a
## stdout: -- a
## status: 0

#### Echo_BuiltinOptionScan row 6
echo -e -n x; echo '|'
## stdout: x|
## status: 0

#### Echo_BuiltinOptionScan row 7
echo -
## stdout: -
## status: 0

#### Echo_BuiltinOptionScan row 8
echo -E 'a\tb'
## stdout: a\tb
## status: 0

#### Echo_BuiltinOptionScan row 9
echo --help
## stdout: --help
## status: 0

#### Echo_BuiltinOptionScan row 10
echo -n- a
## stdout: -n- a
## status: 0

#### Echo_BuiltinOptionScan row 11
echo -neE 'x\ty'; echo '|'
## stdout: x\ty|
## status: 0

#### Echo_BuiltinOptionScan row 12
echo -e -- x
## stdout: -- x
## status: 0

#### Echo_BuiltinOptionScan row 13
echo -x -n a
## stdout: -x -n a
## status: 0

#### Echo_BuiltinOptionScan row 14
echo -e; echo '|'
## STDOUT:

|
## END
## status: 0

#### Echo_BuiltinOptionScan row 15
echo -e 'a\cb' c; echo '|'
## stdout: a|
## status: 0

#### Echo_BuiltinOptionScan row 16
echo -eE 'a\tb'
## stdout: a\tb
## status: 0

#### Echo_BuiltinOptionScan row 18
echo -e -E 'a\tb'
## stdout: a\tb
## status: 0

#### Echo_BuiltinOptionScan row 20
echo --version
## stdout: --version
## status: 0

#### Echo_BuiltinOptionScan row 21
echo -e-n x
## stdout: -e-n x
## status: 0

#### Echo_BuiltinOptionScan row 22
echo hello -n
## stdout: hello -n
## status: 0

#### Printf_BuiltinOptionScan row 1
printf -x 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 2
printf -v 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 3
printf -- 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 4
printf 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 5
printf -- -x; echo
## stdout: -x
## status: 0

#### Printf_BuiltinOptionScan row 6
printf -- '%s\n' -n
## stdout: -n
## status: 0

#### Printf_BuiltinOptionScan row 7
printf '%s\n' -n -v --
## STDOUT:
-n
-v
--
## END
## status: 0

#### Printf_BuiltinOptionScan row 8
printf -- --; echo
## stdout: --
## status: 0

#### Printf_BuiltinOptionScan row 9
printf -; echo
## stdout: -
## status: 0

#### Printf_BuiltinOptionScan row 10
printf -xv 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 11
printf '-n\n' 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 12
printf -v 1bad x 2>/dev/null; echo rc=$?
## stdout: rc=2
## status: 0

#### Printf_BuiltinOptionScan row 13
printf -v x '%s-%d' a 5; echo "x=[$x]"
## stdout: x=[a-5]
## status: 0

#### Printf_BuiltinOptionScan row 14
printf -v x '%s\n' a; echo "x=[$x]"
## STDOUT:
x=[a
]
## END
## status: 0

#### Printf_BuiltinOptionScan row 15
printf -v x -- '-%s' a; echo "x=[$x]"
## stdout: x=[-a]
## status: 0

#### Printf_BuiltinOptionScan row 16
printf -vx '%s' hi; echo "x=[$x]"
## stdout: x=[hi]
## status: 0

#### Printf_BuiltinOptionScan row 17
printf -v x -v y z; echo "x=[$x] y=[$y]"
## stdout: x=[] y=[z]
## status: 0

#### Printf_BuiltinOptionScan row 18
x=keep; printf -v x 2>/dev/null; echo "x=[$x] rc=$?"
## stdout: x=[keep] rc=2
## status: 0

#### Printf_BuiltinOptionScan row 19
printf -v x ''; echo "x=[$x]"
## stdout: x=[]
## status: 0

#### Printf_BuiltinOptionScan row 20
printf -v x '%s %s' a b c d; echo "x=[$x]"
## stdout: x=[a bc d]
## status: 0

#### Test_BuiltinHasNoOptions row 1
[ -n -e ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 2
[ -z -z ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 3
x=-f; [ "$x" = -f ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 4
x=-f; [ "$x" != -f ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 5
[ ! -z x ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 6
[ ! -n '' ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 7
[ -o ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 8
[ -a ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 9
[ -f = -f ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 10
[ -n -a -n ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 11
[ -n x -a -n y ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 12
[ -n x -a -z y ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 13
[ -z x -o -n y ]; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 18
[ -d -d ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 19
[ -w -w ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 20
[ x = -e ]; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 21
test -n -e; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 22
test -z -z; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 23
test -o; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 24
test ! -z x; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 25
test -a -a -a; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 26
test -o -o -o -o; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 27
test -n -n -a -n; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 28
test 5 -gt 3 -a 2 -lt 4; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 29
test x = -f; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 30
test --help; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 31
test --version; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 32
test -h; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 33
test a b 2>/dev/null; echo $?
## stdout: 2
## status: 0

#### Test_BuiltinHasNoOptions row 34
test 1 -eq x 2>/dev/null; echo $?
## stdout: 2
## status: 0

#### Test_BuiltinHasNoOptions row 35
test -n x y 2>/dev/null; echo $?
## stdout: 2
## status: 0

#### Test_BuiltinHasNoOptions row 36
test a = b c 2>/dev/null; echo $?
## stdout: 2
## status: 0

#### Test_BuiltinHasNoOptions row 37
test -n -n -n -n 2>/dev/null; echo $?
## stdout: 2
## status: 0

#### Test_BuiltinHasNoOptions row 38
test ! 2>/dev/null; echo $?
## stdout: 0
## status: 0

#### Test_BuiltinHasNoOptions row 39
test 2>/dev/null; echo $?
## stdout: 1
## status: 0

#### Test_BuiltinHasNoOptions row 40
test ''; echo $?
## stdout: 1
## status: 0

#### Eq
echo -E -e 'a\tb'
## stdout: a	b
## status: 0

#### Eq row 2
echo -Ee 'a\tb'
## stdout: a	b
## status: 0

#### Eq row 3
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --directory sub; cd /; rm -rf "$d"
## stdout: sub
## status: 0

#### Eq row 4
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --group; cd /; rm -rf "$d"
## STDOUT:
sub
a
b
c
## END
## status: 0

#### Eq row 5
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --sort=size; cd /; rm -rf "$d"
## STDOUT:
sub
b
c
a
## END
## status: 0

#### Eq row 6
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -1; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub
## END
## status: 0

#### Eq row 7
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --reverse; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 8
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -pF; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub/
## END
## status: 0

#### Eq row 9
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --color=auto; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub
## END
## status: 0

#### Eq row 10
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --classify=never; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub
## END
## status: 0

#### Eq row 11
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --sort=time; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 12
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -r; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 13
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -Fp; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub/
## END
## status: 0

#### Eq row 14
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --rev; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 15
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --sort=s; cd /; rm -rf "$d"
## STDOUT:
sub
b
c
a
## END
## status: 0

#### Eq row 16
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --classify; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub/
## END
## status: 0

#### Eq row 17
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -1 -r -S; cd /; rm -rf "$d"
## STDOUT:
a
c
b
sub
## END
## status: 0

#### Eq row 18
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -tS; cd /; rm -rf "$d"
## STDOUT:
sub
b
c
a
## END
## status: 0

#### Eq row 19
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --color=never; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub
## END
## status: 0

#### Eq row 20
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -F; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub/
## END
## status: 0

#### Eq row 21
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -Sr; cd /; rm -rf "$d"
## STDOUT:
a
c
b
sub
## END
## status: 0

#### Eq row 22
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls a -r b; cd /; rm -rf "$d"
## STDOUT:
b
a
## END
## status: 0

#### Eq row 23
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --group-directories-first; cd /; rm -rf "$d"
## STDOUT:
sub
a
b
c
## END
## status: 0

#### Eq row 24
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -tr; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub
## END
## status: 0

#### Eq row 25
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -d sub; cd /; rm -rf "$d"
## stdout: sub
## status: 0

#### Eq row 26
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -t; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 27
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -p; cd /; rm -rf "$d"
## STDOUT:
a
b
c
sub/
## END
## status: 0

#### Eq row 28
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -- a; cd /; rm -rf "$d"
## stdout: a
## status: 0

#### Eq row 29
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -S; cd /; rm -rf "$d"
## STDOUT:
sub
b
c
a
## END
## status: 0

#### Eq row 30
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -St; cd /; rm -rf "$d"
## STDOUT:
sub
c
b
a
## END
## status: 0

#### Eq row 31
[ -e -e ]; echo $?
## stdout: 1
## status: 0

#### Eq row 32
[ ! -z x -a ! -z y ]; echo $?
## stdout: 0
## status: 0

#### Eq row 33
d=$(mktemp -d) && printf '' > "$d/a" && test "$d/a" -ef "$d/a"; echo $?; test "$d/a" -nt "$d/missing"; echo $?; test "$d/missing" -ot "$d/a"; echo $?
## STDOUT:
0
0
0
## END
## status: 0

#### Eq row 34
d=$(mktemp -d) && printf '' > "$d/f" && test -s "$d/f"; echo $?; echo x > "$d/f"; test -s "$d/f"; echo $?; test -r "$d/f" -a -w "$d/f"; echo $?
## STDOUT:
1
0
0
## END
## status: 0

#### Eq row 35
[ \( -n x \) -a -n y ]; echo $?
## stdout: 0
## status: 0

#### Eq row 36
d=$(mktemp -d) && printf '' > "$d/f" && mkdir "$d/dir" && test -e "$d/f" -a -d "$d/dir"; echo $?; test -e "$d/nope" -o -f "$d/f"; echo $?; test -w "$d/nope"; echo $?; ls "$d"
## STDOUT:
0
0
1
dir
f
## END
## status: 0

#### Eq row 37
[ 1 -eq 1 -a 2 -lt 3 ]; echo $?
## stdout: 0
## status: 0

#### Eq row 38
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -- -x 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 39
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --sort=bogus 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=1
## status: 0

#### Eq row 40
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --color=bogus 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=1
## status: 0

#### Eq row 41
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --a 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 42
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --dir 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 43
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --classify=bogus 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=1
## status: 0

#### Eq row 44
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls nosuch 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 45
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --sort 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 46
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --c 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 47
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls -Y 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0

#### Eq row 48
d=$(mktemp -d) && cd "$d" && mkdir sub && printf 'x' > a && printf 'yyyyyyyyyy' > b && printf 'zzz' > c && touch -t 202001010000 a && touch -t 202101010000 b && touch -t 202201010000 c; ls --nope 2>/dev/null; echo rc=$?; cd /; rm -rf "$d"
## stdout: rc=2
## status: 0
