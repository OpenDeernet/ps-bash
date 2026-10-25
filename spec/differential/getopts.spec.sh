## Absorbed from Differential.Tests/GetoptsTests.cs (scripts only; expectations recorded from bash 5.2).

#### Loop_WithArgumentsAndOptind
set -- -a -b X -c rest1 rest2; while getopts 'ab:c' o; do echo "o=$o arg=[$OPTARG]"; done; shift $((OPTIND-1)); echo "left: $@"
## STDOUT:
o=a arg=[]
o=b arg=[X]
o=c arg=[]
left: rest1 rest2
## END
## status: 0

#### ClusteredFlags_AndAttachedArgument
set -- -abfile -c; while getopts 'ab:c' o; do echo "$o [$OPTARG] $OPTIND"; done
## STDOUT:
a [] 1
b [file] 2
c [] 3
## END
## status: 0

#### SilentMode_UnknownAndMissingArgument
set -- -x -b; while getopts ':ab:' o; do echo "$o [$OPTARG]"; done
## STDOUT:
? [x]
: [b]
## END
## status: 0

#### NonSilent_Diagnostics_GoToStderr
set -- -x -b; while getopts 'ab:' o 2>/dev/null; do echo "$o [$OPTARG]"; done
## STDOUT:
? []
? []
## END
## status: 0

#### DoubleDash_EndsOptions
set -- -a -- -b; while getopts 'ab' o; do echo "$o"; done; echo "optind=$OPTIND"
## STDOUT:
a
optind=3
## END
## status: 0

#### ExplicitArguments_AndExitStatus
getopts 'ab:' o -a; echo "o=$o rc=$?"; OPTIND=1; getopts 'ab:' o plain; echo "o=$o rc=$?"
## STDOUT:
o=a rc=0
o=? rc=1
## END
## status: 0

#### InsideFunction_UsesFunctionArguments
f() { OPTIND=1; while getopts 'n:v' o; do echo "$o=$OPTARG"; done; }; f -n 5 -v; f -v
## STDOUT:
n=5
v=
v=
## END
## status: 0
