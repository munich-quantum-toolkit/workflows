# Upgrade Guide

This document describes breaking changes and how to upgrade. For a complete list of changes including minor and patch releases, please refer to the [changelog](CHANGELOG.md).

## [Unreleased]

## [1.9.0]

This release adds support for the new Windows 11 ARM runners.
Since not every tool may be compatible with the new runners, they are opt-in by default.
As such, this release allows explicitly configuring the GitHub runners that will be used for running the Python packaging workflow.
Using the default configuration, everything will remain the same as before. That is, the workflow will run on:

- Ubuntu 24.04
- Ubuntu 24.04 ARM
- macOS 13
- macOS 14
- Windows 2022

However, to additionally enable the latest Windows 11 ARM runner, you can now use the following configuration:

```yaml
uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-python-packaging.yml@v1.9
with:
  enable-windows11-arm: true
```

To properly support the new runners, the `msvc-dev-cmd` action has been dropped.
While initial testing has shown minimal impact, this is still a breaking change.
For example, it seems like using Ninja as a generator will lead to the wrong compiler being used.
Consider removing any `-G Ninja` flags from your CMake invocations under Windows.

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.9.0...HEAD
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.8.1...v1.9.0
