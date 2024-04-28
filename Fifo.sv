`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2024 05:12:18 PM
// Design Name: 
// Module Name: Fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/*
reset is active high
*/
module Fifo#(parameter FIFO_DEPTH=16)(
    input clk,
    input reset,
    input write,
    input read,
    input[31:0] data_in,
    output logic[31:0] data_out,
    output full,
    output empty
    );

    logic [$clog2(FIFO_DEPTH)-1:0] w_ptr = 0;
    logic [$clog2(FIFO_DEPTH)-1:0] r_ptr = 0;

    logic [31:0] fifo[FIFO_DEPTH];

    always@(posedge clk) begin
        if(reset) begin
            w_ptr <= 0; 
            r_ptr <= 0;
            data_out <= 0;
        end
        
        if(write & !full) begin
            fifo[w_ptr] <= data_in;
            w_ptr <= w_ptr + 1;
        end

        if(read & !empty) begin
            data_out <= fifo[r_ptr];
            r_ptr <= r_ptr + 1;
        end
    end

    assign full = ((w_ptr+1'b1) == r_ptr);
    assign empty = (w_ptr == r_ptr);
endmodule
