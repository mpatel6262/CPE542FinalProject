`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 02:55:22 PM
// Design Name: 
// Module Name: ProcessingElementMod
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


module ProcessingElementMem#(parameter RAM_SIZE)(
    input clk,
    input active,
    input vec_fin,

    input [31:0] left_addr,
    input [31:0] right_addr,
    input [31:0] result_addr,

    ref logic [31:0] RAM [RAM_SIZE],
    
    output step_fin
    );

    logic [31:0]  mult_out = 0, reg_out = 0, counter = 0, left_in, right_in;

    assign left_in = RAM[left_addr];
    assign right_int = RAM[right_addr];

    /*This variable will always be high for single cycle mutliplication.
    for future work, it will be important to facilitate multicycle calculations
    e.g. floating point multiplication. */
    assign step_fin = 1;

    Multiplier mult(
        left_in, 
        right_in, 
        mult_out
    );

    Adder add(
        reg_out,
        mult_out, 
        result
    );

    Register PE_reg(
        clk, 
        result, 
        vec_fin, 
        0, 
        reg_out
    );
                                
    
    always @(posedge clk) begin
        
        if(vec_fin) begin
            RAM[result_addr] <= result;
        end

    end

endmodule