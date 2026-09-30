#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
uvm_dir="${UVM_HOME:-$project_dir/.deps/uvm}"
seed="${1:-1}"
[[ "$seed" =~ ^[0-9]+$ ]] || { echo "Seed must be a non-negative integer" >&2; exit 2; }
[[ -f "$uvm_dir/src/uvm_pkg.sv" ]] || { echo "UVM library missing: $uvm_dir" >&2; exit 2; }
mkdir -p "$project_dir/results"
verilator --binary --timing --assert --vpi -Wno-fatal -j "${JOBS:-4}" \
  --top-module top --Mdir "$project_dir/build" \
  +incdir+"$uvm_dir/src" \
  "$uvm_dir/src/uvm_pkg.sv" \
  "$project_dir/tb/mem_if.sv" "$project_dir/rtl/sync_memory.sv" \
  "$project_dir/tb/mem_pkg.sv" "$project_dir/tb/top.sv" \
  "$uvm_dir/src/dpi/uvm_dpi.cc" \
  > "$project_dir/results/build.log" 2>&1 || { tail -80 "$project_dir/results/build.log"; exit 1; }
bash "$project_dir/scripts/run_seed.sh" "$seed"
