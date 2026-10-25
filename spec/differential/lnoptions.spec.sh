## Absorbed from Differential.Tests/LnOptionsDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Ln_Backup_NoExistingName_MakesNone
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bv a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'n' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./n QQo=
## END
## status: 0

#### Ln_Backup_NoneAndOff
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v --backup=none -f a b; ln -vf --backup=off c b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b' => 'a'
'b' => 'c'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qwo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_WithForce
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bfv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Relative_WithoutSymbolic_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -r a n
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
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Suffix_AloneTurnsBackupsOn
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -vS .zz a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b.zz' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.zz Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Interactive_No
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | ln -iv a b
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
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_VersionControlEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
VERSION_CONTROL=numbered ln -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b.~1~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_Numbered
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v --backup=numbered a b; ln -vf --backup=t c b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b.~1~' ~ 'b' => 'a'
'b.~2~' ~ 'b' => 'c'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qwo=
F ./b.~1~ Qgo=
F ./b.~2~ QQo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Interactive_NewName_NoPrompt
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -iv a n </dev/null
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'n' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
F ./n QQo=
## END
## status: 0

#### Ln_Interactive_WithBackup
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | ln -ibv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_BareLongOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v --backup a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Interactive_Yes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | ln -iv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_IntoADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'd'
printf '%s\n' 'OLD' > 'd/a'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bv a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'd/a~' ~ 'd/a' => 'a'
== exit 0
== fs
D .
F ./a QQo=
D ./d
F ./d/a QQo=
F ./d/a~ T0xECg==
## END
## status: 0

#### Ln_Relative_LongWithoutSymbolic_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln --relative a n; ln -v --rel a n
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
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_Simple
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_ExistingPicksNumberedOnlyWhenOneExists
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v --backup=existing a b; ln -v --backup=numbered c b; ln -v --backup=existing a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
'b.~1~' ~ 'b' => 'c'
'b.~2~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ QQo=
F ./b.~2~ Qwo=
F ./b~ Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_BadControlWord_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln --backup=bogus a b
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
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_SuffixOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bvS .bak a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b.bak' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.bak Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Backup_OverwritesAnOldSimpleBackup
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'OLD' > 'b~'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'b~' ~ 'b' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
## END
## status: 0

#### Ln_Interactive_LastOfIFWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | ln -if a b; echo n | ln -fi c b
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
F ./a QQo=
F ./b QQo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Interactive_EmptyStdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -iv a b </dev/null
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
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
## END
## status: 0

#### Ln_Interactive_IntoADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'd'
printf '%s\n' 'OLD' > 'd/a'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | ln -iv a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'd/a' => 'a'
== exit 0
== fs
D .
F ./a QQo=
D ./d
F ./d/a QQo=
## END
## status: 0
