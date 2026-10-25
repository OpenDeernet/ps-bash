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
$total = 0; $skipped = 0
$nameRx = [regex]'(?:Task|void)\s+(\w+)\s*\('
foreach ($f in Get-ChildItem "$Root/src/PsBash.Differential.Tests" -Filter *.cs -File) {
    $text = Get-Content $f.FullName -Raw
    $cls = [IO.Path]::GetFileNameWithoutExtension($f.Name) -replace 'DifferentialTests$|Tests$', ''
    $cases = [System.Collections.Generic.List[string]]::new(); $seen = @{}
    $pos = 0
    while (($i = $text.IndexOf('AssertOracle.EqualAsync(', $pos, [StringComparison]::Ordinal)) -ge 0) {
        $pos = $i + 24
        $total++
        $j = $pos; while ($j -lt $text.Length -and [char]::IsWhiteSpace($text[$j])) { $j++ }
        if ($text[$j] -ne '"' -or ($j + 1 -lt $text.Length -and $text[$j+1] -eq '"' -and $text[$j+2] -eq '"')) { $skipped++; continue }
        $k = $j + 1; $sb = [System.Text.StringBuilder]::new()
        while ($k -lt $text.Length -and $text[$k] -ne '"') { if ($text[$k] -eq '\') { [void]$sb.Append($text[$k]); $k++ }; [void]$sb.Append($text[$k]); $k++ }
        $m = $k + 1; while ($m -lt $text.Length -and [char]::IsWhiteSpace($text[$m])) { $m++ }
        if ($text[$m] -ne ',' -and $text[$m] -ne ')') { $skipped++; continue }   # concatenation etc.
        $end = $text.IndexOf(';', $m); $tail = $text.Substring($m, $end - $m)
        if ($tail -match 'liveOnly\s*:\s*true') { $skipped++; continue }
        $before = $text.Substring([Math]::Max(0, $i - 1500), [Math]::Min(1500, $i))
        $nm = $nameRx.Matches($before); if ($nm.Count -eq 0) { $skipped++; continue }
        $name = $nm[$nm.Count - 1].Groups[1].Value
        $script = Unescape $sb.ToString()
        if ($script -match '(?m)^#### |^## ' -or $seen.ContainsKey($script)) { $skipped++; continue }
        $seen[$script] = 1
        $cases.Add("#### $name`n$($script.TrimEnd("`n"))`n")
    }
    if ($cases.Count -gt 0) {
        $header = "## Absorbed from Differential.Tests/$($f.Name) (scripts only; expectations recorded from bash 5.2).`n"
        [IO.File]::WriteAllText((Join-Path $out "$($cls.ToLower()).spec.sh"), $header + "`n" + ($cases -join "`n"))
    }
}"literal calls: $total, skipped: $skipped"
