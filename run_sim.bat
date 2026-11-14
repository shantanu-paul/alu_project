@echo off
echo =====================================================================
echo  Running SystemVerilog ALU Simulation in AMD/Xilinx Vivado Simulator
echo =====================================================================

REM Step 1: Compile SystemVerilog Files from src/ and tb/
call xvlog -sv src\alu.sv tb\alu_tb.sv
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] xvlog compilation failed.
    exit /b %ERRORLEVEL%
)

REM Step 2: Elaborate Design Snapshot
call xelab -debug typical alu_tb -s alu_sim
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] xelab elaboration failed.
    exit /b %ERRORLEVEL%
)

REM Step 3: Run Simulation
call xsim alu_sim -R
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] xsim execution failed.
    exit /b %ERRORLEVEL%
)

echo Simulation finished successfully!
