## Absorbed from Differential.Tests/TestExpressionDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_FileTest_NonexistentFile_IsFalse
if [ -f /nonexistent/path/file.txt ]; then echo yes; else echo no; fi
## stdout: no
## status: 0

#### Differential_DirTest_TmpIsDirectory
if [ -d /tmp ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_StringTest_EqualityTrue
if [ "hello" = "hello" ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_StringTest_InequalityTrue
if [ "a" != "b" ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_StringTest_ZeroLength_EmptyIsTrue
if [ -z "" ]; then echo empty; else echo nonempty; fi
## stdout: empty
## status: 0

#### Differential_StringTest_NonEmpty_StringIsTrue
if [ -n "x" ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_IntTest_GtTrue
if [ 5 -gt 3 ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_IntTest_EqTrue
if [ 7 -eq 7 ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_IntTest_LtTrue
if [ 2 -lt 10 ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_Negation_BracketNot_FileTest
if [ ! -f /nonexistent/file ]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_Negation_PipelineNegated_False
if ! false; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_DoubleBracket_Regex_Matches
if [[ "hello world" =~ hello ]]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_DoubleBracket_LogicalAnd_FalseAndTrue_IsFalse
if [[ -f /nonexistent && -d /tmp ]]; then echo yes; else echo no; fi
## stdout: no
## status: 0

#### Differential_DoubleBracket_GlobMatch_Matches
if [[ "abc" == a* ]]; then echo yes; else echo no; fi
## stdout: yes
## status: 0

#### Differential_QuotedUndefinedVar_ZeroLengthTest_IsTrue
unset UNDEFINED_VAR_PSBASH_TEST; if [ -z "$UNDEFINED_VAR_PSBASH_TEST" ]; then echo empty; else echo defined; fi
## stdout: empty
## status: 0

#### Differential_Standalone_FileTest_AndChain_TmpExists
[ -d /tmp ] && echo yes
## stdout: yes
## status: 0

#### Differential_Standalone_FileTest_OrChain_NonexistentFallsBack
[ -f /nonexistent/file ] || echo no
## stdout: no
## status: 0
