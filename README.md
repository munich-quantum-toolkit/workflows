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

## Passing Project-Specific Secrets to Reusable Workflows

Most reusable build, test, lint, and packaging workflows expose a fixed
whitelist of inherited secrets as environment variables. In the calling
workflow, use `secrets: inherit` and define the corresponding repository or
environment secrets with the same names.

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
