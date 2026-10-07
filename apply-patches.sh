#!/bin/bash
# Applies the platform patches to a synced source tree.
# patches/<project path with "/" replaced by "_">.patch is applied to that project.
# Usage: ./apply-patches.sh <source tree>
set -e
top="${1:?usage: $0 <source tree>}"
here="$(cd "$(dirname "$0")" && pwd)"
for p in "$here"/patches/*.patch; do
  project="$(basename "$p" .patch | tr _ /)"
  echo "== $project"
  git -C "$top/$project" apply "$p"
done
