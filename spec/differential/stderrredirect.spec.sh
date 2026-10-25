## Absorbed from Differential.Tests/StderrRedirectDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Stderr_DupToStderr_GoesToStderr
echo x >&2; echo y 1>&2; echo out
## stdout: out
## status: 0

#### Stderr_DupOrder_LeftToRight
echo 1 >&2 2>/dev/null; echo 2 2>/dev/null >&2; echo 3 2>&1 >&2; echo 4 >&2 2>&1
## stdout: 3
## status: 0

#### Stderr_WriteIsNotAFailure
echo x >&2 || echo FALLBACK; echo y >&2 && echo AND-RAN; echo z >&2; echo "rc=$?"; ( set -e; echo q >&2; echo after )
## STDOUT:
AND-RAN
rc=0
after
## END
## status: 0

#### Stderr_CmdletError_MergeUnderOuterCapture
d=$(mktemp -d); eval 'ls /nonexistent-zz 2>&1' >"$d/o" 2>"$d/e"; echo "rc=$? o=[$(cat "$d/o")] e=[$(cat "$d/e")]"; rm -rf "$d"
## stdout: rc=2 o=[ls: cannot access '/nonexistent-zz': No such file or directory] e=[]
## status: 0

#### Stderr_FileTargetsAroundDup
d=$(mktemp -d); echo x >"$d/t" >&2; echo y 2>"$d/u" >&2; echo z >&2 2>"$d/w"; { echo e >&2; } 2>"$d/g"; echo "t=[$(cat "$d/t")] u=[$(cat "$d/u")] w=[$(cat "$d/w")] g=[$(cat "$d/g")]"; rm -rf "$d"
## stdout: t=[] u=[y] w=[] g=[e]
## status: 0
