## Imported from the Oils spec tests (redirect-command.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### >$file touches a file
rm -f myfile
test -f myfile
echo status=$?

>myfile
test -f myfile
echo status=$?



# regression for OSH
## STDOUT:
status=1
status=0
## END
## status: 0
## timeout: 10

#### $(< $file) yields the contents of the file

seq 2 3 > myfile
foo=$(< myfile)
argv.py "$foo"
## stdout:
## status: 127
## timeout: 10

#### `< $file` behaves like $(< file)

seq 7 8 > myfile

x=`< myfile`

echo "[$x]"
## STDOUT:
[7
8]
## END
## status: 0
## timeout: 10

#### $(< file; end) is not a special case

seq 5 6 > myfile

# zsh prints the file each time!
# other shells do nothing?

foo=$(echo begin; < myfile)
echo $foo
echo ---

foo=$(< myfile; echo end)
echo $foo
echo ---

foo=$(< myfile; <myfile)
echo $foo
echo ---
## STDOUT:
begin
---
end
---

---
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
