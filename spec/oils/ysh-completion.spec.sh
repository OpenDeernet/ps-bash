## Imported from the Oils spec tests (ysh-completion.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### compexport

compexport -c 'hay'
## stdout:
## status: 127
## timeout: 10

#### compexport with multi-line commands

# TODO: Why do we get 3 copies of echo?
# compexport -c $'for x in y; do\nec'

compexport -c $'for x in y; do\ncompl'
## stdout:
## status: 127
## timeout: 10

#### redirect completions are quoted

touch "can't touch this"

compexport -c 'echo hi > c'
## stdout:
## status: 127
## timeout: 10

#### dir completions have trailing slash

mkdir -p "can't touch this"
compexport -c 'cd ca'
## stdout:
## status: 127
## timeout: 10

#### filenames are completed

touch foo bar baz

compexport -c $'echo ba'
## stdout:
## status: 127
## timeout: 10

#### complete both -W and -F: words and functions

__git() {
  COMPREPLY=(corn dill)
}
complete -W 'ale $(echo bean)' -F __git GIT

compexport -c 'GIT '
## stdout:
## status: 127
## timeout: 10

#### -o default is an "else action", when zero are shown

touch file1 file2

echo '-- nothing registered'
compexport -c 'GIT '

__git() {
  #argv.py "$@"
  COMPREPLY=(foo bar)
}

complete -F __git GIT

echo '-- func'
compexport -c 'GIT '

complete -F __git -o default GIT
echo '-- func default'
compexport -c 'GIT '

__git() {
  # don't show anything
  true
}

# have to RE-REGISTER after defining function!  Hm
complete -F __git -o default GIT

echo '-- empty func default'
compexport -c 'GIT '

# Is the order reversed?
# Does GNU readline always sort them?


# TODO:
# --begin --end  
# --table ?  For mulitiple completions
# compatible with -C ?
# --trace - show debug_f tracing on stderr?  Would be very nice!
## STDOUT:
-- nothing registered
-- func
-- func default
-- empty func default
## END
## status: 127
## timeout: 10

#### Complete Filenames with bad characters

touch hello
touch $'hi\xffthere'

compexport -c 'echo h'
## stdout:
## status: 127
## timeout: 10

#### Complete Command with bad characters

touch foo fooz

compexport -c $'echo "bad \xff byte" f'
## stdout:
## status: 127
## timeout: 10
