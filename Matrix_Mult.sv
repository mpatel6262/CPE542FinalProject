`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 02:47:29 PM
// Design Name: 
// Module Name: Matrix_Mult
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


module Matrix_Mult#(parameter RAM_SIZE, PE_COUNT)(
    input clk,

    input [1:0] start_singal [PE_COUNT],

    input [31:0] M,
    input [31:0] N,
    input [31:0] P,

    input[31:0] left_offset,
    input[31:0] right_offset,
    input[31:0] result_offset,

    ref logic [31:0] RAM [RAM_SIZE]
    );

    

    genvar element;
    generate for (element = 0; element < PE_COUNT; element = element + 1) begin

        PE_wrapper #(PE_COUNT, element, RAM_SIZE) ProcElem(
            clk,                        //clock
            start_singal[element],      //read in data

            M,                          //matrix dimensions
            N,
            P,
                                 
            left_offset,                //data offsets in memory
            right_offset,       
            result_offset,  

            RAM                         //reference to the memory block
        );

    end
    endgenerate

endmodule
