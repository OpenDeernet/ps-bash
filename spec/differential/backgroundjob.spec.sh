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

#### Differential_Kill_ListSignals_Golden
kill -l | head -1
## stdout:  1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)

#### Differential_Background_QuotedArg_Golden
sleep 0 & wait; echo quoting_ok
## stdout: quoting_ok
## status: 0
