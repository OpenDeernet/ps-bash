## Imported from the Oils spec tests (ysh-with-sh.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Shell ${x:-default} with YSH List (issue #954)

var mylist = [1, 2, 3]

echo mylist ${mylist:-default}

var myint = 42

echo myint ${myint:-default}
## STDOUT:
mylist default
myint default
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Shell ${a[0]} with YSH List (issue #1092)

var a = [1, 2, 3]
echo first ${a[0]}
## stdout: first
## status: 0
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Can't splice nested List

shopt --set parse_at

var mylist = ["ls", {name: 42}]

echo @mylist
## stdout: @mylist
## status: 0
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Can't splice nested Dict

declare -A A=([k]=v [k2]=v2)
echo ${A[@]}

var d ={name: [1, 2, 3]}
echo ${d[@]}
## STDOUT:
v v2

## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### ${#x} on List and Dict

var L = [1,2,3]

echo List ${#L[@]}
echo List ${#L}
# Not supported.  TODO: could be a problem
#echo List ${#L[0]}

declare -a a=(abc d)

echo array ${#a[@]}
echo array ${#a}
echo array ${#a[0]}

var d = {k: 'v', '0': 'abc'}

echo Dict ${#d[@]}
echo Dict ${#d}
# Not supported.  TODO: could be a problem
#echo Dict ${#d[0]}

declare -A d=([k]=v [0]=abc)

echo Assoc ${#d[@]}
echo Assoc ${#d}
echo Assoc ${#d[0]}
## STDOUT:
List 0
List 0
array 2
array 3
array 3
Dict 0
Dict 0
Assoc 2
Assoc 3
Assoc 3
## END
## status: 0
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Can't use $x on List and Dict

declare -a a=(abc d)
echo array $a
echo array ${a[0]}

var L = [1,2,3]
echo List $L

declare -A A=([k]=v [0]=abc)
echo Assoc $A
echo Assoc ${A[0]}

var d = {k: 'v', '0': 'abc'}
#echo Dict $d
## STDOUT:
array abc
array abc
List
Assoc abc
Assoc abc
## END
## status: 127
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Iterate over array with holes (bug fix)

declare -a array=(a b)
array[5]=c
argv.py "${array[@]}"

# TODO: Should print this like this bash, with value.BashArray
declare -a

for i, item in (array) {
  echo "$i $item"
}
## STDOUT:
declare -a BASH_ARGC=()
declare -a BASH_ARGV=()
declare -a BASH_LINENO=([0]="0")
declare -a BASH_SOURCE=([0]="/mnt/c/Users/andyb/AppData/Local/Temp/ps-bash/spec-record/388aa89174b94556b6964ee79a8edfcf.sh")
declare -ar BASH_VERSINFO=([0]="5" [1]="2" [2]="21" [3]="1" [4]="release" [5]="x86_64-pc-linux-gnu")
declare -a DIRSTACK=()
declare -a FUNCNAME
declare -a GROUPS=()
declare -a PIPESTATUS=([0]="127")
declare -a array=([0]="a" [1]="b" [5]="c")
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-with-sh ysh-with-sh (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Concat ++ not defined on shell array

declare -a a=(x y)
declare -a b=(x y)

= a ++ b
## stdout:
## status: 127
## timeout: 10
