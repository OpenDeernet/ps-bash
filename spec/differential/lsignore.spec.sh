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
