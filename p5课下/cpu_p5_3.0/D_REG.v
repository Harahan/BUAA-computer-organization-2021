`timescale 1ns / 1ps
`include "const.v"


module D_REG(
    input reset,
    input clk,
    input we,
    input [31:0] instr_in,
    output reg[31:0] instr_out,
    input [31:0] pc_in,
    output reg[31:0] pc_out
    );
	always@(posedge clk)begin
		if(reset)begin
			instr_out <= 0;
			pc_out <= 32'h0000_3000;
		end
		else if(we)begin
			instr_out <= instr_in;
			pc_out <= pc_in;
		end
	end

endmodule
