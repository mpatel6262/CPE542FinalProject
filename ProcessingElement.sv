`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2024 08:13:13 PM
// Design Name: 
// Module Name: ProcessingElement
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
//`define DEPTH 16

module ProcessingElement#(parameter PE_FIFO_DEPTH=16)(
    input clk,
    input PE_reset,
    input active,
    input read_in,
    input [$clog2(PE_FIFO_DEPTH)-1-1:0] length,
    input [31:0] left_in,
    input [31:0] right_in,
    output logic [31:0] comp_count
    
    );

    logic do_step;
    logic input_read, input_empty;

    logic[PE_FIFO_DEPTH-1:0] counter = 0;
    logic [31:0] add_out = 0, left_out = 0;
    logic [31:0] right_out = 0;
    logic [31:0] output_out = 0;
    logic [31:0] mult_out = 0;
    logic [31:0] reg_out = 0; 
    logic hold, read_left, read_right, write_out;
    logic left_full, left_empty, right_full, right_empty, out_full, out_empty, reset, input_buffer_reset;

    Multiplier mult(left_out, right_out, mult_out);

    Adder add(mult_out, reg_out, add_out);

    Register PE_reg(clk, add_out, reset, hold, reg_out);

    Fifo #(PE_FIFO_DEPTH) left_input_buffer(
        clk, 
        input_buffer_reset, 
        input_read,
        read_left, 
        left_in, 
        left_out, 
        left_full, 
        left_empty
    );
                                            
    Fifo #(PE_FIFO_DEPTH) right_input_buffer(
        clk, 
        input_buffer_reset, 
        input_read,
        read_right,  
        right_in, 
        right_out, 
        right_full, 
        right_empty
    );

    Fifo #(PE_FIFO_DEPTH) output_buffer(
        clk, 
        0, 
        write_out, 
        1,  
        add_out, 
        output_out, 
        out_full, 
        out_empty
    );

    assign do_step = active & !input_empty & (!out_full);

    always @(posedge clk) begin
    
        input_read <= read_in;
        input_empty <= left_empty | right_empty;

        input_buffer_reset <= 0;
        hold <= 0;
        if(PE_reset) begin
            comp_count <= 0;
            input_buffer_reset <= 1;
        end

        else if(do_step) begin
            

            read_left  <= 1;
            read_right <= 1;

            counter <= counter + 1;

            if(counter == length) begin
                write_out <= 1;
                reset <= 1;
                comp_count <= comp_count+1;
                counter <= 1;
            end
            else begin
                write_out <= 0;
                reset <= 0;
            end
        end
        else begin
            read_left  <= 0;
            read_right <= 0;

            counter <= counter;

            write_out <= 0;
            reset <= 0;

            hold <= 1;
        end

    end

endmodule
