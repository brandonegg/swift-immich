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

Tooling is managed with [mise](https://mise.jdx.dev). `mise.toml` pins the CLI tools and defines the project's tasks. Run once after cloning:

```sh
brew install mise
mise install
```

`mise install` installs the pinned tools (verified against `mise.lock`) and turns on the git pre-commit hook.

| Task | What it does |
| --- | --- |
| `mise run doctor` | Checks that your Xcode and SwiftLint versions match the project's pins |
| `mise run format` | Formats Swift sources in place and auto-fixes SwiftLint issues |
| `mise run lint` | Runs swift-format and SwiftLint checks (same as CI) |
| `mise run build` | Builds the app and tests for the simulator |
| `mise run test` | Runs the unit tests on the simulator |
| `mise run unused` | Finds unused code with Periphery |

To use a different simulator locally, create a git-ignored `mise.local.toml`:

```toml
[env]
SIMULATOR_DESTINATION = "platform=iOS Simulator,name=iPhone 18 Pro,OS=27.2"
```

| Tool | Purpose | Config |
| --- | --- | --- |
| [swift-format](https://github.com/swiftlang/swift-format) | Code formatting (bundled with Xcode) | `.swift-format` |
| [SwiftLint](https://github.com/realm/SwiftLint) | Linting; also runs in Xcode builds | `.swiftlint.yml` |
| [Periphery](https://github.com/peripheryapp/periphery) | Unused code detection | `.periphery.yml` |

The first time you open the project, Xcode asks you to trust the SwiftLint build plugin. Click **Trust & Enable**.

SwiftLint is pinned in two places: `mise.toml` for the command line, and the `SwiftLintPlugins` package in the Xcode project for in-Xcode warnings. `mise run doctor` fails (locally and in CI) if they differ. Dependabot bumps the Xcode package; when it does, bump `mise.toml` to match with `mise up --bump`.

CI (`.github/workflows/ci.yml`) runs `doctor`, `lint`, `test` and `unused` through mise on every pull request.
