module Adder(
    input [31:0] srcA,
    input [31:0] srcB,
    output logic [31:0] result
    );

    assign result = srcA+srcB;

endmodule