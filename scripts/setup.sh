#!/usr/bin/env bash
# One-time developer setup: installs tools and enables the repo's git hooks.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

if command -v brew >/dev/null 2>&1; then
    brew bundle --file=Brewfile
else
    echo "Homebrew not found; install SwiftLint, Periphery and xcbeautify manually." >&2
fi

git config core.hooksPath .githooks
echo "✓ Git hooks enabled (.githooks)"
