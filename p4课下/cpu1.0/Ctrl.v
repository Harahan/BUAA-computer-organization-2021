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
	 wire addu, subu, ori, lui, jal, jr, beq, lw, sw;
	 
	 assign op = instr[31:26];
	 
	 assign func = instr[5:0];
	 
	 assign addu = (op == `op_r && func == `func_addu)? 1 : 0;
	 assign subu = (op == `op_r && func == `func_subu)? 1 : 0;
	 assign jr = (op == `op_r && func == `func_jr)? 1 : 0;
	 
	 assign ori = (op == `op_ori)? 1 : 0;
	 assign lui = (op == `op_lui)? 1 : 0;
	 
	 assign beq = (op == `op_beq)? 1 : 0;
	 
	 assign jal = (op == `op_jal)? 1 : 0;
	 
	 assign lw = (op == `op_lw)? 1 : 0;
	 assign sw = (op == `op_sw)? 1 : 0;
	 
	 //NPC
	 assign NPCSel[0] = beq | jr | 0;
	 assign NPCSel[1] = jal | jr | 0;
	 assign NPCSel[2] = 0;
	 //Ext
	 assign ExtOp = sw | lw | 0;
	 //GRF
	 assign GWDSel[0] = lw | 0;
	 assign GWDSel[1] = jal | 0;
	 
	 assign A3Sel[0] = ori | lui | lw | 0;
	 assign A3Sel[1] = jal | 0;
	 
	 assign GWE = addu | subu | ori | lui | lw | jal | 0;
	 //ALU
	 assign SrcBSel[0] = ori | lui | sw | lw | 0;
	 assign SrcBSel[1] = 0;
	 
	 assign ALUControl[0] = subu | beq | 0;
	 assign ALUControl[1] = ori | beq | 0;
	 assign ALUControl[2] = lui | 0;
	 assign ALUControl[3] = 0;
	 //DM
	 assign DWE = sw | 0;
	 
	 assign DMSel[0] = 0;
	 assign DMSel[1] = 0;
	 assign DMSel[2] = 0;


endmodule
