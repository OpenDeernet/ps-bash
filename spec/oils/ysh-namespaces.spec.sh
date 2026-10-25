## Imported from the Oils spec tests (ysh-namespaces.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### global frame doesn't contain builtins like len(), dict(), io

try {
  pp frame_vars_ | grep -o len
}
pp test_ (_pipeline_status)

try {
  pp frame_vars_ | grep -o dict
}
pp test_ (_pipeline_status)

try {
  pp frame_vars_ | grep -o -w io
}
pp test_ (_pipeline_status)
## stdout:
## status: 2
## timeout: 10

#### global frame doesn't contain env vars

#pp frame_vars_

try {
  pp frame_vars_ | grep -o TMP
}
pp test_ (_pipeline_status)
## stdout:
## status: 2
## timeout: 10

#### global frame doesn't have PWD, IFS

echo "IFS=[$IFS]"
echo "PWD=[$PWD]"
## STDOUT:
IFS=[ 	
]
PWD=[/tmp/tmp.Du9xlZ92Uk]
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### __defaults__ is a Dict, showing default PATH, PS1

pp test_ (type(__defaults__))

pp test_ (__defaults__)
## stdout:
## status: 2
## timeout: 10

#### __builtins__ module

var b = len(propView(__builtins__))

# more than 30 builtins
assert [b > 30]

var mylist = :| a b |

setvar len = 4  # overwrite
setvar len = __builtins__.len(mylist)
assert [2 === len]
## stdout:
## status: 2
## timeout: 10

#### compgen -c respects ENV.PATH, not PATH

setglobal ENV.PATH = '/bin'

# ls is required by POSIX
compgen -c | grep -w 'ls'
## STDOUT:
ls
ls
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
