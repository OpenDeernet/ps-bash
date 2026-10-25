## Absorbed from Differential.Tests/CpMvDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Eq
d=$(mktemp -d) && cd "$d" && { echo a > a; echo b > b; echo r > result; cp a b result 2>/dev/null; echo rc=$?; cat result; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
r
.
./a
./b
./result
## END
## status: 0

#### Eq row 2
d=$(mktemp -d) && cd "$d" && { mkdir -p p/src && echo a > p/src/f; mv p/src p 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
.
./p
./p/src
./p/src/f
## END
## status: 0

#### Eq row 3
d=$(mktemp -d) && cd "$d" && { echo a > a; echo b > b; cp a b result 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
.
./a
./b
## END
## status: 0

#### Eq row 4
d=$(mktemp -d) && cd "$d" && { mkdir -p s t/s && echo k > t/s/keep; mv s t 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
.
./s
./t
./t/s
./t/s/keep
## END
## status: 0

#### Eq row 5
d=$(mktemp -d) && cd "$d" && { mkdir -p s/x t/s/x && echo new1 > s/x/f1 && echo new2 > s/x/f2 && echo old1 > t/s/x/f1; cp -rn s t 2>/dev/null; echo rc=$?; cat t/s/x/f1 t/s/x/f2; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=0
old1
new2
.
./s
./s/x
./s/x/f1
./s/x/f2
./t
./t/s
./t/s/x
./t/s/x/f1
./t/s/x/f2
## END
## status: 0

#### Eq row 6
d=$(mktemp -d) && cd "$d" && { mkdir dd && echo x > ff; mv dd ff 2>/dev/null; echo rc=$?; cat ff; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
x
.
./dd
./ff
## END
## status: 0

#### Eq row 7
d=$(mktemp -d) && cd "$d" && { mkdir -p s t/s && echo a > s/f; mv s t 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=0
.
./t
./t/s
./t/s/f
## END
## status: 0

#### Eq row 8
d=$(mktemp -d) && cd "$d" && { echo a > sf; cp sf sf 2>/dev/null; echo rc=$?; cat sf; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
a
.
./sf
## END
## status: 0

#### Eq row 9
d=$(mktemp -d) && cd "$d" && { mkdir -p s/sub; mv s s/sub 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
.
./s
./s/sub
## END
## status: 0

#### Eq row 10
d=$(mktemp -d) && cd "$d" && { mkdir -p src/proj dst/proj && echo n > src/proj/new && echo old > dst/proj/only && echo o > dst/proj/new; cp -rf src/proj dst 2>/dev/null; echo rc=$?; cat dst/proj/new dst/proj/only; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=0
n
old
.
./dst
./dst/proj
./dst/proj/new
./dst/proj/only
./src
./src/proj
./src/proj/new
## END
## status: 0

#### Eq row 11
d=$(mktemp -d) && cd "$d" && { echo 1 > m1; echo 2 > m2; mv m1 m2 nope 2>/dev/null; echo rc=$?; find . | sort; }; cd /; rm -rf "$d"
## STDOUT:
rc=1
.
./m1
./m2
## END
## status: 0
