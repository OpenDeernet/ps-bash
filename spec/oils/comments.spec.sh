## Imported from the Oils spec tests (comments.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### comment
echo foo #comment
## stdout: foo
## status: 0
## timeout: 10

#### not a comment without leading space x
echo foo#not_comment
## stdout: foo#not_comment
## status: 0
## timeout: 10
