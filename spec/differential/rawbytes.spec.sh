## Absorbed from Differential.Tests/RawBytesDifferentialTests.cs (scripts only; expectations recorded from bash 5.2).

#### Printf_LoneInvalidByte_WcC_IsOne
printf '\351' | wc -c
## stdout: 1
## status: 0

#### Printf_HexInvalidByte_WcC_IsOne
printf '\xe9' | wc -c
## stdout: 1
## status: 0

#### Printf_InvalidBytes_Base64
printf '\xff\xfe' | base64
## stdout: //4=
## status: 0

#### Printf_InvalidByte_Md5sum
printf '\xe9' | md5sum
## stdout: 3406877694691ddd1dfb0aca54681407  -
## status: 0

#### Printf_InvalidByte_Sha256sum
printf '\xe9' | sha256sum
## stdout: de2e331d891ae267a7009cb45b4e8830f170e0c937288ea2731a1941c7a53b0d  -
## status: 0

#### Printf_ValidUtf8_Euro_IsThreeBytes
printf '\xe2\x82\xac' | wc -c
## stdout: 3
## status: 0

#### Printf_ValidUtf8_Euro_IsOneCharacter
printf '\xe2\x82\xac' | wc -m
## stdout: 1
## status: 0

#### AnsiCQuoting_InvalidByte_IsOneByte
printf '%s' $'\xe9' | wc -c
## stdout: 1
## status: 0

#### EchoE_InvalidByte_IsOneByteAndNewline
echo -e '\xe9' | wc -c
## stdout: 2
## status: 0

#### CommandSubstitution_KeepsTheInvalidByte
x=$(printf '\351'); printf '%s' "$x" | wc -c
## stdout: 1
## status: 0

#### Base64_Decode_KeepsTheFinalNewlineByte
printf 'a\n' | base64 | base64 -d | wc -c; printf 'a' | base64 | base64 -d | wc -c; printf 'a\n\n' | base64 | base64 -d | wc -c
## STDOUT:
2
1
3
## END
## status: 0

#### Wc_Mwlc_OnInvalidByteWithText
printf 'a\xffb c' | wc -w -m -c -L | awk '{print $1, $2, $3, $4}'
## stdout: 2 4 5 4
## status: 0

#### Wc_Mwlc_OnLoneInvalidByteAndNewline
printf '\xe9\n' | wc -l -w -m -c -L | awk '{print $1, $2, $3, $4, $5}'
## stdout: 1 0 1 2 0
## status: 0

#### Wc_M_OnOnlyInvalidBytes
printf '\xff\xfe' | wc -m
## stdout: 0
## status: 0

#### Wc_Mc_OnAccentsEmojiCjk
printf 'caf\xc3\xa9 \xf0\x9f\x98\x80 \xe6\x97\xa5\n' | wc -m -c | awk '{print $1, $2}'
## stdout: 9 15
## status: 0

#### Tr_OctalSet_MatchesTheByte
printf 'a\351b' | tr '\351' x
## stdout-json: "axb"
## status: 0

#### Tr_Delete_InvalidByte
printf 'a\351b' | tr -d '\351' | wc -c
## stdout: 2
## status: 0

#### Cut_Bytes_SelectsTheInvalidByte
printf 'a\351b\n' | cut -b2 | wc -c
## stdout: 2
## status: 0

#### Cut_Bytes_ExcludesTheInvalidByte
printf 'a\351b\n' | cut -b1,3
## stdout: ab
## status: 0

#### FusedLane_InvalidBytes_PassThroughCatHeadWc
printf 'a\351\nb\377\n' | cat | head -n 1 | wc -c
## stdout: 3
## status: 0

#### ProcessSubstitution_CarriesInvalidBytes
cat <(printf '\351') | wc -c
## stdout: 1
## status: 0

#### Printf_InvalidByte_Redirect_WritesOneByteFile
printf '\xe9' > f
## stdout:
## status: 0

#### PrintfAppendRedirect_InvalidBytes
printf '\xe9' >> f; printf '\xe9\x80' >> f
## stdout:
## status: 0

#### FusedLane_Tac_Rev_Keep_TheBytes
printf 'x\351\ny\n' | tac | cat > out
## stdout:
## status: 0

#### Sort_OfInvalidBytes_KeepsEveryByte
printf 'b\351\na\377\n' | sort | wc -c > n
## stdout:
## status: 0
