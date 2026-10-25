## Imported from the Oils spec tests (unicode.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### $'' does NOT check that 0x110000 is too big at parse time

py-repr() {
  python2 -c 'import sys; print repr(sys.argv[1])'  "$@"
}

py-repr $'\U00110000'
## stdout:
## status: 127
## timeout: 10

#### $'' does not check for surrogate range at parse time

py-repr() {
  python2 -c 'import sys; print repr(sys.argv[1])'  "$@"
}

py-repr $'\udc00'

py-repr $'\U0000dc00' 
## stdout:
## status: 127
## timeout: 10
