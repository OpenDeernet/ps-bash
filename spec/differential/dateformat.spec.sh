## Absorbed from Differential.Tests/DateFormatDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Date_Nanoseconds_FullAndWidthForms
date -d @0.1234567 -u +%N; date -d @1.25 -u +%T.%3N; date -d @0 -u +%N; date -d @1,5 -u +%6N
## STDOUT:
123456700
00:00:01.250
000000000
500000
## END
## status: 0

#### Date_NegativeFractionalEpoch_FloorsLikeGnu
date -d @-1.5 -u +%s.%N
## stdout: -2.500000000
## status: 0

#### Date_EpochNanos_HasNineteenDigits
date +%s%N | wc -c
## stdout: 20
## status: 0
