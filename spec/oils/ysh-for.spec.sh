## Imported from the Oils spec tests (ysh-for.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### For loop over expression: List
var mylist = [1, 2, 3]
for item in (mylist) {
  echo "item $item"
}
## stdout:
## status: 2
## timeout: 10

#### For loop over expression: Dict, not BashAssoc

var mydict = {name: 'bob', age: 40}
for key in (mydict) {
  echo "key $key"
}

# We can declare this
shopt --unset no_osh_builtins
declare -A A=([name]=bob)

# But there is no iteration
for key in (A) {
  echo "key $key"
}
## stdout:
## status: 2
## timeout: 10

#### For loop over range
var myrange = 0 ..< 3
for i in (myrange) {
  echo "i $i"
}
## stdout:
## status: 2
## timeout: 10

#### Shell for loop with index (equivalent of enumerate())
for i, item in a b c {
  echo "$i $item"
}
## stdout:
## status: 2
## timeout: 10

#### 3 indices with (mylist) is a runtime error
for i, item bad in (['foo', 'bar']) {
  echo "$i $item $bad"
}
## stdout:
## status: 2
## timeout: 10

#### Shell for loop can't have 3 indices
for i, bad, bad in a b c {
  echo $i $item
}
## stdout:
## status: 2
## timeout: 10

#### Any for loop can't have 4 indices
for a, b, c, d in (['foo']) {
  echo $i $item
}
## stdout:
## status: 2
## timeout: 10

#### Expression for loop with index: List
for i, item in (['spam', 'eggs']) {
  echo "$i $item"
}
## stdout:
## status: 2
## timeout: 10

#### Expression for loop with index: Dict (TODO: define dict iter order)
for key, value in ({name: 'bob', age: 40}) {
  echo "pair $key $value"
}
## stdout:
## status: 2
## timeout: 10

#### Dict: index key value loop (TODO: define dict iter order)
for i, key, value in ({name: 'bob', age: 40}) {
  echo "entry $i $key $value"
}
## stdout:
## status: 2
## timeout: 10

#### no_parse_bare_word eliminates confusion

shopt --set no_parse_bare_word

for x in mylist {  # THIS FAILS
  echo "BAD $x"
}
## stdout:
## status: 2
## timeout: 10

#### Object that's not iterable

echo hi
for x in (42) {
  echo $x
}
## stdout: hi
## status: 2
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### YSH for with brace substitution and glob

touch {foo,bar}.py
for i, file in *.py {README,foo}.md {
  echo "$i $file"
}
## stdout:
## status: 2
## timeout: 10

#### Append to List in loop extends the loop (matches JS)

# see demo/survey-loop

var mylist = [1,2,3]
for x in (mylist) {
  if (x === 2) {
    call mylist->append(99)
  }
  echo $x
}
## stdout:
## status: 2
## timeout: 10

#### Remove from List in loop shortens it (matches JS)

# see demo/survey-loop

var mylist = [1,2,3,4]
for x in (mylist) {
  if (x === 2) {
    call mylist->pop()
  }
  echo $x
}
## stdout:
## status: 2
## timeout: 10

#### Adding to Dict in loop does NOT extend the loop (matches JS)

# see demo/survey-loop

var mydict = {"1": null, "2": null, "3": null}
for x in (mydict) {
  if (x === "2") {
    setvar mydict["99"] = null
  }
  echo $x
}
## stdout:
## status: 2
## timeout: 10

#### Removing from Dict in loop does NOT change the loop (does NOT match JS)

# see demo/survey-loop

var mydict = {"1": null, "2": null, "3": null, "4": null}
for x in (mydict) {
  if (x === "2") {
    call mydict->erase("1")
    call mydict->erase("3")
  }
  echo $x
}
## stdout:
## status: 2
## timeout: 10
