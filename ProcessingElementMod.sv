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


module ProcessingElementMod#(parameter PE_FIFO_DEPTH=16)(
    input clk,
    input read_in,
    input [31:0] length,
    input [31:0] left_in,
    input [31:0] right_in,
    input read_out,
    output out_empty,
    output [31:0] output_out
    
    );


    logic [31:0] add_out = 0, right_out = 0, left_out = 0, mult_out = 0, reg_out = 0, count = 0,to_reg;


    logic data_ready, fifo_read, stall, left_full, right_full, left_empty, right_empty, write_out = 0, flush = 0, flush2 = 0, add_stall;



    Multiplier mult(left_out, right_out, mult_out);

    Adder add(
        clk,
        add_stall,
        length,
        reg_out,
        mult_out, 
        add_out,
        to_reg,
        write_out
    );




    Register PE_reg(clk, to_reg, write_out, stall, reg_out);

    Fifo #(PE_FIFO_DEPTH) left_input_buffer(
        clk, 
        0, 
        read_in,
        fifo_read, 
        left_in, 
        left_out, 
        left_full, 
        left_empty
    );
                                            
    Fifo #(PE_FIFO_DEPTH) right_input_buffer(
        clk, 
        0, 
        read_in,
        fifo_read,  
        right_in, 
        right_out, 
        right_full, 
        right_empty
    );

    Fifo #(PE_FIFO_DEPTH) output_buffer(
        clk, 
        0, 
        write_out, 
        read_out,  
        add_out, 
        output_out, 
        out_full, 
        out_empty
    );

    assign data_ready = !(right_empty|left_empty) | flush2;
    assign fifo_read = data_ready & (!stall);
    assign stall = out_full;

    assign add_stall = !(flush);

    always @(posedge clk) begin
        
        flush <= !(right_empty|left_empty);
        flush2 <= flush;

    end

endmodule