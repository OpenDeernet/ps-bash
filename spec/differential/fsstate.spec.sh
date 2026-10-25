## Absorbed from Differential.Tests/FsStateDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Tee_PrintfWithoutNewline_FileBytesAreExactlyTheInput
printf x | tee f
## stdout-json: "x"
## status: 0

#### Tee_DoubleDash_DashNamedFileIsAnOperand
printf 'hi\n' | tee -- -zz
## stdout: hi
## status: 0

#### Mkdir_Mode_CreatesTheDirectories
mkdir -m 755 a; mkdir --mode=u=rwx,go=rx b; mkdir -pm 700 p/q/r; mkdir -m 0777 c
## stdout:
## status: 0

#### Touch_Stamp_OrdersFilesByModificationTime
touch -t 202401021530 a; touch -t 202401021531 b; touch -t 202401021529.30 c; touch -t 2401021532 d; ls -t
## STDOUT:
d
b
a
c
## END
## status: 0

#### Touch_NoDereference_DoesNotCreateAMissingName
touch -h nosuch; echo r1=$?; touch -hc nosuch2; echo r2=$?; touch --no-dereference plain; echo r3=$?
## STDOUT:
r1=1
r2=0
r3=1
## END
## status: 0

#### Redirect_PrintfWithoutNewline_FileBytesAreExactlyTheInput
printf x > f
## stdout:
## status: 0

#### Redirect_PrintfNulEscape_FileHoldsARealNulByte
printf 'x\0' > f
## stdout:
## status: 0

#### Redirect_PrintfOctalEscapes_FileBytesMatch
printf 'a\101\0101b\n' > f; printf '%b' 'p\0101q' > g
## stdout:
## status: 0

#### Redirect_EchoEOctalAndNul_FileBytesMatch
echo -e 'a\0101b\0c\101' > f
## stdout:
## status: 0

#### Redirect_EchoDashN_FileBytesAreExactlyTheInput
echo -n x > f
## stdout:
## status: 0

#### Redirect_Append_PrintfThenPrintf_Concatenates
printf a > f; printf b >> f
## stdout:
## status: 0

#### Redirect_PrintfMultiLine_NoFinalNewline
printf 'a\nb' > f
## stdout:
## status: 0

#### Redirect_BraceGroupMixedRecords_OnlyLastLosesNewline
{ echo x; printf y; } > f
## stdout:
## status: 0

#### Redirect_PlainEcho_KeepsNewline
echo x > f
## stdout:
## status: 0

#### Rm_ExplicitPreserveRootOnRoot_IsRefused
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --preserve-root / 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: it is dangerous to operate recursively on '/'
rm: use --no-preserve-root to override this failsafe
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Mkdir_InvalidMode_ExitsOneAndCreatesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
mkdir -m 999 d; echo "one=$?"; mkdir -m rwx a b; echo "two=$?"; mkdir -m '' e; echo "three=$?"
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
one=1
two=1
three=1
== exit 0
== fs
D .
F ./keep awo=
## END
## status: 0

#### Ln_SeveralTargets_IntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v a b e
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'e/a' => 'a'
'e/b' => 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
F ./e/a QQo=
F ./e/b Qgo=
## END
## status: 0

#### Ln_TargetAndNoTargetDirectory_Conflict
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -t e -T a 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: cannot combine --target-directory and --no-target-directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Mkdir_ModeOnExistingDirectory_IsFileExists
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
mkdir -m 700 d; echo "rc=$?"
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Mv_SourceIntoItsOwnParent_KeepsSource
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/src'
printf '%s\n' 'payload' > 'p/src/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv p/src p
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
D ./p/src
F ./p/src/f cGF5bG9hZAo=
## END
## status: 0

#### Ln_HardLink_MissingTarget
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln missing z 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: failed to access 'missing': No such file or directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Tee_PrintfWithoutNewline_FileBytesAreExactlyTheInput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf x | tee f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
x== exit 0
== fs
D .
F ./f eA==
## END
## status: 0

#### Touch_Stamp_OrdersFilesByModificationTime
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t 202401021530 a; touch -t 202401021531 b; touch -t 202401021529.30 c; touch -t 2401021532 d; ls -t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d
b
a
c
== exit 0
== fs
D .
F ./a 
F ./b 
F ./c 
F ./d 
## END
## status: 0

#### Rm_InteractiveWhen_NeverAlwaysAndBare
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | rm --interactive=never a; echo n | rm --interactive=always b; echo n | rm --interactive c
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
F ./b Qgo=
F ./c Qwo=
## END
## status: 0

#### Rm_Interactive_OneAnswerPerOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'y\nn\nyes\n' | rm -i a b c
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
F ./b Qgo=
## END
## status: 0

#### Rm_LastRootOptionWins_PreserveRootAfterNoPreserveRoot
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --no-preserve-root --preserve-root / 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: it is dangerous to operate recursively on '/'
rm: use --no-preserve-root to override this failsafe
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Cp_SeveralSourcesToMissingDestination_ErrorsAndWritesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a b result
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

#### Tee_DoubleDash_DashNamedFileIsAnOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'hi\n' | tee -- -zz
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
hi
== exit 0
== fs
D .
F ./-zz aGkK
## END
## status: 0

#### CpMv_HardLinksIntoADirectory_AreFine
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
mkdir -p 'd'
mkdir -p 'e'
ln a h
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a h d; echo r1=$?; mv a h e; echo r2=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r1=0
r2=0
== exit 0
== fs
D .
D ./d
F ./d/a QQo=
F ./d/h QQo=
D ./e
F ./e/a QQo=
F ./e/h QQo=
## END
## status: 0

#### Redirect_EchoDashN_FileBytesAreExactlyTheInput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
echo -n x > f
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
F ./f eA==
## END
## status: 0

#### Mv_DiagnosticsQuoteOperandsAsTyped
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv nosuch dst 2>&1; mv s ./s 2>&1; mv d d/x 2>&1; mv s nodir/x 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
mv: cannot stat 'nosuch': No such file or directory
mv: 's' and './s' are the same file
mv: cannot move 'd' to a subdirectory of itself, 'd/x'
mv: cannot move 's' to 'nodir/x': No such file or directory
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
F ./s Uwo=
## END
## status: 0

#### Cp_NoClobber_OnHardLinkedOperands_IsASilentSkip
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
ln a h
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -n a h 2>/dev/null; echo r=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r=0
== exit 0
== fs
D .
F ./a QQo=
F ./h QQo=
## END
## status: 0

#### Ln_NoTargetDirectory_PlainName
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -Tv a z
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'z' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
F ./z QQo=
## END
## status: 0

#### Rm_BadPreserveRootArgument_RemovesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --preserve-root=bogus d 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: unrecognized --preserve-root argument: 'bogus'
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Rm_NoPreserveRoot_RemovesAnOrdinaryTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd/e'
printf '%s\n' 'x' > 'd/e/f'
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --no-preserve-root d
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
F ./keep awo=
## END
## status: 0

#### Ln_TargetDirectoryOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v -t e a b
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'e/a' => 'a'
'e/b' => 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
F ./e/a QQo=
F ./e/b Qgo=
## END
## status: 0

#### Touch_TimeWord_OnlyTheNamedTimeMoves
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'o' > 'old'
printf '%s\n' 'm' > 'mid'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t 200101010000 old mid; touch --time=mtime -t 202401021530 mid; ls -t; echo r=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
mid
old
r=0
== exit 0
== fs
D .
F ./mid bQo=
F ./old bwo=
## END
## status: 0

#### Rm_Interactive_NoAnswerIsNo
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '' | rm -i a
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
## END
## status: 0

#### Rm_InteractiveOnce_ThreeFiles_DoesNotAsk
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | rm -I a b c
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
## END
## status: 0

#### Ln_SingleOperand_ExistingName_Fails
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln a 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: failed to create hard link './a': File exists
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Ln_NoTargetDirectory_DoesNotDescendIntoDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -T a d 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: failed to create hard link 'd': File exists
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Mkdir_Mode_CreatesTheDirectories
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
mkdir -m 755 a; mkdir --mode=u=rwx,go=rx b; mkdir -pm 700 p/q/r; mkdir -m 0777 c
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
D ./a
D ./b
D ./c
D ./p
D ./p/q
D ./p/q/r
## END
## status: 0

#### Rm_OneFileSystem_RemovesAnOrdinaryTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd/a'
printf '%s\n' 'x' > 'd/a/f'
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rv --one-file-system d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
removed 'd/a/f'
removed directory 'd/a'
removed directory 'd'
== exit 0
== fs
D .
F ./keep awo=
## END
## status: 0

#### Ln_SingleOperand_LinksBasenameIntoCwd
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v d/c
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'./c' => 'd/c'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
F ./c Qwo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Redirect_PrintfMultiLine_NoFinalNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\nb' > f
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
F ./f YQpi
## END
## status: 0

#### Rm_RecursiveVerbose_DirectoriesAreReportedAsRemovedDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rv d
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
removed 'd/f'
removed directory 'd'
== exit 0
== fs
D .
## END
## status: 0

#### Redirect_PlainEcho_KeepsNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
echo x > f
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
F ./f eAo=
## END
## status: 0

#### Redirect_BraceGroupMixedRecords_OnlyLastLosesNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
{ echo x; printf y; } > f
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
F ./f eAp5
## END
## status: 0

#### Redirect_EchoEOctalAndNul_FileBytesMatch
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
echo -e 'a\0101b\0c\101' > f
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
F ./f YUFiAGNcMTAxCg==
## END
## status: 0

#### Cp_DiagnosticsQuoteOperandsAsTyped
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
mkdir -p 'd1'
printf '%s\n' 'x' > 'd1/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp nosuch dst 2>&1; cp d1 dst 2>&1; cp s ./s 2>&1; cp s d1/../s 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cp: cannot stat 'nosuch': No such file or directory
cp: -r not specified; omitting directory 'd1'
cp: 's' and './s' are the same file
cp: 's' and 'd1/../s' are the same file
== exit 1
== fs
D .
D ./d1
F ./d1/f eAo=
F ./s Uwo=
## END
## status: 0

#### Cp_RecursiveNoClobber_TraversesAndSkipsOnlyConflicts
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's/x'
printf '%s\n' 'new1' > 's/x/f1'
mkdir -p 's/x'
printf '%s\n' 'new2' > 's/x/f2'
mkdir -p 't/s/x'
printf '%s\n' 'old1' > 't/s/x/f1'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rn s t
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
F ./s/x/f1 bmV3MQo=
F ./s/x/f2 bmV3Mgo=
D ./t
D ./t/s
D ./t/s/x
F ./t/s/x/f1 b2xkMQo=
F ./t/s/x/f2 bmV3Mgo=
## END
## status: 0

#### Ln_HardLink_DirectoryTarget
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln d z 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: d: hard link not allowed for directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Redirect_PrintfOctalEscapes_FileBytesMatch
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\101\0101b\n' > f; printf '%b' 'p\0101q' > g
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
F ./f YUEIMWIK
F ./g cEFx
## END
## status: 0

#### Rm_DashD_RemovesEmptyDirsAndFiles_RefusesNonEmpty
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'e'
mkdir -p 'ne'
printf '%s\n' 'x' > 'ne/g'
printf '%s\n' 'x' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -d e ne f 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: cannot remove 'ne': Directory not empty
== exit 1
== fs
D .
D ./ne
F ./ne/g eAo=
## END
## status: 0

#### Cp_HardLinkedOperands_AreTheSameFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
ln a h
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a h 2>&1; echo r1=$?; cp h a 2>&1; echo r2=$?; cp -f a ./h 2>&1; echo r3=$?; cp -u a h 2>&1; echo r4=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cp: 'a' and 'h' are the same file
r1=1
cp: 'h' and 'a' are the same file
r2=1
cp: 'a' and './h' are the same file
r3=1
cp: 'a' and 'h' are the same file
r4=1
== exit 0
== fs
D .
F ./a QQo=
F ./h QQo=
## END
## status: 0

#### Mv_DirOntoNonEmptyDirectory_Refused
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'moved' > 's/moved'
mkdir -p 't/s'
printf '%s\n' 'old' > 't/s/keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
mv s t
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
D ./s
F ./s/moved bW92ZWQK
D ./t
D ./t/s
F ./t/s/keep b2xkCg==
## END
## status: 0

#### Cp_MissingDestinationParent_ErrorsAndCreatesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp s nodir/x 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cp: cannot create regular file 'nodir/x': No such file or directory
== exit 1
== fs
D .
F ./s Uwo=
## END
## status: 0

#### Redirect_PrintfNulEscape_FileHoldsARealNulByte
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\0' > f
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
F ./f eAA=
## END
## status: 0

#### Redirect_PrintfWithoutNewline_FileBytesAreExactlyTheInput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf x > f
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
F ./f eA==
## END
## status: 0

#### Rm_PreserveRootAll_RemovesAnOrdinaryTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd/e'
printf '%s\n' 'x' > 'd/e/f'
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --preserve-root=all d
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
F ./keep awo=
## END
## status: 0

#### Ln_NoTargetDirectory_ExtraOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -T a z y 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: extra operand 'y'
Try 'ln --help' for more information.
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Cp_RecursiveForce_MergesAndKeepsDestinationOnlyFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'src/proj'
printf '%s\n' 'n' > 'src/proj/new'
mkdir -p 'dst/proj'
printf '%s\n' 'old' > 'dst/proj/new'
mkdir -p 'dst/proj'
printf '%s\n' 'keep' > 'dst/proj/only'
mkdir -p 'dst/proj/nested'
printf '%s\n' 'keep-deep' > 'dst/proj/nested/deep'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp -rf src/proj dst
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
D ./dst
D ./dst/proj
D ./dst/proj/nested
F ./dst/proj/nested/deep a2VlcC1kZWVwCg==
F ./dst/proj/new bgo=
F ./dst/proj/only a2VlcAo=
D ./src
D ./src/proj
F ./src/proj/new bgo=
## END
## status: 0

#### Touch_NoDereference_DoesNotCreateAMissingName
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
touch -h nosuch; echo r1=$?; touch -hc nosuch2; echo r2=$?; touch --no-dereference plain; echo r3=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r1=1
r2=0
r3=1
== exit 0
== fs
D .
## END
## status: 0

#### Redirect_Append_PrintfThenPrintf_Concatenates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf a > f; printf b >> f
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
F ./f YWI=
## END
## status: 0

#### Ln_TwoOperands_LinkNameIsDirectory_LinksInside
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v a e
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'e/a' => 'a'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
F ./e/a QQo=
## END
## status: 0

#### Rm_LastOfFAndIWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '1' > 'z1'
printf '%s\n' '2' > 'z2'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | rm -if z2; echo n | rm -fi z1
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
F ./z1 MQo=
## END
## status: 0

#### Rm_DotDotOperand_IsNeverRemoved
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cd d && rm -r .. 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: refusing to remove '.' or '..' directory: skipping '..'
== exit 1
== fs
D .
F ./f eAo=
## END
## status: 0

#### Rm_InteractiveOnce_Recursive_AsksEvenForOneArgument
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'k/l'
printf '%s\n' 'x' > 'k/l/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | rm -I -r k
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
D ./k
D ./k/l
F ./k/l/f eAo=
## END
## status: 0

#### Rm_DiagnosticsQuoteOperandsAsTyped
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd1'
printf '%s\n' 'x' > 'd1/f'
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm nosuch ./nosuch2 d1 nosuch/x 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: cannot remove 'nosuch': No such file or directory
rm: cannot remove './nosuch2': No such file or directory
rm: cannot remove 'd1': Is a directory
rm: cannot remove 'nosuch/x': No such file or directory
== exit 1
== fs
D .
D ./d1
F ./d1/f eAo=
F ./keep awo=
## END
## status: 0

#### Touch_InvalidStampOrConflictingSources_ExitOneAndCreateNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'k' > 'keep'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t bad f; echo r1=$?; touch -t 202401021530 -d 2020-01-01 g; echo r2=$?; touch --time=bogus h; echo r3=$?; touch -t 202401021530.61 i; echo r4=$?; touch -t 202302291200 j; echo r5=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r1=1
r2=1
r3=1
r4=1
r5=1
== exit 0
== fs
D .
F ./keep awo=
## END
## status: 0

#### Rm_DashRD_RemovesANonEmptyTree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'ne/x'
printf '%s\n' 'x' > 'ne/x/g'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rd ne
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
## END
## status: 0

#### Rm_InteractiveOnce_FourFilesDeclined_KeepsEverything
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
printf '%s\n' 'C' > 'c'
printf '%s\n' 'D' > 'd'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo n | rm -I a b c d
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
F ./c Qwo=
F ./d RAo=
## END
## status: 0

#### Ln_SeveralTargets_OneExists_OthersStillLinked
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'e'
printf '%s\n' 'OLD' > 'e/a'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln a b e 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: failed to create hard link 'e/a': File exists
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./e
F ./e/a T0xECg==
F ./e/b Qgo=
## END
## status: 0

#### Ln_SeveralTargets_LastOperandIsFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln a b b 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: target 'b': Not a directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Rm_InteractiveRecursive_DecliningADescentKeepsTheSubtree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'p/q/r'
printf '%s\n' 'x' > 'p/q/r/f'
mkdir -p 'p'
printf '%s\n' 't' > 'p/top'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'y\nn\ny\n' | rm -ir p
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
D ./p
D ./p/q
D ./p/q/r
F ./p/q/r/f eAo=
## END
## status: 0

#### Cp_Preserve_ListAndOrder
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t 200101010000 s; cp --preserve=mode,timestamps s a; cp --preserve=ownership,links,xattr s b; cp --preserve=timestamps --no-preserve=timestamps s c; cp --no-preserve=timestamps --preserve=timestamps s d; find . -newer s | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
.
./b
./c
== exit 0
== fs
D .
F ./a Uwo=
F ./b Uwo=
F ./c Uwo=
F ./d Uwo=
F ./s Uwo=
## END
## status: 0

#### Rm_DotOperand_IsNeverRemoved
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cd d && rm -rf . 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: refusing to remove '.' or '..' directory: skipping '.'
== exit 1
== fs
D .
F ./f eAo=
## END
## status: 0

#### Rm_TrailingDotComponent_IsNeverRemoved
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r d/. 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: refusing to remove '.' or '..' directory: skipping 'd/.'
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Cp_Preserve_ErrorsExitOneAndCopyNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
} >/dev/null 2>&1
echo '== stdout'
{ :
cp --preserve=context s x; echo r1=$?; cp --preserve=bogus s y; echo r2=$?; cp --preserve= s z; echo r3=$?; cp --no-preserve s w; echo r4=$?; cp --preserve=mode,bogus s v; echo r5=$?; cp --preserve=mode,context s u; echo r6=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
r1=1
r2=1
r3=1
r4=1
r5=1
r6=1
== exit 0
== fs
D .
F ./s Uwo=
## END
## status: 0

#### Ln_SeveralTargets_LastOperandMissing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln a b nodir 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: target 'nodir': No such file or directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Rm_RecursiveForceOnDoubleSlash_NamesTheSameAsRoot
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rf // 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: it is dangerous to operate recursively on '//' (same as '/')
rm: use --no-preserve-root to override this failsafe
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Rm_RecursiveOnRoot_IsRefused
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r / 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: it is dangerous to operate recursively on '/'
rm: use --no-preserve-root to override this failsafe
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Cp_Preserve_Recursive_TimestampsOfTheTreeStayOld
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 's'
printf '%s\n' 'F' > 's/f'
printf '%s\n' 'R' > 'ref'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t 200101010000 s/f ref; touch -t 200101010000 s; cp -r --preserve=timestamps s t; cp -r s u; find t u -newer ref | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
u
u/f
== exit 0
== fs
D .
F ./ref Ugo=
D ./s
F ./s/f Rgo=
D ./t
F ./t/f Rgo=
D ./u
F ./u/f Rgo=
## END
## status: 0

#### Mv_HardLinkedOperands_AreTheSameFile_BothNamesRemain
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
ln a h
} >/dev/null 2>&1
echo '== stdout'
{ :
mv a h 2>&1; echo r1=$?; mv -f h a 2>&1; echo r2=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
mv: 'a' and 'h' are the same file
r1=1
mv: 'h' and 'a' are the same file
r2=1
== exit 0
== fs
D .
F ./a QQo=
F ./h QQo=
## END
## status: 0

#### Redirect_EmptyPrintf_TruncatesExistingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'OLD' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '' > f
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
F ./f 
## END
## status: 0

#### Ln_SeveralTargets_TrailingSlashDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -v a b d/
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
'd/a' => 'a'
'd/b' => 'b'
== exit 0
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/a QQo=
F ./d/b Qgo=
F ./d/c Qwo=
D ./e
## END
## status: 0

#### Rm_AbbreviatedNoPreserveRoot_IsRefused
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'x' > 'd/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --no-pre d 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rm: you may not abbreviate the --no-preserve-root option
== exit 1
== fs
D .
D ./d
F ./d/f eAo=
## END
## status: 0

#### Rm_OneFileSystemAbbreviation
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd/a'
printf '%s\n' 'x' > 'd/a/f'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r --one d
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
## END
## status: 0

#### Cp_Preserve_OnlyTimestampPreservingCopiesStayOld
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'S' > 's'
} >/dev/null 2>&1
echo '== stdout'
{ :
touch -t 200101010000 s; cp s d1; cp --preserve=timestamps s d2; cp --no-preserve=all s d3; cp -p --no-preserve=timestamps s d4; cp --no-preserve=timestamps -p s d5; cp --preserve s d6; cp --preserve=mode s d7; cp --preserve=t s d8; cp --preserve=all --no-preserve=mode s d9; find . -newer s | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
.
./d1
./d3
./d4
./d7
== exit 0
== fs
D .
F ./d1 Uwo=
F ./d2 Uwo=
F ./d3 Uwo=
F ./d4 Uwo=
F ./d5 Uwo=
F ./d6 Uwo=
F ./d7 Uwo=
F ./d8 Uwo=
F ./d9 Uwo=
F ./s Uwo=
## END
## status: 0

#### Cp_DestinationDirectoryTrailingSlash_SameFileNamesJoinedTarget
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'S' > 'd/s'
} >/dev/null 2>&1
echo '== stdout'
{ :
cd d; cp s ./ 2>&1; cp s . 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cp: 's' and './s' are the same file
cp: 's' and './s' are the same file
== exit 1
== fs
D .
F ./s Uwo=
## END
## status: 0

#### Ln_TargetDirectoryOption_MissingDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'A' > 'a'
printf '%s\n' 'B' > 'b'
mkdir -p 'd'
printf '%s\n' 'C' > 'd/c'
mkdir -p 'e'
} >/dev/null 2>&1
echo '== stdout'
{ :
ln -t nodir a 2>&1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ln: failed to access 'nodir': No such file or directory
== exit 1
== fs
D .
F ./a QQo=
F ./b Qgo=
D ./d
F ./d/c Qwo=
D ./e
## END
## status: 0
