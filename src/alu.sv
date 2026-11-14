`timescale 1ns / 1ps

module alu #(
    parameter int WIDTH = 8
)(
    input  logic [3:0]         sel,
    input  logic [WIDTH-1:0]   A,
    input  logic [WIDTH-1:0]   B,
    output logic [WIDTH-1:0]   out
);

    typedef enum logic [3:0] {
        OP_ADD  = 4'b0000, // 0: A + B
        OP_SUB  = 4'b0001, // 1: A - B
        OP_MUL  = 4'b0010, // 2: A * B
        OP_DIV  = 4'b0011, // 3: A / B (Div-by-zero protected)
        OP_LSL  = 4'b0100, // 4: A << 1
        OP_LSR  = 4'b0101, // 5: A >> 1
        OP_ROL  = 4'b0110, // 6: {A[6:0], A[7]}
        OP_ROR  = 4'b0111, // 7: {A[0], A[7:1]}
        OP_AND  = 4'b1000, // 8: A & B
        OP_OR   = 4'b1001, // 9: A | B
        OP_XOR  = 4'b1010, // 10: A ^ B
        OP_NOR  = 4'b1011, // 11: ~(A | B)
        OP_NAND = 4'b1100, // 12: ~(A & B)
        OP_XNOR = 4'b1101, // 13: ~(A ^ B)
        OP_GT   = 4'b1110, // 14: (A > B) ? 1 : 0
        OP_EQ   = 4'b1111  // 15: (A == B) ? 1 : 0
    } alu_op_e;

    always_comb begin
        unique case (sel)
            OP_ADD : out = A + B;
            OP_SUB : out = A - B;
            OP_MUL : out = A * B;
            OP_DIV : begin
                if (B != '0)
                    out = A / B;
                else
                    out = '0;
            end
            OP_LSL : out = A << 1;
            OP_LSR : out = A >> 1;
            OP_ROL : out = {A[WIDTH-2:0], A[WIDTH-1]};
            OP_ROR : out = {A[0], A[WIDTH-1:1]};
            OP_AND : out = A & B;
            OP_OR  : out = A | B;
            OP_XOR : out = A ^ B;
            OP_NOR : out = ~(A | B);
            OP_NAND: out = ~(A & B);
            OP_XNOR: out = ~(A ^ B);
            OP_GT  : out = (A > B) ? {{(WIDTH-1){1'b0}}, 1'b1} : '0;
            OP_EQ  : out = (A == B) ? {{(WIDTH-1){1'b0}}, 1'b1} : '0;
            default: out = '0;
        endcase
    end

endmodule
