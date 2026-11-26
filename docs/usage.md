# Using the MQT workflows

## Reusable workflows

### [`reusable-cpp-install-tests.yml`](../.github/workflows/reusable-cpp-install-tests.yml)

Runs `cmake -P test/install.cmake` from the repository root. Provide a script
that:

1. Configures and builds the project using the workflow's compiler and generator
   settings.
2. Installs it to a temporary directory and relocates that installation.
3. Builds and runs a separate consumer using the installed headers and exported
   CMake targets, without relying on the source or build tree.

The checks must run offline and propagate build and test failures as script
errors.

### [`reusable-cpp-packaging.yml`](../.github/workflows/reusable-cpp-packaging.yml)

Packages wheel artifacts as standalone C++ archives, tests them after
relocation, and uploads `cpp-archives-<runner>`.

The wheel artifact must contain one project's wheels for that platform. When
multiple Python variants are available, the first non-musllinux wheel in
lexicographic filename order supplies the C++ installation. That installation
must be independent of the Python variant.

Provide `.github/cpp-packaging.json` in the calling repository:

```json
{
  "package": "my-library",
  "install-prefix": "my/package"
}
```

`package` names the exported CMake package. `install-prefix` is its directory
inside the wheel. Archive names use the wheel's platform tag.

Only the CMake installation directories (`bin`, `include`, `lib`, `lib64`, and
`share`) are included, leaving out Python modules and bindings. Shared libraries
must use relocatable runtime search paths.

The caller's `test/install.cmake` must also accept `-Dinstalled_prefix=<path>`
to test an existing installation without rebuilding the package. Wheels must
include headers, CMake package files, and license notices.

### [`reusable-docs.yml`](../.github/workflows/reusable-docs.yml)

Builds documentation with `uvx nox --non-interactive -s docs`. The session must
produce `docs/_build/html/index.html`. Use the change detector's `run-docs`
output to condition the job and include it in the aggregate CI check.

For Read the Docs publication, call the workflow from a default-branch
`workflow_run` listener for completed builds. Provide a Read the Docs token and
project slug. PR previews use the PR number, the default branch publishes as
`latest`, and tags publish under their own names. The highest stable version
also updates `stable`. See the [direct upload guide].

### [`reusable-github-release.yml`](../.github/workflows/reusable-github-release.yml)

Publishes a GitHub release with links to the project's changelog and optional
upgrade guide, or with GitHub's full generated release notes. New-contributor
notes are included when available. It attaches any `cpp-archives-*` artifacts
with checksums.

Call it after the build and approval jobs. Publication uses the calling
repository's `GITHUB_TOKEN`. Supply `RELEASE_TOKEN` when GitHub requires
workflow-write permission for the release target or release events must trigger
other workflows. Published releases are left unchanged when a workflow is
retried.

[direct upload guide]: https://docs.readthedocs.com/platform/stable/guides/build/direct-upload.html
