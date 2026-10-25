## Absorbed from Differential.Tests/TmpPathDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Tmp_ExpandedAndLiteral_NameOneFile
d=/tmp; f=psb_rt_$$
echo x > $d/$f; echo y >> "$d/$f"
cat /tmp/$f
[ -e $d/$f ] && echo test-e
[[ -f "$d/$f" ]] && echo dbl-f
while read -r l; do echo "read $l"; done < $d/$f
rm $d/$f
[ -e /tmp/$f ] || echo gone
## STDOUT:
x
y
test-e
dbl-f
read x
read y
gone
## END
## status: 0

#### Tmp_ExpandedDirectoryOps_LandWhereLiteralLooks
d=/tmp; f=psb_rtd_$$
mkdir $d/$f && touch $d/$f/t
[ -e /tmp/$f/t ] && echo mkdir-touch
cp /tmp/$f/t $d/$f/u && mv $d/$f/u $d/$f/v && [ -e /tmp/$f/v ] && echo cp-mv
find $d/$f -name v | wc -l
(cd $d/$f && [ -e t ] && echo cd)
rm -r $d/$f; [ -e /tmp/$f ] || echo gone
## STDOUT:
mkdir-touch
cp-mv
1
cd
gone
## END
## status: 0
