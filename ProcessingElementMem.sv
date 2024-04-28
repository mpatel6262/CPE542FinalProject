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


module ProcessingElementMem(
    input clk,
    input active,
    input vec_fin,
    input [31:0] length,
    input [31:0] left_in,
    input [31:0] right_in,
    
    output step_fin,
    output [31:0] result
    
    );

    logic [31:0]  mult_out = 0, reg_out = 0, counter = 0;

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


                                        
    /*
    always @(posedge clk) begin
        
        if(active) begin
            counter <= counter+1;

            if(count >= length) begin
                counter <= 0;
                vec_fin <= 1;
            end
        end

    end
*/
endmodule