#!/usr/bin/env bash
set -euo pipefail

# Install ps-bash from GitHub releases.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/standardbeagle/ps-bash/main/install.sh | bash
#
# Installs the COMPLETE release package (launcher + ps-bash-host + runtime assets) into
# $INSTALL_ROOT/<version>, smoke-tests it by running a real command, and only then
# switches $INSTALL_ROOT/current and the $INSTALL_DIR/ps-bash entry point. Previous
# version directories are kept so an upgrade can be rolled back.

VERSION="${VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
INSTALL_ROOT="${INSTALL_ROOT:-$HOME/.local/opt/ps-bash}"
NO_ADD_TO_PATH="${NO_ADD_TO_PATH:-}"

# Detect OS and architecture
OS=""
ARCH=""
case "$(uname -s)" in
    Linux*)     OS=linux ;;
    Darwin*)    OS=osx ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "On Windows use install.ps1 (it installs the full package)." >&2; exit 1 ;;
    *)          echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
    x86_64)  ARCH=x64 ;;
    arm64|aarch64) ARCH=arm64 ;;
    *)       echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

RID="${OS}-${ARCH}"

# Release archives exist only for these RIDs (see the publish.yml build matrix).
case "$RID" in
    linux-x64|osx-arm64) ;;
    *) echo "Unsupported platform: no ps-bash release archive is built for ${RID}." >&2; exit 1 ;;
esac

BINARY_NAME="ps-bash"
HOST_NAME="ps-bash-host"
TARGET_PATH="${INSTALL_DIR}/${BINARY_NAME}"

# Resolve version
if [ "$VERSION" = "latest" ]; then
    VERSION=$(curl -fsSL "https://api.github.com/repos/standardbeagle/ps-bash/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    [ -n "$VERSION" ] || { echo "Could not resolve the latest release." >&2; exit 1; }
fi

# GitHub release tags carry a leading 'v'
if [ "${VERSION#v}" = "$VERSION" ]; then
    VERSION="v${VERSION}"
fi

echo "Installing ps-bash ${VERSION} for ${RID}..."

ASSET_NAME="ps-bash-${VERSION}-${RID}.zip"
BASE_URL="https://github.com/standardbeagle/ps-bash/releases/download/${VERSION}"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

curl -fsSL "${BASE_URL}/${ASSET_NAME}" -o "${TEMP_DIR}/${ASSET_NAME}" \
    || { echo "Download failed: ${BASE_URL}/${ASSET_NAME}" >&2; exit 1; }

# Verify the published digest when the release has one.
if curl -fsSL "${BASE_URL}/${ASSET_NAME}.sha256" -o "${TEMP_DIR}/${ASSET_NAME}.sha256" 2>/dev/null; then
    expected=$(cut -d' ' -f1 "${TEMP_DIR}/${ASSET_NAME}.sha256")
    if command -v sha256sum >/dev/null 2>&1; then
        actual=$(sha256sum "${TEMP_DIR}/${ASSET_NAME}" | cut -d' ' -f1)
    else
        actual=$(shasum -a 256 "${TEMP_DIR}/${ASSET_NAME}" | cut -d' ' -f1)
    fi
    [ "$expected" = "$actual" ] || { echo "Checksum mismatch for ${ASSET_NAME}; aborting." >&2; exit 1; }
fi

# Extract to a staging directory first; only a verified package gets its final name.
STAGE_DIR="${TEMP_DIR}/stage"
mkdir -p "$STAGE_DIR"
unzip -q "${TEMP_DIR}/${ASSET_NAME}" -d "$STAGE_DIR" \
    || { echo "Invalid archive: ${ASSET_NAME}" >&2; exit 1; }
for required in "$BINARY_NAME" "$HOST_NAME"; do
    [ -f "${STAGE_DIR}/${required}" ] || { echo "Archive is missing ${required}; aborting." >&2; exit 1; }
done
chmod +x "${STAGE_DIR}/${BINARY_NAME}" "${STAGE_DIR}/${HOST_NAME}"

# Real smoke: run a command end to end (launcher -> host), not just --version.
SMOKE_OUT=$("${STAGE_DIR}/${BINARY_NAME}" -c 'echo ready; seq 1 3 | wc -l' 2>&1) || {
    echo "Smoke test failed; nothing was installed:" >&2
    echo "$SMOKE_OUT" >&2
    exit 1
}
case "$SMOKE_OUT" in
    *ready*) ;;
    *) echo "Smoke test produced unexpected output; nothing was installed:" >&2
       echo "$SMOKE_OUT" >&2
       exit 1 ;;
esac

# Install into a versioned directory, then switch `current`. The previous version
# directory stays in place, so a bad upgrade is undone by repointing `current`.
PACKAGE_DIR="${INSTALL_ROOT}/${VERSION#v}"
mkdir -p "$INSTALL_ROOT" "$INSTALL_DIR"
rm -rf "${PACKAGE_DIR}.new"
mv "$STAGE_DIR" "${PACKAGE_DIR}.new"
rm -rf "$PACKAGE_DIR"
mv "${PACKAGE_DIR}.new" "$PACKAGE_DIR"
ln -sfn "$PACKAGE_DIR" "${INSTALL_ROOT}/current"

# The entry point is a tiny exec wrapper (not a copy of the launcher), so the launcher
# always runs from inside the package directory, beside its host.
cat > "${TARGET_PATH}.tmp" <<WRAP
#!/bin/sh
exec "${INSTALL_ROOT}/current/${BINARY_NAME}" "\$@"
WRAP
chmod +x "${TARGET_PATH}.tmp"
mv -f "${TARGET_PATH}.tmp" "$TARGET_PATH"

echo "Installed ${VERSION} to: ${PACKAGE_DIR}"
echo "Entry point: $TARGET_PATH"

# Add to PATH
if [ -z "$NO_ADD_TO_PATH" ]; then
    if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
        SHELL_NAME=$(basename "${SHELL:-bash}")
        case "$SHELL_NAME" in
            zsh)
                PROFILE="$HOME/.zshrc"
                ;;
            bash)
                PROFILE="$HOME/.bashrc"
                ;;
            fish)
                PROFILE="$HOME/.config/fish/config.fish"
                mkdir -p "$(dirname "$PROFILE")"
                ;;
            *)
                PROFILE="$HOME/.profile"
                ;;
        esac

        if [ -f "$PROFILE" ]; then
            if ! grep -q "$INSTALL_DIR" "$PROFILE"; then
                echo "" >> "$PROFILE"
                echo "# ps-bash" >> "$PROFILE"
                echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$PROFILE"
                echo "Added $INSTALL_DIR to PATH in $PROFILE"
            fi
        else
            echo "export PATH=\"$INSTALL_DIR:\$PATH\"" > "$PROFILE"
            echo "Created $PROFILE and added $INSTALL_DIR to PATH"
        fi
    else
        echo "$INSTALL_DIR is already in your PATH."
    fi
fi

# Verify the installed entry point, not just the package tested in staging.
INSTALLED_VERSION=$("$TARGET_PATH" --version) || { echo "Installed ps-bash failed to run." >&2; exit 1; }
echo "Installed version: $INSTALLED_VERSION"
"$TARGET_PATH" -c 'echo ok' >/dev/null || { echo "Installed ps-bash could not execute a command." >&2; exit 1; }

echo "Done. Run 'ps-bash --help' to get started. (Open a new terminal if 'ps-bash' is not found yet.)"
