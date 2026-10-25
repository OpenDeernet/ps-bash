## Absorbed from Differential.Tests/AwkFunctionDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Eq
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function setg(){G=42} function f(G){G=1} BEGIN{setg(); print G; H=9; f(H); print H}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
42
9
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'a\nb\nc\nd\ne\n' | awk 'function odd(n){return n%2} odd(NR){print NR ":" $0}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1:a
3:c
5:e
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 3
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(a){a[1]=1} BEGIN{f(x); x=2; print "no"}'
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
## END
## status: 0

#### Eq row 4
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'a 1
b 2
a 3
' > 'data'
} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function out(n, s){ print s > (n ".txt") } { out($1, $2) }' data
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
F ./.txt Cg==
F ./a.txt MQozCg==
F ./b.txt Mgo=
F ./data YSAxCmIgMgphIDMKCg==
## END
## status: 0

#### Eq row 5
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(a){a[1]=5} BEGIN{x=1; f(x); print "no"}'
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
## END
## status: 0

#### Eq row 6
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function rev(s){return length(s)<=1?s:rev(substr(s,2)) substr(s,1,1)} function hex(n){return sprintf("%x", n)} BEGIN{print rev("abcdef"), hex(255)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
fedcba ff
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 7
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function r(a,n){if(n==0)return; a[n]=n; r(a,n-1)} BEGIN{r(q,3); print length(q), q[1], q[3]}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
3 1 3
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 8
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(a,b,c){return a "-" b "-" c "-"} BEGIN{print f(1); print f(1,2); print f()}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1---
1-2--
---
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 9
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{print later(4), sq(5)} function later(x){return x*2} func sq(x){return x*x}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
8 25
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 10
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(x){x=1} function g(){return} BEGIN{v=f(2); w=g(); print "[" v "]", length(v), v+0, "[" w "]"}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[] 0 0 []
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 11
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
echo 'a b c' | awk 'function f(){$2="Z"; return NF} {print f(), $0}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
3 a Z c
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 12
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function g(  loc,k,n){loc["a"]=1; loc["b"]=2; for(k in loc) n++; return n} BEGIN{print g(), g()}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2 2
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 13
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function find(  i,j){for(i=1;i<9;i++){for(j=1;j<9;j++){if(i*j==12 && i==3) return i "," j}} return "none"} BEGIN{print find()}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
3,4
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 14
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function max(a,b){return a>b?a:b} BEGIN{print max(3,7), max(9,2), max("a","b")}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
7 9 b
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 15
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'x\ny\n' | awk 'function f(){if ($0=="x") next} {f(); print "kept:" $0} END{print NR}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
kept:y
2
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 16
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(){exit 3} BEGIN{f(); print "no"} END{print "end"}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
end
== exit 3
== fs
D .
## END
## status: 0

#### Eq row 17
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function ev(n){return n==0?1:od(n-1)} function od(n){return n==0?0:ev(n-1)} BEGIN{print ev(10), od(10), ev(7)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1 0 0
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 18
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function clean(s){gsub(/[aeiou]/,"_",s); return s} function pos(s){return match(s,/b+/) ":" RLENGTH} BEGIN{print clean("education"), pos("aabbbc")}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
_d_c_t__n 3:3
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 19
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function h(  z){return z+1 "|" length(z)} function c(  x){x=x+1; return x} BEGIN{print h(), c(), c(), c()}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1|0 1 1 1
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 20
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function fib(n){return n<2?n:fib(n-1)+fib(n-2)} BEGIN{print fib(20)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
6765
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 21
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function sum(a,  k,s){for(k in a)s+=a[k]; return s} function clr(a,  k){for(k in a)delete a[k]} function sp(s,a){return split(s,a,",")} BEGIN{a[1]=2;a[2]=3; print sum(a); clr(a); print length(a); n=sp("x,y,z",arr); print n, arr[3]}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
5
0
3 z
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 22
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function fill(a,n,  i){for(i=1;i<=n;i++)a[i]=i*i} BEGIN{fill(sq,4); for(i=1;i<=4;i++) printf "%s ", sq[i]; print ""}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1 4 9 16 
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 23
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'l1\nl2\n' | awk 'function nxt(  l){getline l; return l} {print $0 "/" nxt()}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
l1/l2
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 24
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(s){return s+0} BEGIN{print f("3x"), f("abc"), f(2.5), f("0x1A")}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
3 0 2.5 0
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 25
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function mk(a){a["k"]="v"} function inner(b){b[1]="deep"} function outer(a){inner(a)} BEGIN{mk(arr); print arr["k"], length(arr); outer(z); print z[1]}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
v 1
deep
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 26
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf '3\n1\n2\n' | awk 'function emit(x){print x | "sort -n"} {emit($1)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
2
3
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 27
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function f(n){return n<=1?1:n*f(n-1)} BEGIN{print f(1), f(5), f(10), f(20)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1 120 3628800 2432902008176640000
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 28
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
printf 'b a b\nc b\n' | awk 'function bump(w){cnt[w]++} {for(i=1;i<=NF;i++) bump($i)} END{n=0; for(w in cnt) keys[++n]=w; for(i=1;i<=n;i++) for(j=i+1;j<=n;j++) if(keys[j]<keys[i]){t=keys[i];keys[i]=keys[j];keys[j]=t} for(i=1;i<=n;i++) print keys[i], cnt[keys[i]]}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
a 1
b 3
c 1
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 29
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'BEGIN{print nosuch(1)}'
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
## END
## status: 0

#### Eq row 30
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function inc(x){x++; return x} BEGIN{y=5; print inc(y), y}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
6 5
== exit 0
== fs
D .
## END
## status: 0

#### Eq row 31
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :

} >/dev/null 2>&1
echo '== stdout'
{ :
awk 'function d(n){return n==0?0:1+d(n-1)} BEGIN{print d(1000)}'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1000
== exit 0
== fs
D .
## END
## status: 0
