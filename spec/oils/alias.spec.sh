## Imported from the Oils spec tests (alias.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Usage of builtins
shopt -s expand_aliases || true
alias -- foo=echo
echo status=$?
foo x
unalias -- foo
foo x
# dash doesn't accept --
## STDOUT:
status=0
x
## END
## status: 127
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Basic alias
shopt -s expand_aliases  # bash requires this
alias hi='echo hello world'
hi || echo 'should not run this'
echo hi  # second word is not
'hi' || echo 'expected failure'
## STDOUT:
hello world
hi
expected failure
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### define and use alias on a single line
shopt -s expand_aliases
alias e=echo; e one  # this is not alias-expanded because we parse lines at once
e two; e three
## STDOUT:
two
three
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias can override builtin
shopt -s expand_aliases
alias echo='echo foo'
echo bar
## stdout: foo bar
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### defining multiple aliases, then unalias
shopt -s expand_aliases  # bash requires this
x=x
y=y
alias echo-x='echo $x' echo-y='echo $y'
echo status=$?
echo-x X
echo-y Y
unalias echo-x echo-y
echo status=$?
echo-x X || echo undefined
echo-y Y || echo undefined
## STDOUT:
status=0
x X
y Y
status=0
undefined
undefined
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias not defined
alias e='echo' nonexistentZ
echo status=$?
## stdout: status=1
## status: 0
## timeout: 10

#### unalias not defined
alias e=echo ll='ls -l'
unalias e nonexistentZ ll
echo status=$?
## stdout: status=1
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### unalias -a

alias foo=bar
alias spam=eggs

alias | egrep 'foo|spam' | wc -l

unalias -a

alias
echo status=$?
## STDOUT:
2
status=0
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### List aliases by providing names

alias e=echo ll='ls -l'
alias e ll
## STDOUT:
alias e='echo'
alias ll='ls -l'
## END
## status: 0
## timeout: 10

#### alias without args lists all aliases
alias ex=exit ll='ls -l'
alias | grep -E 'ex=|ll='  # need to grep because mksh/zsh have builtin aliases
echo status=$?
## STDOUT:
alias ex='exit'
alias ll='ls -l'
status=0
## END
## status: 0
## timeout: 10

#### unalias without args is a usage error
unalias
if test "$?" != 0; then echo usage-error; fi
## stdout: usage-error
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias with trailing space causes alias expansion on second word
shopt -s expand_aliases  # bash requires this

alias hi='echo hello world '
alias punct='!!!'

hi punct

alias hi='echo hello world'  # No trailing space

hi punct
## STDOUT:
hello world !!!
hello world punct
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Recursive alias expansion of first word
shopt -s expand_aliases  # bash requires this
alias hi='e_ hello world'
alias e_='echo __'
hi   # first hi is expanded to echo hello world; then echo is expanded.  gah.
## stdout: __ hello world
## status: 0
## timeout: 10

#### Recursive alias expansion of SECOND word
shopt -s expand_aliases  # bash requires this
alias one='ONE '
alias two='TWO '
alias e_='echo one '
e_ two hello world
## stdout: one TWO hello world
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Expansion of alias with variable
shopt -s expand_aliases  # bash requires this
x=x
alias echo-x='echo $x'  # nothing is evaluated here
x=y
echo-x hi
## stdout: y hi
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Alias must be an unquoted word, no expansions allowed
shopt -s expand_aliases  # bash requires this
alias echo_alias_='echo'
cmd=echo_alias_
echo_alias_ X  # this works
$cmd X  # this fails because it's quoted
echo status=$?
## STDOUT:
X
status=127
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### first and second word are the same alias, but no trailing space
shopt -s expand_aliases  # bash requires this
x=x
alias echo-x='echo $x'  # nothing is evaluated here
echo-x echo-x
## stdout: x echo-x
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### first and second word are the same alias, with trailing space
shopt -s expand_aliases  # bash requires this
x=x
alias echo-x='echo $x '  # nothing is evaluated here
echo-x echo-x
## stdout: x echo x
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Invalid syntax of alias
shopt -s expand_aliases  # bash requires this
alias echo_alias_= 'echo --; echo'  # bad space here
echo_alias_ x
## stdout:
## status: 127
## timeout: 10

#### Alias is respected inside eval
shopt -s expand_aliases
eval "alias sayhi='echo hello'
sayhi inside"
sayhi outside
## STDOUT:
hello inside
hello outside
## END
## status: 0
## timeout: 10

#### alias with environment bindings works
shopt -s expand_aliases
alias p_=printenv.py
FOO=1 printenv.py FOO
FOO=2 p_ FOO
## stdout:
## status: 127
## timeout: 10

#### alias with line continuation in the middle
shopt -s expand_aliases
alias e_='echo '
alias one='ONE '
alias two='TWO '
alias three='THREE'  # no trailing space
e_ one \
  two one \
  two three two \
  one
## stdout: ONE TWO ONE TWO THREE two one
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias for left brace
shopt -s expand_aliases
alias LEFT='{'
LEFT echo one; echo two; }
## STDOUT:
one
two
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias for left paren
shopt -s expand_aliases
alias LEFT='('
LEFT echo one; echo two )
## STDOUT:
one
two
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias used in subshell and command sub
# This spec seems to be contradictoary?
# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_03_01
# "When used as specified by this volume of POSIX.1-2017, alias definitions
# shall not be inherited by separate invocations of the shell or by the utility
# execution environments invoked by the shell; see Shell Execution
# Environment."
shopt -s expand_aliases
alias echo_='echo [ '
( echo_ subshell; )
echo $(echo_ commandsub)
## STDOUT:
[ subshell
[ commandsub
## END
## status: 0
## timeout: 10

#### alias used in here doc
shopt -s expand_aliases
alias echo_='echo [ '
cat <<EOF
$(echo_ ])
EOF
## stdout: [ ]
## status: 0
## timeout: 10

#### here doc inside alias
shopt -s expand_aliases
alias c='cat <<EOF
$(echo hi)
EOF
'
c
## stdout:
## status: 127
## timeout: 10

#### Corner case: alias inside LHS array arithmetic expression
shopt -s expand_aliases
alias zero='echo 0'
a[$(zero)]=ZERO
a[1]=ONE
argv.py "${a[@]}"
## stdout:
## status: 127
## timeout: 10

#### Alias that is pipeline
shopt -s expand_aliases
alias t1='echo hi|wc -c'
t1
## stdout: 3
## status: 0
## timeout: 10

#### Alias that is && || ;
shopt -s expand_aliases
alias t1='echo one && echo two && echo 3 | wc -l;
echo four'
t1
## STDOUT:
one
two
1
four
## END
## status: 0
## timeout: 10

#### Alias and arithmetic
shopt -s expand_aliases
alias a=argv.py
a $((1 + 2))
## stdout:
## status: 127
## timeout: 10

#### alias with keywords
# from issue #299
shopt -s expand_aliases
alias a=

# both of these fail to parse in OSH
# this is because of our cleaner evaluation model

a (( var = 0 ))
#a case x in x) true ;; esac

echo done
## stdout: done
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### alias with word of multiple lines
shopt -s expand_aliases

alias ll='ls -l'
ll '1
  2
  3'
echo status=$?
## stdout: status=2
## status: 0
## timeout: 10
