`timescale 1ns / 1ps

module Multiplier(
    input [31:0] srcA,
    input [31:0] srcB,
    output [31:0] result
    );

    assign result = srcA * srcB;
endmodule