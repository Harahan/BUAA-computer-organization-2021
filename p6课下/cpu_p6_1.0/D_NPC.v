`timescale 1ns / 1ps
`include "const.v"


module D_NPC(
    input [31:0] D_pc,
    input [31:0] F_pc,
    input [25:0] imm26,
    input [15:0] imm16,
    input [31:0] rs_d,  
    input [2:0] npc_sel,
    input b_j,
    output [31:0] npc
    );
	 
	 assign npc = (npc_sel == `ns_pc4)?F_pc + 4:
					  (npc_sel == `ns_j)?{D_pc[31:28], imm26, 2'b0}:
					  (npc_sel == `ns_rs)?rs_d:
					  (npc_sel == `ns_b && b_j)?D_pc + 4 + {{14{imm16[15]}}, imm16, 2'b0}:
					  F_pc + 4;

endmodule
