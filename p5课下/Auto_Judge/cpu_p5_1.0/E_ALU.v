`timescale 1ns / 1ps
`include "const.v"


module E_ALU(
    input [31:0] a,
    input [31:0] b,
    output [31:0] alu_out,
    input [4:0] alu_sel
    ); 
		wire [31:0]res_sra, res_slt;
	 
	 assign res_sra = $signed($signed(a) >>> b);
	 assign res_slt = ($signed(a) < $signed(b))? 32'b1 : 32'b0;
	 
	 assign alu_out = (alu_sel == `alu_add)? a + b:
							(alu_sel == `alu_sub)? a - b:
							(alu_sel == `alu_or)? a | b:
							(alu_sel == `alu_and)? a & b:
							(alu_sel == `alu_xor)? a ^ b:
							(alu_sel == `alu_nor)? ~(a | b):
							(alu_sel == `alu_sll)? a << b:
							(alu_sel == `alu_srl)? a >> b:
							(alu_sel == `alu_sra)? res_sra:
							(alu_sel == `alu_slt)? res_slt:
							(alu_sel == `alu_sltu)?a < b:
							(alu_sel == `alu_lui)? b << 16:
							0;
						  

endmodule
