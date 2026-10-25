## Absorbed from Differential.Tests/LsColumnsDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Vertical_Width40
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -C -w 40 | cat -A
## STDOUT:
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
## END
## status: 0

#### Vertical_Width20
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -C -w 20 | cat -A
## STDOUT:
alpha^I iota$
beta^I kappa$
delta^I lambda$
epsilon  mu$
eta^I theta$
gamma^I zeta$
## END
## status: 0

#### Vertical_Width100
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -C -w 100 | cat -A
## stdout: alpha  beta  delta  epsilon  eta  gamma  iota  kappa  lambda  mu  theta  zeta$
## status: 0

#### Vertical_DefaultWidth80
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -C | cat -A
## stdout: alpha  beta  delta  epsilon  eta  gamma  iota  kappa  lambda  mu  theta  zeta$
## status: 0

#### Vertical_WidthOne
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -C -w 1 | cat -A
## STDOUT:
alpha$
beta$
delta$
epsilon$
eta$
gamma$
iota$
kappa$
lambda$
mu$
theta$
zeta$
## END
## status: 0

#### Vertical_WidthZero_Unlimited_NoTabs
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -C -w 0 | cat -A
## stdout: aaaa  bbbb  cccc  dddd  eeee  ffff$
## status: 0

#### Vertical_ExactFit_IsNotEnough
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -C -w 16 | cat -A; ls -C -w 17 | cat -A
## STDOUT:
aaaa  dddd$
bbbb  eeee$
cccc  ffff$
aaaa  cccc  eeee$
bbbb  dddd  ffff$
## END
## status: 0

#### Vertical_TabCrossing
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -C -w 1000 | cat -A
## stdout: aaaa  bbbb  cccc  dddd^Ieeee  ffff$
## status: 0

#### Across_Width40
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -x -w 40 | cat -A
## STDOUT:
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
## END
## status: 0

#### Across_Width20
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -x -w 20 | cat -A
## STDOUT:
alpha^Ibeta$
delta^Iepsilon$
eta^Igamma$
iota^Ikappa$
lambda^Imu$
theta^Izeta$
## END
## status: 0

#### Across_TabCrossing
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -x -w 30 | cat -A
## STDOUT:
aaaa  bbbb  cccc  dddd^Ieeee$
ffff$
## END
## status: 0

#### Commas_Width30
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -m -w 30 | cat -A
## STDOUT:
alpha, beta, delta, epsilon,$
eta, gamma, iota, kappa,$
lambda, mu, theta, zeta$
## END
## status: 0

#### Commas_Width12
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -m -w 12 | cat -A
## STDOUT:
alpha, beta,$
delta,$
epsilon,$
eta, gamma,$
iota, kappa,$
lambda, mu,$
theta, zeta$
## END
## status: 0

#### Commas_Unlimited
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -m -w 0 | cat -A
## stdout: alpha, beta, delta, epsilon, eta, gamma, iota, kappa, lambda, mu, theta, zeta$
## status: 0

#### Commas_DefaultWidth
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -m | cat -A
## stdout: alpha, beta, delta, epsilon, eta, gamma, iota, kappa, lambda, mu, theta, zeta$
## status: 0

#### TabSize4
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -C -T 4 -w 40 | cat -A
## stdout: aaaa  bbbb^Icccc  dddd^Ieeee  ffff$
## status: 0

#### TabSize3
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -C -T 3 -w 40 | cat -A
## stdout: aaaa^Ibbbb^Icccc^Idddd^Ieeee^Iffff$
## status: 0

#### TabSize0_SpacesOnly
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -x -T 0 -w 30 | cat -A
## STDOUT:
aaaa  bbbb  cccc  dddd  eeee$
ffff$
## END
## status: 0

#### LongOptions
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls --width=40 --tabsize=4 --format=across | cat -A
## STDOUT:
alpha  beta  delta^Iepsilon  eta$
gamma  iota  kappa^Ilambda^I mu$
theta  zeta$
## END
## status: 0

#### FormatWords
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls --format=vertical -w 40 | cat -A; ls --format=commas -w 40 | cat -A; ls --format=horizontal -w 40 | cat -A; ls --format=single-column | head -3
## STDOUT:
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
alpha, beta, delta, epsilon, eta, gamma,$
iota, kappa, lambda, mu, theta, zeta$
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
alpha
beta
delta
## END
## status: 0

#### FormatAbbreviations
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls --format=h -w 40 | cat -A; ls --format=ac -w 40 | cat -A; ls --format=c -w 40 | cat -A
## STDOUT:
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
alpha, beta, delta, epsilon, eta, gamma,$
iota, kappa, lambda, mu, theta, zeta$
## END
## status: 0

#### ColumnsEnvironment
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
COLUMNS=30 ls -C | cat -A
## STDOUT:
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
## END
## status: 0

#### WidthBeatsColumnsEnvironment
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
COLUMNS=100 ls -C -w 30 | cat -A
## STDOUT:
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
## END
## status: 0

#### TabsizeEnvironment
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
TABSIZE=0 ls -C -w 1000 | cat -A
## stdout: aaaa  bbbb  cccc  dddd  eeee  ffff$
## status: 0

#### FormatIsLastWins
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -Cx -w 40 | cat -A; ls -xC -w 40 | cat -A; ls -mC -w 40 | cat -A; ls -x1 | head -3; ls -1x -w 40 | cat -A
## STDOUT:
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
alpha  epsilon^Iiota^Imu$
beta   eta^Ikappa^Itheta$
delta  gamma^Ilambda^Izeta$
alpha
beta
delta
alpha  beta  delta  epsilon  eta$
gamma  iota  kappa  lambda   mu$
theta  zeta$
## END
## status: 0

#### LongFormatIsOverriddenByLaterColumns_ButNotByDashOne
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -lC -w 30 | cat -A; ls -l1 | wc -l; ls -1l | wc -l
## STDOUT:
aaaa  cccc  eeee$
bbbb  dddd  ffff$
7
7
## END
## status: 0

#### IndicatorsCountTowardsTheWidth
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done; mkdir gggg
ls -FC -w 30 | cat -A; ls -pC -w 18 | cat -A
## STDOUT:
aaaa  cccc  eeee  gggg/$
bbbb  dddd  ffff$
aaaa  dddd  gggg/$
bbbb  eeee$
cccc  ffff$
## END
## status: 0

#### BlockSizes
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done; printf 'xxx' > bbbb
ls -sC -w 40 | cat -A; ls -sm -w 40 | cat -A
## STDOUT:
total 4$
0 aaaa^I0 cccc^I0 eeee$
4 bbbb^I0 dddd^I0 ffff$
total 4$
0 aaaa, 4 bbbb, 0 cccc, 0 dddd, 0 eeee,$
0 ffff$
## END
## status: 0

#### Recursive_EachDirectoryIsItsOwnBlock
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done; mkdir sub; printf '' > sub/one; printf '' > sub/two
ls -RC -w 30 | cat -A
## STDOUT:
.:$
aaaa  cccc  eeee  sub$
bbbb  dddd  ffff$
$
./sub:$
one  two$
## END
## status: 0

#### SeveralOperands
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done; mkdir sub; printf '' > sub/one
ls -C -w 30 aaaa bbbb sub | cat -A
## STDOUT:
aaaa  bbbb$
$
sub:$
one$
## END
## status: 0

#### DirectoryOperandsWithD
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls -Cd -w 30 aaaa bbbb cccc | cat -A
## stdout: aaaa  bbbb  cccc$
## status: 0

#### Reverse
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -Cr -w 40 | cat -A
## STDOUT:
zeta   lambda  gamma^Idelta$
theta  kappa   eta^Ibeta$
mu     iota    epsilon^Ialpha$
## END
## status: 0

#### AllIncludesDots
for f in alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu; do printf '' > $f; done
ls -Ca -w 40 | cat -A
## STDOUT:
.      beta^Ieta    kappa   theta$
..     delta^Igamma  lambda  zeta$
alpha  epsilon^Iiota   mu$
## END
## status: 0

#### Utf8Names
for f in héllo abc ñandú zzz; do printf '' > $f; done
ls -C -w 30 | cat -A
## stdout: abc  hM-CM-)llo  zzz  M-CM-1andM-CM-:$
## status: 0

#### Error_FormatWord
for f in aaaa bbbb cccc dddd eeee ffff; do printf '' > $f; done
ls --format=bogus
## stdout:
## status: 1
