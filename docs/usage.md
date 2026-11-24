# Using the MQT workflows

## General guidance

### Project-specific secrets

Some build, test, lint, and packaging workflows expose provider secrets as
environment variables. Use `secrets: inherit` in the calling workflow and define
the supported secrets in the calling repository or environment:

- `IQM_TOKEN`
- `IQM_QC_ALIAS`
- `AWS_S3_BUCKET`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Secrets that are not defined have empty values. Inheritance is limited to
callers in the same organization or enterprise. Cross-organization callers can
pass individual secrets when the workflow declares them explicitly.

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

[`reusable-github-release.yml`](../.github/workflows/reusable-github-release.yml)
publishes C++ `.tar.gz` archives from the current run's artifacts, with
`SHA256SUMS`, a link to the tagged changelog and optional new-contributor notes.
It uploads the archives to a draft before publishing. Retries resume drafts and
leave published releases unchanged.

Call it after the build and approval jobs. Pass the stable version without `v`,
the release title, and GitHub App credentials with write access to repository
contents and workflows. The default artifact pattern is `cpp-sdk-*`; set
`artifacts-pattern` to use another name.

```yaml
publish-github:
  needs: [check-release, approve-release]
  permissions:
    contents: write
  uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-github-release.yml@<commit-sha>
  with:
    version: ${{ needs.check-release.outputs.version }}
    release-name: My project ${{ needs.check-release.outputs.version }} Release
  secrets:
    APP_ID: ${{ secrets.APP_ID }}
    APP_PRIVATE_KEY: ${{ secrets.APP_PRIVATE_KEY }}
```

Keep PyPI trusted publishing in a separate job in the calling workflow.
Serialize release runs in the caller so publications cannot overlap.

### [`reusable-python-packaging-wheel-cibuildwheel.yml`](../.github/workflows/reusable-python-packaging-wheel-cibuildwheel.yml)

Cross-organization callers can pass AWS secrets explicitly:

```yaml
secrets:
  AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

[direct upload guide]: https://docs.readthedocs.com/platform/stable/guides/build/direct-upload.html
