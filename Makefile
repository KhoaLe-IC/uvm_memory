SHELL := /bin/bash
SEED ?= 1
.PHONY: help setup run seed check export
export:
	python3 scripts/export_eda.py
help:
	@echo "make export            Refresh EDA Playground sources"
	@echo "make setup             Fetch pinned UVM dependency"
	@echo "make run SEED=1        Build and simulate"
	@echo "make seed SEED=42      Simulate existing binary"
	@echo "make check             Check shell syntax"
setup:
	bash scripts/setup_uvm.sh
run:
	bash scripts/run.sh $(SEED)
seed:
	bash scripts/run_seed.sh $(SEED)
check:
	bash -n scripts/setup_uvm.sh scripts/run.sh scripts/run_seed.sh
