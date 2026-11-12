# SwiftImmich

A native iOS client for [Immich](https://immich.app), the self-hosted photo and video management solution, built with Swift and SwiftUI.

## Requirements

- Xcode 27+
- iOS 26.0+

## Getting started

Open `SwiftImmich.xcodeproj` in Xcode and run the `SwiftImmich` scheme.

From the command line:

```sh
xcodebuild test -project SwiftImmich.xcodeproj -scheme SwiftImmich \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## Development setup

Run once after cloning:

```sh
scripts/setup.sh
```

This installs SwiftLint, Periphery and xcbeautify (from the `Brewfile`) and turns on the git pre-commit hook.

| Tool | Purpose | Config |
| --- | --- | --- |
| [swift-format](https://github.com/swiftlang/swift-format) | Code formatting (bundled with Xcode) | `.swift-format` |
| [SwiftLint](https://github.com/realm/SwiftLint) | Linting; also runs in Xcode builds | `.swiftlint.yml` |
| [Periphery](https://github.com/peripheryapp/periphery) | Unused code detection | `.periphery.yml` |

- `scripts/format.sh` formats everything in place.
- `scripts/lint.sh` runs the same checks as CI.
- `periphery scan` finds unused code.

The first time you open the project, Xcode asks you to trust the SwiftLint build plugin. Click **Trust & Enable**.

CI (`.github/workflows/ci.yml`) runs lint, build and test, and Periphery on every pull request. Dependabot keeps Swift packages and GitHub Actions up to date.
