## Absorbed from Differential.Tests/BackgroundJobProcessTests.cs (scripts only; expectations recorded from bash 5.2).

#### RunAsync
export PSBASH_BG_MODE=process
for i in 1 2 3 4 5 6 7 8 9 10; do true & echo $!; done; wait; echo "rc=$?"
## STDOUT:
2567075
2567076
2567077
2567079
2567080
2567081
2567082
2567083
2567084
2567085
rc=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)

#### RunAsync row 2
export PSBASH_BG_MODE=process
x=before; { sleep 1; echo "job:$x"; } & x=after; wait; echo "parent:$x"
## STDOUT:
job:before
parent:after
## END
## status: 0

#### RunAsync row 3
export PSBASH_BG_MODE=process
sleep 120 & echo $!; sleep 120 & echo $!; sleep 120 & echo $!
## STDOUT:
2567088
2567089
2567090
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)

#### RunAsync row 4
export PSBASH_BG_MODE=process
{ echo out1; echo err1 >&2; echo out2; } & wait; echo next
## STDOUT:
out1
out2
next
## END
## status: 0

#### RunAsync row 5
export PSBASH_BG_MODE=process
false & wait $!; echo "rc=$?"; (exit 3) & wait $!; echo "rc=$?"
## STDOUT:
rc=1
rc=3
## END
## status: 0

#### RunAsync row 6
export PSBASH_BG_MODE=process
sleep 60 & p=$!; kill -0 $p && echo alive; kill $p; wait $p; echo "rc=$?"; kill -0 $p 2>/dev/null && echo still-alive || echo gone
## STDOUT:
alive
rc=143
gone
## END
## status: 0

#### RunAsync row 7
export PSBASH_BG_MODE=process
export PSBASH_JOBS_MAX=1; { sleep 2; echo first; } & { echo second; } & wait; echo done
## STDOUT:
second
first
done
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)

#### RunAsync row 8
export PSBASH_BG_MODE=process
f() { echo "f:$1"; }; arr=(a b c); f hi & wait; { echo "arr=${arr[1]} n=${#arr[@]}"; } & wait
## STDOUT:
f:hi
arr=b n=3
## END
## status: 0

#### RunAsync row 9
export PSBASH_BG_MODE=process
x=parent; { x=child; echo in-job; } & wait $!; echo "x=$x"
## STDOUT:
in-job
x=parent
## END
## status: 0
