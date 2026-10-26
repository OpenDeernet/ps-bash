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

#### mini-parseArgs
proc parser (; place ; ; block_def) {
  var p = {}
  ctx push (p; ; block_def)
  call place->setValue(p)
}

var Bool = "Bool"
var Int = "Int"
proc flag (short_name, long_name; type; help) {
  ctx emit flag ({short_name, long_name, type, help})
}

proc arg (name) {
  ctx emit arg ({name})
}

parser (&spec) {
  flag -t --tsv (Bool, help='Output as a TSV')
  flag -r --recursive (Bool, help='Recurse into the given directory')
  flag -N --count (Int, help='Process no more than N files')
  arg path
}
json write (spec)
## stdout:
## status: 2
## timeout: 10

#### ctx with value.Place, not List/Dict (error location bug fix)

ctx push (&p) {
  true
}
## stdout:
## status: 2
## timeout: 10
