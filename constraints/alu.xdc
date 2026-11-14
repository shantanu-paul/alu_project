# ==============================================================================
# Timing Constraints: 8-Bit Parameterized ALU
# Target Device: AMD/Xilinx Artix-7 (xc7a35tcpg236-1)
# ==============================================================================

# 1. Virtual Clock Definition
# The ALU module is purely combinational (no internal clock pin).
# To enable Static Timing Analysis (STA), we define a virtual reference clock
# representing the driving and receiving registers in the enclosing SoC/CPU.
# Target Frequency: 100 MHz (Period: 10.000 ns)
create_clock -name vclk -period 10.000

# 2. Input Arrival Delays
# Models the external clock-to-output (T_co) + board routing delay of upstream logic.
# Budgeted external delay: 2.000 ns
set_input_delay -clock vclk 2.000 [get_ports {sel[*] A[*] B[*]}]

# 3. Output Required Delays
# Models the external setup time (T_setup) + board routing delay of downstream logic.
# Budgeted external delay: 2.000 ns
set_output_delay -clock vclk 2.000 [get_ports {out[*]}]

# Timing Budget for ALU internal combinational delay (T_comb):
# T_comb_max = Clock Period (10.000 ns) - Input Delay (2.000 ns) - Output Delay (2.000 ns) = 6.000 ns
