@echo off
echo =====================================================================
echo  Running Vivado Synthesis, Placement, Routing and STA
echo =====================================================================

call vivado -mode batch -source scripts\run_pnr.tcl -nojournal -nolog
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Vivado Synthesis and PnR flow failed.
    exit /b %ERRORLEVEL%
)

echo =====================================================================
echo  Synthesis and Place ^& Route Completed! Reports are in reports\
echo =====================================================================
