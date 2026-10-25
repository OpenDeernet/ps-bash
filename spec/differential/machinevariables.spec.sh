## Absorbed from Differential.Tests/MachineVariablesTests.cs (scripts only; expectations recorded from bash 5.2).

#### Uid_IsNumeric
[ "$UID" -ge 0 ] && [ "$EUID" -ge 0 ] && echo ok; case "$UID" in *[!0-9]*|'') echo bad;; *) echo digits;; esac
## STDOUT:
ok
digits
## END
## status: 0

#### Ostype_IsKnown
case "$OSTYPE" in msys*|linux*|darwin*) echo known;; *) echo "unknown $OSTYPE";; esac
## stdout: known
## status: 0

#### Hosttype_IsArch
case "$HOSTTYPE" in x86_64|aarch64) echo arch;; *) echo bad;; esac; case "$MACHTYPE" in "$HOSTTYPE"-*) echo machtype;; *) echo bad;; esac
## STDOUT:
arch
machtype
## END
## status: 0

#### Hostname_NonEmpty
[ -n "$HOSTNAME" ] && echo set; echo "${HOSTNAME:-none}" | grep -q . && echo default
## STDOUT:
set
default
## END
## status: 0

#### Bashpid_IsPositive
[ "$BASHPID" -gt 0 ] && echo pid
## stdout: pid
## status: 0

#### Epoch_Shapes
[ "$EPOCHSECONDS" -gt 1700000000 ] && echo secs; case "$EPOCHREALTIME" in [0-9]*.[0-9][0-9][0-9][0-9][0-9][0-9]) echo real;; *) echo "bad $EPOCHREALTIME";; esac
## STDOUT:
secs
real
## END
## status: 0
