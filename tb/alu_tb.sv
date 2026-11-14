`timescale 1ns/1ps

module alu_tb;

    localparam WIDTH = 8;

    logic [3:0] sel;
    logic [WIDTH-1:0] A, B;
    logic [WIDTH-1:0] out;

    integer total = 0;
    integer passed = 0;
    integer failed = 0;

    // ALU operation codes
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam MUL  = 4'b0010;
    localparam DIV  = 4'b0011;
    localparam LSL  = 4'b0100;
    localparam LSR  = 4'b0101;
    localparam ROL  = 4'b0110;
    localparam ROR  = 4'b0111;
    localparam AND_ = 4'b1000;
    localparam OR_  = 4'b1001;
    localparam XOR_ = 4'b1010;
    localparam NOR_ = 4'b1011;
    localparam NAND_= 4'b1100;
    localparam XNOR_= 4'b1101;
    localparam GT   = 4'b1110;
    localparam EQ   = 4'b1111;

    // DUT
    alu #(.WIDTH(WIDTH)) dut (
        .sel(sel),
        .A(A),
        .B(B),
        .out(out)
    );

    // Check ALU output
    task automatic run_check(
        input logic [3:0] op,
        input logic [7:0] a,
        input logic [7:0] b,
        input logic [7:0] expected
    );
        begin
            sel = op;
            A = a;
            B = b;

            #10;
            total = total + 1;

            if (out === expected) begin
                $display("PASS | sel=%b | A=%d | B=%d | Out=%d",
                         sel, A, B, out);
                passed = passed + 1;
            end
            else begin
                $display("FAIL | sel=%b | A=%d | B=%d | Got=%d | Expected=%d",
                         sel, A, B, out, expected);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("alu_sim.vcd");
        $dumpvars(0, alu_tb);

        $display("\nALU TESTBENCH STARTED");

        // Test 1: A=10, B=5
        $display("\n--- Test 1: A=10, B=5 ---");

        run_check(ADD,  10, 5, 15);
        run_check(SUB,  10, 5, 5);
        run_check(MUL,  10, 5, 50);
        run_check(DIV,  10, 5, 2);
        run_check(LSL,  10, 5, 20);
        run_check(LSR,  10, 5, 5);
        run_check(ROL,  10, 5, 20);
        run_check(ROR,  10, 5, 5);
        run_check(AND_, 10, 5, 0);
        run_check(OR_,  10, 5, 15);
        run_check(XOR_, 10, 5, 15);
        run_check(NOR_, 10, 5, 240);
        run_check(NAND_,10, 5, 255);
        run_check(XNOR_,10, 5, 240);
        run_check(GT,   10, 5, 1);
        run_check(EQ,   10, 5, 0);

        // Test 2: A=5, B=10
        $display("\n--- Test 2: A=5, B=10 ---");

        run_check(ADD,  5, 10, 15);
        run_check(SUB,  5, 10, 251);
        run_check(MUL,  5, 10, 50);
        run_check(DIV,  5, 10, 0);
        run_check(LSL,  5, 10, 10);
        run_check(LSR,  5, 10, 2);
        run_check(ROL,  5, 10, 10);
        run_check(ROR,  5, 10, 130);
        run_check(AND_, 5, 10, 0);
        run_check(OR_,  5, 10, 15);
        run_check(XOR_, 5, 10, 15);
        run_check(NOR_, 5, 10, 240);
        run_check(NAND_,5, 10, 255);
        run_check(XNOR_,5, 10, 240);
        run_check(GT,   5, 10, 0);
        run_check(EQ,   5, 10, 0);

        // Test 3: Division edge cases
        $display("\n--- Test 3: Division Tests ---");

        run_check(DIV, 50, 0, 0);
        run_check(DIV, 0, 0, 0);
        run_check(DIV, 255, 0, 0);
        run_check(DIV, 0, 25, 0);
        run_check(DIV, 255, 1, 255);
        run_check(DIV, 255, 255, 1);

        // Test 4: Arithmetic overflow and underflow
        $display("\n--- Test 4: Arithmetic Tests ---");

        run_check(ADD, 250, 10, 4);
        run_check(ADD, 255, 1, 0);
        run_check(ADD, 255, 255, 254);
        run_check(SUB, 0, 1, 255);
        run_check(SUB, 0, 255, 1);
        run_check(SUB, 128, 128, 0);
        run_check(MUL, 16, 16, 0);
        run_check(MUL, 255, 255, 1);
        run_check(MUL, 255, 0, 0);

        // Test 5: Shift and rotate
        $display("\n--- Test 5: Shift and Rotate Tests ---");

        run_check(LSL, 8'h81, 0, 8'h02);
        run_check(ROL, 8'h81, 0, 8'h03);
        run_check(LSR, 8'h81, 0, 8'h40);
        run_check(ROR, 8'h81, 0, 8'hC0);
        run_check(LSL, 8'h80, 0, 8'h00);
        run_check(ROL, 8'h80, 0, 8'h01);
        run_check(LSR, 8'h01, 0, 8'h00);
        run_check(ROR, 8'h01, 0, 8'h80);

        // Test 6: Logic operations
        $display("\n--- Test 6: Logic Tests ---");

        run_check(AND_, 8'hAA, 8'h55, 8'h00);
        run_check(OR_,  8'hAA, 8'h55, 8'hFF);
        run_check(XOR_, 8'hAA, 8'h55, 8'hFF);
        run_check(NOR_, 8'hAA, 8'h55, 8'h00);
        run_check(NAND_,8'hAA, 8'h55, 8'hFF);
        run_check(XNOR_,8'hAA, 8'h55, 8'h00);
        run_check(XOR_, 8'hFF, 8'hFF, 8'h00);
        run_check(XNOR_,8'hFF, 8'hFF, 8'hFF);
        run_check(NAND_,8'hFF, 8'hFF, 8'h00);
        run_check(NOR_, 8'hFF, 8'hFF, 8'h00);

        // Test 7: Comparison
        $display("\n--- Test 7: Comparison Tests ---");

        run_check(GT, 128, 128, 0);
        run_check(EQ, 128, 128, 1);
        run_check(GT, 128, 127, 1);
        run_check(EQ, 128, 127, 0);
        run_check(GT, 127, 128, 0);
        run_check(EQ, 127, 128, 0);
        run_check(GT, 255, 0, 1);
        run_check(GT, 0, 255, 0);
        run_check(EQ, 0, 0, 1);
        run_check(EQ, 255, 255, 1);

        // Final results
        $display("\n==============================");
        $display("       TEST SUMMARY");
        $display("==============================");
        $display("Total Tests : %0d", total);
        $display("Passed      : %0d", passed);
        $display("Failed      : %0d", failed);

        if (failed == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: SOME TESTS FAILED");

        $display("==============================");

        $finish;
    end

endmodule
