## Imported from the Oils spec tests (whitespace.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases needing the rest of the Oils harness ($REPO_ROOT, ysh, ...) are omitted; `$SH` cases run on the real launcher.
#### Parsing shell words \r \v

# frontend/lexer_def.py has rules for this

tab=$(python2 -c 'print "argv.py -\t-"')
cr=$(python2 -c 'print "argv.py -\r-"')
vert=$(python2 -c 'print "argv.py -\v-"')
ff=$(python2 -c 'print "argv.py -\f-"')

$SH -c "$tab"
$SH -c "$cr"
$SH -c "$vert"
$SH -c "$ff"
## stdout:
## status: 0
## timeout: 10
## real-launcher

#### \r in arith expression is allowed by some shells, but not most!

arith=$(python2 -c 'print "argv.py $(( 1 +\n2))"')
arith_cr=$(python2 -c 'print "argv.py $(( 1 +\r\n2))"')

$SH -c "$arith"
if test $? -ne 0; then
  echo 'failed'
fi

$SH -c "$arith_cr"
if test $? -ne 0; then
  echo 'failed'
fi
## stdout:
## status: 0
## timeout: 10
## real-launcher

#### whitespace in string to integer conversion

tab=$(python2 -c 'print "\t42\t"')
cr=$(python2 -c 'print "\r42\r"')

$SH -c 'echo $(( $1 + 1 ))' dummy0 "$tab"
if test $? -ne 0; then
  echo 'failed'
fi

$SH -c 'echo $(( $1 + 1 ))' dummy0 "$cr"
if test $? -ne 0; then
  echo 'failed'
fi
## STDOUT:
1
1
## END
## status: 0
## timeout: 10
## real-launcher

#### \r at end of line is not special

# hm I wonder if Windows ports have rules for this?

cr=$(python2 -c 'print "argv.py -\r"')

$SH -c "$cr"
## stdout:
## status: 0
## timeout: 10
## real-launcher

#### Default IFS does not include \r \v \f

# dash and zsh don't have echo -e
tab=$(python2 -c 'print "-\t-"')
cr=$(python2 -c 'print "-\r-"')
vert=$(python2 -c 'print "-\v-"')
ff=$(python2 -c 'print "-\f-"')

$SH -c 'argv.py $1' dummy0 "$tab"
$SH -c 'argv.py $1' dummy0 "$cr"
$SH -c 'argv.py $1' dummy0 "$vert"
$SH -c 'argv.py $1' dummy0 "$ff"


# No word splitting in zsh
## stdout:
## status: 127
## timeout: 10
## real-launcher
