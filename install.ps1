#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Install ps-bash from GitHub releases.
.DESCRIPTION
    Detects platform (Windows, Linux, macOS) and architecture (x64, arm64),
    downloads the latest GitHub release, and installs ps-bash to a suitable
    location. Optionally adds it to your PATH.
.EXAMPLE
    iwr https://raw.githubusercontent.com/standardbeagle/ps-bash/main/install.ps1 | iex
#>
param(
    [string]$Version = "latest",
    [string]$InstallDir,
    [switch]$NoAddToPath
)

$ErrorActionPreference = 'Stop'

function Install-PsBashWindowsPackage {
    param([string]$Stage, [string]$InstallDir)

    $InstallDir = [IO.Path]::TrimEndingDirectorySeparator([IO.Path]::GetFullPath($InstallDir))
    if ($InstallDir -eq [IO.Path]::GetPathRoot($InstallDir)) {
        throw 'Refusing to install into a filesystem root; choose a package directory.'
    }
    $marker = '.ps-bash-package'
    if (Test-Path -LiteralPath $InstallDir) {
        $existing = Get-Item -Force -LiteralPath $InstallDir
        if (-not $existing.PSIsContainer -or ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Refusing to replace $InstallDir; choose an empty package directory."
        }
        $owned = Join-Path $InstallDir $marker
        if (@(Get-ChildItem -Force -LiteralPath $InstallDir).Count -gt 0 -and
            (-not (Test-Path -LiteralPath $owned -PathType Leaf) -or
             [IO.File]::ReadAllText($owned) -ne 'ps-bash')) {
            throw "Refusing to replace unowned directory $InstallDir; choose an empty package directory. Legacy installs must be moved aside explicitly."
        }
    }
    [IO.File]::WriteAllText((Join-Path $Stage $marker), 'ps-bash')
    New-Item -ItemType Directory -Force -Path ([IO.Path]::GetDirectoryName($InstallDir)) | Out-Null
    # Never delete a pre-existing backup. Each upgrade retains its own original directory.
    $previous = "$InstallDir.previous-$([guid]::NewGuid().ToString('N'))"
    $movedPrevious = $false
    if (Test-Path -LiteralPath $InstallDir) {
        Move-Item -LiteralPath $InstallDir -Destination $previous
        $movedPrevious = $true
    }
    try {
        Move-Item -LiteralPath $Stage -Destination $InstallDir
    } catch {
        if ($movedPrevious -and -not (Test-Path -LiteralPath $InstallDir)) {
            Move-Item -LiteralPath $previous -Destination $InstallDir
        }
        throw
    }
    if ($movedPrevious) { Write-Host "Previous package retained at: $previous" }
}

# --- Platform detection ---
$os = if ($IsWindows) { 'win' } elseif ($IsMacOS) { 'osx' } else { 'linux' }
$arch = switch ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture) {
    ([System.Runtime.InteropServices.Architecture]::Arm64) { 'arm64' }
    ([System.Runtime.InteropServices.Architecture]::X64)   { 'x64' }
    default {
        Write-Error "Unsupported architecture: $_"
        exit 1
    }
}
$rid = "${os}-${arch}"
$ext = if ($IsWindows) { '.exe' } else { '' }

# Release archives exist only for these RIDs (see the publish.yml build matrix).
if ($rid -notin @('win-x64', 'linux-x64', 'osx-arm64')) {
    Write-Error "Unsupported platform: no ps-bash release archive is built for $rid."
    exit 1
}

# --- Install path ---
# Windows: InstallDir IS the package directory (launcher + host + assets together).
# Unix: InstallDir holds only an exec wrapper; the full package lives in a versioned
# directory under $packageRoot so the launcher always runs beside ps-bash-host.
if (-not $InstallDir) {
    $InstallDir = if ($IsWindows) {
        Join-Path $env:LOCALAPPDATA 'ps-bash'
    } else {
        Join-Path $env:HOME '.local/bin'
    }
}
$packageRoot = if (-not $IsWindows) {
    if ($env:INSTALL_ROOT) { $env:INSTALL_ROOT } else { Join-Path $env:HOME '.local/opt/ps-bash' }
}

$binaryName = "ps-bash${ext}"
$hostName = "ps-bash-host${ext}"
$targetPath = Join-Path $InstallDir $binaryName

# --- Resolve version ---
if ($Version -eq 'latest') {
    $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/standardbeagle/ps-bash/releases/latest'
    $Version = $release.tag_name
} else {
    if (-not $Version.StartsWith('v')) { $Version = "v${Version}" }
}
Write-Host "Installing ps-bash $Version for $rid..."

# --- Download ---
$assetName = "ps-bash-${Version}-${rid}.zip"
$baseUrl = "https://github.com/standardbeagle/ps-bash/releases/download/${Version}"
$downloadUrl = "$baseUrl/$assetName"
$workDir = Join-Path ([System.IO.Path]::GetTempPath()) "ps-bash-install-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Force -Path $workDir | Out-Null
$tempZip = Join-Path $workDir $assetName

try {
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing
    } catch {
        throw "Failed to download ${downloadUrl}: $($_.Exception.Message)"
    }

    # Verify the published digest when the release has one.
    try {
        $digestText = (Invoke-WebRequest -Uri "$downloadUrl.sha256" -UseBasicParsing).Content
        if ($digestText -is [byte[]]) { $digestText = [Text.Encoding]::ASCII.GetString($digestText) }
        $expected = ($digestText.Trim() -split '\s+')[0].ToLowerInvariant()
    } catch { $expected = $null }
    if ($expected) {
        $actual = (Get-FileHash $tempZip -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected) { throw "Checksum mismatch for $assetName; aborting." }
    }

    # --- Extract to staging, never straight over a working install ---
    $stage = Join-Path $workDir 'stage'
    New-Item -ItemType Directory -Force -Path $stage | Out-Null
    if ($IsWindows) {
        Expand-Archive -Path $tempZip -DestinationPath $stage
    } else {
        unzip -q $tempZip -d $stage
        if ($LASTEXITCODE -ne 0) { throw "Invalid archive: $assetName" }
    }
    foreach ($required in @($binaryName, $hostName)) {
        if (-not (Test-Path -LiteralPath (Join-Path $stage $required))) {
            throw "Archive is missing $required; aborting."
        }
    }
    if (-not $IsWindows) {
        chmod +x (Join-Path $stage $binaryName) (Join-Path $stage $hostName)
    }

    # --- Smoke: run a real command end to end (launcher -> host), not just --version ---
    $smoke = & (Join-Path $stage $binaryName) -c 'echo ready; seq 1 3 | wc -l' 2>&1
    if ($LASTEXITCODE -ne 0 -or ($smoke -join "`n") -notmatch 'ready') {
        throw "Smoke test failed; nothing was installed:`n$($smoke -join "`n")"
    }

    # --- Install the verified package ---
    if ($IsWindows) {
        Install-PsBashWindowsPackage -Stage $stage -InstallDir $InstallDir
    } else {
        $packageDir = Join-Path $packageRoot ($Version -replace '^v', '')
        New-Item -ItemType Directory -Force -Path $packageRoot, $InstallDir | Out-Null
        if (Test-Path -LiteralPath $packageDir) { Remove-Item -Recurse -Force -LiteralPath $packageDir }
        Move-Item -LiteralPath $stage -Destination $packageDir
        $current = Join-Path $packageRoot 'current'
        if (Test-Path -LiteralPath $current) { Remove-Item -Force -LiteralPath $current }
        New-Item -ItemType SymbolicLink -Path $current -Target $packageDir | Out-Null
        # Exec wrapper so the launcher always runs inside the package, beside its host.
        $wrapper = "#!/bin/sh`nexec `"$current/$binaryName`" `"`$@`"`n"
        [IO.File]::WriteAllText($targetPath, $wrapper)
        chmod +x $targetPath
    }
} finally {
    Remove-Item -Recurse -Force -LiteralPath $workDir -ErrorAction SilentlyContinue
}

Write-Host "Installed to: $targetPath"

# --- PATH ---
if (-not $NoAddToPath) {
    $alreadyInPath = $env:PATH -split [IO.Path]::PathSeparator | Where-Object { $_ -eq $InstallDir }
    if (-not $alreadyInPath) {
        if ($IsWindows) {
            $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
            if ($userPath -notlike "*${InstallDir}*") {
                [Environment]::SetEnvironmentVariable('Path', "${userPath};${InstallDir}", 'User')
                Write-Host "Added $InstallDir to your user PATH. Restart your terminal to use 'ps-bash'."
            }
        } else {
            $profileFiles = @(
                (Join-Path $env:HOME '.bashrc'),
                (Join-Path $env:HOME '.zshrc'),
                (Join-Path $env:HOME '.config/fish/config.fish')
            )
            foreach ($pf in $profileFiles) {
                # fish has no POSIX `export PATH=a:$PATH` (its PATH is a list)
                $exportLine = if ($pf -like '*.fish') {
                    "fish_add_path `"$InstallDir`""
                } else {
                    "export PATH=`"${InstallDir}:`$PATH`""
                }
                if (Test-Path $pf) {
                    $content = Get-Content -Raw -Path $pf -ErrorAction SilentlyContinue
                    if ($content -notlike "*$InstallDir*") {
                        Add-Content -Path $pf -Value "`n# ps-bash`n$exportLine`n"
                        Write-Host "Added $InstallDir to PATH in $pf"
                    }
                }
            }
        }
    } else {
        Write-Host "$InstallDir is already in your PATH."
    }
}

# --- Verify ---
$installedVersion = & $targetPath --version
if ($LASTEXITCODE -ne 0) { Write-Error "Installed ps-bash failed to run."; exit 1 }
Write-Host "Installed version: $installedVersion"
$null = & $targetPath -c 'echo ok'
if ($LASTEXITCODE -ne 0) { Write-Error "Installed ps-bash could not execute a command."; exit 1 }

Write-Host "Done. Run '$binaryName --help' to get started."
