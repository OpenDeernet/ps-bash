## Imported from the Oils spec tests (brace-expansion.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### no expansion
echo {foo}
## stdout: {foo}
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### incomplete trailing expansion
echo {a,b}_{
## stdout: a_{ b_{
## status: 0
## timeout: 10

#### partial leading expansion
echo }_{a,b}
## stdout: }_a }_b
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Char range expansion
echo -{a..e}-
## stdout: -a- -b- -c- -d- -e-
## status: 0
## timeout: 10

#### Char range expansion with step
echo -{a..e..2}-
## stdout: -a- -c- -e-
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Char ranges with steps of the wrong sign
echo -{a..e..-2}-
echo -{e..a..2}-
## STDOUT:
-a- -c- -e-
-e- -c- -a-
## END
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Descending char range expansion
echo -{e..a..-2}-
## stdout: -e- -c- -a-
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Fixed width number range expansion
echo -{01..03}-
echo -{09..12}-  # doesn't become -012-, fixed width
echo -{12..07}-
## STDOUT:
-01- -02- -03-
-09- -10- -11- -12-
-12- -11- -10- -09- -08- -07-
## END
## status: 0
## timeout: 10

#### Inconsistent fixed width number range expansion
# zsh uses the first one, bash uses the max width?
echo -{01..003}-
## stdout: -001- -002- -003-
## status: 0
## timeout: 10

#### Inconsistent fixed width number range expansion
# zsh uses the first width, bash uses the max width?
echo -{01..3}-
## stdout: -01- -02- -03-
## status: 0
## timeout: 10

#### Adjacent comma and range works
echo -{a,b}{1..3}-
## stdout: -a1- -a2- -a3- -b1- -b2- -b3-
## status: 0
## timeout: 10

#### Range inside comma works
echo -{a,_{1..3}_,b}-
## stdout: -a- -_1_- -_2_- -_3_- -b-
## status: 0
## timeout: 10

#### Mixed comma and range doesn't work
echo -{a,b,1..3}-
## stdout: -a- -b- -1..3-
## status: 0
## timeout: 10

#### comma and invalid range (adjacent and nested)
echo -{a,b}{1...3}-
echo -{a,{1...3}}-
echo {a,b}{}
# osh doesn't expand ANYTHING on invalid syntax.  That's OK because of the test
# case below.
## STDOUT:
-a{1...3}- -b{1...3}-
-a- -{1...3}-
a{} b{}
## END
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### OSH provides an alternative to invalid syntax
echo -{a,b}\{1...3\}-
echo -{a,\{1...3\}}-
echo {a,b}\{\}
## STDOUT:
-a{1...3}- -b{1...3}-
-a- -{1...3}-
a{} b{}
## END
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Side effect in expansion
# bash is the only one that does it first.  I guess since this is
# non-POSIX anyway, follow bash?
i=0
echo {a,b,c}-$((i++))
## stdout: a-0 b-1 c-2
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Invalid brace expansions don't expand
echo {1.3}
echo {1...3}
echo {1__3}
## STDOUT:
{1.3}
{1...3}
{1__3}
## END
## status: 0
## XFAIL ps-bash gap-oils-brace-expansion brace-expansion (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
