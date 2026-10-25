## Absorbed from Differential.Tests/QuotingDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_SingleQuote_SpacePreserved
echo 'hello world'
## stdout: hello world
## status: 0

#### Differential_SingleQuote_NoDollarExpansion
echo '$HOME is not expanded'
## stdout: $HOME is not expanded
## status: 0

#### Differential_SingleQuote_NoBacktickExpansion
echo 'no `date` here'
## stdout: no `date` here
## status: 0

#### Differential_SingleQuote_EmptyString
x=''; echo ">${x}<"
## stdout: ><
## status: 0

#### Differential_DoubleQuote_VarExpansionNoSplit
x="hello world"; echo "[$x]"
## stdout: [hello world]
## status: 0

#### Differential_DoubleQuote_MultipleVarRefs
a=foo; b=bar; echo "$a and $b"
## stdout: foo and bar
## status: 0

#### Differential_UnquotedVar_WordSplitsOnSpaces
x="hello world"; echo $x
## stdout: hello world
## status: 0

#### Differential_Backslash_EscapesDollarInDoubleQuotes
echo "price: \$5"
## stdout: price: $5
## status: 0

#### Differential_Backslash_EscapesDoubleQuoteInDoubleQuotes
echo "a\"b"
## stdout: a"b
## status: 0

#### Differential_Backslash_EscapesBacktickInDoubleQuotes
echo "a\`b"
## stdout: a`b
## status: 0

#### Differential_Backslash_NonSpecialCharIsLiteral
echo "hello\nworld"
## stdout: hello\nworld
## status: 0

#### Differential_Backslash_OutsideQuotes_Literal
echo hello\\world
## stdout: hello\world
## status: 0

#### Differential_AnsiCQuote_Newline
echo $'hello\nworld'
## STDOUT:
hello
world
## END
## status: 0

#### Differential_AnsiCQuote_Tab
echo $'col1\tcol2'
## stdout: col1	col2
## status: 0

#### Differential_AnsiCQuote_Hex
echo $'\x41\x42'
## stdout: AB
## status: 0

#### Differential_AnsiCQuote_Octal
echo $'\101\102'
## stdout: AB
## status: 0

#### Differential_AnsiCQuote_Unicode
echo $'caf\u00e9'
## stdout: café
## status: 0

#### Differential_AnsiCQuote_EscapedQuote
echo $'it\'s here'
## stdout: it's here
## status: 0

#### Differential_AnsiCQuote_UnknownEscapeKept
echo $'a\zb'
## stdout: a\zb
## status: 0

#### Differential_AnsiCQuote_AdjacentToLiteral
echo pre$'\t'post
## stdout: pre	post
## status: 0

#### Differential_AnsiCQuote_LeadingThenLiteral
echo $'X\tY'post
## stdout: X	Ypost
## status: 0

#### Differential_AnsiCQuote_InjectionStaysData
echo $'$(echo PWN)'
## stdout: $(echo PWN)
## status: 0

#### Differential_EmptyVar_UnquotedIsOmitted
x=; echo start $x end
## stdout: start end
## status: 0

#### Differential_EmptyVar_QuotedIsEmptyArg
x=; echo "[$x]"
## stdout: []
## status: 0

#### Differential_EnvPrefix_DoesNotLeakToShell
FOO=bar echo hi; echo "after:[$FOO]"
## STDOUT:
hi
after:[]
## END
## status: 0

#### Differential_EnvPrefix_RestoresPriorValue
FOO=orig; FOO=temp echo hi; echo "[$FOO]"
## STDOUT:
hi
[orig]
## END
## status: 0

#### Differential_Printenv_OneNameForm_PrintsValueOnly
unset PSBASH_ENVPFX_TEST; PSBASH_ENVPFX_TEST=yes printenv PSBASH_ENVPFX_TEST; echo ${PSBASH_ENVPFX_TEST:-gone}
## STDOUT:
yes
gone
## END
## status: 0

#### Differential_AdjacentQuotes_SingleThenDouble
echo 'hello'"world"
## stdout: helloworld
## status: 0

#### Differential_AdjacentQuotes_DoubleThenSingle
echo "hello"'world'
## stdout: helloworld
## status: 0

#### Differential_AdjacentQuotes_SingleThenSingle
echo 'a''b'
## stdout: ab
## status: 0

#### Differential_AdjacentQuotes_DoubleThenDouble
echo "a""b"
## stdout: ab
## status: 0

#### Differential_AdjacentQuotes_DoubleVarThenSingle
x=mid; echo "$x"'-tail'
## stdout: mid-tail
## status: 0

#### Differential_AdjacentQuotes_InjectionStaysData
x='$(echo PWN);rm'; echo 'lit'"$x"
## stdout: lit$(echo PWN);rm
## status: 0

#### Differential_AdjacentQuotes_UnquotedAndDoubleQuoted
echo pre"mid"suf
## stdout: premidsuf
## status: 0
