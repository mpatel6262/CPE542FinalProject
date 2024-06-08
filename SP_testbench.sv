`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 06:26:21 PM
// Design Name: 
// Module Name: SP_testbench
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


module SP_testbench(

    );
    /*
    logic [31:0] data1 = 0, data2 = 0, addr1, addr2, cnt, out;
    logic clk, active, read_in, out_empty;
    

    Memory_Reader mem_unit(
        clk,
        1,       
        addr1, 
        addr1+8, 
        data1,  
        data2
    ); 

    assign addr2 = addr1+4;

    initial begin
        clk <= 0;
        
        forever #1 clk <= ~clk;

        
    end

    initial begin
        addr1 = 0;
        addr2 = 8;
        active = 0;
        read_in = 1;
        #2 
            active = 1;
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;
        #2 
            addr1 = addr1+1;
            addr2 = addr2+1;


        #4
            read_in = 0;
            active = 0;
    end

    


    ProcessingElementMod #(16) ProcEl(
    clk,
    active,
    1,
    4,
    data1,
    data2,
    1,
    out_empty,
    out

    );*/
    parameter RAM_SIZE = 256;
    parameter SQUARE = 3;
    parameter PE_COUNT = 4;

    logic clk, active, read_in, out_empty;
    logic[1:0] start_signal[PE_COUNT];
    logic[31:0] M, N, P;
    logic[31:0] RAM [RAM_SIZE];

    initial begin
        clk <= 0;
        
        forever #1 clk <= ~clk;
    end



    Matrix_Mult#(RAM_SIZE,PE_COUNT) Mat_mul(
        clk,

        start_signal,

        M,
        N,
        P,

        0,
        0,
        20,

        RAM
    );


    initial begin

        for(int i = 0; i < RAM_SIZE; i++) begin
            RAM[i] = 0;
        end

        for(int i = 0; i < (12); i++) begin
            RAM[i] = i+1;
        end


        for(int i = 0; i < PE_COUNT; i++) begin
            start_signal[i] = 2'b00;
        end
        M = 2;
        N = SQUARE;
        P = 4;

        #5
            for(int i = 0; i < PE_COUNT; i++) begin
                start_signal[i] = 2'b01;
            end

        #15

        for(int i = 0; i < PE_COUNT; i++) begin
                start_signal[i] = 2'b10;
        end

        #300

        for(int i = 0; i < PE_COUNT; i++) begin
                start_signal[i] = 2'b00;
        end
    end

endmodule