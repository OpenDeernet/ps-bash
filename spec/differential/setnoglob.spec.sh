## Absorbed from Differential.Tests/SetNoglobTests.cs (scripts only; expectations recorded from bash 5.2).

#### SetF_KeepsPatternLiteral
d=$(mktemp -d); cd $d; touch a.txt b.txt; set -f; echo *.txt; cd /; rm -rf $d
## stdout: *.txt
## status: 0

#### SetPlusF_RestoresGlobbing
d=$(mktemp -d); cd $d; touch a.txt b.txt; set -f; set +f; echo *.txt; cd /; rm -rf $d
## stdout: a.txt b.txt
## status: 0

#### LongOption_Noglob
d=$(mktemp -d); cd $d; touch a.txt b.txt; set -o noglob; echo *.txt; set +o noglob; echo *.txt; cd /; rm -rf $d
## STDOUT:
*.txt
a.txt b.txt
## END
## status: 0

#### ExpansionResult_IsNotGlobbed
d=$(mktemp -d); cd $d; touch a.txt b.txt; set -f; x='*.txt'; echo $x; for f in *.txt; do echo "f=$f"; done; cd /; rm -rf $d
## STDOUT:
*.txt
f=*.txt
## END
## status: 0

#### Subshell_DoesNotLeak
d=$(mktemp -d); cd $d; touch a.txt b.txt; ( set -f; echo *.txt ); echo *.txt; cd /; rm -rf $d
## STDOUT:
*.txt
a.txt b.txt
## END
## status: 0
