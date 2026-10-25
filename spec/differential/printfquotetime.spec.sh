## Absorbed from Differential.Tests/PrintfQuoteTimeTests.cs (scripts only; expectations recorded from bash 5.2).

#### Q_Metacharacters
printf '%q\n' 'a b' "it's" 'x$y' 'a;b' 'a&b' 'a|b' 'a*b' 'a?b' 'a(b' 'a"b' 'a`b' 'a\b'
## STDOUT:
a\ b
it\'s
x\$y
a\;b
a\&b
a\|b
a\*b
a\?b
a\(b
a\"b
a\`b
a\\b
## END
## status: 0

#### Q_Empty_AndSafe
printf '[%q]\n' '' abc a/b.c-d_e a:b a=b a+b a@b a%b 'a#b' 'a~b'
## STDOUT:
['']
[abc]
[a/b.c-d_e]
[a:b]
[a=b]
[a+b]
[a@b]
[a%b]
[a#b]
[a~b]
## END
## status: 0

#### Q_LeadingSpecials
printf '%q\n' '#a' '~' '~a' '-a' '=a'
## STDOUT:
\#a
\~
\~a
-a
=a
## END
## status: 0

#### Q_ControlCharacters
printf '%q\n' "$(printf 'a\tb')" "$(printf 'x\001y')" $'l1\nl2'
## STDOUT:
$'a\tb'
$'x\001y'
$'l1\nl2'
## END
## status: 0

#### Q_RoundTrips
v=$(printf '%q' 'we ird;$x'); eval "w=$v"; echo "[$w]"
## stdout: [we ird;$x]
## status: 0

#### Time_EpochSeconds
printf '%(%Y-%m-%d %j %a %b)T\n' 302400
## stdout: 1970-01-04 004 Sun Jan
## status: 0

#### Time_Now_HasShape
case $(printf '%(%Y)T' -1) in 20[0-9][0-9]) echo year;; esac; case $(printf '%(%s)T') in [0-9]*) echo secs;; esac
## STDOUT:
year
secs
## END
## status: 0
