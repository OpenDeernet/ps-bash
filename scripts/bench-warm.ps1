<#
.SYNOPSIS
  Warm-path latency harness for the executor design (docs/specs/background-jobs.md §7).
.DESCRIPTION
  Measures the launcher end to end (process start -> exit) for the cases the acceptance bars name:
    back-to-back   `-c 'echo hi'` N times in a row
    spaced         the same with a pause between calls (replacement warm-up finished)
    concurrent     4 launchers at once, wall time vs one command
    bg-wait        `{ :; } & wait`
    bg-sleep       `sleep 1 & wait`  (budget: `sleep 1` + 50 ms)
  Prints min/p50/p90 per case. Run it twice, once per build or setting, and compare p50s.
  NEVER point -Exe at src/*/bin/**/ps-bash.exe (no checkout lock; see CLAUDE.md): use the installed
  launcher or a packaged build. -Env sets process environment for the A/B (e.g. PSBASH_BG_MODE=process).
.EXAMPLE
  ./scripts/bench-warm.ps1 -Label inproc  -Env @{ PSBASH_BG_MODE = 'inproc' }
  ./scripts/bench-warm.ps1 -Label process -Env @{ PSBASH_BG_MODE = 'process' }
#>
param(
    [string]$Exe = (Join-Path $HOME '.local/bin/ps-bash.exe'),
    [int]$Runs = 15,
    [int]$SpacedGapMs = 2000,
    [hashtable]$Env = @{},
    [string]$Label = 'run'
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path $Exe)) { throw "launcher not found: $Exe" }
foreach ($k in $Env.Keys) { Set-Item -Path "Env:$k" -Value $Env[$k] }

function Invoke-Once([string]$Script) {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $null = & $Exe -c $Script 2>&1
    $sw.Stop()
    if ($LASTEXITCODE -ne 0) { Write-Warning "exit $LASTEXITCODE for: $Script" }
    return $sw.Elapsed.TotalMilliseconds
}

function Stat([string]$Name, [double[]]$Ms) {
    $s = $Ms | Sort-Object
    $p = { param($q) $s[[Math]::Min($s.Count - 1, [int][Math]::Floor($q * $s.Count))] }
    [pscustomobject]@{
        Label = $Label; Case = $Name; N = $s.Count
        Min = [int]$s[0]; P50 = [int](& $p 0.5); P90 = [int](& $p 0.9)
    }
}

function Measure-Case([string]$Name, [string]$Script, [int]$GapMs = 0) {
    $null = Invoke-Once $Script                       # discard: daemon/runspace warm-up
    $ms = foreach ($i in 1..$Runs) {
        if ($GapMs) { Start-Sleep -Milliseconds $GapMs }
        Invoke-Once $Script
    }
    Stat $Name $ms
}

$rows = @()
$rows += Measure-Case 'back-to-back echo' 'echo hi'
$rows += Measure-Case 'spaced echo' 'echo hi' $SpacedGapMs
$rows += Measure-Case 'bg-wait { :; } & wait' '{ :; } & wait'
$rows += Measure-Case 'bg-sleep sleep 1 & wait' 'sleep 1 & wait'
$rows += Measure-Case 'fg sleep 1' 'sleep 1'

# 4 concurrent launchers: wall time of the whole batch.
$null = Invoke-Once 'echo hi'
$walls = foreach ($i in 1..[Math]::Max(3, [int]($Runs / 3))) {
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $jobs = 1..4 | ForEach-Object { Start-Job -ArgumentList $Exe -ScriptBlock { param($e) $null = & $e -c 'echo hi' 2>&1 } }
    $null = $jobs | Wait-Job -Timeout 120
    $jobs | Remove-Job -Force
    $sw.Elapsed.TotalMilliseconds
}
$rows += Stat '4 concurrent (batch wall)' $walls

$rows | Format-Table -AutoSize
