## Imported from the Oils spec tests (builtin-fc.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### fc ignores too many args
fc -l 0 1 2 || echo too many args!
## stdout:
## status: 0
## timeout: 10
## real-launcher

#### fc errors out on too many args with strict_arg_parse
shopt -s strict_arg_parse || true
fc -l 0 1 2 || echo too many args!
## stdout:
## status: 0
## timeout: 10
## real-launcher

#### fc -l when no history is present
fc -l
## stdout:
## status: 0
## timeout: 10
## real-launcher
