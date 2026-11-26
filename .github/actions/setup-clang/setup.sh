#!/usr/bin/env bash
# Copyright (c) 2023 - 2026 Chair for Design Automation, TUM
# Copyright (c) 2025 - 2026 Munich Quantum Software Company GmbH
# All rights reserved.
#
# SPDX-License-Identifier: MIT
#
# Licensed under the MIT License

set -euo pipefail

version=${CLANG_VERSION#clang-}
if [[ ! $version =~ ^[0-9]+$ ]]; then
  echo "Expected a Clang major version, got '$CLANG_VERSION'" >&2
  exit 1
fi

packages=()
if ! command -v "clang-$version" > /dev/null || ! command -v "clang++-$version" > /dev/null; then
  packages+=("clang-$version")
fi
# clang-scan-deps is supplied by clang-tools.
if ! command -v "clang-scan-deps-$version" > /dev/null; then
  packages+=("clang-tools-$version")
fi
if [[ $INSTALL_LINT_TOOLS == true ]]; then
  for tool in clang-format clang-tidy; do
    if ! command -v "$tool-$version" > /dev/null; then
      packages+=("$tool-$version")
    fi
  done
fi

if (( ${#packages[@]} )); then
  sudo apt-get update
  if ! apt-get --simulate install "${packages[@]}" > /dev/null 2>&1; then
    # Ubuntu does not package every LLVM release for every runner image.
    codename=$(lsb_release -cs)
    curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key -o "$RUNNER_TEMP/llvm.asc"
    sudo install -m 0644 "$RUNNER_TEMP/llvm.asc" /etc/apt/keyrings/apt.llvm.org.asc
    echo "deb [signed-by=/etc/apt/keyrings/apt.llvm.org.asc] https://apt.llvm.org/$codename/ llvm-toolchain-$codename-$version main" |
      sudo tee /etc/apt/sources.list.d/mqt-llvm.list > /dev/null
    sudo apt-get update
  fi
  sudo apt-get install -y --no-install-recommends -- "${packages[@]}"
fi

echo "CC=clang-$version" >> "$GITHUB_ENV"
echo "CXX=clang++-$version" >> "$GITHUB_ENV"
