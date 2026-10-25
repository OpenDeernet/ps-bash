## Absorbed from Differential.Tests/JqFilesDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Files_RedirectedOutput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . a.json > out.txt; cat out.txt
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"a":1}
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./out.txt eyJhIjoxfQo=
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"a":1}
[1,2]
3
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### NamedArgs_UsedAsVariables
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc --arg a 1 --argjson b '{"x":2}' --slurpfile s stream.json '[$a, $b.x, $s[1]]'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
["1",2,2]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_MissingFirst_OthersStillRun
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . nosuch.json a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"a":1}
== exit 2
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_JsonArgs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc '$ARGS.positional' --jsonargs 1 2
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[1,2]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### NamedArgs_AllKinds
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc --arg a 1 --argjson b '[1]' --slurpfile s stream.json --rawfile r raw.txt '$ARGS'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"positional":[],"named":{"a":"1","b":[1],"s":[1,2,3],"r":"line1\n"}}
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_ErrorLocationNamesTheFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq '.a.b' a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 5
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### ProgramFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -f prog.jq a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_PositionalArgsAfterArgs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc '$ARGS.positional' --args a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
["a.json","b.json"]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_PipelineInto
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -r '.a' a.json | head -n 1
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles_InputFilename
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c '[., input_filename]' a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[{"a":1},"a.json"]
[[1,2],"b.json"]
[3,"b.json"]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles_NullInputInputs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc '[inputs]' a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[{"a":1},[1,2],3]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SlurpFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc --slurpfile s stream.json '$s'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[1,2,3]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### ProgramFile_Long
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq --from-file prog.jq a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### ProgramFile_DefsAndComments
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -f multi.jq a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_MissingFile_ExitsTwo
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . nosuch.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_ExitStatus
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -e '.a == 2' a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
false
== exit 1
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_OptionsAfterOperands
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq . a.json -c
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"a":1}
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### ProgramFile_WithNullInput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -n -f prog.jq
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Stdin_DashOperand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . - < a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
{"a":1}
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### RawFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -n --rawfile r raw.txt '$r'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
"line1\n"
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_Stream
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c --stream . a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[["a"],1]
[["a"]]
[[0],1]
[[1],2]
[[1]]
[[],3]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Files_MalformedFile
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":' > 'bad.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c . bad.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 5
== fs
D .
F ./bad.json eyJhIjoK
## END
## status: 0

#### ProgramFile_Stdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -f prog.jq < a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
2
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SingleFile_Operand
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c '.a' a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
1
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### Stdin_FilenameIsNull
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -c 'input_filename' < a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
"<stdin>"
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### RawFile_Missing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -n --rawfile r nosuch.txt '$r'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles_RawInput
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -R . raw.txt a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
"line1"
"{\"a\":1}"
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles_RawInputSlurp
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -Rs . raw.txt a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
"line1\n{\"a\":1}\n"
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### ProgramFile_Missing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -f nosuch.jq a.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SlurpFile_MultipleDocs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc --slurpfile s b.json '$s, ($s | length)'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[[1,2],3]
2
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SeveralFiles_Slurp
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -sc . a.json b.json
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
[{"a":1},[1,2],3]
== exit 0
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0

#### SlurpFile_Missing
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '{"a":1}' > 'a.json'
printf '%s\n' '[1,2]
3' > 'b.json'
printf '%s\n' '.a + 1' > 'prog.jq'
printf '%s\n' 'def f: . * 2;
# comment
.a | f' > 'multi.jq'
printf '%s\n' 'line1' > 'raw.txt'
printf '%s\n' '1 2 3' > 'stream.json'
} >/dev/null 2>&1
echo '== stdout'
{ :
jq -nc --slurpfile s nosuch.json '$s'
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 2
== fs
D .
F ./a.json eyJhIjoxfQo=
F ./b.json WzEsMl0KMwo=
F ./multi.jq ZGVmIGY6IC4gKiAyOwojIGNvbW1lbnQKLmEgfCBmCg==
F ./prog.jq LmEgKyAxCg==
F ./raw.txt bGluZTEK
F ./stream.json MSAyIDMK
## END
## status: 0
