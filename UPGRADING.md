# Upgrade Guide

This document describes breaking changes and how to upgrade. For a complete list of changes, including minor and patch releases, please refer to the [changelog](CHANGELOG.md).

## [Unreleased]

This release adapts the file filter for the change detection to the new project structure regarding the Python bindings.
This new project structure moves all Python code (except tests) to the top-level `python` directory and the C++ code for the Python bindings to the top-level `bindings` directory.
Hence, the directories `src` and `include` then contain only C++ code that is not related to the Python bindings.

If the old directory structure is still in use, this update may trigger warnings in C++ files when changes are made only to Python files.
Additionally, pure Python changes will not trigger the Python CI anymore using the old structure.

## [1.10.0]

This release adds support for linting Python bindings. To this end, the `reusable-cpp-linter.yml` workflow adds the option
`setup-pybind11` to set up a Python environment and install the `pybind11` package. By default, this option is disabled.
When enabled, the Python environment is activated automatically such that CMake will find the `pybind11` package.

This change includes that all `python` subdirectories are not ignored by the linter anymore. This may result in new warnings
when the bindings are changed. To fix this, enable the option `setup-pybind11` of the `reusable-cpp-linter.yml` workflow
and add the additional workflow argument `cmake-args: -DBUILD_MQT_[project]_BINDINGS=ON` to the `reusable-cpp-linter.yml` workflow step where
`[project]` is the name of the project you want to build. This will ensure that the bindings are built and the warnings are
resolved.

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

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.10.0...HEAD
[1.10.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.8.1...v1.9.0
