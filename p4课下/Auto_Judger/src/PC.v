`timescale 1ns / 1ps
`include "const_def.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:50:54 11/11/2021 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input [31:0] NPC,
    output reg [31:0] PC,
    input reset,
    input clk
    );
	always@(posedge clk)begin
		if(reset)begin
			PC <= 32'h0000_3000;//32bite
		end
		else begin
			PC <= NPC;
		end
	end

endmodule
