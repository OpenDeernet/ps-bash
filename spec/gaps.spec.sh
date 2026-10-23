## Known ps-bash gaps from docs/specs/bash-feature-coverage.md. Each XFAIL is removed when its fix lands (an XPASS fails the suite).

#### declare -n nameref
x=1; declare -n r=x; r=5; echo $x
## stdout: 5
## status: 0
## XFAIL ps-bash nameref declare -n unsupported

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

#### extglob pattern
shopt -s extglob; case abc in @(abc|x)) echo y;; *) echo n;; esac
## stdout:
## status: 2
## XFAIL ps-bash extglob extglob patterns unsupported

#### trap ERR
trap 'echo err' ERR; false; echo done
## STDOUT:
err
done
## END
## status: 0
## XFAIL ps-bash trap-err ERR trap not run
