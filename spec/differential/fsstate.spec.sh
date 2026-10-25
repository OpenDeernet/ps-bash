## Absorbed from Differential.Tests/FsStateDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Tee_PrintfWithoutNewline_FileBytesAreExactlyTheInput
printf x | tee f
## stdout-json: "x"
## status: 0

#### Tee_DoubleDash_DashNamedFileIsAnOperand
printf 'hi\n' | tee -- -zz
## stdout: hi
## status: 0

#### Mkdir_Mode_CreatesTheDirectories
mkdir -m 755 a; mkdir --mode=u=rwx,go=rx b; mkdir -pm 700 p/q/r; mkdir -m 0777 c
## stdout:
## status: 0

#### Touch_Stamp_OrdersFilesByModificationTime
touch -t 202401021530 a; touch -t 202401021531 b; touch -t 202401021529.30 c; touch -t 2401021532 d; ls -t
## STDOUT:
d
b
a
c
## END
## status: 0

#### Touch_NoDereference_DoesNotCreateAMissingName
touch -h nosuch; echo r1=$?; touch -hc nosuch2; echo r2=$?; touch --no-dereference plain; echo r3=$?
## STDOUT:
r1=1
r2=0
r3=1
## END
## status: 0

#### Redirect_PrintfWithoutNewline_FileBytesAreExactlyTheInput
printf x > f
## stdout:
## status: 0

#### Redirect_PrintfNulEscape_FileHoldsARealNulByte
printf 'x\0' > f
## stdout:
## status: 0

#### Redirect_PrintfOctalEscapes_FileBytesMatch
printf 'a\101\0101b\n' > f; printf '%b' 'p\0101q' > g
## stdout:
## status: 0

#### Redirect_EchoEOctalAndNul_FileBytesMatch
echo -e 'a\0101b\0c\101' > f
## stdout:
## status: 0

#### Redirect_EchoDashN_FileBytesAreExactlyTheInput
echo -n x > f
## stdout:
## status: 0

#### Redirect_Append_PrintfThenPrintf_Concatenates
printf a > f; printf b >> f
## stdout:
## status: 0

#### Redirect_PrintfMultiLine_NoFinalNewline
printf 'a\nb' > f
## stdout:
## status: 0

#### Redirect_BraceGroupMixedRecords_OnlyLastLosesNewline
{ echo x; printf y; } > f
## stdout:
## status: 0

#### Redirect_PlainEcho_KeepsNewline
echo x > f
## stdout:
## status: 0
