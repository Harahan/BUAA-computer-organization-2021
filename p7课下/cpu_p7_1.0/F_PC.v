`timescale 1ns / 1ps
`include "const.v"

`define start_instr 32'h0000_3000
`define end_instr 32'h0000_6fff


module F_PC(
	input req,
	input eret,
	input [31:0] epc,
	output ex_adel,
    input [31:0] npc,
    output [31:0] pc,
	input pwe,
    input reset,
    input clk
    );
	reg [31:0] temp_pc;

	assign ex_adel = ((pc[1:0] != 0)||(pc < `start_instr) || (pc > `end_instr));
	assign pc = eret? epc : temp_pc;

	always@(posedge clk)begin
		if(reset)begin
			temp_pc <= 32'h0000_3000;//32bite
		end
		else if(pwe | req) begin
			temp_pc <= npc;
		end
	end

endmodule

