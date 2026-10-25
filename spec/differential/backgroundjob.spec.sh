## Absorbed from Differential.Tests/BackgroundJobDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_Background_TrueAndWait_ExitsZero
true & wait; echo done
## stdout: done
## status: 0

#### Differential_Wait_NoJobs_ExitsZero
wait; echo ok
## stdout: ok
## status: 0

#### Differential_Background_InCommandSub_DoesNotHang
x=$(sleep 0 & echo sub_done); echo $x
## stdout: sub_done
## status: 0

#### Differential_Jobs_NoProcesses_EmitsNothing
jobs; echo empty
## stdout: empty
## status: 0
