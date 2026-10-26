## Imported from the Oils spec tests (builtin-meta-assign.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### command local

f() {
  command local s=local
  echo s=$s
}

f
## stdout: s=local
## status: 0
## XFAIL ps-bash gap-oils-builtin-meta-assign builtin-meta-assign (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### export, builtin export

x='a b'

export y=$x
echo $y

builtin export z=$x
echo $z
## STDOUT:
a b
a
## END
## status: 0
## XFAIL ps-bash gap-oils-builtin-meta-assign builtin-meta-assign (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
