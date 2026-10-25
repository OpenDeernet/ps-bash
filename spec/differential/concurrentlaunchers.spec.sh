## Absorbed from Differential.Tests/ConcurrentLaunchersTests.cs (scripts only; expectations recorded from bash 5.2).

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart
sleep 2; echo warm0
## stdout: warm0
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 2
sleep 2; echo warm1
## stdout: warm1
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 3
sleep 2; echo warm2
## stdout: warm2
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 4
sleep 2; echo warm3
## stdout: warm3
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 5
v=launcher0; sleep 2; echo "$v"
## stdout: launcher0
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 6
v=launcher1; sleep 2; echo "$v"
## stdout: launcher1
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 7
v=launcher2; sleep 2; echo "$v"
## stdout: launcher2
## status: 0

#### ManyLaunchers_RunInParallel_AndKeepTheirStateApart row 8
v=launcher3; sleep 2; echo "$v"
## stdout: launcher3
## status: 0
