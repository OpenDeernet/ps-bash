## Absorbed from Differential.Tests/ErrexitEvalSourceTests.cs (scripts only; expectations recorded from bash 5.2).

#### Eval_FalseOrTrue_UnderErrexit_IsExemptAndContinues
( set -e; eval 'false || true; echo yes' ); echo "rc=$?"
## STDOUT:
yes
rc=0
## END
## status: 0

#### Eval_FalseAndAnything_UnderErrexit_IsExemptAndContinues
( set -e; eval 'false && echo no; echo yes' ); echo "rc=$?"
## STDOUT:
yes
rc=0
## END
## status: 0

#### Eval_IfFalse_UnderErrexit_IsExempt
( set -e; eval 'if false; then echo no; fi; echo yes' ); echo "rc=$?"
## STDOUT:
yes
rc=0
## END
## status: 0

#### Source_FileWithSetEFalseOrTrue_DoesNotEscapeTheShell
d=$(mktemp -d); echo '( set -e; false || true; echo yes )' > $d/f.sh; . $d/f.sh; echo "after rc=$?"
## STDOUT:
yes
after rc=0
## END
## status: 0
