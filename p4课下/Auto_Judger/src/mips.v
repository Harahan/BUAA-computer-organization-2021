`timescale 1ns / 1ps
`include "const_def.v"
`include "ALU.v"
`include "DM.v"
`include "IM.v"
`include "PC.v"
`include "NPC.v"
`include "GRF.v"
`include "EXT.v"
`include "Ctrl.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:29 11/12/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 wire [31:0] PC, NPC, RD1, PC4, instr, ExtOut, ALUOut, DMOut, RD2 ;
	 wire [25:0] im26;
	 wire [4:0] rs_base, rt, rd, shamt;
	 wire [15:0] im16_offest;
	 wire ALUZero, ExtOp, GWE, DWE;
	 wire [3:0] ALUControl;
	 wire [2:0] NPCSel, DMSel;
	 wire [1:0] A3Sel, GWDSel, SrcBSel;
	 
	 
	 NPC npc (
    .RD1(RD1), 
    .im16(im16_offest), 
    .im26(im26), 
    .PC(PC), 
    .ALUZero(ALUZero), 
    .NPCSel(NPCSel), 
    .PC4(PC4), //O
    .NPC(NPC)//O
    );
		
	PC pc (
    .NPC(NPC), 
    .PC(PC), //O
    .reset(reset), 
    .clk(clk)
    );
	 
	IM im (
    .PC(PC), 
    .instr(instr), //O
    .rs(rs_base), //O
    .rt(rt), //O
    .rd(rd), //O
    .im16(im16_offest), //O
	 .im26(im26), //O
	 .shamt(shamt) //O
    );
	 
	 GRF grf (
    .A1(rs_base), 
    .A2(rt), 
    .A3((A3Sel == `A3Rd)? rd :
		  (A3Sel == `A3Rt)? rt :
		  (A3Sel == `A3Ra)? 5'd31 :
		  5'b0), //mux
    .GWD((GWDSel == `GWDALUOut)? ALUOut :
			(GWDSel == `GWDDMOut)? DMOut :
			(GWDSel == `GWDPC4)? PC4:
			0), //mux
    .RD1(RD1), //O
    .RD2(RD2), //O
    .GWE(GWE), 
    .reset(reset),
    .clk(clk),
	 .PC(PC)
    );
	 
	 EXT ext (
    .im16(im16_offest), 
    .ExtOp(ExtOp), 
    .ExtOut(ExtOut) //O
    );
	
	 ALU alu (
    .SrcA(RD1), 
    .SrcB((SrcBSel == `SrcBRD2)? RD2 :
			 (SrcBSel == `SrcBExtOut)? ExtOut :
			 0), //mux
    .ALUOut(ALUOut), //O
    .ALUZero(ALUZero), //O
    .shamt(shamt), 
    .ALUControl(ALUControl)
    );

	 DM dm (
    .clk(clk), 
    .reset(reset), 
    .DWE(DWE), 
    .DMOut(DMOut), //O 
    .DMSel(DMSel), 
    .RD2(RD2), 
    .Addr(ALUOut),
	 .PC(PC)
    );
	 
	 Ctrl ctrl (
    .instr(instr), 
    .NPCSel(NPCSel),//O 
    .ExtOp(ExtOp), //O
    .GWDSel(GWDSel), //O
    .A3Sel(A3Sel), //O
    .GWE(GWE), //O
    .SrcBSel(SrcBSel), //O
    .ALUControl(ALUControl), //O
    .DWE(DWE), //O
    .DMSel(DMSel)//O
    );
	
	 

endmodule
