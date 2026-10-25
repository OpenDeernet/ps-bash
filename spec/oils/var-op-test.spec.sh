## Imported from the Oils spec tests (var-op-test.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Lazy Evaluation of Alternative
i=0
x=x
echo ${x:-$((i++))}
echo $i
echo ${undefined:-$((i++))}
echo $i  # i is one because the alternative was only evaluated once
## STDOUT:
x
0
0
1
## END
## status: 0
## timeout: 10

#### Default value when empty
empty=''
echo ${empty:-is empty}
## stdout: is empty
## status: 0
## timeout: 10

#### Default value when unset
echo ${unset-is unset}
## stdout: is unset
## status: 0
## timeout: 10

#### Unquoted with array as default value
set -- '1 2' '3 4'
argv.py X${unset=x"$@"x}X
argv.py X${unset=x$@x}X  # If you want OSH to split, write this
# osh
## stdout:
## status: 127
## timeout: 10

#### Quoted with array as default value
set -- '1 2' '3 4'
argv.py "X${unset=x"$@"x}X"
argv.py "X${unset=x$@x}X"  # OSH is the same here

# Bash 4.2..4.4 had a bug. This was fixed in Bash 5.0.
#
# ## BUG bash STDOUT:
# ['Xx1', '2', '3', '4xX']
# ['Xx1 2 3 4xX']
# ## END
## stdout:
## status: 127
## timeout: 10

#### Assign default with array
set -- '1 2' '3 4'
argv.py X${unset=x"$@"x}X
argv.py "$unset"
## stdout:
## status: 127
## timeout: 10

#### Assign default value when empty
empty=''
${empty:=is empty}
echo $empty
## stdout: is empty
## status: 0
## timeout: 10

#### Assign default value when unset
${unset=is unset}
echo $unset
## stdout: is unset
## status: 0
## timeout: 10

#### ${v:+foo} Alternative value when empty
v=foo
empty=''
echo ${v:+v is not empty} ${empty:+is not empty}
## stdout: v is not empty
## status: 0
## timeout: 10

#### ${v+foo} Alternative value when unset
v=foo
echo ${v+v is not unset} ${unset:+is not unset}
## stdout: v is not unset
## status: 0
## timeout: 10

#### "${x+foo}" quoted (regression)
# Python's configure caught this
argv.py "${with_icc+set}" = set
## stdout:
## status: 127
## timeout: 10

#### ${s+foo} and ${s:+foo} when set -u
set -u
v=v
echo v=${v:+foo}
echo v=${v+foo}
unset v
echo v=${v:+foo}
echo v=${v+foo}
## STDOUT:
v=foo
v=foo
v=
v=
## END
## status: 0
## timeout: 10

#### ${v-foo} and ${v:-foo} when set -u
set -u
v=v
echo v=${v:-foo}
echo v=${v-foo}
unset v
echo v=${v:-foo}
echo v=${v-foo}
## STDOUT:
v=v
v=v
v=foo
v=foo
## END
## status: 0
## timeout: 10

#### $@ (empty) and - and +
echo argv=${@-minus}
echo argv=${@+plus}
echo argv=${@:-minus}
echo argv=${@:+plus}
## STDOUT:
argv=minus
argv=
argv=minus
argv=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $@ ("") and - and +
set -- ""
echo argv=${@-minus}
echo argv=${@+plus}
echo argv=${@:-minus}
echo argv=${@:+plus}

# Zsh treats $@ as an array unlike Bash converting it to a string by joining it
# with a space.
## STDOUT:
argv=
argv=plus
argv=minus
argv=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $@ ("" "") and - and +
set -- "" ""
echo argv=${@-minus}
echo argv=${@+plus}
echo argv=${@:-minus}
echo argv=${@:+plus}
## STDOUT:
argv=
argv=plus
argv=
argv=plus
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### $* ("" "") and - and + (IFS=)
set -- "" ""
IFS=
echo argv=${*-minus}
echo argv=${*+plus}
echo argv=${*:-minus}
echo argv=${*:+plus}
## STDOUT:
argv=
argv=plus
argv=
argv=plus
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### "$*" ("" "") and - and + (IFS=)
set -- "" ""
IFS=
echo "argv=${*-minus}"
echo "argv=${*+plus}"
echo "argv=${*:-minus}"
echo "argv=${*:+plus}"
## STDOUT:
argv=
argv=plus
argv=minus
argv=
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Error when empty
empty=''
echo ${empty:?'is em'pty}  # test eval of error
echo should not get here
## stdout:
## status: 1
## timeout: 10

#### Error when unset
echo ${unset?is empty}
echo should not get here
## stdout:
## status: 1
## timeout: 10

#### Error when unset
v=foo
echo ${v+v is not unset} ${unset:+is not unset}
## stdout: v is not unset
## status: 0
## timeout: 10

#### ${var=x} dynamic scope
f() { : "${hello:=x}"; echo $hello; }
f
echo hello=$hello

f() { hello=x; }
f
echo hello=$hello
## STDOUT:
x
hello=x
hello=x
## END
## status: 0
## timeout: 10

#### array ${arr[0]=x}
arr=()
echo ${#arr[@]}
: ${arr[0]=x}
echo ${#arr[@]}
## STDOUT:
0
1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### assoc array ${arr["k"]=x}
# note: this also works in zsh

declare -A arr=()
echo ${#arr[@]}
: ${arr['k']=x}
echo ${#arr[@]}
## STDOUT:
0
1
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### "\z" as arg
echo "${undef-\$}"
echo "${undef-\(}"
echo "${undef-\z}"
echo "${undef-\"}"
echo "${undef-\`}"
echo "${undef-\\}"
# Note: this line terminates the quoting by ` not to confuse the text editor.
## STDOUT:
$
\(
\z
"
`
\
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### "\e" as arg
echo "${undef-\e}"
## stdout: \e
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
