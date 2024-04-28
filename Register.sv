`timescale 1ns / 1ps

module Register(
    input clk,
    input [31:0] in,
    input clear,
    input hold,
    output logic [31:0] out = 0
    );

    always_ff @(posedge clk) begin
        
        if(clear) out <= 0;
        else if(hold) out <= out;
        else out <= in;

    end
    
endmodule