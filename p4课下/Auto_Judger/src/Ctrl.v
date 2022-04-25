`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:58:13 11/12/2021 
// Design Name: 
// Module Name:    Ctrl 
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
module Ctrl(
    input [31:0] instr,
    output [2:0] NPCSel,
    output ExtOp,
    output [1:0] GWDSel,
    output [1:0] A3Sel,
    output GWE,
    output [1:0] SrcBSel,
    output [3:0] ALUControl,
    output DWE,
    output [2:0] DMSel
    );
	 wire [5:0] op,func;
	 wire addu, subu, ori, lui, jal, jr, beq, lw, sw, j, lh, lhu, sh, lb, lbu, sb, sll, slti, bgtz;//add wire!!!
	 
	 assign op = instr[31:26];
	 
	 assign func = instr[5:0];
	 
	 assign addu = (op == `op_r && func == `func_addu)? 1 : 0;
	 assign subu = (op == `op_r && func == `func_subu)? 1 : 0;
	 assign jr = (op == `op_r && func == `func_jr)? 1 : 0;
	 assign sll = (op == `op_r && func == `func_sll)? 1 : 0;
	 
	 assign ori = (op == `op_ori)? 1 : 0;
	 assign lui = (op == `op_lui)? 1 : 0;
	 assign slti = (op == `op_slti)? 1 : 0;
	 
	 assign beq = (op == `op_beq)? 1 : 0;
	 assign bgtz = (op == `op_bgtz)? 1 : 0;
	 
	 assign jal = (op == `op_jal)? 1 : 0;
	 assign j = (op == `op_j)? 1 : 0;
	 
	 assign lw = (op == `op_lw)? 1 : 0;
	 assign sw = (op == `op_sw)? 1 : 0;
	 assign lh = (op == `op_lh)? 1 : 0;
	 assign lhu = (op == `op_lhu)? 1 : 0;
	 assign sh = (op == `op_sh)? 1 : 0;
	 assign lb = (op == `op_lb)? 1 : 0;
	 assign lbu = (op == `op_lbu)? 1 : 0;
	 assign sb = (op == `op_sb)? 1 : 0;
	 
	 //be careful!!!
	 //NPC
	 assign NPCSel[0] = beq | jr | 0;
	 assign NPCSel[1] = j | jal | jr | 0;
	 assign NPCSel[2] = bgtz | 0;
	 
	 
	 //Ext
	 assign ExtOp = slti | lb | lbu | sb | lh | lhu | sh | sw | lw | 0;
	 
	 
	 //GRF
	 assign GWDSel[0] = lh | lhu | lb | lbu | lw | 0;
	 assign GWDSel[1] = jal | 0;
	 
	 assign A3Sel[0] = slti | lh | lhu | lb | lbu | ori | lui | lw | 0;
	 assign A3Sel[1] = jal | 0;
	 
	 assign GWE = slti | sll | lh | lhu | lb | lbu | addu | subu | ori | lui | lw | jal | 0;
	 
	 
	 //ALU
	 assign SrcBSel[0] = slti | lh | lhu | sh | lb | lbu | sb | ori | lui | sw | lw | 0;
	 assign SrcBSel[1] = 0;
	 
	 assign ALUControl[0] = bgtz | sll | subu | beq | 0;
	 assign ALUControl[1] = slti | ori | beq | 0;
	 assign ALUControl[2] = slti | sll | lui | 0;
	 assign ALUControl[3] = bgtz | 0;
	 
	 
	 //DM
	 assign DWE = sh | sb | sw | 0;
	 
	 assign DMSel[0] = sh | lh | lhu | 0;
	 assign DMSel[1] = sb | lb | lhu | 0;
	 assign DMSel[2] = lbu | 0;


endmodule
