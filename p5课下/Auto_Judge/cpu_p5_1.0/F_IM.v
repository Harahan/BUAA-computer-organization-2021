`timescale 1ns / 1ps
`include "const.v"


module F_IM(
    input [31:0] PC,
    output [31:0] instr
    );
	reg [31:0] im [4095:0];
	
	initial begin
		$readmemh("code.txt", im, 0, 4095);
	end
	
	assign instr = im[PC[13:2] - 12'hc00];
	
endmodule

