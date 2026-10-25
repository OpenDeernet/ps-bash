## Imported from the Oils spec tests (subshell.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Subshell exit code
( false; )
echo $?
## stdout: 1
## status: 0
## timeout: 10

#### Subshell with redirects
( echo 1 ) > a.txt
( env echo 2 ) > b.txt
( env echo 3; ) > c.txt  # Sentence in LST
( echo 4; echo 5 ) > d.txt
echo status=$?
cat a.txt b.txt c.txt d.txt
## STDOUT:
status=0
1
2
3
4
5
## END
## status: 0
## timeout: 10
