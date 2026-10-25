## Imported from the Oils spec tests (ysh-place.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### place->setValue()

func f(place) {
  var x = 'f'
  call place->setValue('zzz')
  echo "f x=$x"
}

func fillPlace(place) {
  var x = 'fillPlace'
  call f(place)
  echo "fillPlace x=$x"
}

proc p {
  var x = 'hi'
  call fillPlace(&x)
  echo "p x=$x"
}

x=global

p
echo "global x=$x"
## stdout:
## status: 2
## timeout: 10

#### [DISABLED] Places can't dangle; they should passed UP the stack only

func f() {
  var f_local = null
  return (&f_local)
}

func g() {
  # This place is now INVALID!
  var place = f()

  # Should fail when we try to use the place
  echo zzz | read --all (place)

  # This should also fail
  # call place->setValue('zzz')

}

call g()

echo done
## stdout:
## status: 2
## timeout: 10
