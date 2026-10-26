## Imported from the Oils spec tests (ysh-multiline.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### ... with simple command
... echo  # comment
    hi  # comment
    there
    ;
echo ---
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-multiline ysh-multiline (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### ... with pipeline
... { echo one; echo two; }
  | sort
  | wc -l
  ;
## stdout:
## status: 2
## timeout: 10

#### ... with multiline $()

# newlines mean the normal thing
echo $(echo one
       echo two)

... echo
    $(echo 3
      echo 4)  # is this right?
  | wc -l
  ;
## stdout: one two
## status: 2
## XFAIL ps-bash gap-oils-ysh-multiline ysh-multiline (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### ... inside command sub $()
echo one $(... echo
              two
              three) four
echo five
## STDOUT:
one four
five
## END
## status: 0
## timeout: 10

#### ... with && and [[
echo one && false || echo two

... echo three
 && [[ 0 -eq 0 ]]
 && echo four
 && false
 || echo five
 ;

echo ---
## STDOUT:
one
two
## END
## status: 2
## XFAIL ps-bash gap-oils-ysh-multiline ysh-multiline (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### '... for' is allowed, but NOT recommended
... for x in foo bar; do echo $x; done
    ;

... for x in foo bar; do
      echo $x;
    done
    ;

return

# This style gets messed up because of translation, but that is EXPECTED.
... for x in foo bar
    do
      echo $x;
    done
    ;
## stdout:
## status: 2
## timeout: 10

#### Blank line in multiline command is syntax error
... echo comment
    # comment
    is OK
    ;

... echo blank line

    is not OK
    ;
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-multiline ysh-multiline (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10

#### Blank line with spaces and tabs isn't OK either
... echo comment
    # comment
    is OK
    ;

# NOTE: invisible spaces and tabs below (:set list in vim)
... echo blank line
   
    is not OK
    ;



# Notes:
# - MakeParserForCommandSub() instantiates a new WordParser, so we can safely
# change state in the top-level one only
# - BoolParser is called for [[ ]] and uses the same self.w_parser.  I think
# that's OK?

# So I think we can change state in WordParser.  (Also possible in
# CommandParser but meh).
#
# self.is_multiline = False
#
# When this is flag is on, then we
#
# Id.Op_Newline -> Id.WS_Space or Id.Ignored_LineCont
#  - and then that is NOT passed to the command parser?
#  - Or you can make it Id.Ignored_Newline
#
# BUT if you get 2 of them in a row without a comment, you can change it to:
# - Id.Op_Newline?
#
# Actually this is very simple rule and maybe can be done without much
# disturbance to the code.
#
# cursor_was_newline might need more state?
## stdout:
## status: 2
## XFAIL ps-bash gap-oils-ysh-multiline ysh-multiline (oils): differs from bash 5.2; see docs/specs/spec-gaps.md
## timeout: 10
