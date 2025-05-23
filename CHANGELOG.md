# Changelog

All notable changes to this project will be documented in this file.

The format is based on a mixture of [Keep a Changelog] and [Common Changelog].
This project adheres to [Semantic Versioning], with the exception that minor releases may include breaking changes.

## [Unreleased]

### Changed

- 🚨 Add support for linting python bindings ([#114]) ([**@ystade**])

## [1.9.0] - 2025-04-26

### Added

- 👷 Add support for Windows 11 ARM runners ([#95], [#96]. [#100]) ([**@burgholzer**])

### Changed

- 🚸 Allow configuring the runners enabled for Python packaging ([#96]) ([**@burgholzer**])
- 🔧 Use MSVC generator for Windows builds over Ninja ([#102]) ([**@burgholzer**])

### Removed

- 🔥 Remove `msvc-dev-cmd` from the Windows runners ([#100]) ([**@burgholzer**])

## [1.8.1] - 2025-04-04

_📚 Refer to the [GitHub Release Notes] for previous changelogs._

<!-- Version links -->

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.9.0...HEAD
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.9.0
[1.8.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.8.1

<!-- PR links -->

[#114]: https://github.com/munich-quantum-toolkit/workflows/pull/114
[#102]: https://github.com/munich-quantum-toolkit/workflows/pull/102
[#100]: https://github.com/munich-quantum-toolkit/workflows/pull/100
[#96]: https://github.com/munich-quantum-toolkit/workflows/pull/96
[#95]: https://github.com/munich-quantum-toolkit/workflows/pull/95

<!-- Contributor -->

[**@burgholzer**]: https://github.com/burgholzer
[**@ystade**]: https://github.com/ystade

<!-- General links -->

[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Common Changelog]: https://common-changelog.org
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[GitHub Release Notes]: https://github.com/munich-quantum-toolkit/workflows/releases
