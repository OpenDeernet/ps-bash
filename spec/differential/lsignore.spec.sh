## Absorbed from Differential.Tests/LsIgnoreDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Ignore_Suffix
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I '*.c' | cat -A
## STDOUT:
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
## END
## status: 0

#### Ignore_Repeated
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I '*.c' -I '*.h' | cat -A
## STDOUT:
a b$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
## END
## status: 0

#### Ignore_LongForm
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --ignore='*.c' | cat -A; ls --ignore '*.h' | cat -A
## STDOUT:
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
a b$
alpha.c$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
## END
## status: 0

#### Ignore_Abbreviation_IsAmbiguousWithIgnoreBackups
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --ign='*.c'; echo rc=$?
## stdout: rc=2
## status: 0

#### Ignore_AppliesWithDashA
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -a -I '*.c' | cat -A
## STDOUT:
.$
..$
.cfg$
.hid$
.old~$
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
## END
## status: 0

#### Ignore_DotPatternRemovesHiddenAndDots
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -a -I '.*' | cat -A; ls -A -I '.*' | cat -A
## STDOUT:
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
## END
## status: 0

#### Ignore_ExactDot_RemovesOnlyDot
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -a -I '.' | cat -A
## STDOUT:
..$
.cfg$
.hid$
.old~$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
## END
## status: 0

#### Ignore_PatternForms
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I 'a*' | cat -A; ls -I '[a-c]*' | cat -A; ls -I '?eta*' | cat -A; ls -I 'noext' | cat -A; ls -I 'a b' | cat -A; ls -I '[!a-m]*' | cat -A
## STDOUT:
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
theta$
x.o$
z.a$
zeta.c$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
## END
## status: 0

#### Ignore_Everything
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I '*'; echo rc=$?
## stdout: rc=0
## status: 0

#### Ignore_NotAppliedToOperands
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I '*.c' alpha.c beta.h | cat -A
## STDOUT:
alpha.c$
beta.h$
## END
## status: 0

#### Ignore_NotAppliedToDirOperandItself
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I 'dd' dd | cat -A
## stdout: g.c$
## status: 0

#### Ignore_WithDashD
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -d -I '*.c' alpha.c beta.h | cat -A
## STDOUT:
alpha.c$
beta.h$
## END
## status: 0

#### Ignore_Recursive_SkipsIgnoredDirectories
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c; mkdir -p dd/x; printf '' > dd/x/f.c; printf '' > dd/x/f.h
ls -R -I 'x' dd | cat -A; ls -R -I '*.c' dd | cat -A
## STDOUT:
dd:$
g.c$
dd:$
x$
$
dd/x:$
f.h$
## END
## status: 0

#### Ignore_WithLong
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -l -I '*.c' | wc -l
## stdout: 13
## status: 0

#### Ignore_WithColumns
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -C -w 40 -I '*.c' | cat -A
## STDOUT:
a b^Idd^I      gamma   theta$
beta.h^Idelta.tar.gz  m.zz.b  x.o$
bk~^Iepsilon.txt   noext   z.a$
## END
## status: 0

#### Hide_Suffix
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --hide='*.c' | cat -A
## STDOUT:
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
## END
## status: 0

#### Hide_OverriddenByDashA
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -a --hide='*.c' | cat -A
## STDOUT:
.$
..$
.cfg$
.hid$
.old~$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
## END
## status: 0

#### Hide_AndIgnoreTogether
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --hide='*.c' -I '*.h' | cat -A
## STDOUT:
a b$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
## END
## status: 0

#### Hide_Abbreviation_IsAmbiguousWithHideControlChars
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --hi='*.c'; echo rc=$?
## stdout: rc=2
## status: 0

#### IgnoreBackups
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -B | cat -A; ls -aB | cat -A; ls --ignore-backups | cat -A
## STDOUT:
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
.$
..$
.cfg$
.hid$
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
## END
## status: 0

#### Error_IgnoreWithoutArgument
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls -I; echo rc=$?
## stdout: rc=2
## status: 0

#### Error_HideWithoutArgument
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
ls --hide; echo rc=$?
## stdout: rc=2
## status: 0

#### Ignore_Recursive_SkipsIgnoredDirectories
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c; mkdir -p dd/x; printf '' > dd/x/f.c; printf '' > dd/x/f.h
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -R -I 'x' dd | cat -A; ls -R -I '*.c' dd | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
dd:$
g.c$
dd:$
x$
$
dd/x:$
f.h$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
D ./dd/x
F ./dd/x/f.c 
F ./dd/x/f.h 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_WithDashD
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -d -I '*.c' alpha.c beta.h | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
alpha.c$
beta.h$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_DotPatternRemovesHiddenAndDots
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -a -I '.*' | cat -A; ls -A -I '.*' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_ExactDot_RemovesOnlyDot
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -a -I '.' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
..$
.cfg$
.hid$
.old~$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### IgnoreBackups
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -B | cat -A; ls -aB | cat -A; ls --ignore-backups | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
.$
..$
.cfg$
.hid$
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_LongForm
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --ignore='*.c' | cat -A; ls --ignore '*.h' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
a b$
alpha.c$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Hide_Suffix
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --hide='*.c' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_Abbreviation_IsAmbiguousWithIgnoreBackups
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --ign='*.c'; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_AppliesWithDashA
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -a -I '*.c' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
.$
..$
.cfg$
.hid$
.old~$
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Hide_OverriddenByDashAUpper
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -A --hide='*.c' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
.cfg$
.hid$
.old~$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_Repeated
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I '*.c' -I '*.h' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_NotAppliedToDirOperandItself
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I 'dd' dd | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
g.c$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_WithColumns
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -C -w 40 -I '*.c' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b^Idd^I      gamma   theta$
beta.h^Idelta.tar.gz  m.zz.b  x.o$
bk~^Iepsilon.txt   noext   z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Error_HideWithoutArgument
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --hide; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Hide_Abbreviation_IsAmbiguousWithHideControlChars
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --hi='*.c'; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_PatternForms
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I 'a*' | cat -A; ls -I '[a-c]*' | cat -A; ls -I '?eta*' | cat -A; ls -I 'noext' | cat -A; ls -I 'a b' | cat -A; ls -I '[!a-m]*' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
theta$
x.o$
z.a$
zeta.c$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
zeta.c$
a b$
alpha.c$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_Suffix
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I '*.c' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
beta.h$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_Everything
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I '*'; echo rc=$?
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
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Hide_AndIgnoreTogether
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --hide='*.c' -I '*.h' | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a b$
bk~$
dd$
delta.tar.gz$
epsilon.txt$
gamma$
m.zz.b$
noext$
theta$
x.o$
z.a$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_NotAppliedToOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I '*.c' alpha.c beta.h | cat -A
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
alpha.c$
beta.h$
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Ignore_WithLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l -I '*.c' | wc -l
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
13
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0

#### Error_IgnoreWithoutArgument
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in alpha.c beta.h gamma delta.tar.gz epsilon.txt zeta.c theta .hid 'bk~' x.o noext 'a b' z.a m.zz.b .cfg '.old~'; do printf '' > "$f"; done; mkdir dd; printf '' > dd/g.c
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -I; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./.cfg 
F ./.hid 
F ./.old~ 
F ./a b 
F ./alpha.c 
F ./beta.h 
F ./bk~ 
D ./dd
F ./dd/g.c 
F ./delta.tar.gz 
F ./epsilon.txt 
F ./gamma 
F ./m.zz.b 
F ./noext 
F ./theta 
F ./x.o 
F ./z.a 
F ./zeta.c 
## END
## status: 0
