# SwiftImmich

A native iOS client for [Immich](https://immich.app), the self-hosted photo and video management solution, built with Swift and SwiftUI.

## Requirements

- Xcode 27+
- iOS 26.0+

## Getting started

Open `SwiftImmich.xcodeproj` in Xcode and run the `SwiftImmich` scheme.

To run the tests from the command line, use `mise run test`. See [Development setup](#development-setup) first.

## Immich API client

`ImmichAPI/` is a local Swift package that holds the REST client. It's generated at build time by [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) from Immich's OpenAPI spec (`ImmichAPI/Sources/ImmichAPI/openapi.json`). Each API operation becomes a method on `Client`:

```swift
import ImmichAPI

let client = Client(serverURL: serverURL, credential: .apiKey(key))
let version = try await client.getServerVersion().ok.body.json
```

`serverURL` is the server's root URL, such as `https://photos.example.com`. The client adds the `/api` prefix itself. A credential can be an API key (`.apiKey`) or a session token from `login` (`.accessToken`).

To move to a newer Immich release, run `mise run api:update v3.5.0`, build, fix any compile errors from changed endpoints, then commit the new spec. The first time you build, Xcode asks you to trust the OpenAPIGenerator plugin. Click **Trust & Enable**.

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
| `mise run test` | Runs all unit tests: the app's on the simulator (`test:app`) and ImmichAPI's on macOS (`test:api`) |
| `mise run unused` | Finds unused code with Periphery |
| `mise run api:update <tag>` | Downloads the Immich OpenAPI spec for a release, e.g. `v3.4.1` |

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
