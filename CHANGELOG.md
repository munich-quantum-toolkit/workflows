<!-- Entries in each category are sorted by merge time, with the latest PRs appearing first. -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on a mixture of [Keep a Changelog] and [Common Changelog].
This project adheres to [Semantic Versioning], with the exception that minor releases may include breaking changes.

## [Unreleased]

### Fixed

- 🐛 Fix bug preventing multiple CMake args ([#160]) ([**@denialhaag**])

## [1.15.0] - 2025-07-18

### Added

- 👷 Add `reusable-qiskit-upstream-issue.yml` workflow for creating an issue if the Qiskit upstream tests fail ([#151]) ([**@denialhaag**])

### Changed

- ♻️ Rename `reusable-qiskit-upstream.yml` to `reusable-qiskit-upstream-tests.yml` ([#151]) ([**@denialhaag**])

## [1.14.0] - 2025-07-17

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1140)._

### Added

- 👷 Add `reusable-python-coverage.yml` workflow for uploading Python coverage ([#150]) ([**@denialhaag**])
- 👷 Add `reusable-python-packaging-sdist.yml` workflow for building source distributions ([#150]) ([**@denialhaag**])
- 👷 Add `reusable-python-packaging-wheel-build.yml` workflow for building wheels using `build` ([#150]) ([**@denialhaag**])
- 👷 Add `reusable-python-packaging-wheel-cibuildwheel.yml` workflow for building wheels using `cibuildwheel` ([#150]) ([**@denialhaag**])

### Changed

- ♻️ Move matrix generation to calling workflow ([#150]) ([**@denialhaag**])

### Removed

- 🔥 Remove `reusable-cpp-ci.yml` workflow ([#150]) ([**@denialhaag**])
- 🔥 Remove `reusable-python-ci.yml` workflow ([#150]) ([**@denialhaag**])
- 🔥 Remove `reusable-python-packaging.yml` workflow ([#150]) ([**@denialhaag**])

## [1.13.0] - 2025-07-16

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1130)._

### Added

- 👷🐧 Allow configuring Clang version in Ubuntu C++ testing workflow ([#146]) ([**@burgholzer**])
- 👷🍎 Allow configuring GCC and Clang version in macOS C++ testing workflow ([#146]) ([**@burgholzer**])
- ✨🐉 Add MLIR configuration when specifying `clang-XX` as the `compiler` in the C++ testing workflows on Linux and macOS ([#146]) ([**@burgholzer**])

### Changed

- ♻️ Streamline runner and compiler configuration in C++ as well as Python workflows ([#146]) ([**@burgholzer**])

## [1.12.0] - 2025-07-08

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1120)._

### Added

- 🐍🚨 Add support for running Astral's `ty` type checker as part of the `reusable-python-linter.yml` workflow ([#128]) ([**@burgholzer**])

### Changed

- 👷 Use GitHub App token for workflow that updates MQT Core ([#142]) ([**@denialhaag**])
- 🐍🚨 Update `reusable-python-linter.yml` to allow disabling the `mypy` type checker ([#128]) ([**@burgholzer**])

## [1.11.0] - 2025-06-15

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1110)._

### Changed

- ⬆️ Update `cibuildwheel` to `v3` ([#126]) ([**@burgholzer**])
- 💚 Adapt file filter for the change detection to the new project structure regarding the Python bindings ([#119]) ([**@ystade**])

## [1.10.0] - 2025-05-23

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1100)._

### Changed

- 🚨 Add support for linting Python bindings with clang-tidy ([#114]) ([**@ystade**])

## [1.9.0] - 2025-04-26

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#190)._

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

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.15.0...HEAD
[1.15.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.15.0
[1.14.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.14.0
[1.13.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.13.0
[1.12.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.12.0
[1.11.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.11.0
[1.10.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.10.0
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.9.0
[1.8.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.8.1

<!-- PR links -->

[#160]: https://github.com/munich-quantum-toolkit/workflows/pull/160
[#151]: https://github.com/munich-quantum-toolkit/workflows/pull/151
[#150]: https://github.com/munich-quantum-toolkit/workflows/pull/150
[#146]: https://github.com/munich-quantum-toolkit/workflows/pull/146
[#142]: https://github.com/munich-quantum-toolkit/workflows/pull/142
[#126]: https://github.com/munich-quantum-toolkit/workflows/pull/126
[#119]: https://github.com/munich-quantum-toolkit/workflows/pull/119
[#114]: https://github.com/munich-quantum-toolkit/workflows/pull/114
[#102]: https://github.com/munich-quantum-toolkit/workflows/pull/102
[#100]: https://github.com/munich-quantum-toolkit/workflows/pull/100
[#96]: https://github.com/munich-quantum-toolkit/workflows/pull/96
[#95]: https://github.com/munich-quantum-toolkit/workflows/pull/95

<!-- Contributor -->

[**@burgholzer**]: https://github.com/burgholzer
[**@ystade**]: https://github.com/ystade
[**@denialhaag**]: https://github.com/denialhaag

<!-- General links -->

[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Common Changelog]: https://common-changelog.org
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[GitHub Release Notes]: https://github.com/munich-quantum-toolkit/workflows/releases
