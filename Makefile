# ==============================================================================
# Makefile: SystemVerilog ALU (Vivado Simulator)
# ==============================================================================

SHELL    = cmd.exe
SRC      = src/alu.sv
TB       = tb/alu_tb.sv
TOP      = alu_tb
SNAPSHOT = alu_sim

.PHONY: all compile elaborate run syn clean

# Default target: Run simulation
all: run

# Step 1: Compile SystemVerilog RTL and testbench
compile:
	xvlog -sv $(SRC) $(TB)

# Step 2: Elaborate design snapshot
elaborate: compile
	xelab -debug typical $(TOP) -s $(SNAPSHOT)

# Step 3: Run simulation in batch mode
run: elaborate
	xsim $(SNAPSHOT) -R

# Step 4: Run complete Vivado Synthesis, Place & Route, and STA
syn:
	vivado -mode batch -source scripts/run_pnr.tcl -nojournal -nolog

# Clean simulation outputs and temporary files
clean:
	-if exist xsim.dir rmdir /s /q xsim.dir
	-del /f /q *.log *.pb *.jou *.wdb *.vcd 2>nul
