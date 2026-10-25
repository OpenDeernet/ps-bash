## Absorbed from Differential.Tests/CpOptionsDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Cp_UpdateNone_CopiesWhenMissing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --update=none a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
F ./n QQo=
## END
## status: 0

#### Cp_HardLink
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -lv a n; echo more >> n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
== exit 0
== fs
D .
F ./a QQptb3JlCg==
F ./n QQptb3JlCg==
## END
## status: 0

#### Cp_Interactive_No_ExitsOne
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | cp -i a b
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

#### Cp_UpdateOlder_DoesNotLiftNoClobber
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -n -u a b
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
## END
## status: 0

#### Cp_StripTrailingSlashes_PairFormKeepsTheSlash
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --strip-trailing-slashes a/ n
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

#### Cp_Parents_DestinationMustBeADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/q'
printf '%s\n' 'R' > 'p/q/r'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --parents p/q/r b
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
F ./b Qgo=
D ./p
D ./p/q
F ./p/q/r Ugo=
## END
## status: 0

#### Cp_Interactive_InARecursiveCopy
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'NEW' > 's/f'
mkdir -p 't/s'
printf '%s\n' 'OLD' > 't/s/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp -ri s t
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
D ./s
F ./s/f TkVXCg==
D ./t
D ./t/s
F ./t/s/f TkVXCg==
## END
## status: 0

#### Cp_Backup_IntoADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'd'
printf '%s\n' 'OLD' > 'd/a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bv a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'd/a' (backup: 'd/a~')
== exit 0
== fs
D .
F ./a QQo=
D ./d
F ./d/a QQo=
F ./d/a~ T0xECg==
## END
## status: 0

#### Cp_TargetDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -vt d a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'd/a'
'b' -> 'd/b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/a QQo=
F ./d/b Qgo=
## END
## status: 0

#### Cp_OneFileSystem_OrdinaryTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's/x'
printf '%s\n' 'F' > 's/x/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rxv s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't'
's/x' -> 't/x'
's/x/f' -> 't/x/f'
== exit 0
== fs
D .
D ./s
D ./s/x
F ./s/x/f Rgo=
D ./t
D ./t/x
F ./t/x/f Rgo=
## END
## status: 0

#### Cp_RemoveDestination_WithNoDestination
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --remove-destination a n
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
F ./n QQo=
## END
## status: 0

#### Cp_Backup_InARecursiveCopy
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'NEW' > 's/f'
mkdir -p 't/s'
printf '%s\n' 'OLD' > 't/s/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rbv s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's/f' -> 't/s/f' (backup: 't/s/f~')
== exit 0
== fs
D .
D ./s
F ./s/f TkVXCg==
D ./t
D ./t/s
F ./t/s/f TkVXCg==
F ./t/s/f~ T0xECg==
## END
## status: 0

#### Cp_Parents_SingleComponent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'out'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --parents a out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'out/a'
== exit 0
== fs
D .
F ./a QQo=
D ./out
F ./out/a QQo=
## END
## status: 0

#### Cp_Sparse_BadWord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --sparse=bogus a n
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

#### Cp_Backup_OverwritesAnOldSimpleBackup
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'OLD' > 'b~'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
## END
## status: 0

#### Cp_UpdateAll_AlwaysCopies
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 a
touch -d 2024-01-01 b
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --update=all a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
## END
## status: 0

#### Cp_Backup_SuffixOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bvS .bak a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b.bak')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.bak Qgo=
D ./d
## END
## status: 0

#### Cp_Backup_SimpleBackupSuffixEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
SIMPLE_BACKUP_SUFFIX=.s cp -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b.s')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.s Qgo=
D ./d
## END
## status: 0

#### Cp_Reflink_Always_FailsWhereNoFilesystemClones
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --reflink=always a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Cp_TargetDirectory_LongForm
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --target-directory=d a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'd/a'
'b' -> 'd/b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/a QQo=
F ./d/b Qgo=
## END
## status: 0

#### Cp_AttributesOnly_CreatesAnEmptyFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --attributes-only a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
== exit 0
== fs
D .
F ./a QQo=
F ./n 
## END
## status: 0

#### Cp_Reflink_BareMeansAlways
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --reflink a n
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

#### Cp_Reflink_BadWord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --reflink=bogus a n
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

#### Cp_UpdateAll_OverridesAnEarlierNoClobber
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -n --update=all a b
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
F ./b QQo=
## END
## status: 0

#### Cp_Interactive_Yes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp -iv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_Interactive_EofIsNo
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -i a b < /dev/null
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

#### Cp_NoTargetDirectory_MergesATree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
mkdir -p 't'
printf '%s\n' 'G' > 't/g'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rvT s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's/f' -> 't/f'
== exit 0
== fs
D .
D ./s
F ./s/f Rgo=
D ./t
F ./t/f Rgo=
F ./t/g Rwo=
## END
## status: 0

#### Cp_Debug_Recursive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -r --debug s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't'
's/f' -> 't/f'
copy offload: yes, reflink: unsupported, sparse detection: no
== exit 0
== fs
D .
D ./s
F ./s/f Rgo=
D ./t
F ./t/f Rgo=
## END
## status: 0

#### Cp_HardLink_RecursiveLinksTheFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's/x'
printf '%s\n' 'F' > 's/x/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rlv s t; echo more >> t/x/f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't'
's/x' -> 't/x'
's/x/f' -> 't/x/f'
== exit 0
== fs
D .
D ./s
D ./s/x
F ./s/x/f Rgptb3JlCg==
D ./t
D ./t/x
F ./t/x/f Rgptb3JlCg==
## END
## status: 0

#### Cp_Backup_Numbered
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=numbered a b; cp -v --backup=t a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b.~1~')
'a' -> 'b' (backup: 'b.~2~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ Qgo=
F ./b.~2~ QQo=
D ./d
## END
## status: 0

#### Cp_Sparse_NeedsAnArgument
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --sparse a n
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

#### Cp_StripTrailingSlashes_FileWithSlashIntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --strip-trailing-slashes a/ d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'd/a'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/a QQo=
## END
## status: 0

#### Cp_UpdateUnknownWord_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --update=bogus a b
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
## END
## status: 0

#### Cp_Backup_ControlWordPrefixes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=nu a b; cp -v --backup=sim a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b.~1~')
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ Qgo=
F ./b~ QQo=
D ./d
## END
## status: 0

#### Cp_TargetDirectory_NoSources
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -t d
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

#### Cp_NoTargetDirectory_OntoADirectory_IsRefused
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -T a d
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

#### Cp_RecursiveVerbose_MergeIntoAnExistingTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'NEW' > 's/f'
mkdir -p 't/s'
printf '%s\n' 'OLD' > 't/s/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rv s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's/f' -> 't/s/f'
== exit 0
== fs
D .
D ./s
F ./s/f TkVXCg==
D ./t
D ./t/s
F ./t/s/f TkVXCg==
## END
## status: 0

#### Cp_TargetDirectory_NotADirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -t b a
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

#### Cp_UpdateNone_AfterUpdateAll
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --update=all --update=none a b
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
## END
## status: 0

#### Cp_AttributesOnly_KeepsAnExistingFilesContent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --attributes-only a b
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

#### Cp_HardLink_LongOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --link a n
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
F ./n QQo=
## END
## status: 0

#### Cp_Interactive_YesWord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo yes | cp -i a b
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
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_TrailingSlashOnAFile_WithoutTheFlag
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a/ d
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

#### Cp_RemoveDestination_BreaksAnExistingHardLink
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln b b2; cp --remove-destination a b; echo more >> b2
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
F ./b QQo=
F ./b2 Qgptb3JlCg==
## END
## status: 0

#### Cp_Parents_RecursiveDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/q'
printf '%s\n' 'R' > 'p/q/r'
mkdir -p 'out'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rv --parents p/q out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
p -> out/p
'p/q' -> 'out/p/q'
'p/q/r' -> 'out/p/q/r'
== exit 0
== fs
D .
D ./out
D ./out/p
D ./out/p/q
F ./out/p/q/r Ugo=
D ./p
D ./p/q
F ./p/q/r Ugo=
## END
## status: 0

#### Cp_Dereference_OptionsAreAcceptedWithoutLinks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -L a n1; cp -P a n2; cp -H a n3; cp -d a n4; cp --dereference a n5; cp --no-dereference a n6
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
F ./n1 QQo=
F ./n2 QQo=
F ./n3 QQo=
F ./n4 QQo=
F ./n5 QQo=
F ./n6 QQo=
## END
## status: 0

#### Cp_HardLink_Force_ReplacesIt
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -lfv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_Backup_NoExistingDestination_MakesNone
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bv a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
== exit 0
== fs
D .
F ./a QQo=
F ./n QQo=
## END
## status: 0

#### Cp_Backup_BareLongOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
D ./d
## END
## status: 0

#### Cp_Dereference_Recursive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rL s t1; cp -rP s t2; cp -rH s t3; cp -rd s t4
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
D ./s
F ./s/f Rgo=
D ./t1
F ./t1/f Rgo=
D ./t2
F ./t2/f Rgo=
D ./t3
F ./t3/f Rgo=
D ./t4
F ./t4/f Rgo=
## END
## status: 0

#### Cp_StripTrailingSlashes_FileIntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --strip-trailing-slashes a d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'd/a'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/a QQo=
## END
## status: 0

#### Cp_Reflink_AutoAndNever
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --reflink=auto a n1; cp -v --reflink=never a n2
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n1'
'a' -> 'n2'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./n1 QQo=
F ./n2 QQo=
## END
## status: 0

#### Cp_Backup_SimpleAndNever
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=simple a b; cp -v --backup=never a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ QQo=
D ./d
## END
## status: 0

#### Cp_UpdateEmptyWord_IsAmbiguous
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --update= a b
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
## END
## status: 0

#### Cp_Interactive_LongOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp --interactive a b
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
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_RecursiveVerbose_NamesEveryEntry
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's/x'
printf '%s\n' 'F' > 's/x/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rv s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't'
's/x' -> 't/x'
's/x/f' -> 't/x/f'
== exit 0
== fs
D .
D ./s
D ./s/x
F ./s/x/f Rgo=
D ./t
D ./t/x
F ./t/x/f Rgo=
## END
## status: 0

#### Cp_Interactive_AfterNoClobber_Asks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp -n -i a b
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
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_Interactive_NewDestinationDoesNotAsk
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | cp -i a n
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
F ./n QQo=
## END
## status: 0

#### Cp_Reflink_AbbreviatedWord
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --reflink=al a n
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

#### Cp_NoOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp
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

#### Cp_Debug_ReflinkNever
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --debug --reflink=never a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
copy offload: avoided, reflink: no, sparse detection: no
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./n QQo=
## END
## status: 0

#### Cp_MissingDestinationOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a
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

#### Cp_Backup_LongSuffixOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=simple --suffix=_x a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b_x')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b_x Qgo=
D ./d
## END
## status: 0

#### Cp_Backup_VersionControlNone
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
VERSION_CONTROL=none cp -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_Update_OlderDestination_IsReplaced
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -uv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
## END
## status: 0

#### Cp_UpdateNone_NeverReplaces
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --update=none a b
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
## END
## status: 0

#### Cp_Backup_NoneAndOff
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=none a b; cp -v --backup=off a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_UpdateBare_IsOlder
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 a
touch -d 2024-01-01 b
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --update a b
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
## END
## status: 0

#### Cp_NoTargetDirectory_FileOverFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -vT a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
D ./d
## END
## status: 0

#### Cp_Backup_SkippedByNoClobber
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bn a b
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

#### Cp_Sparse_WordsAreValidatedAndHarmless
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --sparse=auto a n1; cp --sparse=always a n2; cp --sparse=never a n3; cp --sparse=al a n4
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
F ./n1 QQo=
F ./n2 QQo=
F ./n3 QQo=
F ./n4 QQo=
## END
## status: 0

#### Cp_Backup_BadVersionControl_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
VERSION_CONTROL=bogus cp -b a b
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

#### Cp_UpdateNoneFail_IsNotAWordIn94
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 b
touch -d 2024-01-01 a
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --update=none-fail a b
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
## END
## status: 0

#### Cp_TargetAndNoTargetDirectory_Conflict
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -t d -T a
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

#### Cp_Parents
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/q'
printf '%s\n' 'R' > 'p/q/r'
mkdir -p 'out'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --parents p/q/r out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
p -> out/p
p/q -> out/p/q
'p/q/r' -> 'out/p/q/r'
== exit 0
== fs
D .
D ./out
D ./out/p
D ./out/p/q
F ./out/p/q/r Ugo=
D ./p
D ./p/q
F ./p/q/r Ugo=
## END
## status: 0

#### Cp_UpdateOlder_Named
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 a
touch -d 2024-01-01 b
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --update=older a b; cp -v --update=ol a b
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
## END
## status: 0

#### Cp_NoClobber_AfterInteractive_Skips
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp -i -n a b
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

#### Cp_Backup_AmbiguousControlWord_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --backup=n a b
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

#### Cp_HardLink_WithBackup
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -lbv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
D ./d
## END
## status: 0

#### Cp_Parents_MissingDestination
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/q'
printf '%s\n' 'R' > 'p/q/r'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --parents p/q/r nodir
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
D ./p
D ./p/q
F ./p/q/r Ugo=
## END
## status: 0

#### Cp_Backup_Simple
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b~ Qgo=
D ./d
## END
## status: 0

#### Cp_Debug_ImpliesVerbose
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --debug a n
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'n'
copy offload: yes, reflink: unsupported, sparse detection: no
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./n QQo=
## END
## status: 0

#### Cp_AttributesOnly_Recursive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's/x'
printf '%s\n' 'F' > 's/x/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -r --attributes-only s t
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
D ./s
D ./s/x
F ./s/x/f Rgo=
D ./t
D ./t/x
F ./t/x/f 
## END
## status: 0

#### Cp_Backup_ExistingPicksNumberedOnlyWhenOneExists
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -v --backup=existing a b; cp -v --backup=nil a b; cp -v --backup=numbered a b; cp -v --backup=existing a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b~')
'a' -> 'b' (backup: 'b~')
'a' -> 'b' (backup: 'b.~1~')
'a' -> 'b' (backup: 'b.~2~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ QQo=
F ./b.~2~ QQo=
F ./b~ QQo=
## END
## status: 0

#### Cp_Backup_VersionControlEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
VERSION_CONTROL=numbered cp -bv a b; VERSION_CONTROL=simple cp -bv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b' (backup: 'b.~1~')
'a' -> 'b' (backup: 'b~')
== exit 0
== fs
D .
F ./a QQo=
F ./b QQo=
F ./b.~1~ Qgo=
F ./b~ QQo=
D ./d
## END
## status: 0

#### Cp_NoTargetDirectory_ExtraOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -T a b d
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

#### Cp_HardAndSymbolic_AreExclusive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -l -s a n
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

#### Cp_Debug_SkippedFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --debug -n a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
skipped 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Cp_TargetDirectory_Missing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -t nodir a
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

#### Cp_TargetDirectory_OptionAfterSources
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a b -t d
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
F ./d/a QQo=
F ./d/b Qgo=
## END
## status: 0

#### Cp_Update_NewerDestination_IsKept
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 a
touch -d 2024-01-01 b
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -uv a b
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
## END
## status: 0

#### Cp_RecursiveVerbose_IntoAnExistingDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
mkdir -p 't'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rv s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't/s'
's/f' -> 't/s/f'
== exit 0
== fs
D .
D ./s
F ./s/f Rgo=
D ./t
D ./t/s
F ./t/s/f Rgo=
## END
## status: 0

#### Cp_HardLink_OntoAnExistingFile_Fails
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -lv a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'a' -> 'b'
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
## END
## status: 0

#### Cp_Backup_BadControlWord_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --backup=bogus a b
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

#### Cp_NoTargetDirectory_NewDestinationCreatesIt
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rvT s t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
's' -> 't'
's/f' -> 't/f'
== exit 0
== fs
D .
D ./s
F ./s/f Rgo=
D ./t
F ./t/f Rgo=
## END
## status: 0

#### Cp_Interactive_SkippedWhenUpdateKeepsIt
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
touch -d 2020-01-01 a
touch -d 2024-01-01 b
} >/dev/null 2>&1
echo '== stdout'
{ :
echo y | cp -iu a b
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
## END
## status: 0
