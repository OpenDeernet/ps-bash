## Imported from the Oils spec tests (array-assign.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Indexed LHS without spaces, and +=
a[1]=x
echo status=$?
argv.py "${a[@]}"

a[0+2]=y
#a[2|3]=y  # zsh doesn't allow this
argv.py "${a[@]}"

# += does appending
a[0+2]+=z
argv.py "${a[@]}"
## stdout: status=0
## status: 127
## timeout: 10

#### Are quotes allowed?

# double quotes allowed in bash
a["1"]=2
echo status=$? len=${#a[@]}

a['2']=3
echo status=$? len=${#a[@]}

# allowed in bash
a[2 + "3"]=5
echo status=$? len=${#a[@]}

a[3 + '4']=5
echo status=$? len=${#a[@]}



# syntax errors are not fatal in bash
## STDOUT:
status=0 len=1
status=1 len=1
status=0 len=2
status=1 len=2
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
