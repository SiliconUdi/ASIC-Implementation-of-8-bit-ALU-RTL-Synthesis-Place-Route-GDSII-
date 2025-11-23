`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//SUB MODULES FOR EACH OPERATION

module alu_add(input [7:0]a,b, output [7:0] result);
    assign result = a + b;
endmodule

module alu_sub(input [7:0]a,b, output [7:0] result);
    assign result = a - b;
endmodule

module alu_mul(input [7:0]a,b, output [7:0] result);
    assign result = a * b;                          //// 8-bit multiplication (will truncate higher bits)
endmodule

module alu_rshift(input [7:0] a, input [2:0] shamt, output [7:0] result);
    assign result = a >> shamt;
endmodule

module alu_lshift(input [7:0] a, input [2:0] shamt, output [7:0] result);
    assign result = a << shamt;
endmodule

module alu_pow(input [7:0] a, input [7:0] b, output reg [7:0] result);
    integer i;
    always @(*) begin
        result = 1;
        for(i = 0; i < b; i = i + 1)
            result = result * a;     // exponentiation: a^b
    end
endmodule

module alu_and(input [7:0] a, b, output [7:0] result);
    assign result = a & b;
endmodule

module alu_or(input [7:0] a, b, output [7:0] result);
    assign result = a | b;
endmodule


// ----------------------------------------------------------
// Combinational ALU core (no clock)
// ----------------------------------------------------------
module alu_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] opcode,
    output reg [7:0] result
);

    wire [7:0] add_r, sub_r, mul_r, rshift_r, lshift_r, pow_r, and_r, or_r;

    // Instantiate all submodules
    alu_add    u_add(a, b, add_r);
    alu_sub    u_sub(a, b, sub_r);
    alu_mul    u_mul(a, b, mul_r);
    alu_rshift u_rshift(a, b[2:0], rshift_r);
    alu_lshift u_lshift(a, b[2:0], lshift_r);
    alu_pow    u_pow(a, b, pow_r);
    alu_and    u_and(a, b, and_r);
    alu_or     u_or(a, b, or_r);

    // Operation select
    always @(*) begin
        case(opcode)
            3'b000: result = add_r;
            3'b001: result = sub_r;
            3'b010: result = mul_r;
            3'b011: result = rshift_r;
            3'b100: result = lshift_r;
            3'b101: result = pow_r;
            3'b110: result = and_r;
            3'b111: result = or_r;
           // default: result = 8'b0;
        endcase
    end

endmodule


// ----------------------------------------------------------
// Sequential ALU wrapper (adds clocked output register)
// ----------------------------------------------------------
module alu_8bit_seq(
    input        clk,
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] opcode,
    output reg [7:0] result
);

    wire [7:0] alu_out;

    // Instantiate the combinational ALU
    alu_8bit u_alu (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(alu_out)
    );

    // Register the output (for RTL-to-GDS flow)
    always @(posedge clk) begin
        result <= alu_out;
    end

endmodule
