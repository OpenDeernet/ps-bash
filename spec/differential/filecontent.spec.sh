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

#### Text_Utf8Bom
printf '\xef\xbb\xbfhello\r\n' > f

#### Text_Del_IsData
printf 'abc\x7f\n' > f
