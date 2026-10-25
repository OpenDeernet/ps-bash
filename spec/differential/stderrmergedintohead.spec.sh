## Absorbed from Differential.Tests/StderrMergedIntoHeadTests.cs (scripts only; expectations recorded from bash 5.2).

#### StderrFirstLine_HeadStops_ScriptContinues row 1
ls /nonexist_zz 2>&1 | head -1; echo after
## STDOUT:
ls: cannot access '/nonexist_zz': No such file or directory
after
## END
## status: 0

#### StderrFirstLine_HeadStops_ScriptContinues row 2
ls /nonexist_zz 2>&1 | head -2; echo after
## STDOUT:
ls: cannot access '/nonexist_zz': No such file or directory
after
## END
## status: 0
