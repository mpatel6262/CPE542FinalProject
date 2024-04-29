`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2024 08:57:06 PM
// Design Name: 
// Module Name: PE_wrapper
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


module PE_wrapper#(parameter PE_COUNT=64, CORE_ID, RAM_SIZE)(
    input clk,
    input[1:0] start,
    input[31:0] M,
    input[31:0] N,
    input[31:0] P,
    input[31:0] left_offset,
    input[31:0] right_offset,
    input[31:0] result_offset,

    ref logic [31:0] RAM [RAM_SIZE]
    );

    logic step_fin, PE_active, vec_fin;
    logic[31:0] left_mem_index, right_mem_index, result_mem_index;

    PE_Controller #(PE_COUNT,CORE_ID) controller(
        clk,
        step_fin,
        start, 
        M,
        N,
        P,
        left_offset,
        right_offset,
        result_offset,

        PE_active,
        vec_fin,
        left_mem_index,
        right_mem_index,
        result_mem_index

    );

    ProcessingElementMem #(RAM_SIZE) processing_element(
        clk,
        PE_active,
        vec_fin,

        left_mem_index,
        right_mem_index,
        result_mem_index,

        RAM,
        
        step_fin
    );
endmodule
