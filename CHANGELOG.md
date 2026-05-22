<!-- Entries in each category are sorted by merge time, with the latest PRs appearing first. -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on a mixture of [Keep a Changelog] and [Common Changelog].
This project adheres to [Semantic Versioning], with the exception that minor releases may include breaking changes.

## [Unreleased]

## [2.0.0] - 2026-05-22

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#200)._

### Changed

- 🚸 Adapt C++ workflows to require `cmake-presets` ([#363]) ([**@denialhaag**])

## [1.18.1] - 2026-04-09

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1181)._

### Changed

- 📦️ Archive packaging-related artifacts again ([#356]) ([**@denialhaag**])

## [1.18.0] - 2026-04-08

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1180)._

### Added

- 🤖 Add zizmor security analysis to CI ([#343]) ([**@burgholzer**])

### Changed

- 🛂 Scope secrets for `reusable-mqt-core-update.yml` to an `mqt-app` GitHub environment ([#339]) ([**@burgholzer**])

### Fixed

- 💚 Tweak uv caching so that workflows do not fail on `main` branches due to nothing being cached ([#344]) ([**@burgholzer**])

## [1.17.15] - 2026-03-11

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#11715)._

### Changed

- ⬆️ Update [munich-quantum-software/setup-mlir] to `v1.3.0`, which improves support for LLVM 22 by re-adding Windows Debug builds ([#335]) ([**@burgholzer**])
- ⬆️ Update `cibuildwheel` to `v3.4.0` ([#335]) ([**@denialhaag**])
- 📦️ Selectively disable archiving when uploading artifacts ([#332]) ([**@denialhaag**])

## [1.17.14] - 2026-03-01

### Fixed

- 🐛 Update [munich-quantum-software/setup-mlir] to `v1.2.1` to fix a bug preventing the action to run ([#330])

## [1.17.13] - 2026-03-01

### Changed

- ⬆️ Update [munich-quantum-software/setup-mlir] to `v1.2.0`, which adds support for LLVM 22 ([#329]) ([**@burgholzer**])

## [1.17.12] - 2026-02-18

### Changed

- 🔧 Run `ty check` through `uvx prek run -a ty-check` ([#323]) ([**@burgholzer**])

### Removed

- 🔥 Remove the `nick-fields/retry` action on Windows builds, which put an artificial 15-minute limit on the build time ([#321]) ([**@burgholzer**])

## [1.17.11] - 2026-01-07

### Added

- ✨ Download Debug builds of LLVM for C++ tests on Windows ([#305]) ([**@burgholzer**])

### Changed

- 🔧 Include `mlir/**` in C++ change detection ([#300]) ([**@burgholzer**])

### Removed

- 🔥 Remove dedicated `run-mlir` MLIR output for `reusable-change-detection.yml` ([#300]) ([**@burgholzer**])

## [1.17.10] - 2026-01-04

### Fixed

- 🐛 Fix `LIT_ARG` handling for Linux and macOS C++ jobs ([#298]) ([**@burgholzer**])

## [1.17.9] - 2026-01-04

### Fixed

- 🐛 Fix concurrency group overlap in GitHub Actions ([#297]) ([**@burgholzer**])

## [1.17.8] - 2026-01-04

### Changed

- 🔧 Update CI workflows to use `uv` for installing dependencies and add `lit` installation step ([#295]) ([**@burgholzer**])
- 👷 Use new `ubuntu-slim` runners for light workflows ([#292]) ([**@burgholzer**])

### Fixed

- 🔒 Fix all warnings reported by zizmor ([#296]) ([**@burgholzer**])

## [1.17.7] - 2025-12-23

### Changed

- 🔧 Update [munich-quantum-software/setup-mlir] to `v1.0.0` ([#290]) ([**@denialhaag**])

## [1.17.6] - 2025-12-21

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1176)._

### Changed

- 🚸 Change to `nox -s stubs` for driving stub generation ([#288]) ([**@burgholzer**])

## [1.17.5] - 2025-12-19

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1175)._

### Added

- ✨ Add step for checking if Python stub files are up to date ([#286]) ([**@denialhaag**])
- ✨ Add optional [munich-quantum-software/setup-mlir] input to allow setting up MLIR in the C++ and Python workflows ([#270]) ([**@denialhaag**], [**@burgholzer**])

### Changed

- 🔧 Do not run Python tests on changes to `.pre-commit-config.yaml` ([#276]) ([**@burgholzer**])
- 🔧 Do not run C++ tests on changes to bindings ([#276]) ([**@burgholzer**])

## [1.17.4] - 2025-12-05

### Changed

- 🔧 Specify `LDFLAGS` and `SDKROOT` to fix macOS builds with Homebrew Clang ([#271]) ([**@denialhaag**])
- 👨‍💻 Simplify the workflow for running `ty` ([#257]) ([**@burgholzer**])

## [1.17.3] - 2025-11-26

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1173)._

### Added

- ✨ Add optional `cpp-linter-ignore-extra` input to allow ignoring additional files in C++ linter ([#241]) ([**@flowerthrower**])

### Fixed

- 🐍🚨 Ensure a locked version of `ty` is used when enabled to guarantee stability ([#255]) ([**@burgholzer**])

## [1.17.2] - 2025-11-24

### Changed

- 🐍🚨 Use `prek` instead of `pre-commit` for running `mypy` ([#254]) ([**@burgholzer**])

### Fixed

- 🐍🚨 Ensure project dependencies are installed when running `ty` ([#254]) ([**@burgholzer**])

## [1.17.1] - 2025-11-20

### Changed

- 👷 Free up disk space before running Python tests ([#247]) ([**@denialhaag**])

## [1.17.0] - 2025-09-10

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1170)._

### Changed

- 📌 Pin GitHub Actions to commit SHAs for increased security (various PRs)

### Removed

- 🔥 Remove CodeQL workflows ([#206]) ([**@denialhaag**])

## [1.16.2] - 2025-08-29

### Changed

- ♻️ Only use workflow-local compiler caching in Python CI and CD ([#188]) ([**@burgholzer**])

## [1.16.1] - 2025-08-21

### Added

- ✨🐉 Add change detection for MLIR code ([#184]) ([**@burgholzer**])

## [1.16.0] - 2025-07-30

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1160)._

### Changed

- ⬆️ Update `cibuildwheel` to `v3.1.1` ([#157]) ([**@denialhaag**])

## [1.15.1] - 2025-07-29

### Fixed

- 🐛 Fix bug preventing multiple CMake args ([#160]) ([**@denialhaag**])

## [1.15.0] - 2025-07-18

_If you are upgrading: please see [`UPGRADING.md`](UPGRADING.md#1150)._

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

- ⬆️ Update `cibuildwheel` to `v3.0.0` ([#126]) ([**@burgholzer**])
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

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v2.0.0
[1.18.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.18.1
[1.18.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.18.0
[1.17.15]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.15
[1.17.14]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.14
[1.17.13]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.13
[1.17.12]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.12
[1.17.11]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.11
[1.17.10]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.10
[1.17.9]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.9
[1.17.8]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.8
[1.17.7]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.7
[1.17.6]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.6
[1.17.5]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.5
[1.17.4]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.4
[1.17.3]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.3
[1.17.2]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.2
[1.17.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.1
[1.17.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.17.0
[1.16.2]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.16.2
[1.16.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.16.1
[1.16.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.16.0
[1.15.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.15.1
[1.15.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.15.0
[1.14.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.14.0
[1.13.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.13.0
[1.12.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.12.0
[1.11.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.11.0
[1.10.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.10.0
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.9.0
[1.8.1]: https://github.com/munich-quantum-toolkit/workflows/releases/tag/v1.8.1

<!-- PR links -->

[#363]: https://github.com/munich-quantum-toolkit/workflows/pull/363
[#356]: https://github.com/munich-quantum-toolkit/workflows/pull/356
[#344]: https://github.com/munich-quantum-toolkit/workflows/pull/344
[#343]: https://github.com/munich-quantum-toolkit/workflows/pull/343
[#339]: https://github.com/munich-quantum-toolkit/workflows/pull/339
[#335]: https://github.com/munich-quantum-toolkit/workflows/pull/335
[#332]: https://github.com/munich-quantum-toolkit/workflows/pull/332
[#330]: https://github.com/munich-quantum-toolkit/workflows/pull/330
[#329]: https://github.com/munich-quantum-toolkit/workflows/pull/329
[#323]: https://github.com/munich-quantum-toolkit/workflows/pull/323
[#321]: https://github.com/munich-quantum-toolkit/workflows/pull/321
[#305]: https://github.com/munich-quantum-toolkit/workflows/pull/305
[#300]: https://github.com/munich-quantum-toolkit/workflows/pull/300
[#298]: https://github.com/munich-quantum-toolkit/workflows/pull/298
[#297]: https://github.com/munich-quantum-toolkit/workflows/pull/297
[#296]: https://github.com/munich-quantum-toolkit/workflows/pull/296
[#295]: https://github.com/munich-quantum-toolkit/workflows/pull/295
[#292]: https://github.com/munich-quantum-toolkit/workflows/pull/292
[#290]: https://github.com/munich-quantum-toolkit/workflows/pull/290
[#288]: https://github.com/munich-quantum-toolkit/workflows/pull/288
[#286]: https://github.com/munich-quantum-toolkit/workflows/pull/286
[#276]: https://github.com/munich-quantum-toolkit/workflows/pull/276
[#271]: https://github.com/munich-quantum-toolkit/workflows/pull/271
[#270]: https://github.com/munich-quantum-toolkit/workflows/pull/270
[#257]: https://github.com/munich-quantum-toolkit/workflows/pull/257
[#255]: https://github.com/munich-quantum-toolkit/workflows/pull/255
[#254]: https://github.com/munich-quantum-toolkit/workflows/pull/254
[#247]: https://github.com/munich-quantum-toolkit/workflows/pull/247
[#241]: https://github.com/munich-quantum-toolkit/workflows/pull/241
[#206]: https://github.com/munich-quantum-toolkit/workflows/pull/206
[#188]: https://github.com/munich-quantum-toolkit/workflows/pull/188
[#184]: https://github.com/munich-quantum-toolkit/workflows/pull/184
[#160]: https://github.com/munich-quantum-toolkit/workflows/pull/160
[#157]: https://github.com/munich-quantum-toolkit/workflows/pull/157
[#151]: https://github.com/munich-quantum-toolkit/workflows/pull/151
[#150]: https://github.com/munich-quantum-toolkit/workflows/pull/150
[#146]: https://github.com/munich-quantum-toolkit/workflows/pull/146
[#142]: https://github.com/munich-quantum-toolkit/workflows/pull/142
[#128]: https://github.com/munich-quantum-toolkit/workflows/pull/128
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
[**@flowerthrower**]: https://github.com/flowerthrower

<!-- General links -->

[Keep a Changelog]: https://keepachangelog.com/en/1.1.0/
[Common Changelog]: https://common-changelog.org
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[GitHub Release Notes]: https://github.com/munich-quantum-toolkit/workflows/releases
[munich-quantum-software/setup-mlir]: https://github.com/munich-quantum-software/setup-mlir
