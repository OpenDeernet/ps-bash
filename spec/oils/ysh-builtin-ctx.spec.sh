## Imported from the Oils spec tests (ysh-builtin-ctx.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### ctx push and set
var mydict = {}
ctx push (mydict) {
  ctx set (key1="value1")
  ctx set (key2="value2")
}
json write (mydict)
## stdout:
## status: 2
## timeout: 10

#### ctx emit
var p = {}
ctx push (p) {
  ctx emit flag ({short_name: '-v'})
  # p => {'flag': [{short_name: '-v'}]}
  json write (p)

  ctx emit flag ({short_name: '-c'})
  # p => {'flag': [{short_name: '-v'}, {short_name: '-c'}]}
  json write (p)
}
json write (p)
## stdout:
## status: 2
## timeout: 10

#### nested ctx
var a = {}
var b = {}
ctx push (a) {
  ctx set (from="a")
  ctx push (b) {
    ctx set (from="b")
  }
}
json write (a)
json write (b)
## stdout:
## status: 2
## timeout: 10
