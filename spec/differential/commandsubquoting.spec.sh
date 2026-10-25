## Absorbed from Differential.Tests/CommandSubQuotingDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### CommandSub_HeredocBody_ApostropheAndParen
m="$(cat <<'EOF'
- rc kept: ps-bash's own shell :) (mostly
EOF
)"
printf '[%s]\n' "$m"
## stdout: [- rc kept: ps-bash's own shell :) (mostly]
## status: 0

#### CommandSub_HeredocForms_UnquotedDashMultiple
a=$(cat <<EOF
it's $((1+1))
EOF
)
b="$(cat <<-EOF
	it's ) tabbed
	EOF
)"
c="$(cat <<A; cat <<'B'
it's a
A
it's ) b
B
)"
printf '[%s]\n' "$a" "$b" "$c"
## STDOUT:
[it's 2]
[it's ) tabbed]
[it's a
it's ) b]
## END
## status: 0

#### CommandSub_QuotedParensInQuotedContext
echo "1 [$(echo 'a ) b')]"; echo "2 [$(echo "a ( b")]"; x="$(printf '%s' ':)')"; echo "3 [$x]"; echo "4 [${HOME:+$(echo 'x)')}]"
## STDOUT:
1 [a ) b]
2 [a ( b]
3 [:)]
4 [x)]
## END
## status: 0

#### CommandSub_ParensInAssignmentAndGluedWords
y=$(echo 'bare ) ok'); echo "[$y]"; echo [$(echo ')')] pre$(echo '(')post; echo "a $(echo "b $(echo 'c ) d')") e"
## STDOUT:
[bare ) ok]
[)] pre(post
a b c ) d e
## END
## status: 0

#### CommandSub_EscapedParen
echo "[$(echo \))]" [$(echo \()]
## stdout: [)] [(]
## status: 0

#### CommandSub_ArithShiftIsNotHeredoc
v=$( (( n = 1 << 3 )); echo "$n it's" ); echo "[$v]"
## stdout: [8 it's]
## status: 0
