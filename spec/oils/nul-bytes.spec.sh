## Imported from the Oils spec tests (nul-bytes.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### printf - \0 escape shows NUL byte
show_hex() { od -A n -t c -t x1; }

printf '\0\n' | show_hex
## STDOUT:
  \0  \n
  00  0a
## END
## status: 0
## XFAIL ps-bash gap-oils-nul-bytes nul-bytes (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Compare \x00 byte versus \x01 byte - command sub

# https://stackoverflow.com/questions/32722007/is-skipping-ignoring-nul-bytes-on-process-substitution-standardized
# bash contains a warning!

show_bytes() {
  echo -n "$1" | od -A n -t x1
}

s=$(printf '.\001.')
echo len=${#s}
show_bytes "$s"

s=$(printf '.\000.')
echo len=${#s}
show_bytes "$s"

s=$(printf '\000')
echo len=${#s} 
show_bytes "$s"
## STDOUT:
len=3
 2e 01 2e
len=2
 2e 2e
len=0
## END
## status: 0
## XFAIL ps-bash gap-oils-nul-bytes nul-bytes (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Compare \x00 byte versus \x01 byte - read builtin

# Hm same odd behavior

show_string() {
  read s
  echo len=${#s}
  echo -n "$s" | od -A n -t x1
}

printf '.\001.' | show_string

printf '.\000.' | show_string

printf '\000' | show_string
## STDOUT:
len=3
 2e 01 2e
len=2
 2e 2e
len=0
## END
## status: 0
## XFAIL ps-bash gap-oils-nul-bytes nul-bytes (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Strip ops # ## % %% with NUL bytes

show_bytes() {
  echo -n "$1" | od -A n -t x1
}

s=$(printf '\000.\000')
echo len=${#s}
show_bytes "$s"

echo ---

t=${s#?}
echo len=${#t}
show_bytes "$t"

t=${s##?}
echo len=${#t}
show_bytes "$t"

t=${s%?}
echo len=${#t}
show_bytes "$t"

t=${s%%?}
echo len=${#t}
show_bytes "$t"
## STDOUT:
len=1
 2e
---
len=0
len=0
len=0
len=0
## END
## status: 0
## XFAIL ps-bash gap-oils-nul-bytes nul-bytes (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Issue 2269 Reduction

show_bytes() {
  echo -n "$1" | od -A n -t x1
}

s=$(printf '\000x')
echo len=${#s}
show_bytes "$s"

# strip one char from the front
s=${s#?}
echo len=${#s}
show_bytes "$s"

echo ---

s=$(printf '\001x')
echo len=${#s}
show_bytes "$s"

# strip one char from the front
s=${s#?}
echo len=${#s}
show_bytes "$s"
## STDOUT:
len=1
 78
len=0
---
len=2
 01 78
len=1
 78
## END
## status: 0
## XFAIL ps-bash gap-oils-nul-bytes nul-bytes (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
