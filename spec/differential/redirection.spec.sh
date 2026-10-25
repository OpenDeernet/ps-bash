## Absorbed from Differential.Tests/RedirectionDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_Redirect_StdoutToFile_EchoCatRoundtrip
tmpf="/tmp/psbash_redir_$$"; echo hello > "$tmpf"; cat "$tmpf"; rm -f "$tmpf"
## stdout: hello
## status: 0

#### Differential_Redirect_AppendToFile_TwoLineOutput
tmpf="/tmp/psbash_append_$$"; echo a > "$tmpf"; echo b >> "$tmpf"; cat "$tmpf"; rm -f "$tmpf"
## STDOUT:
a
b
## END
## status: 0

#### Differential_Redirect_DevNull_DiscardsOutput
echo suppressed > /dev/null; echo done
## stdout: done
## status: 0

#### Differential_Redirect_Stderr_DevNull_SuppressesError
__psbash_no_such_cmd_xyz__ 2>/dev/null; echo $?
## stdout: 127
## status: 0

#### Differential_Redirect_HereString_CatHello
cat <<< "hello"
## stdout: hello
## status: 0

#### Differential_Redirect_Heredoc_Literal_NoVarExpansion
cat <<'EOF'
$USER
EOF
## stdout: $USER
## status: 0

#### Differential_Redirect_StderrToStdout_PipedToCat
echo err >&2 2>&1 | cat
## stdout:
## status: 0

#### Differential_Redirect_VariableTarget_WritesCorrectFile
logfile="/tmp/psbash_var_$$"; echo content > "$logfile"; cat "$logfile"; rm -f "$logfile"
## stdout: content
## status: 0

#### Differential_Redirect_StdinFromFile_CatReadsIt
tmpf="/tmp/psbash_stdin_$$"; echo world > "$tmpf"; cat < "$tmpf"; rm -f "$tmpf"
## stdout: world
## status: 0

#### Differential_Redirect_IoNumber_Adjacent_IsStderrRedirect
__psbash_no_such_xyz__ 2>/dev/null; echo after
## stdout: after
## status: 0

#### Differential_Redirect_BraceGroup_StdoutToFile
tmpf="/tmp/psbash_brace_$$"; { echo line1; echo line2; } > "$tmpf"; cat "$tmpf"; rm -f "$tmpf"
## STDOUT:
line1
line2
## END
## status: 0

#### Differential_Redirect_Heredoc_StripTabs
cat <<-EOF
	hello
	world
EOF
## STDOUT:
hello
world
## END
## status: 0

#### Differential_Redirect_HeredocFollowedByCommand
cat <<EOF
body line
EOF
echo SECOND
## STDOUT:
body line
SECOND
## END
## status: 0

#### Differential_Redirect_HeredocBodyUnbalancedQuote_ThenCommand
cat <<'EOF'
val="oops
more )( ` stuff
EOF
echo DONE
## STDOUT:
val="oops
more )( ` stuff
DONE
## END
## status: 0

#### Differential_Redirect_StackedHeredocs_ThenCommand
cat <<A <<B
alpha
A
beta
B
echo END
## STDOUT:
beta
END
## END
## status: 0
