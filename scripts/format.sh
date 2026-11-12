#!/usr/bin/env bash
# Format all Swift sources in place with swift-format, then auto-fix SwiftLint issues.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

swift format format --in-place --recursive --parallel SwiftImmich SwiftImmichTests
if command -v swiftlint >/dev/null 2>&1; then
    swiftlint lint --fix --quiet
fi
