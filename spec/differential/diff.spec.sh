## Absorbed from Differential.Tests/DiffDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### CarriageReturnsAreContent
printf 'a\r\nb\r\n' > c1; printf 'a\nb\n' > c2; diff c1 c2 | tr '\r' '@'
## STDOUT:
1,2c1,2
< a@
< b@
---
> a
> b
## END
## status: 0

#### Context_Zero
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -C0 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 2 ****
! b
--- 2 ----
! B
***************
*** 9 ****
! i
--- 9 ----
! I
***************
*** 10 ****
--- 11 ----
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Dir_NewFileUnified
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -ruN d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
diff -ruN d1/Zed d2/Zed
--- d1/Zed
+++ d2/Zed
@@ -1 +0,0 @@
-c
diff -ruN d1/diff d2/diff
--- d1/diff
+++ d2/diff
@@ -1 +1 @@
-one
+two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
diff -ruN d1/onlyfile1 d2/onlyfile1
--- d1/onlyfile1
+++ d2/onlyfile1
@@ -1 +0,0 @@
-x
diff -ruN d1/onlyfile2 d2/onlyfile2
--- d1/onlyfile2
+++ d2/onlyfile2
@@ -0,0 +1 @@
+y
diff -ruN d1/sub/f d2/sub/f
--- d1/sub/f
+++ d2/sub/f
@@ -1 +1 @@
-s1
+s2
diff -ruN d1/zzed d2/zzed
--- d1/zzed
+++ d2/zzed
@@ -0,0 +1 @@
+c
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### SameFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -s a a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
Files a and a are identical
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### NewFile_MissingOperandIsEmpty
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -N a nosuch > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -N nosuch a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -uN a nosuch > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -cN nosuch a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1,10d0
< a
< b
< c
< d
< e
< f
< g
< h
< i
< j
rc=1
0a1,10
> a
> b
> c
> d
> e
> f
> g
> h
> i
> j
rc=1
--- a
+++ nosuch
@@ -1,10 +0,0 @@
-a
-b
-c
-d
-e
-f
-g
-h
-i
-j
rc=1
*** nosuch
--- a
***************
*** 0 ****
--- 1,10 ----
+ a
+ b
+ c
+ d
+ e
+ f
+ g
+ h
+ i
+ j
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### CarriageReturns_IgnoredByAllSpace
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\r\nb\r\n' > c1; printf 'a\nb\n' > c2; diff -w c1 c2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -b c1 c2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
== exit 0
== fs
D .
F ./c1 YQ0KYg0K
F ./c2 YQpiCg==
## END
## status: 0

#### Labels_OnlyOne
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -u --label A a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- A
+++ b
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Stdin_AsFirstOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
cat a | diff - b ; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2c2
< b
---
> B
9c9
< i
---
> I
10a11
> k
rc=1
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Binary_Differs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\0b\n' > bin1; printf 'a\0c\n' > bin2; diff bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -q bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Binary files bin1 and bin2 differ
rc=1
Binary files bin1 and bin2 differ
rc=1
Files bin1 and bin2 differ
== exit 0
== fs
D .
F ./bin1 YQBiCg==
F ./bin2 YQBjCg==
## END
## status: 0

#### Dir_RecursiveContext
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -rc d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -rc d1/diff d2/diff
*** d1/diff
--- d2/diff
***************
*** 1 ****
! one
--- 1 ----
! two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -rc d1/sub/f d2/sub/f
*** d1/sub/f
--- d2/sub/f
***************
*** 1 ****
! s1
--- 1 ----
! s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### IgnoreBlankLines_WithAllSpace
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n  \nb\n' > b5; printf 'a\nb\n' > b2; diff -B -w b5 b2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./b2 YQpiCg==
F ./b5 YQogIApiCg==
## END
## status: 0

#### Stdin_UnifiedBody
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
cat b | diff -u a - | sed 1,2d; echo done
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
done
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Dir_OrderIsByteOrder
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -q d1 d2 | grep -i zed
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
Only in d1: Zed
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### Context_SeparateValue
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -U 1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,3 +1,3 @@
 a
-b
+B
 c
@@ -8,3 +8,4 @@
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### IgnoreSpaceChange_NoSpaceVersusSpace
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'ab\n' > w1; printf 'a b\n' > w2; diff -b w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1c1
< ab
---
> a b
== exit 0
== fs
D .
F ./w1 YWIK
F ./w2 YSBiCg==
## END
## status: 0

#### Dir_TrailingSlashes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -r d1/ d2/ > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1/: Zed
diff -r d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1/: only1
Only in d2/: only2
Only in d1/: onlyfile1
Only in d2/: onlyfile2
diff -r d1/sub/f d2/sub/f
1c1
< s1
---
> s2
Only in d2/: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### ReportIdentical_WithDifferences_PrintsTheDiff
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -s a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< b
---
> B
9c9
< i
---
> I
10a11
> k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### DirectoryAndFile_MissingInside
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'hi' > 'd/zz'
printf '%s\n' 'ho' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a d > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a aG8K
D ./d
F ./d/zz aGkK
## END
## status: 0

#### Dir_Plain
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
Common subdirectories: d1/both and d2/both
diff d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
Common subdirectories: d1/sub and d2/sub
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### Hunks_Reordered
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf '1\n2\n3\n4\n5\n6\n' > o1; printf '4\n5\n6\n1\n2\n3\n' > o2; diff o1 o2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u o1 o2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1,3d0
< 1
< 2
< 3
6a4,6
> 1
> 2
> 3
rc=1
--- o1
+++ o2
@@ -1,6 +1,6 @@
-1
-2
-3
 4
 5
 6
+1
+2
+3
== exit 0
== fs
D .
F ./o1 MQoyCjMKNAo1CjYK
F ./o2 NAo1CjYKMQoyCjMK
## END
## status: 0

#### Dir_Recursive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -r d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -r d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -r d1/sub/f d2/sub/f
1c1
< s1
---
> s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### IgnoreCase_ShowsTheOriginalLines
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'AbC\nx\n' > i1; printf 'aBc\ny\n' > i2; diff -i i1 i2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -iu i1 i2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< x
---
> y
rc=1
--- i1
+++ i2
@@ -1,2 +1,2 @@
 AbC
-x
+y
== exit 0
== fs
D .
F ./i1 QWJDCngK
F ./i2 YUJjCnkK
## END
## status: 0

#### Hunks_SingleLineFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n' > p1; printf 'b\n' > p2; diff -u p1 p2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c p1 p2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff p1 p2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- p1
+++ p2
@@ -1 +1 @@
-a
+b
rc=1
*** p1
--- p2
***************
*** 1 ****
! a
--- 1 ----
! b
rc=1
1c1
< a
---
> b
== exit 0
== fs
D .
F ./p1 YQo=
F ./p2 Ygo=
## END
## status: 0

#### Hunks_AllLinesDiffer
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 5 > q1; seq 11 15 > q2; diff q1 q2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u q1 q2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c q1 q2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1,5c1,5
< 1
< 2
< 3
< 4
< 5
---
> 11
> 12
> 13
> 14
> 15
rc=1
--- q1
+++ q2
@@ -1,5 +1,5 @@
-1
-2
-3
-4
-5
+11
+12
+13
+14
+15
rc=1
*** q1
--- q2
***************
*** 1,5 ****
! 1
! 2
! 3
! 4
! 5
--- 1,5 ----
! 11
! 12
! 13
! 14
! 15
== exit 0
== fs
D .
F ./q1 MQoyCjMKNAo1Cg==
F ./q2 MTEKMTIKMTMKMTQKMTUK
## END
## status: 0

#### Dir_MissingSide
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -r d1 nosuch > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### OneOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### OptionsAfterOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a b -u > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_RepeatedLinesShiftBoundaries
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\nb\nb\nb\nc\n' > r1; printf 'a\nb\nb\nc\n' > r2; diff r1 r2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u r1 r2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c r2 r1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
4d3
< b
rc=1
--- r1
+++ r2
@@ -1,5 +1,4 @@
 a
 b
 b
-b
 c
rc=1
*** r2
--- r1
***************
*** 1,4 ****
--- 1,5 ----
  a
  b
  b
+ b
  c
== exit 0
== fs
D .
F ./r1 YQpiCmIKYgpjCg==
F ./r2 YQpiCmIKYwo=
## END
## status: 0

#### MissingBoth
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff nosuch1 nosuch2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### IgnoreBlankLines_MixedChanges_Unified
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n\nb\nx\n' > b3; printf 'a\nb\ny\n' > b4; diff -B -u b3 b4 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -B -c b3 b4 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- b3
+++ b4
@@ -1,4 +1,3 @@
 a
-
 b
-x
+y
rc=1
*** b3
--- b4
***************
*** 1,4 ****
  a
- 
  b
! x
--- 1,3 ----
  a
  b
! y
== exit 0
== fs
D .
F ./b3 YQoKYgp4Cg==
F ./b4 YQpiCnkK
## END
## status: 0

#### Hunks_CommonLinesWithAmbiguousAlignment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\ny\nx\ny\nx\n' > m1; printf 'y\nx\ny\nx\ny\n' > m2; diff m1 m2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u m1 m2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1d0
< x
5a5
> y
rc=1
--- m1
+++ m2
@@ -1,5 +1,5 @@
-x
 y
 x
 y
 x
+y
== exit 0
== fs
D .
F ./m1 eAp5CngKeQp4Cg==
F ./m2 eQp4CnkKeAp5Cg==
## END
## status: 0

#### IgnoreAllSpace
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a b\n' > w1; printf 'ab\n' > w2; diff -w w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=1
1c1
< a b
---
> ab
== exit 0
== fs
D .
F ./w1 YSBiCg==
F ./w2 YWIK
## END
## status: 0

#### Context
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -c a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 1,10 ****
  a
! b
  c
  d
  e
  f
  g
  h
! i
  j
--- 1,11 ----
  a
! B
  c
  d
  e
  f
  g
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Brief
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -q a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -q a a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --brief a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Files a and b differ
rc=0
rc=1
Files a and b differ
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Binary_Same
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\0b\n' > bin1; cp bin1 bin2; diff bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -s bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
Files bin1 and bin2 are identical
== exit 0
== fs
D .
F ./bin1 YQBiCg==
F ./bin2 YQBiCg==
## END
## status: 0

#### Hunks_ChangeAtTheLastLine
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^20$/X/' s1 > s2; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- s1
+++ s2
@@ -17,4 +17,4 @@
 17
 18
 19
-20
+X
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKWAo=
## END
## status: 0

#### Hunks_ContextAddOnly
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 5 > t1; seq 1 6 > t2; diff -c t1 t2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c t2 t1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** t1
--- t2
***************
*** 3,5 ****
--- 3,6 ----
  3
  4
  5
+ 6
rc=1
*** t2
--- t1
***************
*** 3,6 ****
  3
  4
  5
- 6
--- 3,5 ----
== exit 0
== fs
D .
F ./t1 MQoyCjMKNAo1Cg==
F ./t2 MQoyCjMKNAo1CjYK
## END
## status: 0

#### Dir_ReportIdentical
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -rs d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -rs d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
Files d1/same and d2/same are identical
diff -rs d1/sub/f d2/sub/f
1c1
< s1
---
> s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### IgnoreSpaceChange_LeadingSpaceStillCounts
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf ' a\n' > w1; printf 'a\n' > w2; diff -b w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -w w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1c1
<  a
---
> a
rc=0
== exit 0
== fs
D .
F ./w1 IGEK
F ./w2 YQo=
## END
## status: 0

#### Context_CWithZero_StillThree
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -c -C0 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 1,10 ****
  a
! b
  c
  d
  e
  f
  g
  h
! i
  j
--- 1,11 ----
  a
! B
  c
  d
  e
  f
  g
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_GapOfSixMerges
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^4$/X/;s/^11$/Y/' s1 > s2; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- s1
+++ s2
@@ -1,14 +1,14 @@
 1
 2
 3
-4
+X
 5
 6
 7
 8
 9
 10
-11
+Y
 12
 13
 14
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKWAo1CjYKNwo4CjkKMTAKWQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAo=
## END
## status: 0

#### IgnoreSpaceChange_TabVersusSpaces
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\t\tb\n' > w1; printf 'a b\n' > w2; diff -b w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -w w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
== exit 0
== fs
D .
F ./w1 YQkJYgo=
F ./w2 YSBiCg==
## END
## status: 0

#### ThreeOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a b a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### NewFile_BothMissingIsAnError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -N nosuch1 nosuch2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### IgnoreBlankLines_OnlyBlankChange
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n\nb\n' > b1; printf 'a\nb\n' > b2; diff -B b1 b2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff b1 b2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=1
2d1
< 
== exit 0
== fs
D .
F ./b1 YQoKYgo=
F ./b2 YQpiCg==
## END
## status: 0

#### Unified_Zero
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -U0 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -2 +2 @@
-b
+B
@@ -9 +9 @@
-i
+I
@@ -10,0 +11 @@
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_DeleteBlock
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed '5,8d' s1 > s2; diff s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
5,8d4
< 5
< 6
< 7
< 8
rc=1
--- s1
+++ s2
@@ -2,10 +2,6 @@
 2
 3
 4
-5
-6
-7
-8
 9
 10
 11
rc=1
*** s1
--- s2
***************
*** 2,11 ****
  2
  3
  4
- 5
- 6
- 7
- 8
  9
  10
  11
--- 2,7 ----
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKNAo5CjEwCjExCjEyCjEzCjE0CjE1CjE2CjE3CjE4CjE5CjIwCg==
## END
## status: 0

#### Hunks_ReplaceBlockWithShorterBlock
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed '5,8c\
only' s1 > s2; diff s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
5,8c5
< 5
< 6
< 7
< 8
---
> only
rc=1
--- s1
+++ s2
@@ -2,10 +2,7 @@
 2
 3
 4
-5
-6
-7
-8
+only
 9
 10
 11
rc=1
*** s1
--- s2
***************
*** 2,11 ****
  2
  3
  4
! 5
! 6
! 7
! 8
  9
  10
  11
--- 2,8 ----
  2
  3
  4
! only
  9
  10
  11
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKNApvbmx5CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
## END
## status: 0

#### Style_ContextThenUnified_Conflict
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -c -U1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### IgnoreBlankLines_WhitespaceOnlyLineIsNotBlank
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n  \nb\n' > b5; printf 'a\nb\n' > b2; diff -B b5 b2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2d1
<   
== exit 0
== fs
D .
F ./b2 YQpiCg==
F ./b5 YQogIApiCg==
## END
## status: 0

#### Dir_ExitStatusWhenOnlyCommonSubdirectories
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p e1/s e2/s
} >/dev/null 2>&1
echo '== stdout'
{ :
diff e1 e2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
Common subdirectories: e1/s and e2/s
== exit 0
== fs
D .
D ./e1
D ./e1/s
D ./e2
D ./e2/s
## END
## status: 0

#### Style_BadLength
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -U x a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Dir_Nested
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'a/x/y'
printf '%s\n' '1' > 'a/x/y/f'
mkdir -p 'a/x'
printf '%s\n' 'same' > 'a/x/g'
mkdir -p 'b/x/y'
printf '%s\n' '2' > 'b/x/y/f'
mkdir -p 'b/x'
printf '%s\n' 'same' > 'b/x/g'
mkdir -p 'b/x'
printf '%s\n' 'new' > 'b/x/h'
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -r a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in b/x: h
diff -r a/x/y/f b/x/y/f
1c1
< 1
---
> 2
rc=0
Common subdirectories: a/x and b/x
== exit 0
== fs
D .
D ./a
D ./a/x
F ./a/x/g c2FtZQo=
D ./a/x/y
F ./a/x/y/f MQo=
D ./b
D ./b/x
F ./b/x/g c2FtZQo=
F ./b/x/h bmV3Cg==
D ./b/x/y
F ./b/x/y/f Mgo=
## END
## status: 0

#### MissingFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a nosuch > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Normal
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< b
---
> B
9c9
< i
---
> I
10a11
> k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Dir_NewFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -rN d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
diff -rN d1/Zed d2/Zed
1d0
< c
diff -rN d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
diff -rN d1/onlyfile1 d2/onlyfile1
1d0
< x
diff -rN d1/onlyfile2 d2/onlyfile2
0a1
> y
diff -rN d1/sub/f d2/sub/f
1c1
< s1
---
> s2
diff -rN d1/zzed d2/zzed
0a1
> c
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### DoubleDashEndsOptions
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
cp a ./-x; diff -- -x b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< b
---
> B
9c9
< i
---
> I
10a11
> k
== exit 0
== fs
D .
F ./-x YQpiCmMKZAplCmYKZwpoCmkKago=
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_ManyChanges
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^3$/X/;s/^9$/Y/;s/^15$/Z/;s/^19$/W/' s1 > s2; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- s1
+++ s2
@@ -1,20 +1,20 @@
 1
 2
-3
+X
 4
 5
 6
 7
 8
-9
+Y
 10
 11
 12
 13
 14
-15
+Z
 16
 17
 18
-19
+W
 20
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyClgKNAo1CjYKNwo4ClkKMTAKMTEKMTIKMTMKMTQKWgoxNgoxNwoxOApXCjIwCg==
## END
## status: 0

#### Dir_Equal
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir e1 e2
} >/dev/null 2>&1
echo '== stdout'
{ :
diff e1 e2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -r e1 e2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
== exit 0
== fs
D .
D ./e1
D ./e2
## END
## status: 0

#### Context_Context1_SplitsHunks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -C1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 1,3 ****
  a
! b
  c
--- 1,3 ----
  a
! B
  c
***************
*** 8,10 ****
  h
! i
  j
--- 8,11 ----
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### DirectoryAndFile_ComparesTheNamedFileInside
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p 'd'
printf '%s\n' 'hi' > 'd/a'
printf '%s\n' 'ho' > 'a'
} >/dev/null 2>&1
echo '== stdout'
{ :
diff a d > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff d a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1c1
< ho
---
> hi
rc=1
1c1
< hi
---
> ho
== exit 0
== fs
D .
F ./a aG8K
D ./d
F ./d/a aGkK
## END
## status: 0

#### Stdin_AsSecondOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
cat b | diff a - ; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2c2
< b
---
> B
9c9
< i
---
> I
10a11
> k
rc=1
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_ContextFormatGapOfSevenSplits
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^4$/X/;s/^12$/Y/' s1 > s2; diff -c s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** s1
--- s2
***************
*** 1,7 ****
  1
  2
  3
! 4
  5
  6
  7
--- 1,7 ----
  1
  2
  3
! X
  5
  6
  7
***************
*** 9,15 ****
  9
  10
  11
! 12
  13
  14
  15
--- 9,15 ----
  9
  10
  11
! Y
  13
  14
  15
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKWAo1CjYKNwo4CjkKMTAKMTEKWQoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAo=
## END
## status: 0

#### EmptyBoth
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf '' > e1; printf '' > e2; diff e1 e2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -s e1 e2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
Files e1 and e2 are identical
== exit 0
== fs
D .
F ./e1 
F ./e2 
## END
## status: 0

#### Dir_BinaryInside
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\0b\n' > d1/bin; printf 'a\0c\n' > d2/bin; diff -r d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
Binary files d1/bin and d2/bin differ
diff -r d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -r d1/sub/f d2/sub/f
1c1
< s1
---
> s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
F ./d1/bin YQBiCg==
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
F ./d2/bin YQBjCg==
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### Hunks_ContextFormatGapOfSixMerges
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^4$/X/;s/^11$/Y/' s1 > s2; diff -c s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** s1
--- s2
***************
*** 1,14 ****
  1
  2
  3
! 4
  5
  6
  7
  8
  9
  10
! 11
  12
  13
  14
--- 1,14 ----
  1
  2
  3
! X
  5
  6
  7
  8
  9
  10
! Y
  12
  13
  14
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKWAo1CjYKNwo4CjkKMTAKWQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAo=
## END
## status: 0

#### Style_UnifiedThenContext_Conflict
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -u -c a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Dir_Brief
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -q d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -rq d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
Common subdirectories: d1/both and d2/both
Files d1/diff and d2/diff differ
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
Common subdirectories: d1/sub and d2/sub
Only in d2: zzed
rc=1
Only in d1: Zed
Files d1/diff and d2/diff differ
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
Files d1/sub/f and d2/sub/f differ
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### Dir_NewFileNotRecursive
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -N d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
diff -N d1/Zed d2/Zed
1d0
< c
Common subdirectories: d1/both and d2/both
diff -N d1/diff d2/diff
1c1
< one
---
> two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Common subdirectories: d1/only1 and d2/only1
Common subdirectories: d1/only2 and d2/only2
diff -N d1/onlyfile1 d2/onlyfile1
1d0
< x
diff -N d1/onlyfile2 d2/onlyfile2
0a1
> y
Common subdirectories: d1/sub and d2/sub
diff -N d1/zzed d2/zzed
0a1
> c
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### Unified_LongForms
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff --unified=2 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --unified a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --context=1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,4 +1,4 @@
 a
-b
+B
 c
 d
@@ -7,4 +7,5 @@
 g
 h
-i
+I
 j
+k
rc=1
--- a
+++ b
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
rc=1
*** a
--- b
***************
*** 1,3 ****
  a
! b
  c
--- 1,3 ----
  a
! B
  c
***************
*** 8,10 ****
  h
! i
  j
--- 8,11 ----
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### EmptyVersusContent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
printf '' > e1; diff e1 a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff a e1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u e1 a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u a e1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c e1 a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c a e1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
0a1,10
> a
> b
> c
> d
> e
> f
> g
> h
> i
> j
rc=1
1,10d0
< a
< b
< c
< d
< e
< f
< g
< h
< i
< j
rc=1
--- e1
+++ a
@@ -0,0 +1,10 @@
+a
+b
+c
+d
+e
+f
+g
+h
+i
+j
rc=1
--- a
+++ e1
@@ -1,10 +0,0 @@
-a
-b
-c
-d
-e
-f
-g
-h
-i
-j
rc=1
*** e1
--- a
***************
*** 0 ****
--- 1,10 ----
+ a
+ b
+ c
+ d
+ e
+ f
+ g
+ h
+ i
+ j
rc=1
*** a
--- e1
***************
*** 1,10 ****
- a
- b
- c
- d
- e
- f
- g
- h
- i
- j
--- 0 ----
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
F ./e1 
## END
## status: 0

#### Dir_SwitchesAfterOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff d1 d2 -r -c > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -r -c d1/diff d2/diff
*** d1/diff
--- d2/diff
***************
*** 1 ****
! one
--- 1 ----
! two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -r -c d1/sub/f d2/sub/f
*** d1/sub/f
--- d2/sub/f
***************
*** 1 ****
! s1
--- 1 ----
! s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### IgnoreCase
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'AbC\n' > i1; printf 'aBc\n' > i2; diff -i i1 i2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --ignore-case i1 i2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff i1 i2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
rc=1
1c1
< AbC
---
> aBc
== exit 0
== fs
D .
F ./i1 QWJDCg==
F ./i2 YUJjCg==
## END
## status: 0

#### NoTrailingNewline_BothAndEqual
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\ny' > n1; printf 'x\ny' > n2; diff n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./n1 eAp5
F ./n2 eAp5
## END
## status: 0

#### Unified_Context1_SplitsHunks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -U1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,3 +1,3 @@
 a
-b
+B
 c
@@ -8,3 +8,4 @@
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Context_LargestNumberWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -U2 -U1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,4 +1,4 @@
 a
-b
+B
 c
 d
@@ -7,4 +7,5 @@
 g
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Context_BareLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff --context a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 1,10 ****
  a
! b
  c
  d
  e
  f
  g
  h
! i
  j
--- 1,11 ----
  a
! B
  c
  d
  e
  f
  g
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_InsertBlock
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed '5a\
new1\
new2' s1 > s2; diff s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
5a6,7
> new1
> new2
rc=1
--- s1
+++ s2
@@ -3,6 +3,8 @@
 3
 4
 5
+new1
+new2
 6
 7
 8
rc=1
*** s1
--- s2
***************
*** 3,8 ****
--- 3,10 ----
  3
  4
  5
+ new1
+ new2
  6
  7
  8
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKNAo1Cm5ldzEKbmV3Mgo2CjcKOAo5CjEwCjExCjEyCjEzCjE0CjE1CjE2CjE3CjE4CjE5CjIwCg==
## END
## status: 0

#### Binary_TreatedAsText
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\0b\n' > bin1; printf 'a\0c\n' > bin2; diff -a bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --text bin1 bin2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
1c1
< a b
---
> a c
rc=1
1c1
< a b
---
> a c
== exit 0
== fs
D .
F ./bin1 YQBiCg==
F ./bin2 YQBjCg==
## END
## status: 0

#### IgnoreBlankLines_MixedChanges_Normal
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\n\nb\nx\n' > b3; printf 'a\nb\ny\n' > b4; diff -B b3 b4 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
4c3
< x
---
> y
== exit 0
== fs
D .
F ./b3 YQoKYgp4Cg==
F ./b4 YQpiCnkK
## END
## status: 0

#### IgnoreSpaceChange
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a  b \n' > w1; printf 'a b\n' > w2; diff -b w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff w1 w2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=1
1c1
< a  b 
---
> a b
== exit 0
== fs
D .
F ./w1 YSAgYiAK
F ./w2 YSBiCg==
## END
## status: 0

#### Dir_SeparateSwitchesInOrder
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -u -r d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff --recursive --unified d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -u -r d1/diff d2/diff
--- d1/diff
+++ d2/diff
@@ -1 +1 @@
-one
+two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -u -r d1/sub/f d2/sub/f
--- d1/sub/f
+++ d2/sub/f
@@ -1 +1 @@
-s1
+s2
Only in d2: zzed
rc=1
Only in d1: Zed
diff --recursive --unified d1/diff d2/diff
--- d1/diff
+++ d2/diff
@@ -1 +1 @@
-one
+two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff --recursive --unified d1/sub/f d2/sub/f
--- d1/sub/f
+++ d2/sub/f
@@ -1 +1 @@
-s1
+s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0

#### IgnoreBlankLines_DistantRealChange
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf '1\n2\n\n3\n4\n5\n6\n7\n8\n9\n10\n11\n' > d1; printf '1\n2\n3\n4\n5\n6\n7\n8\n9\n10\nX\n' > d2; diff -B -u d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- d1
+++ d2
@@ -9,4 +8,4 @@
 8
 9
 10
-11
+X
== exit 0
== fs
D .
F ./d1 MQoyCgozCjQKNQo2CjcKOAo5CjEwCjExCg==
F ./d2 MQoyCjMKNAo1CjYKNwo4CjkKMTAKWAo=
## END
## status: 0

#### Brief_WithReportIdentical
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -qs a a > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
Files a and a are identical
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### NoTrailingNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\ny' > n1; printf 'x\ny\n' > n2; diff n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u n2 n1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< y
\ No newline at end of file
---
> y
rc=1
--- n1
+++ n2
@@ -1,2 +1,2 @@
 x
-y
\ No newline at end of file
+y
rc=1
*** n1
--- n2
***************
*** 1,2 ****
  x
! y
\ No newline at end of file
--- 1,2 ----
  x
! y
rc=1
--- n2
+++ n1
@@ -1,2 +1,2 @@
 x
-y
+y
\ No newline at end of file
== exit 0
== fs
D .
F ./n1 eAp5
F ./n2 eAp5Cg==
## END
## status: 0

#### Stdin_Twice_IsIdentical
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff - - < a; echo rc=$?
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### UnknownOption
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff --bogus a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_GapOfSevenSplits
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^4$/X/;s/^12$/Y/' s1 > s2; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- s1
+++ s2
@@ -1,7 +1,7 @@
 1
 2
 3
-4
+X
 5
 6
 7
@@ -9,7 +9,7 @@
 9
 10
 11
-12
+Y
 13
 14
 15
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 MQoyCjMKWAo1CjYKNwo4CjkKMTAKMTEKWQoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAo=
## END
## status: 0

#### Binary_AgainstText
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\0b\n' > bin1; printf 'a\n' > t; diff bin1 t > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff t bin1 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Binary files bin1 and t differ
rc=1
Binary files t and bin1 differ
== exit 0
== fs
D .
F ./bin1 YQBiCg==
F ./t YQo=
## END
## status: 0

#### CarriageReturnsAreContent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\r\nb\r\n' > c1; printf 'a\nb\n' > c2; diff c1 c2 | tr '\r' '@'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1,2c1,2
< a@
< b@
---
> a
> b
== exit 0
== fs
D .
F ./c1 YQ0KYg0K
F ./c2 YQpiCg==
## END
## status: 0

#### Style_NegativeLength
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -C -1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### NoTrailingNewline_BothButDifferent
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\ny' > n1; printf 'x\nz' > n2; diff n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u n1 n2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
2c2
< y
\ No newline at end of file
---
> z
\ No newline at end of file
rc=1
--- n1
+++ n2
@@ -1,2 +1,2 @@
 x
-y
\ No newline at end of file
+z
\ No newline at end of file
== exit 0
== fs
D .
F ./n1 eAp5
F ./n2 eAp6
## END
## status: 0

#### Unified
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -u a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- a
+++ b
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Labels_TooMany
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff --label x --label y --label z a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### StripTrailingCr
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\r\nb\r\n' > c1; printf 'a\nb\n' > c2; diff --strip-trailing-cr c1 c2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -s --strip-trailing-cr c1 c2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=0
rc=0
Files c1 and c2 are identical
== exit 0
== fs
D .
F ./c1 YQ0KYg0K
F ./c2 YQpiCg==
## END
## status: 0

#### Style_SameStyleTwiceIsFine
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -c -C1 a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
*** a
--- b
***************
*** 1,10 ****
  a
! b
  c
  d
  e
  f
  g
  h
! i
  j
--- 1,11 ----
  a
! B
  c
  d
  e
  f
  g
  h
! I
  j
+ k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Labels
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -u --label A --label B a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -c --label A --label B a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out; diff -u -L X -L Y a b > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- A
+++ B
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
rc=1
*** A
--- B
***************
*** 1,10 ****
  a
! b
  c
  d
  e
  f
  g
  h
! i
  j
--- 1,11 ----
  a
! B
  c
  d
  e
  f
  g
  h
! I
  j
+ k
rc=1
--- X
+++ Y
@@ -1,10 +1,11 @@
 a
-b
+B
 c
 d
 e
 f
 g
 h
-i
+I
 j
+k
== exit 0
== fs
D .
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### NoOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\n' > a; printf 'a\nB\nc\nd\ne\nf\ng\nh\nI\nj\nk\n' > b
} >/dev/null 2>&1
echo '== stdout'
{ :
diff  > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
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
F ./a YQpiCmMKZAplCmYKZwpoCmkKago=
F ./b YQpCCmMKZAplCmYKZwpoCkkKagprCg==
## END
## status: 0

#### Hunks_ChangeAtTheFirstLine
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
seq 1 20 > s1; sed 's/^1$/X/' s1 > s2; diff -u s1 s2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
--- s1
+++ s2
@@ -1,4 +1,4 @@
-1
+X
 2
 3
 4
== exit 0
== fs
D .
F ./s1 MQoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
F ./s2 WAoyCjMKNAo1CjYKNwo4CjkKMTAKMTEKMTIKMTMKMTQKMTUKMTYKMTcKMTgKMTkKMjAK
## END
## status: 0

#### Dir_RecursiveUnified_HeaderLineShowsTheSwitches
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
mkdir -p d1/sub d1/only1 d2/sub d2/only2 d1/both d2/both; echo same > d1/same; echo same > d2/same; echo one > d1/diff; echo two > d2/diff; echo x > d1/onlyfile1; echo y > d2/onlyfile2; echo s1 > d1/sub/f; echo s2 > d2/sub/f; echo c > d1/Zed; echo c > d2/zzed; mkdir d1/dirvsfile; echo f > d2/dirvsfile
} >/dev/null 2>&1
echo '== stdout'
{ :
diff -ru d1 d2 > __out 2>/dev/null; echo "rc=$?"; sed 's/\t.*//' __out; rm -f __out
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
Only in d1: Zed
diff -ru d1/diff d2/diff
--- d1/diff
+++ d2/diff
@@ -1 +1 @@
-one
+two
File d1/dirvsfile is a directory while file d2/dirvsfile is a regular file
Only in d1: only1
Only in d2: only2
Only in d1: onlyfile1
Only in d2: onlyfile2
diff -ru d1/sub/f d2/sub/f
--- d1/sub/f
+++ d2/sub/f
@@ -1 +1 @@
-s1
+s2
Only in d2: zzed
== exit 0
== fs
D .
D ./d1
F ./d1/Zed Ywo=
D ./d1/both
F ./d1/diff b25lCg==
D ./d1/dirvsfile
D ./d1/only1
F ./d1/onlyfile1 eAo=
F ./d1/same c2FtZQo=
D ./d1/sub
F ./d1/sub/f czEK
D ./d2
D ./d2/both
F ./d2/diff dHdvCg==
F ./d2/dirvsfile Zgo=
D ./d2/only2
F ./d2/onlyfile2 eQo=
F ./d2/same c2FtZQo=
D ./d2/sub
F ./d2/sub/f czIK
F ./d2/zzed Ywo=
## END
## status: 0
