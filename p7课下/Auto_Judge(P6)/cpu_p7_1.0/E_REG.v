`timescale 1ns / 1ps
`include "const.v"


module E_REG(
	input req,
	input [4:0] ex_code_in,
	output reg [4:0] ex_code_out,
	input bd_in, 
	output reg bd_out,
	input stall,
    input reset,
    input clk,
    input we,
    input [31:0] instr_in,
    output reg[31:0] instr_out,
    input [31:0] pc_in,
    output reg[31:0] pc_out,
    input [31:0] ext_in,
    output reg[31:0] ext_out,
    input [31:0] rs_d_in,
    output reg[31:0] rs_d_out,
    input [31:0] rt_d_in,
    output reg[31:0] rt_d_out,
	 input b_j_in,
	 output reg b_j_out
    );

	/*
		when is in stall:
			pc == 0, bd == 0
		they will rise exc:
		so, pc, bd continue to pass
		most importantly:
			when D_add, E_nop, M_lw:
				pc for nop is add's
			when D_beq(use $3), E_nop, M_add, W_lw($3):
				bd for nop is beq's 
	*/
	 
	 always@(posedge clk)begin
		if(reset | stall | req)begin
			instr_out <= 0;
			pc_out <= stall ? pc_in : (req? 32'h0000_4180 : 0);
			ext_out <= 0;
			rs_d_out <= 0;
			rt_d_out <= 0;
			b_j_out <= 0;
			ex_code_out <= 0;
			bd_out <= stall ? bd_in : 0;
		end
		else if(we)begin
			instr_out <= instr_in;
			pc_out <= pc_in;
			ext_out <= ext_in;
			rs_d_out <= rs_d_in;
			rt_d_out <= rt_d_in;
			b_j_out <= b_j_in;
			bd_out <= bd_in;
			ex_code_out <= ex_code_in;
		end
	 end

endmodule
