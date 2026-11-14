# ==============================================================================
# Vivado Non-Project Batch Script: Synthesis to Place & Route
# Target: AMD/Xilinx Artix-7 (xc7a35tcpg236-1)
# Module: 8-Bit Parameterized ALU (alu.sv)
# ==============================================================================

# 1. Configuration & Directories
set PART "xc7a35tcpg236-1"
set TOP  "alu"
set REPORTS_DIR "reports"
set CHECKPOINTS_DIR "checkpoints"

file mkdir $REPORTS_DIR
file mkdir $CHECKPOINTS_DIR

puts "\n======================================================="
puts " (STEP 1/5) Reading RTL and Timing Constraints"
puts "=======================================================\n"

read_verilog -sv src/alu.sv
read_xdc constraints/alu.xdc

puts "\n======================================================="
puts " (STEP 2/5) Synthesizing RTL to Gate-Level Netlist"
puts "=======================================================\n"

synth_design -top $TOP -part $PART
write_checkpoint -force $CHECKPOINTS_DIR/alu_synth.dcp

# Generate Post-Synthesis Reports
report_utilization -file $REPORTS_DIR/utilization_synth.rpt
report_timing_summary -file $REPORTS_DIR/timing_synth.rpt

puts "\n======================================================="
puts " (STEP 3/5) Logic Optimization & Placement"
puts "=======================================================\n"

opt_design
place_design
write_checkpoint -force $CHECKPOINTS_DIR/alu_placed.dcp

puts "\n======================================================="
puts " (STEP 4/5) Physical Optimization & Detailed Routing"
puts "=======================================================\n"

phys_opt_design
route_design
write_checkpoint -force $CHECKPOINTS_DIR/alu_routed.dcp

puts "\n======================================================="
puts " (STEP 5/5) Generating Post-Route Physical Reports"
puts "=======================================================\n"

# 1. Post-route resource utilization
report_utilization -file $REPORTS_DIR/utilization_route.rpt

# 2. Comprehensive STA timing summary (WNS, TNS, WHS, THS)
report_timing_summary -delay_type min_max -max_paths 10 -file $REPORTS_DIR/timing_summary_route.rpt

# 3. Critical Path Details
report_timing -nworst 1 -max_paths 1 -file $REPORTS_DIR/critical_path.rpt

# 4. Route Status & DRC
report_route_status -file $REPORTS_DIR/route_status.rpt
report_drc -file $REPORTS_DIR/drc.rpt

# 5. Power Estimation
report_power -file $REPORTS_DIR/power.rpt

puts "\n======================================================="
puts " Flow Completed Successfully! Reports generated in $REPORTS_DIR/"
puts "=======================================================\n"

exit
