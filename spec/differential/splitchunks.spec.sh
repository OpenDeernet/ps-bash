## Absorbed from Differential.Tests/SplitChunksDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Bytes_EmptyInput_MakesEmptyChunkFiles
printf '' > e
split -n 3 e
## stdout:
## status: 0

#### Lines_NoTrailingNewline
printf 'a\nb\ncc' > f
split -n l/2 f
## stdout:
## status: 0
