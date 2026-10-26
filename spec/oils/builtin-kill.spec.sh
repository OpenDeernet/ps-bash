## Imported from the Oils spec tests (builtin-kill.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### kill -KILL kills the process with SIGKILL
sleep 0.1 & 
pid=$!
kill -KILL $pid 
echo kill=$?

wait $pid
echo wait=$?  # 137 is 128 + SIGKILL
## STDOUT:
kill=0
wait=137
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill -s TERM specifies the signal name
sleep 0.1 &
pid=$!
kill -s TERM $pid
echo kill=$?

wait $pid
echo wait=$?
## STDOUT:
kill=0
wait=143
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill -l with exit code
kill -l 134 # 128 + 6 (ABRT)
## stdout: ABRT
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill -l with 128 is invalid
kill -l 128
if [ $? -ne 0 ]; then
    echo "invalid"
fi
## stdout: invalid
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill -l 0 returns EXIT
kill -l 0
## stdout: EXIT
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill -l 0 INT lists both signals
kill -l 0 INT
## STDOUT:
EXIT
2
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill multiple pids at once
sleep 0.1 &
pid1=$!
sleep 0.1 &
pid2=$!
sleep 0.1 &
pid3=$!

kill $pid1 $pid2 $pid3
echo $?
## stdout: 0
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### kill pid and job at once
sleep 0.1 &
pid=$!
sleep 0.1 &
kill %2 $pid
echo $?
## stdout: 0
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Numeric signal out of range - OSH may send it anyway

sleep 0.1 &

# OSH doesn't validate this, but that could be useful for non-portable signals,
# which we don't have a name for.

kill -s 9999 %%
echo kill=$?

wait
echo wait=$?
## STDOUT:
kill=1
wait=0
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-kill builtin-kill (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
