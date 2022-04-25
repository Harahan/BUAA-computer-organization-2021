`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:52 11/11/2021 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] RD1,
    input [15:0] im16,
    input [25:0] im26,
    input [31:0] PC,
    input ALUZero,
    input [2:0] NPCSel,
	 output [31:0] PC4,
    output [31:0] NPC
    );
	assign PC4 = PC + 4;
	
	assign NPC = (NPCSel == `NPCPC4)? PC + 4:
					 (NPCSel == `NPCBeq)? ((ALUZero == 1)? PC + 4 + {{14{im16[15]}},im16,2'b00} : PC + 4):
					 (NPCSel == `NPCJ)? {PC[31:28],im26,2'b00}:
					 (NPCSel == `NPCJr)? RD1:
					 PC + 4;

endmodule
