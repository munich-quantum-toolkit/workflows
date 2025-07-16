# Upgrade Guide

This document describes breaking changes and how to upgrade. For a complete list of changes, including minor and patch releases, please refer to the [changelog](CHANGELOG.md).

## [Unreleased]

## [1.13.0]

This release streamlines the runner and compiler configuration in the C++ as well as Python workflows.
Instead of having an ever-growing list of options for the C++ and Python testing as well as the Python packaging workflows, the configuration options have been simplified.
Most options have been removed and replaced with single list options out of which the desired configuration can be selected.
Specifically, the `reusable-cpp-ci.yml` workflow now has the following new options:

- `ubuntu-runners`: A list of Ubuntu runners to use for the C++ testing workflow.
- `ubuntu-compilers`: A list of compilers to use for the C++ testing workflow on Ubuntu.
- `ubuntu-configs`: A list of configurations to use for the C++ testing workflow on Ubuntu.
- `macos-runners`: A list of macOS runners to use for the C++ testing workflow.
- `macos-compilers`: A list of compilers to use for the C++ testing workflow on macOS.
- `macos-configs`: A list of configurations to use for the C++ testing workflow on macOS.
- `windows-runners`: A list of Windows runners to use for the C++ testing workflow.
- `windows-compilers`: A list of compilers to use for the C++ testing workflow on Windows.
- `windows-configs`: A list of configurations to use for the C++ testing workflow on Windows.

The `reusable-python-ci.yml` and the `reusable-python-packaging.yml` workflows have also been updated with the following new option:

- `runners`: A list of runners to use for the workflow.

In addition, support for additional compilers has been added to the C++ testing workflows.
Specifically, the following compilers are now also supported:

- `clang-XX`: The Clang compiler with version `XX` (e.g., `clang-20`) on Linux and macOS.
- `gcc-XX`: The GCC compiler with version `XX` (e.g., `gcc-15`) on macOS.

When using the `clang-XX` compiler on Linux and macOS, the necessary dependencies for MLIR are automatically installed.
This is a first step towards integrating MLIR into the MQT workflows.

## [1.12.0]

This release adds support for running Astral's `ty` type checker as part of the `reusable-python-linter.yml` workflow.
To enable this, you can set the `run-ty` option to `true` in the workflow configuration.
Additionally, the `mypy` type checker can now be disabled by setting the `run-mypy` option to `false`.
While `ty` is a drop-in replacement for `mypy`, it is still in alpha and may not be as stable as `mypy`.
The current recommendation is to use `ty` and `mypy` in parallel, as they may catch different issues.
Once `ty` is stable, it can be used as a drop-in replacement for `mypy`.
Project may want to add `ty` to their development dependencies to ensure that the same version is used for all developers.

```commandline
uv add --dev ty
```

Furthermore, this release changes the `reusable-mqt-core-update.yml` workflow to use a GitHub App token for creating and editing pull requests.
This token has permissions to trigger workflows in the created pull requests, which is not the case for the default GitHub token used previously.
When using the `reusable-mqt-core-update.yml` workflow, it is now necessary to pass the `APP_ID` and `APP_PRIVATE_KEY` as secrets.

```yaml
update-mqt-core:
  name: ⬆️ Update MQT Core
  uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-mqt-core-update.yml@v1.12
  with:
    update-to-head: ${{ github.event.inputs.update-to-head == 'true' }}
  secrets:
    APP_ID: ${{ secrets.APP_ID }}
    APP_PRIVATE_KEY: ${{ secrets.APP_PRIVATE_KEY }}
```

Both variables are stored as organization-wide secrets and do not need to be explicitly added to each repository.

## [1.11.0]

This release adapts the file filter for the change detection to the new project structure regarding the Python bindings.
This new project structure moves all Python code (except tests) to the top-level `python` directory and the C++ code for the Python bindings to the top-level `bindings` directory.
Hence, the directories `src` and `include` then contain only C++ code that is not related to the Python bindings.

If the old directory structure is still in use, this update may trigger warnings in C++ files when changes are made only to Python files.
Additionally, pure Python changes will not trigger the Python CI anymore using the old structure.

This release also updates `cibuildwheel` to `v3`, the latest major version released a couple of weeks ago.
Most importantly, the default manylinux images have been updated to `manylinux_2_28`, so that the following lines are no longer necessary in Python projects with compiled extensions.

```toml
manylinux-x86_64-image = "manylinux_2_28"
manylinux-aarch64-image = "manylinux_2_28"
manylinux-ppc64le-image = "manylinux_2_28"
manylinux-s390x-image = "manylinux_2_28"
```

In principle, this also marks the point where one could start testing Python 3.14 support, which is currently in beta.

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

<!-- Version links -->

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.13.0...HEAD
[1.13.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.12.0...v1.13.0
[1.12.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.11.0...v1.12.0
[1.11.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.8.1...v1.9.0
