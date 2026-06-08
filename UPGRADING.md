# Upgrade Guide

This document describes breaking changes and how to upgrade. For a complete list of changes, including minor and patch releases, please refer to the [changelog](CHANGELOG.md).

## [Unreleased]

## [2.0.3]

This release adds `additional-cpp-files`, `additional-python-files`, and `additional-cd-files` inputs to `reusable-change-detection.yml` to extend the change detection.
If provided, the specified files are checked in addition to the default ones.

## [2.0.2]

### Inheriting project-specific secrets in reusable workflows

Most reusable build, test, lint, and packaging workflows now expose a fixed whitelist of inherited secrets as environment variables.
This is intended for projects that need to make project-specific credentials available to their CI steps without requiring workflow-specific configuration for every consuming repository.

To use this feature, the calling workflow needs to pass `secrets: inherit` to the reusable workflow invocation.
In addition, the calling repository or environment needs to define the corresponding secrets under the exact same names.

The supported names are:

- `IQM_TOKEN`
- `IQM_QC_ALIAS`
- `AWS_S3_BUCKET`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

If a project needs one of these values, define the matching repository or environment secret and inherit secrets in the calling workflow.
For example:

```yaml
python-tests:
  uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-python-tests.yml@v2.0.2
  with:
    runs-on: ubuntu-24.04
  secrets: inherit
```

Once inherited, the reusable workflow exposes the secret values as environment variables with the same names.
If one of the listed secrets is not defined by the calling repository or environment, the corresponding environment variable is left empty.

## [2.0.0]

This release adapts all C++ workflows to require [CMake presets], providing a standardized and reproducible way to configure builds across different platforms while eliminating scattered configuration with string-based arguments.

The testing workflows for macOS, Ubuntu, and Windows (`reusable-cpp-tests-macos.yml`, `reusable-cpp-tests-ubuntu.yml`, and `reusable-cpp-tests-windows.yml`) now require a `preset-name` input and no longer accept `cmake-args` or `config` inputs.
On Windows, the new `mlir-debug` flag can be used for debug MLIR builds.

The coverage and linter workflows (`reusable-cpp-coverage.yml` and `reusable-cpp-linter.yml`) require `coverage` and `lint` presets, respectively, and no longer accept `cmake-args`.

An exemplary `CMakePresets.json` can be found below.

```json
{
  "version": 3,
  "configurePresets": [
    {
      "name": "base",
      "hidden": true,
      "binaryDir": "${sourceDir}/build/${presetName}"
    },
    {
      "name": "base-unix",
      "hidden": true,
      "inherits": "base",
      "condition": {
        "type": "inList",
        "string": "${hostSystemName}",
        "list": ["Linux", "Darwin"]
      },
      "description": "Default configuration for Linux and macOS builds. Uses the Ninja generator",
      "generator": "Ninja"
    },
    {
      "name": "base-windows",
      "hidden": true,
      "inherits": "base",
      "condition": {
        "type": "equals",
        "lhs": "${hostSystemName}",
        "rhs": "Windows"
      },
      "description": "Default configuration for Windows builds. Uses the default generator"
    },
    {
      "name": "debug",
      "inherits": "base-unix",
      "displayName": "Debug config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    },
    {
      "name": "release",
      "inherits": "base-unix",
      "displayName": "Release config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    },
    {
      "name": "coverage",
      "inherits": "base-unix",
      "displayName": "Coverage config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "ENABLE_COVERAGE": "ON"
      }
    },
    {
      "name": "lint",
      "inherits": "base-unix",
      "displayName": "Lint config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "BUILD_MQT_QMAP_BINDINGS": "ON"
      }
    },
    {
      "name": "debug-windows",
      "inherits": "base-windows",
      "displayName": "Windows Debug config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    },
    {
      "name": "release-windows",
      "inherits": "base-windows",
      "displayName": "Windows Release config",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "debug",
      "configurePreset": "debug"
    },
    {
      "name": "release",
      "configurePreset": "release"
    },
    {
      "name": "coverage",
      "configurePreset": "coverage"
    },
    {
      "name": "lint",
      "configurePreset": "lint"
    },
    {
      "name": "debug-windows",
      "configurePreset": "debug-windows",
      "configuration": "Debug"
    },
    {
      "name": "release-windows",
      "configurePreset": "release-windows",
      "configuration": "Release"
    }
  ],
  "testPresets": [
    {
      "name": "base",
      "hidden": true,
      "output": { "outputOnFailure": true },
      "execution": {
        "repeat": { "mode": "until-pass", "count": 3 },
        "timeout": 600
      }
    },
    {
      "name": "debug",
      "inherits": "base",
      "configurePreset": "debug"
    },
    {
      "name": "release",
      "inherits": "base",
      "configurePreset": "release"
    },
    {
      "name": "coverage",
      "inherits": "base",
      "configurePreset": "coverage"
    },
    {
      "name": "debug-windows",
      "inherits": "base",
      "configurePreset": "debug-windows",
      "configuration": "Debug"
    },
    {
      "name": "release-windows",
      "inherits": "base",
      "configurePreset": "release-windows",
      "configuration": "Release"
    }
  ]
}
```

## [1.18.1]

To reduce complications when uploading artifacts during deployment to PyPI, we are reverting changes made in [1.17.15].
The `pattern` passed to [actions/upload-artifact] can be `cibw-` again.

## [1.18.0]

### Rely on MQT App secrets from `mqt-app` GitHub environment

In accordance with the latest guidelines from the [zizmor] linter, the `reusable-mqt-core-update.yml` workflow now relies on the MQT App secrets from a dedicated `mqt-app` GitHub environment.
This means that the `APP_ID` and `APP_PRIVATE_KEY` secrets are no longer read from organization-wide secrets.
Instead, they must now be configured in a dedicated `mqt-app` GitHub environment, which needs to be created in each repository that uses the `reusable-mqt-core-update.yml` workflow.

## [1.17.15]

Thanks to a change in [actions/upload-artifact], it is now possible to not archive artifacts before uploading them.
We make use of this in `reusable-python-packaging-sdist.yml` and `reusable-python-packaging-wheel-build.yml`.
As a result, the `pattern` passed to [actions/upload-artifact] has to be adjusted.
For example, `cibw-` needs to be replaced with `mqt_bench-`.

## [1.17.11]

### Removal of `run-mlir` output from change-detection

This release removes the `run-mlir` output from the change-detection step of the `reusable-cpp-linter.yml` workflow.
The output was only used in MQT Core, where MLIR will be enabled by default with the next release.
Hence, this update includes `mlir/**` in the regular C++ file filter instead.
Since this is only affecting the MQT Core repository, this is only flagged as a patch release.

### Addition of debug builds for LLVM on Windows

With this release, the C++ testing workflows on Windows will now download a debug build of LLVM instead of the release build.
This is made possible by the latest release of the [portable-mlir-toolchain] (`2026.01.07`) and the [setup-mlir] action (`v1.1.0`).
This enables debug builds of libraries depending on the LLVM distributions, such as MQT Core, in debug mode on Windows without running into ABI issues.

## [1.17.6]

### Checking Python stub files

The optional Python linter workflow for checking Python stub files has been redesigned to rely on the presence of a nox session called `stubs`, that shall generate the stub files.
An example of such a session would be:

```python
import nox
import shutil
from pathlib import Path

@nox.session(reuse_venv=True, venv_backend="uv")
def stubs(session: nox.Session) -> None:
    """Generate type stubs for Python bindings using nanobind."""
    env = {"UV_PROJECT_ENVIRONMENT": session.virtualenv.location}
    session.run(
        "uv",
        "sync",
        "--no-dev",
        "--group",
        "build",
        env=env,
    )

    package_root = Path(__file__).parent / "python" / "mqt" / "core"
    pattern_file = Path(__file__).parent / "bindings" / "core_patterns.txt"

    session.run(
        "python",
        "-m",
        "nanobind.stubgen",
        "--recursive",
        "--include-private",
        "--output-dir",
        str(package_root),
        "--pattern-file",
        str(pattern_file),
        "--module",
        "mqt.core.ir",
        "--module",
        "mqt.core.dd",
        "--module",
        "mqt.core.fomac",
        "--module",
        "mqt.core.na",
    )

    pyi_files = list(package_root.glob("**/*.pyi"))

    if shutil.which("prek") is None:
        session.install("prek")

    # Allow both 0 (no issues) and 1 as success codes for fixing up stubs.
    success_codes = [0, 1]
    session.run("prek", "run", "license-tools", "--files", *pyi_files, external=True, success_codes=success_codes)
    session.run("prek", "run", "ruff-check", "--files", *pyi_files, external=True, success_codes=success_codes)
    session.run("prek", "run", "ruff-format", "--files", *pyi_files, external=True, success_codes=success_codes)

    # Finally, run ruff-check again to ensure everything is clean.
    session.run("prek", "run", "ruff-check", "--files", *pyi_files, external=True)
```

## [1.17.5]

### MLIR support

This release adds support for setting up MLIR in the C++ and Python workflows based on the newly created [`setup-mlir` action](https://github.com/munich-quantum-software/setup-mlir).
To enable MLIR support, you can set the `setup-mlir` option to `true` in the workflow configuration of all relevant workflows.
A specific version of MLIR can be specified by setting the `llvm-version` option, which needs to be a valid LLVM version string (e.g., `21.1.8`) that is available via the GitHub action.
For example, the following configuration enables MLIR support with LLVM version 21.1.8 in the C++ linter workflow:

```yaml
uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-cpp-linter.yml@v1.17.5
with:
  setup-mlir: true
  llvm-version: 21.1.8
```

## [1.17.3]

### Type checking with `ty`

This release fixes the `ty` linter workflow, which would always use the latest version of `ty` available on PyPI.
As `ty` is still moving pretty fast and the latest version may not be stable yet, this was not ideal.
This release changes the behavior to use the version of `ty` listed as a development dependency in `pyproject.toml`.
If you have the `enable-ty` option set to `true` in your workflow configuration, you **must** add `ty` to your development dependencies or the workflow will fail.

### Additional customization for the C++ linter

This release adds the optional `cpp-linter-ignore-extra` input to the `reusable-cpp-linter.yml` workflow.
This allows ignoring additional files in the C++ linter workflow by passing a pipe-separated list of globs.
For example, to ignore all files in the `plugin` directory and the `subdir/third_party` directory, you can use the following configuration:

```yaml
uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-cpp-linter.yml@v1.17.3
with:
  cpp-linter-ignore-extra: "plugin/**|subdir/third_party/**"
```

## [1.17.0]

This release removes all CodeQL workflows because CodeQL is now run automatically by GitHub.

## [1.16.0]

This release updates `cibuildwheel` to `v3.1`.
As a result, CPython 3.14 wheels are built by default.
As free-threading is no longer experimental, also free-threaded wheels are built.
When upgrading, ensure that the following conditions are met:

1. `pybind11` modules are marked with `py::mod_gil_not_used()`
2. `cibuildwheel` skips tests for `cp3*t-*` (because Qiskit does not support free threading)
3. `cibuildwheel` skips tests for `cp314-*` (because not all dependencies support Python 3.14 yet)

## [1.15.0]

The `reusable-qiskit-upstream.yml` workflow has been renamed to `reusable-qiskit-upstream-tests.yml` to align with the added `reusable-qiskit-upstream-issue.yml` workflow.
The added workflow can be used to create an issue if the Qiskit upstream tests have failed.

## [1.14.0]

This release overwrites some of the changes released with [1.13.0].

The `reusable-cpp-ci.yml` workflow has been removed.
Instead, the `reusable-cpp-tests-ubuntu.yml`, `reusable-cpp-tests-macos.yml`, and `reusable-cpp-tests-windows.yml` workflows should be used directly.
A matrix strategy can be defined in the workflow calling the respective test workflows.

Similarly, `reusable-python-ci.yml` workflow has been removed.
The `reusable-python-tests.yml` and `reusable-python-coverage.yml` workflows can be used instead.

Finally, the `reusable-python-packaging.yml` workflow has been split into `reusable-python-packaging-sdist.yml`, `reusable-python-packaging-wheel-build.yml`, and `reusable-python-packaging-wheel-cibuildwheel.yml`.

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

[unreleased]: https://github.com/munich-quantum-toolkit/workflows/compare/v2.0.3...HEAD
[2.0.3]: https://github.com/munich-quantum-toolkit/workflows/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/munich-quantum-toolkit/workflows/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/munich-quantum-toolkit/workflows/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.18.1...v2.0.0
[1.18.1]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.18.0...v1.18.1
[1.18.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.15...v1.18.0
[1.17.15]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.11...v1.17.15
[1.17.11]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.6...v1.17.11
[1.17.6]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.5...v1.17.6
[1.17.5]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.3...v1.17.5
[1.17.3]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.17.0...v1.17.3
[1.17.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.16.0...v1.17.0
[1.16.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.15.0...v1.16.0
[1.15.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.14.0...v1.15.0
[1.14.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.13.0...v1.14.0
[1.13.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.12.0...v1.13.0
[1.12.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.11.0...v1.12.0
[1.11.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/munich-quantum-toolkit/workflows/compare/v1.8.1...v1.9.0

<!-- General links -->

[actions/download-artifact]: https://github.com/actions/download-artifact
[actions/upload-artifact]: https://github.com/actions/upload-artifact
[portable-mlir-toolchain]: https://github.com/munich-quantum-software/portable-mlir-toolchain
[setup-mlir]: https://github.com/munich-quantum-software/setup-mlir
[zizmor]: https://docs.zizmor.sh/
[CMake presets]: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html
