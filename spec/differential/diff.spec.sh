## Absorbed from Differential.Tests/DiffDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### CarriageReturnsAreContent
printf 'a\r\nb\r\n' > c1; printf 'a\nb\n' > c2; diff c1 c2 | tr '\r' '@'
## STDOUT:
1,2c1,2
< a@
< b@
---
> a
> b
## END
## status: 0
