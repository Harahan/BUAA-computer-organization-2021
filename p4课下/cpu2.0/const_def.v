`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:42 11/11/2021 
// Design Name: 
// Module Name:    const_def 
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
//NPC
`define NPCPC4 3'b000
`define NPCBeq 3'b001
`define NPCJ 3'b010
`define NPCJr 3'b011
`define NPCBne 3'b100


//Ctrl
`define op_ori 6'b0011_01
`define op_lui 6'b0011_11
`define op_slti 6'b0010_10

`define op_beq 6'b0001_00
`define op_bgtz 6'b0001_11

`define op_lw 6'b1000_11
`define op_sw 6'b1010_11
`define op_lh 6'b1000_01
`define op_lhu 6'b1001_01
`define op_sh 6'b1010_01
`define op_lb 6'b1000_00
`define op_lbu 6'b1001_00
`define op_sb 6'b1010_00

`define op_jal 6'b0000_11
`define op_j 6'b0000_10

`define op_r 6'b0000_00
`define func_addu 6'b1000_01
`define func_subu 6'b1000_11
`define func_jr 6'b0010_00
`define func_sll 6'b0000_00


//GRF
`define A3Rd 2'b00
`define A3Rt 2'b01
`define A3Ra 2'b10

`define GWDALUOut 2'b00
`define GWDDMOut 2'b01
`define GWDPC4 2'b10
 
 
 //ALU
 `define SrcBRD2 2'b00
 `define SrcBExtOut 2'b01
 
 `define ALUAdd  4'b0000
 `define ALUSub  4'b0001
 `define ALUOr  4'b0010
 `define ALUCmp_eq  4'b0011
 `define ALULui  4'b0100
 `define ALUSll 4'b0101
 `define ALUCmp_lt 4'b0110
 `define ALUCmp_lt_eq 4'b0111
 `define ALUCmp_lt_z 4'b1000
 `define ALUCmp_lt_eq_z 4'b1001
 
 
 //DM
 `define DMW 3'b000
 `define DMH 3'b001
 `define DMB 3'b010
 `define DMHU 3'b011
 `define DMBU 3'b100
 

 