## Imported from the Oils spec tests (process-sub.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Process sub input
f=process-sub.txt
{ echo 1; echo 2; echo 3; } > $f
cat <(head -n 2 $f) <(tail -n 2 $f)
## STDOUT:
1
2
2
3
## END
## status: 0
## timeout: 10

#### Process sub from external process to stdin
seq 3 > >(tac)
## STDOUT:
3
2
1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Process sub from shell to stdin
{ echo 1; echo 2; echo 3; } > >(tac)
## stdout:
## status: 0
## timeout: 10

#### $(<file) idiom with process sub
echo FOO >foo

# works in bash and zsh
echo $(<foo)

# this works in zsh, but not in bash
tr A-Z a-z < <(<foo)

cat < <(<foo; echo hi)
## STDOUT:
FOO
foo
hi
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### process sub in background &

cat <(seq 3; sleep 0.1) & wait

echo sync

# This one escapes, and the shell should still exit
cat <(sleep 0.1) &

echo fork
## STDOUT:
1
2
3
sync
fork
## END
## status: 0
## timeout: 10
