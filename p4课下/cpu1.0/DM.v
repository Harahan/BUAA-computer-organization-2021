`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:04 11/11/2021 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input DWE,
    output [31:0] DMOut,
    input [2:0] DMSel,
    input [31:0] RD2,
    input [31:0] Addr,
	 input [31:0] PC // for test
    );
	reg [31:0] dm [1023:0];
	integer i;
	
	assign DMOut = dm[Addr[11:2]];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i = 0; i < 1024; i = i + 1)
				dm[i] <= 0;
		end
		else if(DWE)begin
			if(DMSel == `DMW)begin
				dm[Addr[11:2]] <= RD2;
			end
			$display("@%h: *%h <= %h", PC, Addr, RD2);
		end
	end

endmodule
