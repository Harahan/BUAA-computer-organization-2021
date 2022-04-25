`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:33 11/11/2021 
// Design Name: 
// Module Name:    IM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IM(
    input [31:0] PC,
    output [31:0] instr,
	 output [4:0] rs,
	 output [4:0] rt,
	 output [4:0] rd,
	 output [15:0] im16,
	 output [25:0] im26,
	 output [4:0]shamt
    );
	reg [31:0] im [1023:0];
	
	initial begin
		$readmemh("code.txt", im, 0, 1023);
	end
	
	assign instr = im[PC[11:2]];
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
	assign im16 = instr[15:0];
	assign im26 = instr[25:0];
	assign shamt = instr[10:6];

endmodule
