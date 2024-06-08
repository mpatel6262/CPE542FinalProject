`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024 12:14:59 PM
// Design Name: 
// Module Name: PE_Controller
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

for core_id in range(NUM_CORES):
    print(f"CORE: {core_id}")

    total_cells = M*P

    if(total_cells > core_id) cells_per_core = (total_cells // NUM_CORES)


    output_cell = cells_per_core * core_id
    
    column = output_cell
    row = 0
    while column >= P:
        row += 1
        column -= P         

    row_start = row*N
    column_start = column
    mat1_idx = mat2_idx = 0

# wait here for all AXI data transfer to complete
    for i in range(cells_per_core):
        print(f"\tComputing output cell: {output_cell}\n\tUsing row: {row} starting at memory index: {row_start}\n\tUsing column: {column} starting at memory index: {column_start}")
        sum = 0
        for idx in range(N):
            sum += MAT1[row_start + mat1_idx] * MAT2[column_start + mat2_idx]
            mat1_idx += 1
            mat2_idx += P
        output[output_cell] = sum
        output_cell += 1
        column_start += 1
        if column_start >= P:
            column_start = 0
            row_start += N
        mat1_idx = mat2_idx = 0
*/


//TODO active state is current infinite
module PE_Controller#(parameter PE_COUNT=64, parameter CORE_ID)(
    input clk,
    input step_fin,
    input[1:0] start, //start[0] = begin preprocessing, start[1] = all data is loaded
    input[31:0] M,
    input[31:0] N,
    input[31:0] P,
    input[31:0] left_offset,
    input[31:0] right_offset,
    input[31:0] result_offset,

    output logic PE_active,
    output logic vec_fin,
    output[31:0] left_mem_index,
    output[31:0] right_mem_index,
    output[31:0] result_mem_index


    );

    

    parameter[1:0] idle = 0, loading = 1, calculating = 2, active = 3;

    logic[1:0] NS = 0, PS = 0;

    logic[31:0] total_cells, cells_per_core, output_cell, column, row, counter = 0, leftdex, rightdex, CPC, spacing, remainder;


    assign left_mem_index = row + leftdex + left_offset;
    assign right_mem_index = column + rightdex + right_offset;
    assign result_mem_index = output_cell + result_offset;

    assign CPC = ((M*P)>>($clog2(PE_COUNT)));
    assign remainder = (M*P) << (32 - $clog2(PE_COUNT)) != 0;

    always_comb begin
        vec_fin = 0;

        if(CPC > 0) spacing = CPC + remainder;
        else spacing = 1;

        case(PS)
            idle: 
            begin
                PE_active = 0;

                if(start[0]) NS = loading;
                else NS = idle;

            end

            loading: 
            begin
                
                NS = calculating;

                
                
            end

            calculating:
            begin
                if(start[1] && column < P) begin
                    NS = active;
                end
            end

            active: 
            begin


                if(counter >= N-1) vec_fin = 1;

                if(cells_per_core == 0 || output_cell >= N*P) begin
                    PE_active = 0;
                    NS = idle;
                end
                else begin
                    PE_active = 1;
                    NS = active;
                end


            end
        
        endcase
    end


    always_ff @ (posedge clk) begin

        PS <= NS;

        case(PS)

            loading:
            begin
                cells_per_core <= spacing;
                column <= CORE_ID*spacing;
                output_cell <= CORE_ID*spacing;
                row <= 0;
                leftdex <= 0;
                rightdex <= 0;
            end

            calculating:
            begin
                if(column >= P) begin
                    row <= row+N;
                    column <= column - P;
                end
            end

            active:
            begin
                if(step_fin) begin
                    
                    if(counter >= N-1) begin
                        counter <= 0;
                        output_cell <= output_cell + 1;
                        
                        cells_per_core <= cells_per_core - 1;
                        

                        if(column == P-1) begin
                            column <= 0;
                            row <= row + N;
                        end
                        else column <= column + 1;

                        leftdex <= 0;
                        rightdex <= 0;
                    end
                    else begin
                        leftdex <= leftdex + 1;
                        rightdex <= rightdex + P;
                        counter <= counter + 1;
                    end
                end
            end

        endcase
    end

    

endmodule

