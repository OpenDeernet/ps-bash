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
