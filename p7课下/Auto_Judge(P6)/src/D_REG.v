`timescale 1ns / 1ps
`include "const.v"


module D_REG(
	input req,
	input [4:0] ex_code_in,
	output reg [4:0] ex_code_out,
	input bd_in, // the instr in branch delay solt
	output reg bd_out,
    input reset,
    input clk,
    input we,
    input [31:0] instr_in,
    output reg[31:0] instr_out,
    input [31:0] pc_in,
    output reg[31:0] pc_out
    );
	always@(posedge clk)begin
		if(reset | req)begin
			instr_out <= 0;
			pc_out <= req? 32'h0000_4180 : 0;
			ex_code_out <= 0;
			bd_out <= 0;
		end
		else if(we)begin
			instr_out <= instr_in;
			pc_out <= pc_in;
			ex_code_out <= ex_code_in;
			bd_out <= bd_in;
		end
	end

endmodule
