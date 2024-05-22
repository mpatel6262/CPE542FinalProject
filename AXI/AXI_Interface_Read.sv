typedef enum {
              Idle,
              SendAddr,
              RecvData,
              Done
              } ReadState_t;


module AXI_Interface_Read(
                     input logic           clk,
                     input logic           rst,
                     input logic [31:0]    read_addr_in,
                     input logic [31:0]    read_len_in,
                     input logic           read_en_in,
                     output logic [31 : 0] read_data_out,
                     output logic dval,
                     output logic done,

                     // AXI Interface
                     output logic [5 : 0]  m00_axi_arid,
                     output logic [31 : 0] m00_axi_araddr,
                     output logic [7 : 0]  m00_axi_arlen,
                     output logic [2 : 0]  m00_axi_arsize,
                     output logic [1 : 0]  m00_axi_arburst,
                     output logic          m00_axi_arlock,
                     output logic [3 : 0]  m00_axi_arcache,
                     output logic [2 : 0]  m00_axi_arprot,
                     output logic [3 : 0]  m00_axi_arqos,
                     output logic          m00_axi_arvalid,
                     input logic           m00_axi_arready,
                     input logic [5 : 0]   m00_axi_rid,
                     input logic [31 : 0]  m00_axi_rdata,
                     input logic [1 : 0]   m00_axi_rresp,
                     input logic           m00_axi_rlast,
                     input logic           m00_axi_rvalid,
                     output logic          m00_axi_rready
);

  ReadState_t curr_read_state = Idle;
   ReadState_t next_read_state;
   logic [31:0] read_cntr;
   logic [31:0] read_addr_cntr;
   logic decr_read_cntr;

   // unused signals
   assign m00_axi_txn_done = 0;
   assign m00_axi_error = 0;
   assign m00_axi_arid = 0;
   assign m00_axi_arlen = 5;
   assign m00_axi_arburst = 0;
   assign m00_axi_arlock = 0;
   assign m00_axi_arcache = 0;
   assign m00_axi_arprot = 0;
   assign m00_axi_arqos = 0;

  // read data sequence
  always_ff @(posedge clk, negedge rst) begin
     if (rst == 0)
       curr_read_state <= Idle;
     else
       curr_read_state <= next_read_state;
  end;
  
   always_comb begin
      // set default values for all the signals
      m00_axi_arvalid = 0;
      m00_axi_araddr = 0;
      m00_axi_arlen = 0;
      m00_axi_arsize = 0;
      m00_axi_rready = 0;
      decr_read_cntr = 0;
      done = 0;
      
      case(curr_read_state)
        Idle:
          next_read_state = read_en_in ? SendAddr: Idle;

        SendAddr: begin
           next_read_state = m00_axi_arready ? RecvData : SendAddr;
           m00_axi_arvalid = 1;
           m00_axi_araddr = read_addr_cntr;
           m00_axi_arlen = 0;
           m00_axi_arsize = 2;
        end

        RecvData: begin
            // handle looping back
           if (m00_axi_rvalid && read_cntr == 0)
            next_read_state = Done;
           else if (m00_axi_rvalid && read_cntr != 0) begin
            next_read_state = SendAddr;
            decr_read_cntr = 1;
           end else begin
            next_read_state = RecvData;
           end
            
           m00_axi_rready = 1'b1;
        end
        
        Done: begin
            next_read_state = Idle;
            done = 1;
        end

        default: begin
           next_read_state = Idle;
        end

      endcase; // case (curr_read_state)

   end;

   // for registering the data output
   always_ff @(posedge clk, negedge rst) begin
      if (rst == 1'b0)
        read_data_out <= 0;
      else begin
          if (m00_axi_rready && m00_axi_rvalid) begin
            read_data_out <= m00_axi_rdata;
            dval <= 1;
          end else
            dval <= 0;
      end
   end;
   
   // register all the nessesecary inputs
   always_ff @(posedge clk, negedge rst) begin
    if (rst == 1'b0) begin
        read_cntr <= 0;
        dval <= 0;
        read_addr_cntr <= 0;
        read_cntr <= 0;
    end else begin
    
        // load the read counters
        if (read_en_in && curr_read_state == Idle) begin
            read_cntr <= read_len_in - 1;
            read_addr_cntr <= read_addr_in;
        end
        
        // update the read counters
        if (decr_read_cntr) begin
            read_cntr <= read_cntr - 1;
            read_addr_cntr <= read_addr_cntr + 4; // NOTE have to change this with read size
        end
    end
  end

endmodule
