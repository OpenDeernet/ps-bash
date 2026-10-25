## Imported from the Oils spec tests (ysh-options-assign.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### OSH behavior
x=1
echo status=$?
echo x=$x

y = 2
echo status=$?
echo y=$y
## STDOUT:
status=0
x=1
status=127
y=
## END
## status: 0
## timeout: 10

#### parse_equals: allows bare assignment in Caps blocks
shopt --set parse_proc parse_brace parse_equals 

proc Rule {
  true
}

Rule {
  x = 1 + 2*3
}
echo x=$x

# still allowed since we didn't unset parse_sh_assign
y=foo
echo y=$y
## stdout:
## status: 2
## timeout: 10
