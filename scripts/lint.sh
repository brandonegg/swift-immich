#!/usr/bin/env bash
# Check formatting and lint rules exactly as CI does. Exits non-zero on any issue.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

swift format lint --strict --recursive --parallel SwiftImmich SwiftImmichTests
swiftlint lint --strict --quiet
