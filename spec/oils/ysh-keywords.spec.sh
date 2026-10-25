## Imported from the Oils spec tests (ysh-keywords.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### = to pretty print
= 1 + 2 * 3
## stdout:
## status: 127
## timeout: 10

#### 'call' to ignore return value
call 1 + 2 * 3

var strs = %(a b)
call len(strs)
call strs->append('c')
write -- @strs

# integer types too
const L = [5, 6]
call L->append(7)
write -- @L

write __

call L->pop()
write -- @L
## stdout:
## status: 2
## timeout: 10
