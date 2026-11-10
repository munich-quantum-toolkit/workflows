![OS](https://img.shields.io/badge/os-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

<p align="center">
  <a href="https://mqt.readthedocs.io">
   <picture>
     <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/logo-mqt-dark.svg" width="60%">
     <img src="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/logo-mqt-light.svg" width="60%" alt="MQT Logo">
   </picture>
  </a>
</p>

# Reusable GitHub Workflows of the Munich Quantum Toolkit (MQT)

This repository hosts the reusable GitHub workflows of the
[_Munich Quantum Toolkit (MQT)_](https://mqt.readthedocs.io).

## Key Features

This repository provides reusable GitHub workflows for the MQT, which can be
used in other repositories to automate various tasks such as:

- Change detection for selective workflow execution.
- Executable documentation builds and Read the Docs artifact publication.
- C++ testing, linting, and coverage reporting.
- Python testing (including coverage reporting), linting, and packaging.
- Dependabot-like updates for MQT Core.
- Upstream testing against Qiskit.

Overall, these enable modern CI/CD for

- C++ projects,
- Python projects with compiled extensions, as well as
- pure Python packages.

If you have any questions, feel free to create a
[discussion](https://github.com/munich-quantum-toolkit/workflows/discussions) or
an [issue](https://github.com/munich-quantum-toolkit/workflows/issues) on
[GitHub](https://github.com/munich-quantum-toolkit/workflows).

## Upstream Failure Issues

[`reusable-upstream-issue.yml`](.github/workflows/reusable-upstream-issue.yml)
creates or updates a project-specific issue when upstream checks fail on `main`.
Pass `tests-result`, the project `name`, and `upstream-repository` as
`owner/repository`, and grant `issues: write` to the calling job.
`reusable-qiskit-upstream-issue.yml` supplies the Qiskit inputs for existing
callers.

## Documentation

[`reusable-docs.yml`](.github/workflows/reusable-docs.yml) runs
`uvx nox --non-interactive -s docs` on Linux. The caller's session owns notebook
execution and documentation checks, and must write HTML to `docs/_build/html`.
The workflow uses sccache and supports `python-version`, `apt-packages`,
`setup-mlir`, and `llvm-version` inputs. Build jobs need only `contents: read`;
do not pass upload credentials to them.

Enable `enable-docs: true` in `reusable-change-detection.yml`, condition the
docs job on its `run-docs` output, and include the job in the existing aggregate
check and its allowed skips. Documentation detection compares both sides of
renames without an API file-count limit. By default, tests, agent files, paper
sources, and issue/PR templates are excluded. Override `docs-ignore-paths` with
newline-separated **Git pathspecs** if those directories supply documentation
inputs; an empty value checks every path. Non-PR events always build.

```yaml
  docs:
    needs: change-detection
    if: fromJSON(needs.change-detection.outputs.run-docs)
    uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-docs.yml@v2
    with:
      apt-packages: doxygen
    permissions:
      contents: read
```

[`reusable-docs-publish.yml`](.github/workflows/reusable-docs-publish.yml)
publishes HTML and an offline ZIP to a Read the Docs project with
[direct upload](https://docs.readthedocs.com/platform/stable/guides/build/direct-upload.html)
enabled. Call it from a separate `workflow_run` workflow on the default branch:

```yaml
name: Publish documentation
on:
  workflow_run:
    workflows: [CI]
    types: [completed]
permissions: {}
jobs:
  publish:
    uses: munich-quantum-toolkit/workflows/.github/workflows/reusable-docs-publish.yml@v2
    with:
      project-slug: my-project
    secrets:
      READTHEDOCS_TOKEN: ${{ secrets.READTHEDOCS_TOKEN }}
    permissions:
      actions: read
      contents: read
      pull-requests: read
```

The publisher accepts artifacts from `.github/workflows/ci.yml` by default;
`build-workflows` can list other trusted caller paths, separated by whitespace.
It publishes current open PR heads, the default branch, and `v*` tags. It skips
missing artifacts and superseded commits, and never executes downloaded code.
Publication waits for the entire caller workflow to finish, but failures in
unrelated jobs do not discard successful docs artifacts. Keep docs validation in
the aggregate check and use `exit 183` in RtD's `post_checkout` job to avoid
compiling the same documentation there.

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

## Contributors and Supporters

The _[Munich Quantum Toolkit (MQT)](https://mqt.readthedocs.io)_ is developed by
the [Chair for Design Automation](https://www.cda.cit.tum.de/) at the
[Technical University of Munich](https://www.tum.de/) and supported by
[MQSC](https://mq.sc). Among others, it is part of the
[Munich Quantum Software Stack (MQSS)](https://www.munich-quantum-valley.de/research/research-areas/mqss)
ecosystem, which is being developed as part of the
[Munich Quantum Valley (MQV)](https://www.munich-quantum-valley.de) initiative.

<p align="center">
  <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/mqt-logo-banner-dark.svg" width="90%">
   <img src="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/mqt-logo-banner-light.svg" width="90%" alt="MQT Partner Logos">
  </picture>
</p>

Thank you to all the contributors who have helped make the MQT Workflows a
reality and keep them up-to-date!

<p align="center">
<a href="https://github.com/munich-quantum-toolkit/workflows/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=munich-quantum-toolkit/workflows" />
</a>
</p>

## Acknowledgements

The Munich Quantum Toolkit has been supported by the European Research Council
(ERC) under the European Union's Horizon 2020 research and innovation program
(grant agreement No. 101001318), the Bavarian State Ministry for Science and
Arts through the Distinguished Professorship Program, as well as the Munich
Quantum Valley, which is supported by the Bavarian state government with funds
from the Hightech Agenda Bayern Plus.

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/mqt-funding-footer-dark.svg" width="90%">
    <img src="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/mqt-funding-footer-light.svg" width="90%" alt="MQT Funding Footer">
  </picture>
</p>
