`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: J. Callenes, P. Hummel
//
// Create Date: 01/27/2019 08:37:11 AM
// Module Name: OTTER_mem
// Project Name: Memory for OTTER RV32I RISC-V
// Tool Versions: Xilinx Vivado 2019.2
// Description: 64k Memory, dual access read single access write. Designed to
//              purposely utilize BRAM which requires synchronous reads and write
//              ADDR1 used for Program Memory Instruction. Word addressable so it
//              must be adapted from byte addresses in connection from PC
//              ADDR2 used for data access, both internal and external memory
//              mapped IO. ADDR2 is byte addressable.
//              RDEN1 and EDEN2 are read enables for ADDR1 and ADDR2. These are 
//              needed due to synchronous reading
//              MEM_SIZE used to specify reads as byte (0), half (1), or word (2)
//              MEM_SIGN used to specify unsigned (1) vs signed (0) extension
//              IO_IN is data from external IO and synchronously buffered
//
// Memory OTTER_MEMORY (
//    .clk   (),
//    .MEM_RDEN1 (), 
//    .MEM_RDEN2 (), 
//    .MEM_WE2   (),
//    .MEM_ADDR1 (),
//    .MEM_ADDR2 (),
//    .MEM_DIN2  (),  
//    .MEM_SIZE  (),
//    .MEM_SIGN  (),
//    .IO_IN     (),
//    .IO_WR     (),
//    .MEM_DOUT1 (),
//    .MEM_DOUT2 ()  ); 
//
// Revision:
// Revision 0.01 - Original by J. Callenes
// Revision 1.02 - Rewrite to simplify logic by P. Hummel
// Revision 1.03 - changed signal names, added instantiation template
// Revision 1.04 - added defualt to write case statement
// Revision 1.05 - changed MEM_WD to MEM_DIN2, changed default to save nothing
// Revision 1.06 - removed type in instantiation template
//
//////////////////////////////////////////////////////////////////////////////////
                                                                                                                             
  module Memory_Reader (
    input clk,
    input mem_rden,        // read enable Instruction
    input [31:0] mem_addr1, // Data Memory Addr
    input [31:0] mem_addr2, // Data Memory Addr
    //output ERR,
    output logic [31:0] mem_dout1,  // Instruction
    output logic [31:0] mem_dout2); // Data
    
    logic [13:0] wordAddr1, wordAddr2;
    logic [31:0] memReadWord, ioBuffer, memReadSized;
    logic weAddrValid;      // active when saving (WE) to valid memory address
       
    (* rom_style="{distributed | block}" *)
    (* ram_decomp = "power" *) logic [31:0] memory [0:16383];
    
    initial begin
        $readmemh("simple_vects.mem", memory, 0, 16383);
    end
    
    assign wordAddr2 = mem_addr2[15:2];

    assign wordAddr1 = mem_addr1[15:2];
               

    // BRAM requires all reads and writes to occur synchronously
    always_ff @(posedge clk) begin
    

        if(mem_rden) begin
            mem_dout1 <= memory[mem_addr1];
            mem_dout2 <= memory[mem_addr2];
        end
    end
        
 endmodule
