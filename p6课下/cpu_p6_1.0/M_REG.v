`timescale 1ns / 1ps
`include "const.v"


module M_REG(
    input reset,
    input clk,
    input we,
    input [31:0] instr_in,
    output reg[31:0] instr_out,
    input [31:0] pc_in,
    output reg[31:0] pc_out,
    input [31:0] alu_in,
    output reg[31:0] alu_out,
    input [31:0] rt_d_in,
    output reg[31:0] rt_d_out,
	 input b_j_in,
	 output reg b_j_out,
	 input [31:0]md_in,
	 output reg[31:0]md_out
    );
	 always@(posedge clk)begin
		if(reset)begin
			instr_out <= 0;
			pc_out <= 32'h0000_3000;
			alu_out <= 0;
			rt_d_out <= 0;
			b_j_out <= 0;
			md_out <= 0;
		end
		else if(we)begin
			instr_out <= instr_in;
			pc_out <= pc_in;
			alu_out <= alu_in;
			rt_d_out <= rt_d_in;
			b_j_out <= b_j_in;
			md_out <= md_in;
		end
	 end


endmodule
