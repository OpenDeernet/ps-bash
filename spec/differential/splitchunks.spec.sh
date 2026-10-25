## Absorbed from Differential.Tests/SplitChunksDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Bytes_EmptyInput_MakesEmptyChunkFiles
printf '' > e
split -n 3 e
## stdout:
## status: 0

#### Lines_NoTrailingNewline
printf 'a\nb\ncc' > f
split -n l/2 f
## stdout:
## status: 0

#### Error_TwoNs
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 2 -n 3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### RoundRobin_TwoWay
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n r/2 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKYwplZWVlZWVlZQo=
F ./xab YmJiYgpkZApmCg==
## END
## status: 0

#### Lines_FromStdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cat f | split -n l/3
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKYmJiYgo=
F ./xab YwpkZAplZWVlZWVlZQo=
F ./xac Zgo=
## END
## status: 0

#### Suffix_NumericAndPrefixAndAdditional
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -d -n 3 --additional-suffix=.p f pre_
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./pre_00.p MDEyMw==
F ./pre_01.p NDU2
F ./pre_02.p NzgK
## END
## status: 0

#### Bytes_FromStdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cat f | split -n 3
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./xaa MDEyMw==
F ./xab NDU2
F ./xac NzgK
## END
## status: 0

#### Lines_KthChunkToStdout
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/2/4 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
c
dd
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
## END
## status: 0

#### Error_ZeroChunks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 0 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### Suffix_TooShortForTheChunkCount_Fails
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 700 -a 2 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### RoundRobin_KthChunkToStdout
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n r/2/3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
bbbb
eeeeeeee
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
## END
## status: 0

#### Bytes_MoreChunksThanBytesPerChunk
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 4 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./xaa MDEy
F ./xab MzQ1
F ./xac Njc=
F ./xad OAo=
## END
## status: 0

#### Lines_FiveWay_LeavesAnEmptyChunk
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/5 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKYmJiYgo=
F ./xab Ywo=
F ./xac ZGQKZWVlZWVlZWUK
F ./xad 
F ./xae Zgo=
## END
## status: 0

#### Error_ChunkNumberZero
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 0/3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### Bytes_KthChunkToStdout_NoFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 2/3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
456== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### Bytes_EmptyInput_MakesEmptyChunkFiles
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '' > e
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 3 e
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./e 
F ./xaa 
F ./xab 
F ./xac 
## END
## status: 0

#### RoundRobin_MoreChunksThanLines
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n r/7 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEK
F ./xab YmJiYgo=
F ./xac Ywo=
F ./xad ZGQK
F ./xae ZWVlZWVlZWUK
F ./xaf Zgo=
F ./xag 
## END
## status: 0

#### Suffix_GrowsToThreeLettersFor700Chunks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 700 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./xaaa MA==
F ./xaab MQ==
F ./xaac Mg==
F ./xaad Mw==
F ./xaae NA==
F ./xaaf NQ==
F ./xaag Ng==
F ./xaah Nw==
F ./xaai OA==
F ./xaaj Cg==
F ./xaak 
F ./xaal 
F ./xaam 
F ./xaan 
F ./xaao 
F ./xaap 
F ./xaaq 
F ./xaar 
F ./xaas 
F ./xaat 
F ./xaau 
F ./xaav 
F ./xaaw 
F ./xaax 
F ./xaay 
F ./xaaz 
F ./xaba 
F ./xabb 
F ./xabc 
F ./xabd 
F ./xabe 
F ./xabf 
F ./xabg 
F ./xabh 
F ./xabi 
F ./xabj 
F ./xabk 
F ./xabl 
F ./xabm 
F ./xabn 
F ./xabo 
F ./xabp 
F ./xabq 
F ./xabr 
F ./xabs 
F ./xabt 
F ./xabu 
F ./xabv 
F ./xabw 
F ./xabx 
F ./xaby 
F ./xabz 
F ./xaca 
F ./xacb 
F ./xacc 
F ./xacd 
F ./xace 
F ./xacf 
F ./xacg 
F ./xach 
F ./xaci 
F ./xacj 
F ./xack 
F ./xacl 
F ./xacm 
F ./xacn 
F ./xaco 
F ./xacp 
F ./xacq 
F ./xacr 
F ./xacs 
F ./xact 
F ./xacu 
F ./xacv 
F ./xacw 
F ./xacx 
F ./xacy 
F ./xacz 
F ./xada 
F ./xadb 
F ./xadc 
F ./xadd 
F ./xade 
F ./xadf 
F ./xadg 
F ./xadh 
F ./xadi 
F ./xadj 
F ./xadk 
F ./xadl 
F ./xadm 
F ./xadn 
F ./xado 
F ./xadp 
F ./xadq 
F ./xadr 
F ./xads 
F ./xadt 
F ./xadu 
F ./xadv 
F ./xadw 
F ./xadx 
F ./xady 
F ./xadz 
F ./xaea 
F ./xaeb 
F ./xaec 
F ./xaed 
F ./xaee 
F ./xaef 
F ./xaeg 
F ./xaeh 
F ./xaei 
F ./xaej 
F ./xaek 
F ./xael 
F ./xaem 
F ./xaen 
F ./xaeo 
F ./xaep 
F ./xaeq 
F ./xaer 
F ./xaes 
F ./xaet 
F ./xaeu 
F ./xaev 
F ./xaew 
F ./xaex 
F ./xaey 
F ./xaez 
F ./xafa 
F ./xafb 
F ./xafc 
F ./xafd 
F ./xafe 
F ./xaff 
F ./xafg 
F ./xafh 
F ./xafi 
F ./xafj 
F ./xafk 
F ./xafl 
F ./xafm 
F ./xafn 
F ./xafo 
F ./xafp 
F ./xafq 
F ./xafr 
F ./xafs 
F ./xaft 
F ./xafu 
F ./xafv 
F ./xafw 
F ./xafx 
F ./xafy 
F ./xafz 
F ./xaga 
F ./xagb 
F ./xagc 
F ./xagd 
F ./xage 
F ./xagf 
F ./xagg 
F ./xagh 
F ./xagi 
F ./xagj 
F ./xagk 
F ./xagl 
F ./xagm 
F ./xagn 
F ./xago 
F ./xagp 
F ./xagq 
F ./xagr 
F ./xags 
F ./xagt 
F ./xagu 
F ./xagv 
F ./xagw 
F ./xagx 
F ./xagy 
F ./xagz 
F ./xaha 
F ./xahb 
F ./xahc 
F ./xahd 
F ./xahe 
F ./xahf 
F ./xahg 
F ./xahh 
F ./xahi 
F ./xahj 
F ./xahk 
F ./xahl 
F ./xahm 
F ./xahn 
F ./xaho 
F ./xahp 
F ./xahq 
F ./xahr 
F ./xahs 
F ./xaht 
F ./xahu 
F ./xahv 
F ./xahw 
F ./xahx 
F ./xahy 
F ./xahz 
F ./xaia 
F ./xaib 
F ./xaic 
F ./xaid 
F ./xaie 
F ./xaif 
F ./xaig 
F ./xaih 
F ./xaii 
F ./xaij 
F ./xaik 
F ./xail 
F ./xaim 
F ./xain 
F ./xaio 
F ./xaip 
F ./xaiq 
F ./xair 
F ./xais 
F ./xait 
F ./xaiu 
F ./xaiv 
F ./xaiw 
F ./xaix 
F ./xaiy 
F ./xaiz 
F ./xaja 
F ./xajb 
F ./xajc 
F ./xajd 
F ./xaje 
F ./xajf 
F ./xajg 
F ./xajh 
F ./xaji 
F ./xajj 
F ./xajk 
F ./xajl 
F ./xajm 
F ./xajn 
F ./xajo 
F ./xajp 
F ./xajq 
F ./xajr 
F ./xajs 
F ./xajt 
F ./xaju 
F ./xajv 
F ./xajw 
F ./xajx 
F ./xajy 
F ./xajz 
F ./xaka 
F ./xakb 
F ./xakc 
F ./xakd 
F ./xake 
F ./xakf 
F ./xakg 
F ./xakh 
F ./xaki 
F ./xakj 
F ./xakk 
F ./xakl 
F ./xakm 
F ./xakn 
F ./xako 
F ./xakp 
F ./xakq 
F ./xakr 
F ./xaks 
F ./xakt 
F ./xaku 
F ./xakv 
F ./xakw 
F ./xakx 
F ./xaky 
F ./xakz 
F ./xala 
F ./xalb 
F ./xalc 
F ./xald 
F ./xale 
F ./xalf 
F ./xalg 
F ./xalh 
F ./xali 
F ./xalj 
F ./xalk 
F ./xall 
F ./xalm 
F ./xaln 
F ./xalo 
F ./xalp 
F ./xalq 
F ./xalr 
F ./xals 
F ./xalt 
F ./xalu 
F ./xalv 
F ./xalw 
F ./xalx 
F ./xaly 
F ./xalz 
F ./xama 
F ./xamb 
F ./xamc 
F ./xamd 
F ./xame 
F ./xamf 
F ./xamg 
F ./xamh 
F ./xami 
F ./xamj 
F ./xamk 
F ./xaml 
F ./xamm 
F ./xamn 
F ./xamo 
F ./xamp 
F ./xamq 
F ./xamr 
F ./xams 
F ./xamt 
F ./xamu 
F ./xamv 
F ./xamw 
F ./xamx 
F ./xamy 
F ./xamz 
F ./xana 
F ./xanb 
F ./xanc 
F ./xand 
F ./xane 
F ./xanf 
F ./xang 
F ./xanh 
F ./xani 
F ./xanj 
F ./xank 
F ./xanl 
F ./xanm 
F ./xann 
F ./xano 
F ./xanp 
F ./xanq 
F ./xanr 
F ./xans 
F ./xant 
F ./xanu 
F ./xanv 
F ./xanw 
F ./xanx 
F ./xany 
F ./xanz 
F ./xaoa 
F ./xaob 
F ./xaoc 
F ./xaod 
F ./xaoe 
F ./xaof 
F ./xaog 
F ./xaoh 
F ./xaoi 
F ./xaoj 
F ./xaok 
F ./xaol 
F ./xaom 
F ./xaon 
F ./xaoo 
F ./xaop 
F ./xaoq 
F ./xaor 
F ./xaos 
F ./xaot 
F ./xaou 
F ./xaov 
F ./xaow 
F ./xaox 
F ./xaoy 
F ./xaoz 
F ./xapa 
F ./xapb 
F ./xapc 
F ./xapd 
F ./xape 
F ./xapf 
F ./xapg 
F ./xaph 
F ./xapi 
F ./xapj 
F ./xapk 
F ./xapl 
F ./xapm 
F ./xapn 
F ./xapo 
F ./xapp 
F ./xapq 
F ./xapr 
F ./xaps 
F ./xapt 
F ./xapu 
F ./xapv 
F ./xapw 
F ./xapx 
F ./xapy 
F ./xapz 
F ./xaqa 
F ./xaqb 
F ./xaqc 
F ./xaqd 
F ./xaqe 
F ./xaqf 
F ./xaqg 
F ./xaqh 
F ./xaqi 
F ./xaqj 
F ./xaqk 
F ./xaql 
F ./xaqm 
F ./xaqn 
F ./xaqo 
F ./xaqp 
F ./xaqq 
F ./xaqr 
F ./xaqs 
F ./xaqt 
F ./xaqu 
F ./xaqv 
F ./xaqw 
F ./xaqx 
F ./xaqy 
F ./xaqz 
F ./xara 
F ./xarb 
F ./xarc 
F ./xard 
F ./xare 
F ./xarf 
F ./xarg 
F ./xarh 
F ./xari 
F ./xarj 
F ./xark 
F ./xarl 
F ./xarm 
F ./xarn 
F ./xaro 
F ./xarp 
F ./xarq 
F ./xarr 
F ./xars 
F ./xart 
F ./xaru 
F ./xarv 
F ./xarw 
F ./xarx 
F ./xary 
F ./xarz 
F ./xasa 
F ./xasb 
F ./xasc 
F ./xasd 
F ./xase 
F ./xasf 
F ./xasg 
F ./xash 
F ./xasi 
F ./xasj 
F ./xask 
F ./xasl 
F ./xasm 
F ./xasn 
F ./xaso 
F ./xasp 
F ./xasq 
F ./xasr 
F ./xass 
F ./xast 
F ./xasu 
F ./xasv 
F ./xasw 
F ./xasx 
F ./xasy 
F ./xasz 
F ./xata 
F ./xatb 
F ./xatc 
F ./xatd 
F ./xate 
F ./xatf 
F ./xatg 
F ./xath 
F ./xati 
F ./xatj 
F ./xatk 
F ./xatl 
F ./xatm 
F ./xatn 
F ./xato 
F ./xatp 
F ./xatq 
F ./xatr 
F ./xats 
F ./xatt 
F ./xatu 
F ./xatv 
F ./xatw 
F ./xatx 
F ./xaty 
F ./xatz 
F ./xaua 
F ./xaub 
F ./xauc 
F ./xaud 
F ./xaue 
F ./xauf 
F ./xaug 
F ./xauh 
F ./xaui 
F ./xauj 
F ./xauk 
F ./xaul 
F ./xaum 
F ./xaun 
F ./xauo 
F ./xaup 
F ./xauq 
F ./xaur 
F ./xaus 
F ./xaut 
F ./xauu 
F ./xauv 
F ./xauw 
F ./xaux 
F ./xauy 
F ./xauz 
F ./xava 
F ./xavb 
F ./xavc 
F ./xavd 
F ./xave 
F ./xavf 
F ./xavg 
F ./xavh 
F ./xavi 
F ./xavj 
F ./xavk 
F ./xavl 
F ./xavm 
F ./xavn 
F ./xavo 
F ./xavp 
F ./xavq 
F ./xavr 
F ./xavs 
F ./xavt 
F ./xavu 
F ./xavv 
F ./xavw 
F ./xavx 
F ./xavy 
F ./xavz 
F ./xawa 
F ./xawb 
F ./xawc 
F ./xawd 
F ./xawe 
F ./xawf 
F ./xawg 
F ./xawh 
F ./xawi 
F ./xawj 
F ./xawk 
F ./xawl 
F ./xawm 
F ./xawn 
F ./xawo 
F ./xawp 
F ./xawq 
F ./xawr 
F ./xaws 
F ./xawt 
F ./xawu 
F ./xawv 
F ./xaww 
F ./xawx 
F ./xawy 
F ./xawz 
F ./xaxa 
F ./xaxb 
F ./xaxc 
F ./xaxd 
F ./xaxe 
F ./xaxf 
F ./xaxg 
F ./xaxh 
F ./xaxi 
F ./xaxj 
F ./xaxk 
F ./xaxl 
F ./xaxm 
F ./xaxn 
F ./xaxo 
F ./xaxp 
F ./xaxq 
F ./xaxr 
F ./xaxs 
F ./xaxt 
F ./xaxu 
F ./xaxv 
F ./xaxw 
F ./xaxx 
F ./xaxy 
F ./xaxz 
F ./xaya 
F ./xayb 
F ./xayc 
F ./xayd 
F ./xaye 
F ./xayf 
F ./xayg 
F ./xayh 
F ./xayi 
F ./xayj 
F ./xayk 
F ./xayl 
F ./xaym 
F ./xayn 
F ./xayo 
F ./xayp 
F ./xayq 
F ./xayr 
F ./xays 
F ./xayt 
F ./xayu 
F ./xayv 
F ./xayw 
F ./xayx 
F ./xayy 
F ./xayz 
F ./xaza 
F ./xazb 
F ./xazc 
F ./xazd 
F ./xaze 
F ./xazf 
F ./xazg 
F ./xazh 
F ./xazi 
F ./xazj 
F ./xazk 
F ./xazl 
F ./xazm 
F ./xazn 
F ./xazo 
F ./xazp 
F ./xazq 
F ./xazr 
F ./xazs 
F ./xazt 
F ./xazu 
F ./xazv 
F ./xazw 
F ./xazx 
F ./xazy 
F ./xazz 
F ./xbaa 
F ./xbab 
F ./xbac 
F ./xbad 
F ./xbae 
F ./xbaf 
F ./xbag 
F ./xbah 
F ./xbai 
F ./xbaj 
F ./xbak 
F ./xbal 
F ./xbam 
F ./xban 
F ./xbao 
F ./xbap 
F ./xbaq 
F ./xbar 
F ./xbas 
F ./xbat 
F ./xbau 
F ./xbav 
F ./xbaw 
F ./xbax 
## END
## status: 0

#### Lines_TenWay_LineBelongsToThePartitionHoldingItsFirstByte
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/10 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEK
F ./xab YmJiYgo=
F ./xac Ywo=
F ./xad ZGQK
F ./xae ZWVlZWVlZWUK
F ./xaf 
F ./xag 
F ./xah 
F ./xai 
F ./xaj Zgo=
## END
## status: 0

#### Bytes_RemainderGoesToTheFirstChunks
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./xaa MDEyMw==
F ./xab NDU2
F ./xac NzgK
## END
## status: 0

#### Lines_TwoWay
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/2 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKYmJiYgpjCmRkCg==
F ./xab ZWVlZWVlZWUKZgo=
## END
## status: 0

#### Error_MoreThanOneWay
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 2 -l 1 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### Lines_ThreeWay
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKYmJiYgo=
F ./xab YwpkZAplZWVlZWVlZQo=
F ./xac Zgo=
## END
## status: 0

#### Bytes_EveryByteItsOwnChunk_AndAnEmptyExtra
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 11 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
F ./xaa MA==
F ./xab MQ==
F ./xac Mg==
F ./xad Mw==
F ./xae NA==
F ./xaf NQ==
F ./xag Ng==
F ./xah Nw==
F ./xai OA==
F ./xaj Cg==
F ./xak 
## END
## status: 0

#### Lines_NoTrailingNewline
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf 'a\nb\ncc' > f
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n l/2 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YQpiCmNj
F ./xaa YQpiCg==
F ./xab Y2M=
## END
## status: 0

#### Error_NotANumber
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n x f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0

#### RoundRobin_FromStdin
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' 'aa
bbbb
c
dd
eeeeeeee
f' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
cat f | split -n r/3
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 0
== fs
D .
F ./f YWEKYmJiYgpjCmRkCmVlZWVlZWVlCmYK
F ./xaa YWEKZGQK
F ./xab YmJiYgplZWVlZWVlZQo=
F ./xac YwpmCg==
## END
## status: 0

#### Error_ChunkNumberTooLarge
__fs_snap() { find . | LC_ALL=C sort | while IFS= read -r p; do if [ -d "$p" ]; then echo "D $p"; else echo "F $p $(base64 -w0 "$p")"; fi; done; }
d=$(mktemp -d) && cd "$d" && { :
printf '%s\n' '012345678' > 'f'
} >/dev/null 2>&1
echo '== stdout'
{ :
split -n 5/3 f
} 2>/dev/null
echo "== exit $?"
echo '== fs'
__fs_snap
cd /; rm -rf "$d"
## STDOUT:
== stdout
== exit 1
== fs
D .
F ./f MDEyMzQ1Njc4Cg==
## END
## status: 0
