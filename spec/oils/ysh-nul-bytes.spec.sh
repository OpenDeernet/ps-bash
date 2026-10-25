## Imported from the Oils spec tests (ysh-nul-bytes.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### read --raw-line, --all, --num-bytes preserve NUL bytes

proc raw-line {
  read --raw-line (&s)
  echo len=${#s}
  write --end '' $s | od -A n -t x1
}

proc all {
  read --all (&s)
  echo len=${#s}
  write --end '' $s | od -A n -t x1
}

proc num-bytes {
  read --num-bytes 3 (&s)
  echo len=${#s}
  write --end '' $s | od -A n -t x1
}

printf '.\000.' | raw-line
printf '.\000.' | all
printf '.\000.' | num-bytes
## stdout:
## status: 2
## timeout: 10
