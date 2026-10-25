## Absorbed from Differential.Tests/RmEmptyOperandDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Rm_RecursiveForce_UnsetVariable_DeletesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'keep' > 'file.txt'
mkdir -p 'sub'
printf '%s\n' 'keep' > 'sub/inner.txt'
printf '%s\n' 'x' > 'gone.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rf "$unset_var"; echo rc=$?
}
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
F ./file.txt a2VlcAo=
F ./gone.txt eAo=
D ./sub
F ./sub/inner.txt a2VlcAo=
## END
## status: 0

#### Rm_EmptyBesideRealOperand_RemovesOnlyTheRealOne
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'keep' > 'file.txt'
mkdir -p 'sub'
printf '%s\n' 'keep' > 'sub/inner.txt'
printf '%s\n' 'x' > 'gone.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -rf "" gone.txt; echo rc=$?
}
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
F ./file.txt a2VlcAo=
D ./sub
F ./sub/inner.txt a2VlcAo=
## END
## status: 0

#### Rm_Recursive_EmptyLiteral_ErrorsAndDeletesNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'keep' > 'file.txt'
mkdir -p 'sub'
printf '%s\n' 'keep' > 'sub/inner.txt'
printf '%s\n' 'x' > 'gone.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
rm -r ''; echo rc=$?
}
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
F ./file.txt a2VlcAo=
F ./gone.txt eAo=
D ./sub
F ./sub/inner.txt a2VlcAo=
## END
## status: 0
