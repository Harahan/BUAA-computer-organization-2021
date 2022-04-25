`timescale 1ns / 1ps
`include "const.v"


module E_ALU(
	input alu_ari_of,
	input alu_dm_of,
	output ex_ov_ari,//load, store overflow
	output ex_ov_dm,//add, addi, sub overflow

    input [31:0] a,
    input [31:0] b,
    output [31:0] alu_out,
    input [4:0] alu_sel
    ); 
		
	assign alu_out = 	(alu_sel == `alu_add)? a + b:
						(alu_sel == `alu_sub)? a - b:
						(alu_sel == `alu_or)? a | b:
						(alu_sel == `alu_and)? a & b:
						(alu_sel == `alu_xor)? a ^ b:
						(alu_sel == `alu_nor)? ~(a | b):
						(alu_sel == `alu_sll)? a << b:
						(alu_sel == `alu_srl)? a >> b:
						(alu_sel == `alu_sra)? $signed($signed(a) >>> b):
						(alu_sel == `alu_slt)? (($signed(a) < $signed(b))? 32'b1 : 32'b0):
						(alu_sel == `alu_sltu)?a < b:
						(alu_sel == `alu_lui)? b << 16:
						0;
		
	wire [32:0] ex_a = {a[31], a}, ex_b = {b[31], b};
	wire [32:0] ex_add = ex_a + ex_b, ex_sub = ex_a - ex_b;

	assign ex_ov_ari = alu_ari_of &&
						(((alu_sel == `alu_add) && (ex_add[32] != ex_add[31])) ||
						((alu_sel == `alu_sub) && (ex_sub[32] != ex_sub[31])));

	assign  ex_ov_dm = alu_dm_of &&
						((alu_sel == `alu_add) && (ex_add[32] != ex_add[31]));
						  

endmodule
