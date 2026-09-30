#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
dep_dir="$project_dir/.deps/uvm"
revision=5d72b6618acfddece7f09382a032ccbc05862fdc
if [[ -e "$dep_dir" ]]; then
  echo "Dependency directory already exists: $dep_dir. Use UVM_HOME or inspect it; no overwrite." >&2
  exit 2
fi
mkdir -p "$project_dir/.deps"
git clone https://github.com/chipsalliance/uvm-verilator.git "$dep_dir"
git -C "$dep_dir" checkout --detach "$revision"
echo "UVM installed at $dep_dir (revision $revision)"
