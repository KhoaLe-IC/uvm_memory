#!/usr/bin/env python3
"""Generate paste-ready EDA Playground sources from the project sources."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
out = root / "eda_playground"
out.mkdir(exist_ok=True)
(out / "design.sv").write_text((root / "rtl/sync_memory.sv").read_text())
files = ["tb/mem_if.sv", "tb/mem_pkg.sv", "tb/top.sv"]
(out / "testbench.sv").write_text("\n".join((root / f).read_text() for f in files))
print("Generated eda_playground/design.sv and testbench.sv")
