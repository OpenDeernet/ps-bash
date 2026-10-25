## Absorbed from Differential.Tests/SourcedPipelineOutputTests.cs (scripts only; expectations recorded from bash 5.2).

#### SourcedPipeline_ByteCount_MatchesBash
d=$(mktemp -d); echo 'seq 1 3 | tail -1' > $d/f.sh; . $d/f.sh | wc -c; x=$(. $d/f.sh); echo "[$x]"; rm -rf $d
## STDOUT:
2
[3]
## END
## status: 0

#### EvalPipeline_ByteCount_MatchesBash
eval 'seq 1 3 | tail -1' | wc -c; eval 'printf "a\nb\n" | sort -r' | wc -c
## STDOUT:
2
4
## END
## status: 0
