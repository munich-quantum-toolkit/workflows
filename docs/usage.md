# Using the MQT workflows

## Documentation

The change detector returns `run-docs` alongside its test and lint outputs. Use
it to condition a job calling
[`reusable-docs.yml`](../.github/workflows/reusable-docs.yml) and include that
job in the aggregate CI check. Grant the caller read access to actions, contents
and pull requests. The build runs `uvx nox --non-interactive -s docs` and
expects `docs/_build/html/index.html`. Projects can request APT packages such as
Doxygen.

PR builds use a shallow checkout with a local `v0.0.0.dev<PR number>` tag for
SCM-based versioning. Main and release builds use the repository's Git history.

Call the same workflow from a default-branch `workflow_run` listener for
completed builds. Grant it the same read permissions and pass
`READTHEDOCS_TOKEN` and the Read the Docs `project-slug`. The publisher checks
the current PR, branch or tag before uploading the HTML and offline ZIP. It
publishes PR previews under their number, the default branch as `latest`, and
tags under their own names. The highest `vMAJOR.MINOR.PATCH` tag also updates
`stable`. Set `build-workflows` when the source workflow paths differ from the
default `.github/workflows/ci.yml`. See the
[direct upload guide](https://docs.readthedocs.com/platform/stable/guides/build/direct-upload.html).

## C++ Installation Tests

[`reusable-cpp-install-tests.yml`](../.github/workflows/reusable-cpp-install-tests.yml)
runs the caller's `test/install.cmake` script. The script owns the project's
build, installation, relocation and consumer checks; the workflow supplies
Windows long-path support, optional Linux dependencies and compiler caching.

```yaml
cpp-install-tests:
  strategy:
    matrix:
      runs-on: [ubuntu-26.04, macos-26, windows-2025]
  uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-cpp-install-tests.yml@main
  with:
    runs-on: ${{ matrix.runs-on }}
    apt-packages: libssl-dev zlib1g-dev
```

Set `use-sccache-gha: false` to disable the workflow's compiler-cache setup.

## Upstream Failure Issues

[`reusable-upstream-issue.yml`](../.github/workflows/reusable-upstream-issue.yml)
creates or updates a project-specific issue when upstream checks fail on `main`.
Pass `tests-result`, the project `name`, and `upstream-repository` as
`owner/repository`, and grant `issues: write` to the calling job.
`reusable-qiskit-upstream-issue.yml` supplies the Qiskit inputs for existing
callers.

## Passing Project-Specific Secrets to Reusable Workflows

Most reusable build, test, lint, and packaging workflows expose a fixed
whitelist of inherited secrets as environment variables. In the calling
workflow, use `secrets: inherit` and define the corresponding repository or
environment secrets with the same names.

Secret inheritance is limited to callers in the same organization or enterprise.
Cross-organization callers of `reusable-python-packaging-wheel-cibuildwheel.yml`
can instead pass the AWS secrets explicitly:

```yaml
secrets:
  AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

The currently supported variables are

- `IQM_TOKEN`,
- `IQM_QC_ALIAS`,
- `AWS_S3_BUCKET`,
- `AWS_ACCESS_KEY_ID`, and
- `AWS_SECRET_ACCESS_KEY`.

If one of these secrets is not defined by the calling repository or environment,
GitHub Actions leaves the corresponding environment variable empty.
