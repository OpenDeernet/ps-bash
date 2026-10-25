## Absorbed from Differential.Tests/TarMembersDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Extract_MissingMember_StillExtractsTheRest
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xf a.tar -C x nosuch t.txt; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
F ./x/t.txt dG9wCg==
## END
## status: 0

#### Exclude_UnanchoredFileName
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='b.txt' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_StarSpansSlash
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='*b*' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_ByExtension
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='*.txt' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/other/
d/other/c.log
d/sub/
e/
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_Bracket
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards 'd/[a-b].txt'; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_Star
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards '*.txt' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
d/sub/b.txt
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_PatternWithoutWildcardsFlag_IsLiteral
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar 'd/*.txt'; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_UnanchoredComponent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='sub' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_Redirected_List
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar t < a.tar | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Extract_DirectoryMember
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xf a.tar -C x d/sub; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
D ./x/d/sub
F ./x/d/sub/b.txt Mgo=
## END
## status: 0

#### Wildcards_Question
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards 'd/?.txt'; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_DotSlashPrefixIsNotNormalised
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar ./t.txt; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Extract
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; printf 't.txt\ne/f.txt\n' > list; tar xf a.tar -C x -T list; rm list; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/e
F ./x/e/f.txt NAo=
F ./x/t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_MissingFile_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar -T nolist; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_ListPlusOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 't.txt\nd/sub\n' > list; tar tf a.tar -T list e/f.txt | sort; rm list; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/sub/
d/sub/b.txt
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Extract_MemberToStdout
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar xOf a.tar t.txt; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
top
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_DuplicateName_SecondIsNotFound
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar t.txt t.txt; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_MemberFilter
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; cat a.tar | tar tf - t.txt; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Extract_Exclude
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xf a.tar -C x --exclude='*.txt'; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
D ./x/d/other
F ./x/d/other/c.log Mwo=
D ./x/d/sub
D ./x/e
## END
## status: 0

#### Gzip_StdinWithZ
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar czf z.tgz d; cat z.tgz | tar tzf - | sort; rm z.tgz
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdout_DashF_PipedToExtract
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
mkdir x; tar cf - d | tar xf - -C x
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
F ./x/d/a.txt MQo=
D ./x/d/other
F ./x/d/other/c.log Mwo=
D ./x/d/sub
F ./x/d/sub/b.txt Mgo=
## END
## status: 0

#### Wildcards_MatchesLeadingDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards 'd/su?' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Stdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 't.txt\n' | tar tf a.tar -T -; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### ExcludeFrom_List
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf '*.log\nsub\n' > ex; tar tf a.tar -X ex | sort; rm ex; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Create_KeepsOperandOrder
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'd/a.txt\n' > list; tar cf b.tar t.txt -T list e/f.txt; tar tf b.tar; rm list b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
d/a.txt
e/f.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_EmptyLineIsSkipped_TrailingBlankIsKept
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 't.txt\n\ne/f.txt  \n' > list; tar tf a.tar -T list; rm list; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_Extract_Verbose
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xvf - -C x < a.tar | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
F ./x/d/a.txt MQo=
D ./x/d/other
F ./x/d/other/c.log Mwo=
D ./x/d/sub
F ./x/d/sub/b.txt Mgo=
D ./x/e
F ./x/e/f.txt NAo=
F ./x/t.txt dG9wCg==
## END
## status: 0

#### Create_Exclude_TopLevelDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf b.tar --exclude=d d t.txt; tar tf b.tar; rm b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Gzip_StdinWithoutZ_IsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar czf z.tgz d; cat z.tgz | tar tf -; rm z.tgz
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_MissingMember_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar nosuch; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_PathPrefix_ExcludesTheSubtree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='d/sub' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_ThenExclude
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards '*.txt' --exclude='d/*' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_NoTrailingNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 't.txt' > list; tar tf a.tar -T list; rm list; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Create_MissingEntry_KeepsTheRest
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'nosuch\nt.txt\n' > list; tar cf b.tar -T list; tar tf b.tar; rm list b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_WildcardLineWithoutFlag_IsLiteral
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 'd/*.txt\n' > list; tar tf a.tar -T list; rm list; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Create
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'd/a.txt\nt.txt\n' > list; tar cf b.tar -T list; tar tf b.tar; rm list b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_MemberToStdout
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; cat a.tar | tar xOf - t.txt; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
top
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_SingleCharacterPattern
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='?' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_List
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 't.txt\nd/sub\n' > list; tar tf a.tar -T list | sort; rm list; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/sub/
d/sub/b.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_DirectoryContents
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards 'd/*' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_MissingAndPresent_ListsThePresentOne
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar t.txt nosuch; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### ExcludeFrom_Create
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '*.log\nsub\n' > ex; tar cf c.tar -X ex d; tar tf c.tar | sort; rm ex c.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Extract_FileMembers_Verbose
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xvf a.tar -C x t.txt e/f.txt | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/e
F ./x/e/f.txt NAo=
F ./x/t.txt dG9wCg==
## END
## status: 0

#### Stdin_NoF_List
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; cat a.tar | tar t | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdout_NoF_PipedToList
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar c d t.txt | tar tf - | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Create_MissingSource_ExitsTwoAndKeepsTheRest
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf b.tar nosuch t.txt; tar tf b.tar; rm b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_StarCrossesSlash
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards '*/b.txt'; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_NoMatch_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --wildcards 'z*'; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_NoWildcards_IsLiteral
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --no-wildcards 'd/*.txt'; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_Create_Directory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'e\n' > list; tar cf b.tar -T list; tar tf b.tar; rm list b.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
e/
e/f.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Exclude_TopLevelDirectory
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar --exclude='d' | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Gzip_Stdout_PipedToList
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar czf - d | tar tzf - | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### FilesFrom_WildcardLineWithFlag
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf 'd/*.txt\n' > list; tar tf a.tar --wildcards -T list | sort; rm list; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/a.txt
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_FileMembers
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar t.txt e/f.txt | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### ExcludeFrom_MissingFile_Exit2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar -X noex; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_Empty_IsNotATarArchive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar t </dev/null
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_WholeDirectory_TrailingSlash
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar d/ | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Wildcards_Extract
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; tar xf a.tar -C x --wildcards '*.log'; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
D ./x/d/other
F ./x/d/other/c.log Mwo=
## END
## status: 0

#### ExcludeFrom_PlusExclude
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf '*.log\nsub\n' > ex; tar tf a.tar --exclude='e*' -X ex | sort; rm ex; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_NoF_Extract
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; mkdir x; cat a.tar | tar x -C x; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
D ./x
D ./x/d
F ./x/d/a.txt MQo=
D ./x/d/other
F ./x/d/other/c.log Mwo=
D ./x/d/sub
F ./x/d/sub/b.txt Mgo=
D ./x/e
F ./x/e/f.txt NAo=
F ./x/t.txt dG9wCg==
## END
## status: 0

#### List_PartialNameSelectsNothing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar d/su; rm -f a.tar
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
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Stdin_Garbage_IsNotATarArchive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
echo garbage | tar t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### List_DirectoryMember_SelectsItAndEverythingBelow
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; tar tf a.tar d/sub | sort; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### Gzip_FileIsDetectedWithoutZ
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar czf z.tgz d; tar tf z.tgz | sort; rm z.tgz
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/other/c.log
d/sub/
d/sub/b.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0

#### ExcludeFrom_EmptyLineIgnored
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' '1' > 'd/a.txt'
mkdir -p 'd/sub'
printf '%s\n' '2' > 'd/sub/b.txt'
mkdir -p 'd/other'
printf '%s\n' '3' > 'd/other/c.log'
mkdir -p 'e'
printf '%s\n' '4' > 'e/f.txt'
printf '%s\n' 'top' > 't.txt'
} >/dev/null 2>&1
echo '== stdout'
{ :
tar cf a.tar d e t.txt; printf '\n*.log\n' > ex; tar tf a.tar -X ex | sort; rm ex; rm -f a.tar
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
d/
d/a.txt
d/other/
d/sub/
d/sub/b.txt
e/
e/f.txt
t.txt
== exit 0
== fs
D .
D ./d
F ./d/a.txt MQo=
D ./d/other
F ./d/other/c.log Mwo=
D ./d/sub
F ./d/sub/b.txt Mgo=
D ./e
F ./e/f.txt NAo=
F ./t.txt dG9wCg==
## END
## status: 0
