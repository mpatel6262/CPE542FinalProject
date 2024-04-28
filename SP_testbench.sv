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

    );


endmodule