## Absorbed from Differential.Tests/GrepDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Grep_RepeatedDashE_OrPatterns
printf 'apple\nbanana\ncherry\n' | grep -e apple -e cherry
## STDOUT:
apple
cherry
## END
## status: 0

#### Grep_DashIeBundle_IgnoreCase
printf 'Apple\nbanana\nAPPLE\n' | grep -ie apple
## STDOUT:
Apple
APPLE
## END
## status: 0

#### Grep_DashVeBundle_Inverts
printf 'apple\nbanana\ncherry\n' | grep -ve apple
## STDOUT:
banana
cherry
## END
## status: 0

#### Grep_DashWeBundle_WordRegexp
printf 'cat\ncatastrophe\nwildcat\n' | grep -we cat
## stdout: cat
## status: 0

#### Grep_PipelineContextA_EmitsAfter
printf 'a\nb\nc\n' | grep -A1 a
## STDOUT:
a
b
## END
## status: 0

#### Grep_PipelineContextB_EmitsBefore
printf 'a\nb\nc\n' | grep -B1 c
## STDOUT:
b
c
## END
## status: 0

#### Grep_PipelineContextC_EmitsAround
printf 'a\nb\nc\nd\ne\n' | grep -C1 c
## STDOUT:
b
c
d
## END
## status: 0

#### Grep_Bre_PunctClass_Compiles
printf 'a!b\nab\n' | grep '[[:punct:]]'
## stdout: a!b
## status: 0

#### Grep_Bre_EscapedPipe_IsAlternation
printf 'foo\nbar\na|b\n(foo)\nfo{2}\nfoofoo\nfofo\nx?\n' | grep 'foo\|bar'
## STDOUT:
foo
bar
(foo)
foofoo
## END
## status: 0

#### Grep_Bre_EscapedGroup_Backref
printf 'foo\nbar\na|b\n(foo)\nfo{2}\nfoofoo\nfofo\nx?\n' | grep '\(fo\)\1'
## stdout: fofo
## status: 0

#### Grep_Bre_EscapedInterval_PlusQuestion
printf 'foo\nbar\na|b\n(foo)\nfo{2}\nfoofoo\nfofo\nx?\n' | grep -e 'o\{2\}' -e 'r\+$' -e '^x\?f'
## STDOUT:
foo
bar
(foo)
fo{2}
foofoo
fofo
## END
## status: 0

#### Grep_Bre_BareMetachars_AreLiteral
printf 'foo\nbar\na|b\n(foo)\nfo{2}\nfoofoo\nfofo\nx?\n' | grep -e 'a|b' -e '(foo)' -e 'fo{2}' -e 'x?'
## STDOUT:
a|b
(foo)
fo{2}
x?
## END
## status: 0

#### Grep_Bre_GroupedAlternation_Anchored
printf 'foo\nbar\na|b\n(foo)\nfo{2}\nfoofoo\nfofo\nx?\n' | grep '^\(a\|b\)'
## STDOUT:
bar
a|b
## END
## status: 0
