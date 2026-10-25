## Absorbed from Differential.Tests/MvOptionsDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Mv_Backup_BareLongOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --backup a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./b QQo=
F ./b~ Qgo=
D ./d
## END
## status: 0

#### Mv_Update_All
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -d '2020-01-01' a; mv -v --update=all a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b'
== exit 0
== fs
D .
F ./b QQo=
D ./d
## END
## status: 0

#### Mv_NoTargetDirectory_OntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -T a d
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
D ./d
## END
## status: 0

#### Mv_Backup_VersionControlEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
VERSION_CONTROL=numbered mv -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b.~1~')
== exit 0
== fs
D .
F ./b QQo=
F ./b.~1~ Qgo=
D ./d
## END
## status: 0

#### Mv_Update_BadWord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv --update=sometimes a b
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
D ./d
## END
## status: 0

#### Mv_Backup_OverwritesAnOldSimpleBackup
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'OLD' > 'b~'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./b QQo=
F ./b~ Qgo=
## END
## status: 0

#### Mv_Update_None
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --update=none a b
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
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Mv_Interactive_NewDestination_NoPrompt
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -vi a n </dev/null
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'n'
== exit 0
== fs
D .
F ./b Qgo=
D ./d
F ./n QQo=
## END
## status: 0

#### Mv_Backup_NoneAndOff
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --backup=none a b; echo C > a; mv -v --backup=off a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b'
renamed 'a' -> 'b'
== exit 0
== fs
D .
F ./b Qwo=
## END
## status: 0

#### Mv_Interactive_Yes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | mv -vi a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b'
== exit 0
== fs
D .
F ./b QQo=
D ./d
## END
## status: 0

#### Mv_Backup_Numbered
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --backup=numbered a b; echo C > a; mv -v --backup=t a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b.~1~')
renamed 'a' -> 'b' (backup: 'b.~2~')
== exit 0
== fs
D .
F ./b Qwo=
F ./b.~1~ Qgo=
F ./b.~2~ QQo=
## END
## status: 0

#### Mv_TargetDirectory_Missing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -t nodir a
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
D ./d
## END
## status: 0

#### Mv_Backup_SimpleBackupSuffixEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
SIMPLE_BACKUP_SUFFIX=.s mv -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b.s')
== exit 0
== fs
D .
F ./b QQo=
F ./b.s Qgo=
D ./d
## END
## status: 0

#### Mv_Update_EqualTimesKept
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -d '2020-01-01' a b; mv -uv a b
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
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Mv_Verbose
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'n'
== exit 0
== fs
D .
F ./b Qgo=
D ./d
F ./n QQo=
## END
## status: 0

#### Mv_TargetDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -vt d a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'd/a'
renamed 'b' -> 'd/b'
== exit 0
== fs
D .
D ./d
F ./d/a QQo=
F ./d/b Qgo=
## END
## status: 0

#### Mv_Interactive_LastOfINWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -i -n a b </dev/null; mv -n -i a b </dev/null; mv -i -f a b </dev/null
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
F ./b QQo=
D ./d
## END
## status: 0

#### Mv_TargetDirectory_NotADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -t b a
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
D ./d
## END
## status: 0

#### Mv_Update_Older
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -d '2020-01-01' b; mv -v --update=older a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b'
== exit 0
== fs
D .
F ./b QQo=
D ./d
## END
## status: 0

#### Mv_NoTargetDirectory_ExtraOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -T a b d
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
D ./d
## END
## status: 0

#### Mv_Interactive_No
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | mv -vi a b
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
D ./d
## END
## status: 0

#### Mv_TargetDirectory_Long
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --target-directory=d a
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'd/a'
== exit 0
== fs
D .
F ./b Qgo=
D ./d
F ./d/a QQo=
## END
## status: 0

#### Mv_Backup_LongSuffixOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --backup=simple --suffix=_x a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b_x')
== exit 0
== fs
D .
F ./b QQo=
F ./b_x Qgo=
D ./d
## END
## status: 0

#### Mv_Backup_IntoADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'd'
printf '%s\n' 'OLD' > 'd/a'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -bv a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'd/a' (backup: 'd/a~')
== exit 0
== fs
D .
D ./d
F ./d/a QQo=
F ./d/a~ T0xECg==
## END
## status: 0

#### Mv_NoTargetDirectory_PlainRename
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -vT a z
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'z'
== exit 0
== fs
D .
F ./b Qgo=
D ./d
F ./z QQo=
## END
## status: 0

#### Mv_Update_OlderSourceKept
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -d '2020-01-01' a; mv -uv a b
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
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Mv_Update_NewerSourceReplaces
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -d '2020-01-01' b; mv -uv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b'
== exit 0
== fs
D .
F ./b QQo=
D ./d
## END
## status: 0

#### Mv_Backup_SuffixOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -bvS .bak a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b.bak')
== exit 0
== fs
D .
F ./b QQo=
F ./b.bak Qgo=
D ./d
## END
## status: 0

#### Mv_Backup_ExistingPicksNumberedOnlyWhenOneExists
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v --backup=existing a b; echo C > a; mv -v --backup=numbered a b; echo D > a; mv -v --backup=existing a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b~')
renamed 'a' -> 'b' (backup: 'b.~1~')
renamed 'a' -> 'b' (backup: 'b.~2~')
== exit 0
== fs
D .
F ./b RAo=
F ./b.~1~ QQo=
F ./b.~2~ Qwo=
F ./b~ Qgo=
## END
## status: 0

#### Mv_TargetAndNoTarget_Conflict
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -t d -T a
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
D ./d
## END
## status: 0

#### Mv_Interactive_EmptyStdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -vi a b </dev/null
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
D ./d
## END
## status: 0

#### Mv_Backup_BadControlWord_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv --backup=bogus a b
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
D ./d
## END
## status: 0

#### Mv_Suffix_AloneTurnsBackupsOn
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -vS .zz a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b.zz')
== exit 0
== fs
D .
F ./b QQo=
F ./b.zz Qgo=
D ./d
## END
## status: 0

#### Mv_Verbose_IntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -v a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'd/a'
== exit 0
== fs
D .
F ./b Qgo=
D ./d
F ./d/a QQo=
## END
## status: 0

#### Mv_Backup_Simple
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./b QQo=
F ./b~ Qgo=
D ./d
## END
## status: 0

#### Mv_Backup_NoExistingDestination_MakesNone
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv -bv a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
renamed 'a' -> 'n'
== exit 0
== fs
D .
F ./n QQo=
## END
## status: 0
