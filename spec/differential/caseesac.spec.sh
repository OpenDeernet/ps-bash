## Absorbed from Differential.Tests/CaseEsacDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Differential_Case_SimpleMatch
case hello in hello) echo yes ;; esac
## stdout: yes
## status: 0

#### Differential_Case_NoMatch_NoOutput
case x in a) echo a ;; b) echo b ;; esac
## stdout:
## status: 0

#### Differential_Case_WildcardDefault
case anything in foo) echo foo ;; *) echo default ;; esac
## stdout: default
## status: 0

#### Differential_Case_LeadingParenForm
case hello in (hello) echo yes ;; esac
## stdout: yes
## status: 0

#### Differential_Case_ExitCodePropagation
case ok in ok) false ;; esac; echo $?
## stdout: 1
## status: 0

#### Differential_Case_AlternatePatterns
case b in a|b|c) echo abc ;; *) echo other ;; esac
## stdout: abc
## status: 0

#### Differential_Case_GlobPattern
case file.txt in *.txt) echo text ;; *) echo other ;; esac
## stdout: text
## status: 0

#### Differential_Case_VariableSubject
x=hello; case $x in hello) echo matched ;; *) echo missed ;; esac
## stdout: matched
## status: 0

#### Differential_Case_QuotedSubject
x=world; case "$x" in world) echo yes ;; *) echo no ;; esac
## stdout: yes
## status: 0

#### Differential_Case_NoFallthrough_OnlyFirstMatchFires
case a in a) echo first ;; b) echo second ;; esac
## stdout: first
## status: 0
