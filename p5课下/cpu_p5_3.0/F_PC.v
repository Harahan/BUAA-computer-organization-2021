`timescale 1ns / 1ps
`include "const.v"


module F_PC(
    input [31:0] npc,
    output reg [31:0] pc,
	 input pwe,
    input reset,
    input clk
    );
	always@(posedge clk)begin
		if(reset)begin
			pc <= 32'h0000_3000;//32bite
		end
		else if(pwe) begin
			pc <= npc;
		end
	end

endmodule

