`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 07:06:37 PM
// Design Name: 
// Module Name: AXI_Interface_Write
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

typedef enum {
    Idle_w,
    SendAddr_w,
    SendData_w,
    GetResp_w,
    Done_w
} WriteState_t;

module AXI_Interface_Write(
        input logic           write_en_in,
        input logic [31:0]    write_addr_in,
        input logic [31:0]    write_data_in,
        input logic [31:0]    write_data_len_in,
        output logic          write_done_out,

        // AXI Signals
        input logic           m00_axi_aclk,
        input logic           m00_axi_aresetn,
        output logic [5 : 0]  m00_axi_awid,
        output logic [31 : 0] m00_axi_awaddr,
        output logic [3 : 0]  m00_axi_awlen,
        output logic [2 : 0]  m00_axi_awsize,
        output logic [1 : 0]  m00_axi_awburst,
        output logic          m00_axi_awlock,
        output logic [3 : 0]  m00_axi_awcache,
        output logic [2 : 0]  m00_axi_awprot,
        output logic [3 : 0]  m00_axi_awqos,
        output logic          m00_axi_awvalid,
        input logic           m00_axi_awready,
        output logic [31 : 0] m00_axi_wdata,
        output logic [7 : 0]  m00_axi_wstrb,
        output logic          m00_axi_wlast,
        output logic          m00_axi_wvalid,
        input logic           m00_axi_wready,
        input logic [5 : 0]   m00_axi_bid,
        input logic [1 : 0]   m00_axi_bresp,
        input logic           m00_axi_bvalid,
        output logic          m00_axi_bready
    );
    
    // variables
    WriteState_t curr_state = Idle_w;
    WriteState_t next_state;
    logic clk, rst;
    logic [31:0] curr_addr;
    logic [31:0] write_cntr;
    logic decr_write_cntr;
    
    
    // signals that we are not driving
    assign m00_axi_awid = 0;
    assign m00_axi_axlock = 0;
    assign m00_axi_awcache = 0;
    assign m00_axi_awprot = 0;
    assign m00_axi_awqos = 0;
    
    
    assign clk = m00_axi_aclk;
    assign rst = m00_axi_aresetn;
    
    always_ff @(posedge clk, negedge rst) begin
        if (rst == 0)
            curr_state <= Idle_w;
        else if (clk == 1) begin
            curr_state <= next_state;
        end
    end
    
    always_comb begin
    
        // give all the signals defaults
        m00_axi_awaddr = 0;
        m00_axi_awlen = 0;
        m00_axi_awsize = 0;
        m00_axi_awburst = 0;
        m00_axi_awvalid = 0;
        m00_axi_wdata = 0;
        m00_axi_wstrb = 0;
        m00_axi_wlast = 0;
        m00_axi_wvalid = 0;
        write_done_out = 0;
        decr_write_cntr = 0;
    
        case (curr_state)
            Idle_w: begin
                next_state = write_en_in ? SendAddr_w:Idle_w;
            end
            
            SendAddr_w: begin
                next_state = m00_axi_awready ? SendData_w:SendAddr_w;
                m00_axi_awvalid = 1;
                m00_axi_awaddr = curr_addr;
                m00_axi_awlen = 0; // one transaction (for now)
                m00_axi_awsize = 5;
            end
            
            SendData_w: begin
                next_state = m00_axi_wready ? GetResp_w:SendData_w;
                m00_axi_wvalid = 1;
                m00_axi_wdata = write_data_in;
                m00_axi_wlast = 1;
            end
            
            GetResp_w: begin
                // loop all the writes
                if (m00_axi_bvalid && write_cntr == 0)
                    next_state = Done_w;
                else if (m00_axi_bvalid && write_cntr != 0) begin
                    next_state = SendAddr_w;
                    decr_write_cntr = 1;
                end else
                    next_state = GetResp_w;
                
                m00_axi_bready = 1;
            end
            
            Done_w: begin
                next_state = Idle_w;
                write_done_out = 1;
            end
            
            default
                next_state = Idle_w;
        endcase
    end
    
    // register inputs and internal signals
    always_ff @(posedge clk, negedge rst) begin
        if (rst == 0) begin
            write_cntr <= 0;
            curr_addr <= 0;
        end else begin
        
            if (write_en_in) begin
                write_cntr <= write_data_len_in - 1;
                curr_addr <= write_addr_in;
            end
            
            if (decr_write_cntr) begin
                write_cntr <= write_cntr - 1;
                curr_addr <= curr_addr + 4; // NOTE depends on the write size
            end
        end
    end
    
    
    
endmodule
