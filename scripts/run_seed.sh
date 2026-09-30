#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
seed="${1:-1}"
[[ "$seed" =~ ^[0-9]+$ ]] || { echo "Seed must be a non-negative integer" >&2; exit 2; }
mkdir -p "$project_dir/results"
[[ -x "$project_dir/build/Vtop" ]] || { echo 'Build first with: bash scripts/run.sh 1' >&2; exit 2; }
"$project_dir/build/Vtop" +verilator+seed+"$seed" +UVM_TESTNAME=mem_test \
  > "$project_dir/results/run_seed_${seed}.log" 2>&1 || { tail -60 "$project_dir/results/run_seed_${seed}.log"; exit 1; }
rg 'PASS:|UVM_ERROR :|UVM_FATAL :' "$project_dir/results/run_seed_${seed}.log"
rg -q 'UVM_ERROR :[[:space:]]+0' "$project_dir/results/run_seed_${seed}.log"
rg -q 'UVM_FATAL :[[:space:]]+0' "$project_dir/results/run_seed_${seed}.log"
rg -q 'PASS: writes=' "$project_dir/results/run_seed_${seed}.log"
