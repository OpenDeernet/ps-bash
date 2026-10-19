# Installing ps-bash

Choose between the **PowerShell module** (`Install-Module PsBash`) and the
**standalone shell**. They have different installation layouts. The current
GitHub release workflow builds self-contained shell archives named
`ps-bash-v<VERSION>-<RID>.zip` for `win-x64`, `linux-x64`, and `osx-arm64`.
Check the selected release's actual assets before downloading; architecture
detection in an installer does not establish that an asset exists.

## Standalone package contents

Keep the entire extracted directory together:

```text
ps-bash[.exe]                    # native launcher
ps-bash-host[.exe]               # PowerShell SDK host
System.Management.Automation.dll
*.dll, *.json, runtimes/, ...    # host dependencies and runtime assets
```

The package includes its .NET/PowerShell SDK runtime assets; copying the
launcher alone does not install a working shell. The repository also contains
slim/full packaging scripts, but the release workflow's archive naming above
is the source for these instructions. Do not infer current release names or
sizes from older slim/full examples.

The installers (`install.sh`, `install.ps1`) install this whole package into a
versioned directory, smoke-test it with a real command before switching, and keep
the previous version for rollback. The manual steps below do the same by hand.

## Manual Installation

Download the appropriate archive for your platform from the
[GitHub Releases](https://github.com/standardbeagle/ps-bash/releases) page.

### Windows

```powershell
# Replace VERSION with the selected release version (without the leading v).
# Use a fresh version directory so a failed upgrade leaves the old one intact.
Expand-Archive ps-bash-vVERSION-win-x64.zip -DestinationPath C:\tools\ps-bash\VERSION

# Verify the package before changing PATH.
& C:\tools\ps-bash\VERSION\ps-bash.exe --version
& C:\tools\ps-bash\VERSION\ps-bash.exe -c 'echo ready; seq 1 3 | wc -l'
if ($LASTEXITCODE -ne 0) { throw 'ps-bash command verification failed' }
# Require the expected version, "ready", and a count of 3.

# Add to PATH (current user)
$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
[Environment]::SetEnvironmentVariable('PATH', "$userPath;C:\tools\ps-bash\VERSION", 'User')
```

On upgrade, replace the old PsBash PATH entry rather than accumulating version
entries: an earlier entry can keep selecting the old binary. Open a new
terminal and check `Get-Command ps-bash` before configuring an agent.

### Linux

```bash
# Replace VERSION with the selected release version.
package_dir="$HOME/.local/opt/ps-bash/VERSION"
mkdir -p "$package_dir"
unzip ps-bash-vVERSION-linux-x64.zip -d "$package_dir"
chmod +x "$package_dir/ps-bash" "$package_dir/ps-bash-host"
"$package_dir/ps-bash" --version
if "$package_dir/ps-bash" -c 'echo ready; seq 1 3 | wc -l'; then
  # Check the expected version, "ready", and a count of 3.
  export PATH="$package_dir:$PATH"
else
  echo 'Command verification failed; keep the previous installation selected.' >&2
fi
```

### macOS

```bash
package_dir="$HOME/.local/opt/ps-bash/VERSION"
mkdir -p "$package_dir"
unzip ps-bash-vVERSION-osx-arm64.zip -d "$package_dir"
chmod +x "$package_dir/ps-bash" "$package_dir/ps-bash-host"
"$package_dir/ps-bash" --version
if "$package_dir/ps-bash" -c 'echo ready; seq 1 3 | wc -l'; then
  # Check the expected version, "ready", and a count of 3.
  export PATH="$package_dir:$PATH"
else
  echo 'Command verification failed; keep the previous installation selected.' >&2
fi
```

These Unix examples set PATH for the current shell. After verification, add the
chosen directory to your actual shell's startup configuration; fish uses its
own PATH syntax (`fish_add_path`). Do not source a Bash example as fish code.
macOS startup was not exercised in the production review; validate the actual
release on the target machine before replacing a working installation.

## Package Manager Installation (Planned)

The following package manager support is planned for post-stable release.

### winget (Windows)

```
winget install standardbeagle.ps-bash
```

Expected install path: `C:\Program Files\ps-bash\`

### Scoop (Windows)

```
scoop bucket add standardbeagle https://github.com/standardbeagle/scoop-bucket
scoop install ps-bash
```

Expected install path: `%USERPROFILE%\scoop\apps\ps-bash\current\`

### Homebrew (macOS / Linux)

```
brew tap standardbeagle/tap
brew install ps-bash
```

Expected install path: `/opt/homebrew/Cellar/ps-bash/<version>/` (macOS ARM)
or `/home/linuxbrew/.linuxbrew/Cellar/ps-bash/<version>/` (Linux)

## Configure a terminal or coding agent

Launch the verified shell by its full path first, then configure the terminal
profile or the agent's documented shell setting. Agents differ in how they
select shells; setting `SHELL` alone is not a universal configuration method.
The [Agent Setup Guide](agent-setup.md) includes the Windows Claude Code
`bash.exe` naming requirement and fallback detection. Keep any launcher alias
beside the complete package so it can still locate its dependencies.

## Upgrade, recover, and remove

Keep the previous version directory until the new package passes the command
smoke and your actual terminal/agent workflow. If startup fails, select the old
entry point and inspect the [host lifecycle diagnostics](specs/host-lifecycle-contract.md).
Do not delete another running host to make an installation appear successful.

Removing the standalone application and removing user data are separate
operations. Inspect `~/.psbash` for history/frecency and configuration before
deciding what to retain; `PSBASH_HOME` can select a different data location.
History databases, WAL/SHM files and recovery copies may contain sensitive
commands and paths. Removing an application directory does not erase them or
external AI-provider records.

Complete onboarding, failure and recovery criteria are in
[journey J01](planning/production-user-journeys.md#j01--install-and-reach-a-useful-first-command).
