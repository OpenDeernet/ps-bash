## Absorbed from Differential.Tests/FileContentDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Empty
printf '' > f
## stdout:
## status: 0

#### OneByte
printf a > f
## stdout:
## status: 0

#### OneNewline
printf '\n' > f
## stdout:
## status: 0

#### TwoBytes
printf ab > f
## stdout:
## status: 0

#### Gzip_NoName
printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03xxxxxxxx\x00\x00\x00\x00\x06\x00\x00\x00' > f
## stdout:
## status: 0

#### Gzip_NameAndTime
printf '\x1f\x8b\x08\x08\x00\x65\x53\x65\x00\x03a.txt\x00xxxx\x00\x00\x00\x00\x06\x00\x00\x00' > f
## stdout:
## status: 0

#### Gzip_MaxCompression_Ntfs
printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x02\x0bxxxx\x00\x00\x00\x00\x2a\x00\x00\x00' > f
## stdout:
## status: 0

#### Gzip_Truncated
printf '\x1f\x8b\x08\x00\x00\x00' > f
## stdout:
## status: 0

#### Png_Rgb
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x10\x00\x00\x00\x10\x08\x02\x00\x00\x00' > f
## stdout:
## status: 0

#### Png_Palette_Interlaced
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x05\x00\x00\x00\x07\x04\x03\x00\x00\x01' > f
## stdout:
## status: 0

#### Png_SignatureOnly_IsData
printf '\x89PNG\r\n\x1a\n' > f
## stdout:
## status: 0

#### Jpeg_Jfif_Baseline
printf '\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xc0\x00\x0b\x08\x01\xe0\x02\x80\x01\x01\x11\x00\xff\xd9' > f
## stdout:
## status: 0

#### Jpeg_NoJfif
printf '\xff\xd8\xff\xfe\x00\x04hi\xff\xc2\x00\x0b\x08\x00\x21\x00\x2c\x01\x01\x11\x00\xff\xd9' > f
## stdout:
## status: 0

#### Jpeg_Bare
printf '\xff\xd8\xff\xdb' > f
## stdout:
## status: 0

#### Pdf_Version
printf '%%PDF-1.4\n%%EOF\n' > f
## stdout:
## status: 0

#### Pdf_PageCount
printf '%%PDF-1.7\n<</Type/Pages/Count 3>>\n' > f
## stdout:
## status: 0

#### Pdf_BinaryComment
printf '%%PDF-1.5\n%%\xe2\xe3\xcf\xd3\n' > f
## stdout:
## status: 0

#### Shebang_Sh
printf '#!/bin/sh\necho hi\n' > f
## stdout:
## status: 0

#### Shebang_Bash
printf '#!/bin/bash\necho hi\n' > f
## stdout:
## status: 0

#### Shebang_EnvBash
printf '#!/usr/bin/env bash\necho hi\n' > f
## stdout:
## status: 0

#### Shebang_EnvSh_IsGeneric
printf '#!/usr/bin/env sh\necho hi\n' > f
## stdout:
## status: 0

#### Shebang_Python
printf '#!/usr/bin/env python3\nprint(1)\n' > f
## stdout:
## status: 0

#### Shebang_Perl
printf '#!/usr/bin/perl\nprint 1;\n' > f
## stdout:
## status: 0

#### Shebang_Node
printf '#!/usr/bin/env node\n1\n' > f
## stdout:
## status: 0

#### Shebang_Unknown
printf '#!/usr/bin/foo\necho\n' > f
## stdout:
## status: 0

#### Shebang_Crlf
printf '#!/bin/sh\r\necho hi\r\n' > f
## stdout:
## status: 0

#### Shebang_Utf8
printf '#!/bin/sh\necho caf\xc3\xa9\n' > f
## stdout:
## status: 0

#### Shebang_NoNewline
printf '#!/bin/sh' > f
## stdout:
## status: 0

#### Text_Crlf
printf 'a\r\nb\r\n' > f
## stdout:
## status: 0

#### Text_CrlfNoFinalNewline
printf 'a\r\nb' > f
## stdout:
## status: 0

#### Text_MixedCrlfLf
printf 'a\r\nb\nc\r\n' > f
## stdout:
## status: 0

#### Text_CrOnly
printf 'a\rb\rc\r' > f
## stdout:
## status: 0

#### Text_AllThreeTerminators
printf 'a\rb\r\nc\n' > f
## stdout:
## status: 0

#### Text_LoneCrAtEnd_IsNoTerminator
printf 'x\r' > f
## stdout:
## status: 0

#### Text_NoTerminator
printf 'hello world' > f
## stdout:
## status: 0

#### Text_EscapeAndBackspace
printf 'a\bb\033[0m\n' > f
## stdout:
## status: 0

#### Text_Utf8Crlf
printf 'caf\xc3\xa9\r\n' > f
## stdout:
## status: 0

#### Text_Latin1Crlf
printf 'caf\xe9\r\n' > f
## stdout:
## status: 0

#### Text_Utf8Bom
printf '\xef\xbb\xbfhello\r\n' > f
## stdout:
## status: 0

#### Text_Del_IsData
printf 'abc\x7f\n' > f
## stdout:
## status: 0

#### Both
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\r\nb\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with CRLF line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQ0KYg0K
## END
## status: 0

#### Both row 2
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'MZ\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: MS-DOS executable, MZ for MS-DOS
application/x-dosexec; charset=binary
== exit 0
== fs
D .
F ./f TVoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
## END
## status: 0

#### Both row 3
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\r\nb' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with CRLF line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQ0KYg==
## END
## status: 0

#### Both row 4
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x10\x00\x00\x00\x10\x08\x02\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PNG image data, 16 x 16, 8-bit/color RGB, non-interlaced
image/png; charset=binary
== exit 0
== fs
D .
F ./f iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAAA=
## END
## status: 0

#### Both row 5
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\rb\rc\r' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with CR line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQ1iDWMN
## END
## status: 0

#### Both row 6
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x28\x00\x01\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ELF 32-bit LSB shared object, ARM, version 1 (SYSV)
application/x-sharedlib; charset=binary
== exit 0
== fs
D .
F ./f f0VMRgEBAQAAAAAAAAAAAAMAKAABAAAA
## END
## status: 0

#### Both row 7
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x05\x00\x00\x00\x07\x04\x03\x00\x00\x01' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PNG image data, 5 x 7, 4-bit colormap, interlaced
image/png; charset=binary
== exit 0
== fs
D .
F ./f iVBORw0KGgoAAAANSUhEUgAAAAUAAAAHBAMAAAE=
## END
## status: 0

#### Both row 8
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'caf\xc3\xa9\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Unicode text, UTF-8 text, with CRLF line terminators
text/plain; charset=utf-8
== exit 0
== fs
D .
F ./f Y2Fmw6kNCg==
## END
## status: 0

#### Both row 9
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\xff\xd8\xff\xdb' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: JPEG image data
image/jpeg; charset=iso-8859-1
== exit 0
== fs
D .
F ./f /9j/2w==
## END
## status: 0

#### Both row 10
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'PK\x03\x04\x14\x00\x00\x00\x08\x00\x00\x00\x21\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00a.txt' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: data
application/octet-stream; charset=binary
== exit 0
== fs
D .
F ./f UEsDBBQAAAAIAAAAIQAAAAAAAAAAAAAAAAAFAAAAYS50eHQ=
## END
## status: 0

#### Both row 11
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/env bash\necho hi\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Bourne-Again shell script, ASCII text executable
text/x-shellscript; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9lbnYgYmFzaAplY2hvIGhpCg==
## END
## status: 0

#### Both row 12
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%%PDF-1.7\n<</Type/Pages/Count 3>>\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PDF document, version 1.7, 3 page(s)
application/pdf; charset=us-ascii
== exit 0
== fs
D .
F ./f JVBERi0xLjcKPDwvVHlwZS9QYWdlcy9Db3VudCAzPj4K
## END
## status: 0

#### Both row 13
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00\x01\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ELF 64-bit LSB executable, x86-64, version 1 (SYSV)
application/x-executable; charset=binary
== exit 0
== fs
D .
F ./f f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAA
## END
## status: 0

#### Both row 14
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x7fELF\x02\x01\x01\x03\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00\x01\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux)
application/x-executable; charset=binary
== exit 0
== fs
D .
F ./f f0VMRgIBAQMAAAAAAAAAAAIAPgABAAAA
## END
## status: 0

#### Both row 15
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/perl\nprint 1;\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Perl script text executable
text/x-perl; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9wZXJsCnByaW50IDE7Cg==
## END
## status: 0

#### Both row 16
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\rb\r\nc\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with CRLF, CR, LF line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQ1iDQpjCg==
## END
## status: 0

#### Both row 17
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\xef\xbb\xbfhello\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Unicode text, UTF-8 (with BOM) text, with CRLF line terminators
text/plain; charset=utf-8
== exit 0
== fs
D .
F ./f 77u/aGVsbG8NCg==
## END
## status: 0

#### Both row 18
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/bin/sh\necho hi\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: POSIX shell script, ASCII text executable
text/x-shellscript; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvYmluL3NoCmVjaG8gaGkK
## END
## status: 0

#### Both row 19
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/env python3\nprint(1)\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Python script, ASCII text executable
text/x-script.python; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9lbnYgcHl0aG9uMwpwcmludCgxKQo=
## END
## status: 0

#### Both row 20
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/bin/sh\necho caf\xc3\xa9\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: POSIX shell script, Unicode text, UTF-8 text executable
text/x-shellscript; charset=utf-8
== exit 0
== fs
D .
F ./f IyEvYmluL3NoCmVjaG8gY2Fmw6kK
## END
## status: 0

#### Both row 21
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/env sh\necho hi\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: a sh script, ASCII text executable
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9lbnYgc2gKZWNobyBoaQo=
## END
## status: 0

#### Both row 22
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'PK\x05\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Zip archive data (empty)
application/zip; charset=binary
== exit 0
== fs
D .
F ./f UEsFBgAAAAAAAAAAAAAAAAAAAAAAAA==
## END
## status: 0

#### Both row 23
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\xff\xd8\xff\xe0\x00\x10JFIF\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xc0\x00\x0b\x08\x01\xe0\x02\x80\x01\x01\x11\x00\xff\xd9' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: JPEG image data, JFIF standard 1.01, resolution (DPI), density 72x72, segment length 16, baseline, precision 8, 640x480, components 1
image/jpeg; charset=binary
== exit 0
== fs
D .
F ./f /9j/4AAQSkZJRgABAQEASABIAAD/wAALCAHgAoABAREA/9k=
## END
## status: 0

#### Both row 24
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'MZ\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00PE\x00\x00\x64\x86\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x00\x22\x00\x0b\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PE32+ executable (console) x86-64, for MS Windows, 3 sections
application/vnd.microsoft.portable-executable; charset=binary
== exit 0
== fs
D .
F ./f TVoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQRQAAZIYDAAAAAAAAAAAAAAAAAPAAIgALAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
## END
## status: 0

#### Both row 25
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/bin/sh\r\necho hi\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: POSIX shell script, ASCII text executable, with CRLF line terminators
text/x-shellscript; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvYmluL3NoDQplY2hvIGhpDQo=
## END
## status: 0

#### Both row 26
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/foo\necho\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: a /usr/bin/foo script, ASCII text executable
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9mb28KZWNobwo=
## END
## status: 0

#### Both row 27
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf ab > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with no line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YWI=
## END
## status: 0

#### Both row 28
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\r\nb\nc\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with CRLF, LF line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQ0KYgpjDQo=
## END
## status: 0

#### Both row 29
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: very short file (no magic)
application/octet-stream; charset=binary
== exit 0
== fs
D .
F ./f Cg==
## END
## status: 0

#### Both row 30
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x1f\x8b\x08\x08\x00\x65\x53\x65\x00\x03a.txt\x00xxxx\x00\x00\x00\x00\x06\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: gzip compressed data, was "a.txt", last modified: Tue Nov 14 12:16:00 2023, from Unix, original size modulo 2^32 6
application/gzip; charset=binary
== exit 0
== fs
D .
F ./f H4sICABlU2UAA2EudHh0AHh4eHgAAAAABgAAAA==
## END
## status: 0

#### Both row 31
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with very long lines (400), with CRLF line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eA0K
## END
## status: 0

#### Both row 32
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/bin/sh' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: a /bin/sh script, ASCII text executable, with no line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvYmluL3No
## END
## status: 0

#### Both row 33
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/usr/bin/env node\n1\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Node.js script executable, ASCII text
application/javascript; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvdXNyL2Jpbi9lbnYgbm9kZQoxCg==
## END
## status: 0

#### Both row 34
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x02\x0bxxxx\x00\x00\x00\x00\x2a\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: gzip compressed data, max compression, from NTFS filesystem (NT), original size modulo 2^32 42
application/gzip; charset=binary
== exit 0
== fs
D .
F ./f H4sIAAAAAAACC3h4eHgAAAAAKgAAAA==
## END
## status: 0

#### Both row 35
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x89PNG\r\n\x1a\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: data
application/octet-stream; charset=binary
== exit 0
== fs
D .
F ./f iVBORw0KGgo=
## END
## status: 0

#### Both row 36
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%%PDF-1.5\n%%\xe2\xe3\xcf\xd3\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PDF document, version 1.5
application/pdf; charset=iso-8859-1
== exit 0
== fs
D .
F ./f JVBERi0xLjUKJeLjz9MK
## END
## status: 0

#### Both row 37
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x3e\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ELF 64-bit LSB shared object, x86-64, (SYSV)
application/x-sharedlib; charset=binary
== exit 0
== fs
D .
F ./f f0VMRgIBAQAAAAAAAAAAAAMAPgA=
## END
## status: 0

#### Both row 38
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '#!/bin/bash\necho hi\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Bourne-Again shell script, ASCII text executable
text/x-shellscript; charset=us-ascii
== exit 0
== fs
D .
F ./f IyEvYmluL2Jhc2gKZWNobyBoaQo=
## END
## status: 0

#### Both row 39
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03xxxxxxxx\x00\x00\x00\x00\x06\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: gzip compressed data, from Unix, original size modulo 2^32 6
application/gzip; charset=binary
== exit 0
== fs
D .
F ./f H4sIAAAAAAAAA3h4eHh4eHh4AAAAAAYAAAA=
## END
## status: 0

#### Both row 40
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: empty
inode/x-empty; charset=binary
== exit 0
== fs
D .
F ./f 
## END
## status: 0

#### Both row 41
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%%PDF-1.4\n%%EOF\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: PDF document, version 1.4
application/pdf; charset=us-ascii
== exit 0
== fs
D .
F ./f JVBERi0xLjQKJUVPRgo=
## END
## status: 0

#### Both row 42
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf a > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: very short file (no magic)
application/octet-stream; charset=binary
== exit 0
== fs
D .
F ./f YQ==
## END
## status: 0

#### Both row 43
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'hello world' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with no line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f aGVsbG8gd29ybGQ=
## END
## status: 0

#### Both row 44
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'PK\x03\x04\x14\x00\x00\x00\x08\x00\x00\x00\x21\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00a.txt\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: Zip archive data, at least v2.0 to extract, compression method=deflate
application/zip; charset=binary
== exit 0
== fs
D .
F ./f UEsDBBQAAAAIAAAAIQAAAAAAAAAAAAAAAAAFAAAAYS50eHQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
## END
## status: 0

#### Both row 45
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'caf\xe9\r\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ISO-8859 text, with CRLF line terminators
text/plain; charset=iso-8859-1
== exit 0
== fs
D .
F ./f Y2Fm6Q0K
## END
## status: 0

#### Both row 46
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'x\r' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with no line terminators
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f eA0=
## END
## status: 0

#### Both row 47
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\x1f\x8b\x08\x00\x00\x00' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: gzip compressed data
application/gzip; charset=binary
== exit 0
== fs
D .
F ./f H4sIAAAA
## END
## status: 0

#### Both row 48
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\bb\033[0m\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: ASCII text, with escape sequences, with overstriking
text/plain; charset=us-ascii
== exit 0
== fs
D .
F ./f YQhiG1swbQo=
## END
## status: 0

#### Both row 49
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '\xff\xd8\xff\xfe\x00\x04hi\xff\xc2\x00\x0b\x08\x00\x21\x00\x2c\x01\x01\x11\x00\xff\xd9' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: JPEG image data, progressive, precision 8, 44x33, components 1
image/jpeg; charset=binary
== exit 0
== fs
D .
F ./f /9j//gAEaGn/wgALCAAhACwBAREA/9k=
## END
## status: 0

#### Both row 50
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'abc\x7f\n' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
file f; file -b --mime f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
f: data
application/octet-stream; charset=binary
== exit 0
== fs
D .
F ./f YWJjfwo=
## END
## status: 0
