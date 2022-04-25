`timescale 1ns / 1ps
`include "const.v"


module D_EXT(
    input [15:0] imm16,
    input ext_sel,
    output [31:0] ext_out
    );
	assign ext_out = (ext_sel)? {{16{imm16[15]}},imm16} : {{16{1'b0}},imm16};
	
endmodule