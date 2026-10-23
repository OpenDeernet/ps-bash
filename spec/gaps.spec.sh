## Known ps-bash gaps from docs/specs/bash-feature-coverage.md. Each XFAIL is removed when its fix lands (an XPASS fails the suite).

#### declare -n nameref
x=1; declare -n r=x; r=5; echo $x
## stdout: 5
## status: 0

#### declare -i arithmetic on assignment
declare -i n=2+3; n=n+1; echo $n
## stdout: 6
## status: 0

#### unset of a readonly variable fails
readonly v=1; unset v 2>/dev/null; echo $?
## stdout: 1
## status: 0

#### sparse indexed array
a=(); a[3]=x; echo ${#a[@]} ${!a[@]}
## stdout: 1 3
## status: 0
## XFAIL ps-bash sparse-array PowerShell arrays are dense

#### trap ERR
trap 'echo err' ERR; false; echo done
## STDOUT:
err
done
## END
## status: 0

#### extglob in pathname expansion
shopt -s extglob
d=$(mktemp -d); cd "$d"; touch a.c b.h c.c
echo !(*.h)
echo @(a|b).*
cd /; rm -rf "$d"
## STDOUT:
a.c c.c
a.c b.h
## END
## status: 0
