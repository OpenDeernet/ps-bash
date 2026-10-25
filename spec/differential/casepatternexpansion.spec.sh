## Absorbed from Differential.Tests/CasePatternExpansionTests.cs (scripts only; expectations recorded from bash 5.2).

#### Pattern_Expands row 1
i=a; case a in $i) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 2
i=a; case a in "$i") echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 3
i=a; case ' a ' in *" $i "*) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 4
i=a; case " $i " in *" $i "*) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 5
p='a*'; case abc in $p) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 6
p='a*'; case abc in "$p") echo y;; *) echo n;; esac
## stdout: n
## status: 0

#### Pattern_Expands row 7
p='a*'; case 'a*' in "$p") echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 8
x=b; case b in a|$x|c) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 9
case a in $(echo a)) echo y;; *) echo n;; esac
## stdout: y
## status: 0

#### Pattern_Expands row 10
i=a; case zz in $i) echo y;; *) echo n;; esac
## stdout: n
## status: 0

#### Pattern_Expands row 11
case a in '$i') echo y;; *) echo n;; esac
## stdout: n
## status: 0
