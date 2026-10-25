## Imported from the Oils spec tests (append.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Append string to string
s='abc'
s+=d
echo $s
## stdout: abcd
## status: 0
## timeout: 10

#### Append to array to undefined variable

y+=(c d)
argv.py "${y[@]}"
## stdout:
## status: 127
## timeout: 10
