## Imported from the Oils spec tests (array-basic.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### "${a[@]}" and "${a[*]}"
a=(1 '2 3')
argv.py "${a[@]}" "${a[*]}"
## stdout:
## status: 127
## timeout: 10

#### ${a[@]} and ${a[*]}
a=(1 '2 3')
argv.py ${a[@]} ${a[*]}
## stdout:
## status: 127
## timeout: 10

#### 4 ways to interpolate empty array
argv.py 1 "${a[@]}" 2 ${a[@]} 3 "${a[*]}" 4 ${a[*]} 5
## stdout:
## status: 127
## timeout: 10

#### empty array
empty=()
argv.py "${empty[@]}"
## stdout:
## status: 127
## timeout: 10

#### Empty array with :-
empty=()
argv.py ${empty[@]:-not one} "${empty[@]:-not one}"
## stdout:
## status: 127
## timeout: 10
