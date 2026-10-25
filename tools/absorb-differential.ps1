# Converts literal-script AssertOracle.EqualAsync calls in Differential.Tests into spec/differential/*.spec.sh cases
# (names + scripts only; expectations are re-recorded from the bash oracle by PSBASH_SPEC_RECORD=1).
param([string]$Root = (Resolve-Path "$PSScriptRoot/..").Path)
$out = Join-Path $Root 'spec/differential'
New-Item -ItemType Directory -Force $out | Out-Null
function Unescape([string]$s) {
    $sb = [System.Text.StringBuilder]::new()
    for ($i = 0; $i -lt $s.Length; $i++) {
        $c = $s[$i]
        if ($c -ne '\') { [void]$sb.Append($c); continue }
        $i++; $n = $s[$i]
        switch ($n) { 'n' { [void]$sb.Append("`n") } 't' { [void]$sb.Append("`t") } 'r' { [void]$sb.Append("`r") }
            '0' { [void]$sb.Append([char]0) } default { [void]$sb.Append($n) } }
    }
    $sb.ToString()
}
# Reads one C# string-literal expression (regular, verbatim @"", raw """, joined by +) starting at $p; returns @(value, endIndex) or $null.
function ReadLiteral([string]$text, [int]$p) {
    $acc = [System.Text.StringBuilder]::new()
    while ($true) {
        while ($p -lt $text.Length -and [char]::IsWhiteSpace($text[$p])) { $p++ }
        if ($p -ge $text.Length) { return $null }
        if ($text.Substring($p, [Math]::Min(3, $text.Length - $p)) -eq '"""') {
            $q = $text.IndexOf('"""', $p + 3, [StringComparison]::Ordinal); if ($q -lt 0) { return $null }
            $body = $text.Substring($p + 3, $q - $p - 3) -replace '^\s*\r?\n', '' -replace '\r?\n[ \t]*$', ''
            $lines = $body -split "`r?`n"; $ind = ($lines | Where-Object { $_.Trim() } | ForEach-Object { $_.Length - $_.TrimStart().Length } | Measure-Object -Minimum).Minimum
            [void]$acc.Append((($lines | ForEach-Object { if ($_.Length -ge $ind) { $_.Substring($ind) } else { $_ } }) -join "`n")); $p = $q + 3
        } elseif ($text[$p] -eq '@' -and $text[$p+1] -eq '"') {
            $k = $p + 2
            while ($k -lt $text.Length) { if ($text[$k] -eq '"') { if ($text[$k+1] -eq '"') { [void]$acc.Append('"'); $k += 2; continue } else { break } }; [void]$acc.Append($text[$k]); $k++ }
            $p = $k + 1
        } elseif ($text[$p] -eq '"') {
            $k = $p + 1; $sb = [System.Text.StringBuilder]::new()
            while ($k -lt $text.Length -and $text[$k] -ne '"') { if ($text[$k] -eq '\') { [void]$sb.Append($text[$k]); $k++ }; [void]$sb.Append($text[$k]); $k++ }
            [void]$acc.Append((Unescape $sb.ToString())); $p = $k + 1
        } else { return $null }
        $q = $p; while ($q -lt $text.Length -and [char]::IsWhiteSpace($text[$q])) { $q++ }
        if ($text[$q] -eq '+') { $p = $q + 1; continue }
        return @($acc.ToString(), $p)
    }
}
$total = 0; $skipped = 0
$nameRx = [regex]'(?:Task|void)\s+(\w+)\s*\('
foreach ($f in Get-ChildItem "$Root/src/PsBash.Differential.Tests" -Filter *.cs -File) {
    $text = Get-Content $f.FullName -Raw
    $cls = [IO.Path]::GetFileNameWithoutExtension($f.Name) -replace 'DifferentialTests$|Tests$', ''
    $cases = [System.Collections.Generic.List[string]]::new(); $seen = @{}
    $helpers = @([regex]::Matches($text, 'private\s+static\s+(?:async\s+)?Task\s+(\w+)\s*\(\s*string\s+\w+\s*\)\s*(?:=>|\{)[^;]*?EqualAsync\(') | ForEach-Object { $_.Groups[1].Value })
    # A helper that forwards `CONST + script` (fixture setup) keeps its constant as a prefix.
    $prefix = ""
    $pm = [regex]::Match($text, 'private\s+static\s+(?:async\s+)?Task\s+\w+\s*\(\s*string\s+\w+\s*\)\s*(?:=>|\{)[^;]*?EqualAsync\(\s*(\w+)\s*\+\s*\w+')
    if ($pm.Success) {
        $cm = [regex]::Match($text, '(?:const|static\s+readonly)\s+string\s+' + $pm.Groups[1].Value + '\s*=\s*')
        if ($cm.Success) { $lit = ReadLiteral $text ($cm.Index + $cm.Length); if ($lit) { $prefix = $lit[0] } }
    }
    $apis = @('AssertOracle.EqualAsync(', 'AssertOracle.GoldenAsync(') + @($helpers | ForEach-Object { "$_(" })
    foreach ($api in $apis) {
      $pos = 0
      while (($i = $text.IndexOf($api, $pos, [StringComparison]::Ordinal)) -ge 0) {
        $pos = $i + $api.Length
        if ($i -gt 0 -and ($text[$i-1] -match '[\w.]') -and $api -notlike 'AssertOracle*') { continue }   # method declaration or member call, not the helper
        $total++
        $r = ReadLiteral $text $pos
        if ($null -eq $r) { $skipped++; continue }
        $end = $text.IndexOf(';', $r[1]); $tail = $text.Substring($r[1], $end - $r[1])
        if ($tail -match 'liveOnly\s*:\s*true') { $skipped++; continue }
        $before = $text.Substring([Math]::Max(0, $i - 1500), [Math]::Min(1500, $i))
        $nm = $nameRx.Matches($before); if ($nm.Count -eq 0) { $skipped++; continue }
        $name = $nm[$nm.Count - 1].Groups[1].Value
        $script = $r[0]
        if ($api -notlike 'AssertOracle*' -and $prefix) { $script = $prefix + $script }
        if ($script -match '(?m)^#### |^## ' -or $seen.ContainsKey($script)) { $skipped++; continue }
        $seen[$script] = 1
        $cases.Add("#### $name`n$($script.TrimEnd("`n"))`n")
      }
    }
    # Theory rows: a method that forwards its first `string script` parameter to the oracle; each [InlineData("...")] is a case.
    $mrx = [regex]('(?s)((?:[ \t]*\[(?:InlineData|SkippableTheory|Theory|Trait)[^\n]*\n)+)[ \t]*public\s+(?:async\s+)?(?:Task|void)\s+(\w+)\s*\(\s*string\s+(\w+)\b[^)]*\)\s*(?:=>|\{)\s*(?:await\s+)?(?:AssertOracle\.EqualAsync|' + (($helpers + 'ZZNONE') -join '|') + ')\(\s*\3\b')
    foreach ($m in $mrx.Matches($text)) {
        $n = 0
        foreach ($line in ($m.Groups[1].Value -split "`n")) {
            $idx = $line.IndexOf('[InlineData(', [StringComparison]::Ordinal); if ($idx -lt 0) { continue }
            $r = ReadLiteral $line ($idx + 12); if ($null -eq $r) { $total++; $skipped++; continue }
            $total++; $n++
            $script = $r[0]
            if ($script -match '(?m)^#### |^## ' -or $seen.ContainsKey($script)) { $skipped++; continue }
            $seen[$script] = 1
            $cases.Add("#### $($m.Groups[2].Value) row $n`n$($script.TrimEnd("`n"))`n")
        }
    }    if ($cases.Count -gt 0) {
        $file = Join-Path $out "$($cls.ToLower()).spec.sh"
        if (Test-Path $file) {
            # Merge: keep the recorded file as is, append only scripts it does not already contain.
            $existing = [IO.File]::ReadAllText($file)
            $add = $cases | Where-Object { $existing.Contains(($_ -split "`n", 2)[1].TrimEnd("`n")) -eq $false }
            if ($add) { [IO.File]::AppendAllText($file, "`n" + ($add -join "`n")) }
        } else {
            $header = "## Absorbed from Differential.Tests/$($f.Name) (scripts only; expectations recorded from bash 5.2).`n"
            [IO.File]::WriteAllText($file, $header + "`n" + ($cases -join "`n"))
        }
    }
}"literal calls: $total, skipped: $skipped"
