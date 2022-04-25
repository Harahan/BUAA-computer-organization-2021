`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:36 11/11/2021 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] GWD,
    output [31:0] RD1,
    output [31:0] RD2,
    input GWE,
    input reset,
    input clk,
	 input [31:0] PC
    );
	reg [31:0] grf [31:0];
	integer i;
	
	assign RD1 = grf[A1];
	
	assign RD2 = grf[A2];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i = 0; i < 32; i = i + 1)
				grf[i] <= 0;
		end
		else if(GWE)begin
			if(A3 != 0)begin//$0 == 0 forever!!!
				grf[A3] <= GWD;
				$display("@%h: $%d <= %h", PC, A3, GWD);
			end
		end
	end

endmodule
