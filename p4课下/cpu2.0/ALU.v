`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:58 11/11/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    output [31:0] ALUOut,
    output ALUZero,
	 input [4:0] shamt,
    input [3:0] ALUControl
    );
	 assign ALUZero = (ALUOut == 1)? 1 : 0;
	 
	 assign ALUOut = (ALUControl == `ALUAdd)? SrcA + SrcB :
					 (ALUControl == `ALUSub)? SrcA - SrcB :
					 (ALUControl == `ALUOr)? SrcA | SrcB :
					 (ALUControl == `ALUCmp_eq)? (SrcA == SrcB) :
					 (ALUControl == `ALULui)? SrcB << 16 :
					 (ALUControl == `ALUSll)? SrcB << shamt :
					 (ALUControl == `ALUCmp_lt)? (SrcA < SrcB) :
					 (ALUControl == `ALUCmp_lt_eq)? (SrcA <= SrcB) ://becareful SrcA or SrcB 
					 (ALUControl == `ALUCmp_lt_z)? $signed($signed(SrcA) < 0) :
					 (ALUControl == `ALUCmp_lt_eq_z)? $signed($signed(SrcA) <= 0) :
					 32'b0;
						  

endmodule
