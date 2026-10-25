## Absorbed from Differential.Tests/LsSortTimeDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### X_ExtensionThenName
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -X
## STDOUT:
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
## END
## status: 0

#### X_Reversed
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -Xr
## STDOUT:
bbbb.h
ee.tar.gz
dddd.a.c
aaaa.c
ff
cccc
## END
## status: 0

#### SortExtension_LongForm
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --sort=extension; ls --sort=ext
## STDOUT:
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
## END
## status: 0

#### X_WithAll_DotfilesSortByTheirWholeName
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff; printf '' > .cfg; printf '' > .bashrc
ls -Xa
## STDOUT:
cccc
ff
.
..
.bashrc
aaaa.c
dddd.a.c
.cfg
ee.tar.gz
bbbb.h
## END
## status: 0

#### X_ThenT_LastWins
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -Xt; ls -tX
## STDOUT:
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
## END
## status: 0

#### U_ListsEverything
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -U | sort
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### SortNone_ListsEverything
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --sort=none | sort; ls --sort=n | sort
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### U_ThenT_Sorts
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -Ut
## STDOUT:
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
## END
## status: 0

#### SortWord_Bogus
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --sort=bogus; echo rc=$?
## stdout: rc=1
## status: 0

#### T_ByModification
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -t
## STDOUT:
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
## END
## status: 0

#### U_AloneSortsByAccessTime
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -u
## STDOUT:
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
## END
## status: 0

#### Ut_SortsByAccessTime
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -ut; ls -tu
## STDOUT:
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
## END
## status: 0

#### Utr_Reversed
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -utr
## STDOUT:
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
## END
## status: 0

#### Us_SizeSortKeepsNameOrderForEqualSizes
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -uS
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### Lu_NameOrderWithAccessDates
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -lu --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2023-06-01 10:00 dddd.a.c
2019-01-01 10:00 ee.tar.gz
2024-05-05 05:05 ff
## END
## status: 0

#### Lut_AccessOrderAndDates
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -lut --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-05-05 05:05 ff
2023-06-01 10:00 dddd.a.c
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2019-01-01 10:00 ee.tar.gz
## END
## status: 0

#### Time_Atime_Access_Use
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --time=atime; ls --time=access; ls --time=use; ls -t --time=atime
## STDOUT:
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
## END
## status: 0

#### Time_Mtime_BeatsEarlierU
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -u --time=mtime; ls -u --time=modification
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### LastOfUAndTimeWins
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time=ctime -u --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l -u --time=mtime --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2023-06-01 10:00 dddd.a.c
2019-01-01 10:00 ee.tar.gz
2024-05-05 05:05 ff
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
## END
## status: 0

#### Time_AbbreviationsAndErrors
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --time=at; ls --time=a; echo rc=$?; ls --time=bogus; echo rc=$?
## STDOUT:
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
rc=0
rc=1
## END
## status: 0

#### C_AndCtime_ListEveryEntry
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -c | sort; ls -lc | wc -l; ls --time=ctime | sort; ls --time=status | sort
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
7
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### LongIso
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
## END
## status: 0

#### Iso_OldRecentAndFuture
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=iso | cat -A | awk '{ $1=$2=$3=$4=$5=""; print }'
## STDOUT:
    
     2024-01-01 aaaa.c$
     2024-01-02 bbbb.h$
     2024-01-03 cccc$
     2023-06-01 dddd.a.c$
     2099-01-02 ee.tar.gz$
     2000-02-03 ff$
## END
## status: 0

#### Locale_IsTheDefault
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=locale | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l | awk 'NF >= 8 { print $6, $7, $8 }' 
## STDOUT:
Jan 1 2024
Jan 2 2024
Jan 3 2024
Jun 1 2023
Jan 2 2099
Feb 3 2000
Jan 1 2024
Jan 2 2024
Jan 3 2024
Jun 1 2023
Jan 2 2099
Feb 3 2000
## END
## status: 0

#### PosixPrefixed_AreTheLocaleForm
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=posix-long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
## END
## status: 0

#### FullIso_WithoutTheOffset
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=full-iso | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
## END
## status: 0

#### FullTime
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --full-time | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
## END
## status: 0

#### FullTime_Last_OfFullTimeAndStyle
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --full-time --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l --time-style=long-iso --full-time | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
## END
## status: 0

#### FullTime_WithU
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --full-time -u | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2022-01-01 10:00:00.000000000 aaaa.c
2021-01-01 10:00:00.000000000 bbbb.h
2020-01-01 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2019-01-01 10:00:00.000000000 ee.tar.gz
2024-05-05 05:05:05.000000000 ff
## END
## status: 0

#### FullTime_ThenColumnsAreNotLong
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --full-time -C -w 40; ls --full-time -1 | wc -l
## STDOUT:
aaaa.c	cccc	  ee.tar.gz
bbbb.h	dddd.a.c  ff
7
## END
## status: 0

#### TimeStyle_Abbreviations
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=long-i | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l --time-style=f | wc -l; ls -l --time-style=i | wc -l
## STDOUT:
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
7
7
## END
## status: 0

#### TimeStyle_Environment
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
TIME_STYLE=long-iso ls -l | awk 'NF >= 8 { print $6, $7, $8 }'
## STDOUT:
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
## END
## status: 0

#### TimeStyle_OptionBeatsEnvironment
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
TIME_STYLE=long-iso ls -l --time-style=iso | cat -A | awk '{ $1=$2=$3=$4=$5=""; print }'
## STDOUT:
    
     2024-01-01 aaaa.c$
     2024-01-02 bbbb.h$
     2024-01-03 cccc$
     2023-06-01 dddd.a.c$
     2099-01-02 ee.tar.gz$
     2000-02-03 ff$
## END
## status: 0

#### TimeStyle_BogusWithoutLongIsNoError
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls --time-style=bogus | wc -l; echo rc=$?
## STDOUT:
6
rc=0
## END
## status: 0

#### TimeStyle_BogusIsAnErrorForLong
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=bogus; echo rc=$?
## stdout: rc=2
## status: 0

#### TimeStyle_AmbiguousAbbreviation
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -l --time-style=l; echo rc=$?
## stdout: rc=2
## status: 0

#### G_NoOwnerColumn
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -g --time-style=long-iso | awk '{ $3=""; print }'
## STDOUT:
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
## END
## status: 0

#### O_NoGroupColumn
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -o --time-style=long-iso | awk '{ $3=""; print }'
## STDOUT:
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
## END
## status: 0

#### GO_NeitherColumn
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -go --time-style=long-iso; ls -og --time-style=long-iso; ls -lgo --time-style=long-iso
## STDOUT:
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
## END
## status: 0

#### G_NoGroup_Long
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -lG --time-style=long-iso | awk '{ $3=""; print }'; ls -l --no-group --time-style=long-iso | awk '{ $3=""; print }'
## STDOUT:
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
## END
## status: 0

#### G_Alone_IsNotLong
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -G
## STDOUT:
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
## END
## status: 0

#### N_NumericIdsImplyLong
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -n --time-style=long-iso | awk '{ print NF, $1, $2, $5, $6, $7, $8 }'; ls --numeric-uid-gid | wc -l
## STDOUT:
2 total 24    
8 -rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
8 -rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
8 -rw-r--r-- 1 1 2024-01-03 10:00 cccc
8 -rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
8 -rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
8 -rw-r--r-- 1 1 2000-02-03 04:05 ff
7
## END
## status: 0

#### N_ColumnsAreNumbers
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -n | awk 'NF >= 8 { print ($3 ~ /^[0-9]+$/) ? "num" : "name", ($4 ~ /^[0-9]+$/) ? "num" : "name" }' | sort -u
## stdout: num num
## status: 0

#### GO_WithHumanAndBlocks
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
ls -gohs --time-style=long-iso
## STDOUT:
total 24K
4.0K -rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
4.0K -rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
4.0K -rw-r--r-- 1 1 2024-01-03 10:00 cccc
4.0K -rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
4.0K -rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
4.0K -rw-r--r-- 1 1 2000-02-03 04:05 ff
## END
## status: 0

#### U_AloneSortsByAccessTime
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -u
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### G_NoOwnerColumn
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -g --time-style=long-iso | awk '{ $3=""; print }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Time_Atime_Access_Use
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --time=atime; ls --time=access; ls --time=use; ls -t --time=atime
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### G_NoGroup_Long
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -lG --time-style=long-iso | awk '{ $3=""; print }'; ls -l --no-group --time-style=long-iso | awk '{ $3=""; print }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Iso_OldRecentAndFuture
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=iso | cat -A | awk '{ $1=$2=$3=$4=$5=""; print }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
    
     2024-01-01 aaaa.c$
     2024-01-02 bbbb.h$
     2024-01-03 cccc$
     2023-06-01 dddd.a.c$
     2099-01-02 ee.tar.gz$
     2000-02-03 ff$
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### O_NoGroupColumn
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -o --time-style=long-iso | awk '{ $3=""; print }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
total 24 
-rw-r--r-- 1  1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1  1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1  1 2024-01-03 10:00 cccc
-rw-r--r-- 1  1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1  1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1  1 2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### SortExtension_LongForm
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --sort=extension; ls --sort=ext
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### FullTime_Last_OfFullTimeAndStyle
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --full-time --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l --time-style=long-iso --full-time | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Time_Mtime_BeatsEarlierU
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -u --time=mtime; ls -u --time=modification
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### SortWord_Bogus
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --sort=bogus; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=1
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### PosixPrefixed_AreTheLocaleForm
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=posix-long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_Abbreviations
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=long-i | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l --time-style=f | wc -l; ls -l --time-style=i | wc -l
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
7
7
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### X_Reversed
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -Xr
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
bbbb.h
ee.tar.gz
dddd.a.c
aaaa.c
ff
cccc
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### GO_NeitherColumn
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -go --time-style=long-iso; ls -og --time-style=long-iso; ls -lgo --time-style=long-iso
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
total 24
-rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
-rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
-rw-r--r-- 1 1 2024-01-03 10:00 cccc
-rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
-rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
-rw-r--r-- 1 1 2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_BogusWithoutLongIsNoError
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --time-style=bogus | wc -l; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
6
rc=0
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_AmbiguousAbbreviation
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=l; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### FullTime_WithU
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --full-time -u | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2022-01-01 10:00:00.000000000 aaaa.c
2021-01-01 10:00:00.000000000 bbbb.h
2020-01-01 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2019-01-01 10:00:00.000000000 ee.tar.gz
2024-05-05 05:05:05.000000000 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### FullTime_ThenColumnsAreNotLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --full-time -C -w 40; ls --full-time -1 | wc -l
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c	cccc	  ee.tar.gz
bbbb.h	dddd.a.c  ff
7
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Lu_NameOrderWithAccessDates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -lu --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2023-06-01 10:00 dddd.a.c
2019-01-01 10:00 ee.tar.gz
2024-05-05 05:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### U_ListsEverything
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -U | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### LastOfUAndTimeWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time=ctime -u --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l -u --time=mtime --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2023-06-01 10:00 dddd.a.c
2019-01-01 10:00 ee.tar.gz
2024-05-05 05:05 ff
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### SortNone_ListsEverything
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --sort=none | sort; ls --sort=n | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### G_Alone_IsNotLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -G
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### FullTime
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --full-time | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### GO_WithHumanAndBlocks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -gohs --time-style=long-iso
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
total 24K
4.0K -rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
4.0K -rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
4.0K -rw-r--r-- 1 1 2024-01-03 10:00 cccc
4.0K -rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
4.0K -rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
4.0K -rw-r--r-- 1 1 2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### U_ThenT_Sorts
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -Ut
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### LongIso
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Ut_SortsByAccessTime
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -ut; ls -tu
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### T_ByModification
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -t
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### N_NumericIdsImplyLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -n --time-style=long-iso | awk '{ print NF, $1, $2, $5, $6, $7, $8 }'; ls --numeric-uid-gid | wc -l
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2 total 24    
8 -rw-r--r-- 1 1 2024-01-01 10:00 aaaa.c
8 -rw-r--r-- 1 1 2024-01-02 10:00 bbbb.h
8 -rw-r--r-- 1 1 2024-01-03 10:00 cccc
8 -rw-r--r-- 1 1 2023-06-01 10:00 dddd.a.c
8 -rw-r--r-- 1 1 2099-01-02 03:04 ee.tar.gz
8 -rw-r--r-- 1 1 2000-02-03 04:05 ff
7
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Utr_Reversed
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -utr
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_OptionBeatsEnvironment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
TIME_STYLE=long-iso ls -l --time-style=iso | cat -A | awk '{ $1=$2=$3=$4=$5=""; print }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
    
     2024-01-01 aaaa.c$
     2024-01-02 bbbb.h$
     2024-01-03 cccc$
     2023-06-01 dddd.a.c$
     2099-01-02 ee.tar.gz$
     2000-02-03 ff$
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### FullIso_WithoutTheOffset
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=full-iso | sed 's/ [+-][0-9][0-9][0-9][0-9] / /' | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00:00.000000000 aaaa.c
2024-01-02 10:00:00.000000000 bbbb.h
2024-01-03 10:00:00.000000000 cccc
2023-06-01 10:00:00.000000000 dddd.a.c
2099-01-02 03:04:05.000000000 ee.tar.gz
2000-02-03 04:05:06.000000000 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_BogusIsAnErrorForLong
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=bogus; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
rc=2
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### X_ThenT_LastWins
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -Xt; ls -tX
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ee.tar.gz
cccc
bbbb.h
aaaa.c
dddd.a.c
ff
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### TimeStyle_Environment
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
TIME_STYLE=long-iso ls -l | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-01-01 10:00 aaaa.c
2024-01-02 10:00 bbbb.h
2024-01-03 10:00 cccc
2023-06-01 10:00 dddd.a.c
2099-01-02 03:04 ee.tar.gz
2000-02-03 04:05 ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Locale_IsTheDefault
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -l --time-style=locale | awk 'NF >= 8 { print $6, $7, $8 }'; ls -l | awk 'NF >= 8 { print $6, $7, $8 }' 
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
Jan 1 2024
Jan 2 2024
Jan 3 2024
Jun 1 2023
Jan 2 2099
Feb 3 2000
Jan 1 2024
Jan 2 2024
Jan 3 2024
Jun 1 2023
Jan 2 2099
Feb 3 2000
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### X_ExtensionThenName
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -X
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cccc
ff
aaaa.c
dddd.a.c
ee.tar.gz
bbbb.h
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### N_ColumnsAreNumbers
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -n | awk 'NF >= 8 { print ($3 ~ /^[0-9]+$/) ? "num" : "name", ($4 ~ /^[0-9]+$/) ? "num" : "name" }' | sort -u
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
num num
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Lut_AccessOrderAndDates
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -lut --time-style=long-iso | awk 'NF >= 8 { print $6, $7, $8 }'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2024-05-05 05:05 ff
2023-06-01 10:00 dddd.a.c
2022-01-01 10:00 aaaa.c
2021-01-01 10:00 bbbb.h
2020-01-01 10:00 cccc
2019-01-01 10:00 ee.tar.gz
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Time_AbbreviationsAndErrors
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls --time=at; ls --time=a; echo rc=$?; ls --time=bogus; echo rc=$?
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
ff
dddd.a.c
aaaa.c
bbbb.h
cccc
ee.tar.gz
rc=0
rc=1
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### C_AndCtime_ListEveryEntry
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -c | sort; ls -lc | wc -l; ls --time=ctime | sort; ls --time=status | sort
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
7
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### Us_SizeSortKeepsNameOrderForEqualSizes
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -uS
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
aaaa.c
bbbb.h
cccc
dddd.a.c
ee.tar.gz
ff
== exit 0
== fs
D .
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0

#### X_WithAll_DotfilesSortByTheirWholeName
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
for f in aaaa.c bbbb.h cccc dddd.a.c ee.tar.gz ff; do printf 'x' > $f; done; touch -m -d '2024-01-01 10:00:00' aaaa.c; touch -m -d '2024-01-02 10:00:00' bbbb.h; touch -m -d '2024-01-03 10:00:00' cccc; touch -m -d '2023-06-01 10:00:00' dddd.a.c; touch -m -d '2099-01-02 03:04:05' ee.tar.gz; touch -m -d '2000-02-03 04:05:06' ff; touch -a -d '2022-01-01 10:00:00' aaaa.c; touch -a -d '2021-01-01 10:00:00' bbbb.h; touch -a -d '2020-01-01 10:00:00' cccc; touch -a -d '2023-06-01 10:00:00' dddd.a.c; touch -a -d '2019-01-01 10:00:00' ee.tar.gz; touch -a -d '2024-05-05 05:05:05' ff; printf '' > .cfg; printf '' > .bashrc
} >/dev/null 2>&1
echo '== stdout'
{ :
ls -Xa
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
cccc
ff
.
..
.bashrc
aaaa.c
dddd.a.c
.cfg
ee.tar.gz
bbbb.h
== exit 0
== fs
D .
F ./.bashrc 
F ./.cfg 
F ./aaaa.c eA==
F ./bbbb.h eA==
F ./cccc eA==
F ./dddd.a.c eA==
F ./ee.tar.gz eA==
F ./ff eA==
## END
## status: 0
