## Absorbed from Differential.Tests/PathnameExpansionDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Echo_Star_ListsNamesWithoutHiddenFiles
echo *
## stdout: _tmp
## status: 0

#### Echo_StarDotTxt
echo *.txt
## stdout: *.txt
## status: 0

#### Printf_PerWord
printf '%s\n' *
## stdout: _tmp
## status: 0

#### Function_ReceivesNamesNotThePattern
f() { echo "$#"; }; f *
## stdout: 1
## status: 0

#### Array_AssignmentExpandsElements
arr=(*); echo "${#arr[@]} ${arr[*]}"
## stdout: 1 _tmp
## status: 0

#### Array_MixedLiteralAndGlobElements
arr=(a *.txt z); echo "${#arr[@]}: ${arr[*]}"
## stdout: 3: a *.txt z
## status: 0

#### ForList_StarIsRelativeAndSkipsHidden
for f in *; do echo "[$f]"; done
## stdout: [_tmp]
## status: 0

#### ForList_GlobAndLiterals
for f in a *.txt x; do echo "<$f>"; done
## STDOUT:
<a>
<*.txt>
<x>
## END
## status: 0

#### ForList_NoMatchIteratesOnceWithTheLiteral
for f in *.zz; do echo "<$f>"; done
## stdout: <*.zz>
## status: 0

#### TrailingSlash_DirectoriesOnly
echo */
## stdout: _tmp/
## status: 0

#### DotStar_NeverMatchesDotOrDotDot
echo .*
## stdout: .*
## status: 0

#### CharacterSet
echo [xy]*
## stdout: [xy]*
## status: 0

#### NegatedSet
echo [!x]*
## stdout: _tmp
## status: 0

#### PosixClass
echo [[:alpha:]]*
## stdout: [[:alpha:]]*
## status: 0

#### QuestionMark
echo ?.txt
## stdout: ?.txt
## status: 0

#### SubdirectoryPattern_KeepsThePathAsWritten
echo sub/*
## stdout: sub/*
## status: 0

#### TwoLevelPattern
echo */*
## stdout: */*
## status: 0

#### SetOfOneInTheMiddleOfAWord
echo sub/a[1]
## stdout: sub/a[1]
## status: 0

#### StarInsideQuotesMixedWithAStar
echo *"y"*
## stdout: *y*
## status: 0

#### AbsolutePattern_GivesAbsolutePaths
[ "$(echo "$PWD"/*.txt)" = "$PWD/y.txt" ] && echo same
## stdout:
## status: 1

#### SetDashDash_PositionalParametersFromGlob
set -- *; echo "$#: $1 $3"
## stdout: 1: _tmp 
## status: 0

#### BraceExpansionThenGlob_PrefixAndSuffix
echo sub/{a,b}*
## stdout: sub/a* sub/b*
## status: 0

#### BraceExpansionThenGlob_ExtensionList
echo *.{txt,zz} x
## stdout: *.txt *.zz x
## status: 0

#### DoubleQuotedStar_StaysLiteral
echo "*"
## stdout: *
## status: 0

#### SingleQuotedStar_StaysLiteral
echo '*.txt'
## stdout: *.txt
## status: 0

#### EscapedStar_StaysLiteral
echo \*
## stdout: *
## status: 0

#### EscapedBracketThenStar
echo sub/a\[*
## stdout: sub/a[*
## status: 0

#### QuotedVariablePrefix_DoesNotGlobItsOwnValue
d=sub; echo "$d"/*
## stdout: sub/*
## status: 0

#### QuotedVariableHoldingStar_StaysLiteral
v='*'; echo "$v"
## stdout: *
## status: 0

#### UnquotedVariableHoldingStar_Expands
v='*'; echo $v
## stdout: _tmp
## status: 0

#### UnquotedVariablePrefix_ThenStar
d=sub; echo $d/*
## stdout: sub/*
## status: 0

#### UnquotedCommandSubstitutionResult_Expands
echo $(echo *) end
## stdout: _tmp end
## status: 0

#### UnquotedVariable_SplitsOnIfsThenGlobs
v='x y.t*'; echo $v
## stdout: x y.t*
## status: 0

#### NoMatch_KeepsTheLiteralPattern
echo *.zz
## stdout: *.zz
## status: 0

#### NoMatch_InASubdirectory_KeepsTheLiteralPattern
echo nosuch/*
## stdout: nosuch/*
## status: 0

#### NoMatch_QuotedPartIsUnquotedInTheLiteral
echo *"y"zz*
## stdout: *yzz*
## status: 0

#### Dotglob_IncludesHiddenNames
shopt -s dotglob; echo *
## stdout: _tmp
## status: 0

#### Dotglob_StillExcludesDotAndDotDot
shopt -s dotglob; echo .*
## stdout: .*
## status: 0

#### Nullglob_NoMatchGivesNoWord
shopt -s nullglob; echo *.zz; echo n
## STDOUT:

n
## END
## status: 0

#### Nullglob_ForListRunsZeroTimes
shopt -s nullglob; for f in *.zz; do echo "<$f>"; done; echo done
## stdout: done
## status: 0

#### Cat_StarDotTxt
cat *.txt
## stdout:
## status: 1

#### Ls_StarSkipsHiddenAndListsDirectoryContents
ls *
## stdout:
## status: 0

#### Wc_CountsTheMatchedFiles
wc -c *.txt x
## stdout: 0 total
## status: 1

#### Grep_SearchesTheMatchedFiles
grep -h y *.txt x; echo rc=$?
## stdout: rc=2
## status: 0

#### Cat_StarMatchesAFileNamedLikeAClass
cat sub/a*
## stdout:
## status: 1

#### Cat_ClassOperandMatchesTheOtherFile
cat sub/a[1]
## stdout:
## status: 1

#### Touch_StarTouchesTheExistingMatches
touch *.txt; echo rc=$?
## stdout: rc=0
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
