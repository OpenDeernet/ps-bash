# Bash feature coverage (measured)

How much of bash does ps-bash actually reproduce? This is a **measured** answer from a probe, not a claim.
It is the seed corpus for `spec-suite.md`.

## Published specs this is measured against

ps-bash has no spec of its own to implement; it began as "bash" and the oracle is real bash. The published
references that define "all the features of bash":

- GNU Bash Reference Manual (the 5.2 edition): <https://www.gnu.org/software/bash/manual/bash.html>
- POSIX Shell Command Language (the portable subset): <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html>
- Oils/OSH spec tests (pinned to bash 4.4, the largest public conformance corpus): the `spec/` tests of the oils repo.

Known intentional departures are in `intentional-differences.md`; fd and `BASH_SOURCE` behavior is in
`shell-fds-and-bash-source.md`.

## Method

`tests/bash-coverage/snippets.txt` holds 344 one-feature snippets (id `@@` script) grouped by manual chapter:
quoting, expansion, parameter operators, arithmetic, arrays, redirection, builtins, control flow, special variables,
job control, globbing.
`tests/bash-coverage/driver.sh <dir> <out> <skip>` runs each snippet by sourcing it in a subshell with `</dev/null`
and writes `id|rc|output`. The reference is bash 5.2 under WSL (`oracle-bash-5.2.txt`). Run ps-bash with
`tman dev tests/bash-coverage/driver.sh <dir-of-split-snippets> <out> ""` and compare per id.

Caveats: a few multi-line snippets were split imperfectly (several `var.*` ids hold the wrong snippet), so those
rows prove only that the construct does not crash; rows that print an absolute path differ by the Windows drive form
(`C:/` vs `/`) and are not counted below as gaps.

## Result (after the fixes listed below)

218 of 344 snippets are byte-identical to bash. The other 126 split as follows.

### Fixed by this work (each has an oracle test + cassette)

| Gap | Symptom |
|---|---|
| `false` in `eval`/`source` under `set -e` | threw `PsBash.FalseErrexit`, killed the whole shell |
| `cmd 2>&1 \| head -1` when the first line is stderr | the rest of the script never ran (pipeline stop swallowed) |
| `case` pattern with an expansion (`$i`, `"$i"`, `*" $i "*`) | never matched (pattern was the literal text `$i`) |
| unquoted `${a[@]}` beside another argument | "Cannot convert System.Object[] to String" |
| `echo {1..5} {a..e}` (two brace words) | same binding failure |
| `let` | assigned PowerShell variables the `$env:` reads never saw |
| `${!name}` | treated as array keys; now indirect expansion |
| `eval echo \$$a` | emitted unparseable PowerShell |
| a sourced/eval'd pipeline | output ended each line with CR LF (fused batch) |

### Missing builtins (command not found)

`bind builtin caller compgen complete coproc disown enable fc getopts hash help history-expansion (!!)
logout select suspend times ulimit umask`. `getopts` is the one scripts use most.

### Semantics gaps (the construct runs but differs)

- Arrays: sparse assignment (`a[3]=x` on an empty array), associative-array literals and key listing, `declare -p`,
  `"${a[@]/pat/rep}"`, `"${a[@]}"` word splitting when quoted, `unset a[i]`, `readarray -C`.
- Variables: `declare -n` (namerefs), `declare -i`, `readonly`/`declare -r` enforcement, `export -n`, `local` dynamic
  scope, `${x@A}`, `${@}` with `IFS`, `set -u` unbound-variable error, `${x:?msg}` inside a subshell kills the shell.
- Special variables not provided: `BASHPID BASHOPTS SHELLOPTS EUID UID GROUPS HOSTNAME HOSTTYPE MACHTYPE OSTYPE
  EPOCHSECONDS EPOCHREALTIME DIRSTACK FUNCNAME LINENO(in sourced) OPTIND PS4 TIMEFORMAT`.
- Builtins: `printf %q` and `%(...)T`, `read -d`, `set -f`/`set -o` listing, `set -x` trace output, `shift` error
  status, `shopt -p`, `test -v`, `unalias` error, `trap` for DEBUG/ERR/RETURN/EXIT-ordering/signals.
- Pipelines: `pipefail`, `PIPESTATUS` (deferred on purpose, see the memory note), `time` formatting.
- Redirection: `exec N>file` for fd 1/2, `/dev/fd/N`, `{var}>file`, `<>`, `noclobber`, swapping `3>&1 1>&2 2>&3`.
- Globbing: `extglob`, `globstar`, `nocaseglob`, `failglob`, `set -f`.
- Misc: command-not-found status (127), `function-unset`, empty-command syntax errors, here-document into a function.

### Windows-environment differences (not counted as bugs)

Absolute paths print with a drive (`C:/`), `ln -s` needs a privilege, `timeout` resolves to `timeout.exe`, no `od`,
no file mode bits (`Permission denied` on `./f`).

## Next

This probe finds breadth, one snippet per feature. The conformance suite in `spec-suite.md` adds depth: the Oils
cases per feature, run in-host, with expected output recorded from real bash. Each gap above becomes an XFAIL case
there until fixed, and the fix removes the marker.
