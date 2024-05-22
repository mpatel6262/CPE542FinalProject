`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2024 05:22:38 PM
// Design Name: 
// Module Name: AXI_Wrapper
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


module AXI_Wrapper(
                     // read control signals
                     input wire           clk,
                     input wire           rst,
                     input wire [31:0]    read_addr_in,
                     input wire [31:0]    read_len_in,
                     input wire          read_en_in,
                     output wire [31 : 0] read_data_out,
                     
                     // write control signals
                     input wire [31:0]  write_addr_in,
                     input wire [31:0]  write_data_in,
                     input wire         write_en_in,
                     input wire [31:0]  write_data_len_in,
                     output wire        write_done_out,

                     // AXI interface
                     input wire           m00_axi_init_axi_txn,
                     output wire          m00_axi_txn_done,
                     output wire          m00_axi_error,
                     input wire           m00_axi_aclk,
                     input wire           m00_axi_aresetn,
                     // output wire [5 : 0]  m00_axi_awid,
                     output wire [31 : 0] m00_axi_awaddr,
                     output wire [3 : 0]  m00_axi_awlen,
                     output wire [2 : 0]  m00_axi_awsize,
                     output wire [1 : 0]  m00_axi_awburst,
                     output wire          m00_axi_awlock,
                     output wire [3 : 0]  m00_axi_awcache,
                     output wire [2 : 0]  m00_axi_awprot,
                     output wire [3 : 0]  m00_axi_awqos,
                     output wire          m00_axi_awvalid,
                     input wire           m00_axi_awready,
                     output wire [31 : 0] m00_axi_wdata,
                     output wire [7 : 0]  m00_axi_wstrb,
                     output wire          m00_axi_wlast,
                     output wire          m00_axi_wvalid,
                     input wire           m00_axi_wready,
                     // input wire [5 : 0]   m00_axi_bid,
                     input wire [1 : 0]   m00_axi_bresp,
                     input wire           m00_axi_bvalid,
                     output wire          m00_axi_bready,
                     // output wire [5 : 0]  m00_axi_arid,
                     output wire [31 : 0] m00_axi_araddr,
                     output wire [7 : 0]  m00_axi_arlen,
                     output wire [2 : 0]  m00_axi_arsize,
                     output wire [1 : 0]  m00_axi_arburst,
                     output wire          m00_axi_arlock,
                     output wire [3 : 0]  m00_axi_arcache,
                     output wire [2 : 0]  m00_axi_arprot,
                     output wire [3 : 0]  m00_axi_arqos,
                     output wire          m00_axi_arvalid,
                     input wire           m00_axi_arready,
                     // input wire [5 : 0]   m00_axi_rid,
                     input wire [31 : 0]  m00_axi_rdata,
                     input wire [1 : 0]   m00_axi_rresp,
                     input wire           m00_axi_rlast,
                     input wire           m00_axi_rvalid,
                     output wire          m00_axi_rready

    );
    
    AXI_Interface_Read AXI_Interface_Read (
        .clk(clk),
        .rst(rst),
        .read_addr_in(read_addr_in),
        .read_len_in(read_len_in),
        .read_data_out(read_data_out),
        .read_en_in(read_en_in),
        //.m00_axi_awid(m00_axi_awid),
        
        //.m00_axi_arid(m00_axi_arid),
        .m00_axi_araddr(m00_axi_araddr),
        .m00_axi_arlen(m00_axi_arlen),
        .m00_axi_arsize(m00_axi_arsize),
        .m00_axi_arburst(m00_axi_arburst),
        .m00_axi_arlock(m00_axi_arlock),
        .m00_axi_arcache(m00_axi_arcache),
        .m00_axi_arprot(m00_axi_arprot),
        .m00_axi_arqos(m00_axi_arqos),
        .m00_axi_arvalid(m00_axi_arvalid),
        .m00_axi_arready(m00_axi_arready),
        //.m00_axi_rid(m00_axi_rid),
        .m00_axi_rdata(m00_axi_rdata[31:0]),
        .m00_axi_rresp(m00_axi_rresp),
        .m00_axi_rlast(m00_axi_rlast),
        .m00_axi_rvalid(m00_axi_rvalid),
        .m00_axi_rready(m00_axi_rready) 
    );
    
    AXI_Interface_Write AXI_Interface_Write (
        .write_en_in(write_en_in),
        .write_addr_in(write_addr_in),
        .write_data_in(write_data_in),
        .write_data_len_in(write_data_len_in),
        .write_done_out(write_done_out),
    
        .m00_axi_aclk(clk),
        .m00_axi_aresetn(rst),
    
        .m00_axi_awaddr(m00_axi_awaddr),
        .m00_axi_awlen(m00_axi_awlen),
        .m00_axi_awsize(m00_axi_awsize),
        .m00_axi_awburst(m00_axi_awburst),
        .m00_axi_awlock(m00_axi_awlock),
        .m00_axi_awcache(m00_axi_awcache),
        .m00_axi_awprot(m00_axi_awprot),
        .m00_axi_awqos(m00_axi_awqos),
        .m00_axi_awvalid(m00_axi_awvalid),
        .m00_axi_awready(m00_axi_awready),
        .m00_axi_wdata(m00_axi_wdata[31:0]),
        .m00_axi_wstrb(m00_axi_wstrb),
        .m00_axi_wlast(m00_axi_wlast),
        .m00_axi_wvalid(m00_axi_wvalid),
        .m00_axi_wready(m00_axi_wready),
        .m00_axi_bid(m00_axi_bid),
        .m00_axi_bresp(m00_axi_bresp),
        .m00_axi_bvalid(m00_axi_bvalid),
        .m00_axi_bready(m00_axi_bready)
    );
    
endmodule
