`timescale 1ns/1ps

module alu_8bit_seq_tb;

    // Testbench signals
    reg clk;
    reg [7:0] a, b;
    reg [2:0] opcode;
    wire [7:0] result;

    // Instantiate DUT
    alu_8bit_seq DUT (
        .clk(clk),
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );

    // Clock generation 
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
       
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, alu_8bit_seq_tb);

        // Initialize inputs
        a = 0;
        b = 0;
        opcode = 0;

        // Wait one cycle
        @(posedge clk);

        // ----- TEST ALL 8 OPERATIONS -----

        // ADD
        a = 8'd10; b = 8'd5;  opcode = 3'b000;
        @(posedge clk);

        // SUB
        a = 8'd20; b = 8'd8;  opcode = 3'b001;
        @(posedge clk);

        // MUL
        a = 8'd6;  b = 8'd3;  opcode = 3'b010;
        @(posedge clk);

        // RIGHT SHIFT (a >> 1)
        a = 8'd16; b = 8'd1;  opcode = 3'b011;
        @(posedge clk);

        // LEFT SHIFT (a << 1)
        a = 8'd8;  b = 8'd1;  opcode = 3'b100;
        @(posedge clk);

        // POWER (a^b)
        a = 8'd3;  b = 8'd3;  opcode = 3'b101;
        @(posedge clk);

        // AND
        a = 8'd15; b = 8'd12; opcode = 3'b110;
        @(posedge clk);

        // OR
        a = 8'd10; b = 8'd7;  opcode = 3'b111;
        @(posedge clk);

        #50;
        $finish;
    end

endmodule
