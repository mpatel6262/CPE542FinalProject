`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 02:49:04 PM
// Design Name: 
// Module Name: Processing_Vector
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


module Processing_Vector#(parameter PE_COUNT=8)(
    input clk,
    input [PE_COUNT-1:0] active,
    input length,

    input [PE_COUNT-1:0][31:0] left_datas,
    input [PE_COUNT-1:0][31:0] right_datas,

    input [PE_COUNT-1:0] read_from_output,

    output [PE_COUNT-1:0] out_empty,
    output [PE_COUNT-1:0][31:0] out

    );

    genvar elements;
    generate for (elements = 0; elements < PE_COUNT; elements = elements + 1) begin

        ProcessingElementMod #(16) ProcElem(
            clk,                        //clock
            active[element],            //read in data
            length,                     //vector length
            left_datas[element],        //lefthand data
            right_datas[element],       //righthand data
            read_from_output[element],  //read from output buffer
            out_empty[element],         //output buffer is empty
            out[element]                //output from buffer
        );

    end
    endgenerate

    //planter


    //harvester


    ProcessingElementMod #(16) ProcElem_1(
        clk,        //clock
        active,     //read in data
        1,          //read in length
        4,          //vector length
        data1,      //lefthand data
        data2,      //righthand data
        1,          //read from output buffer
        out_empty,  //output buffer is empty
        out         //output from buffer
    );
endmodule
