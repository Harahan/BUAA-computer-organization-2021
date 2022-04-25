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
	 //!!!function ;
	 function [31:0]out_half;// for test
		input [31:0] word;
		input [15:0] Half;
		begin
			out_half = word;
			out_half[15 + 16*Addr[1] -: 16] = Half;
		end
	 endfunction
	 
	 function [31:0]out_byte; // for test
		input [31:0] word;
		input [7:0] Byte;
		begin
			out_byte = word;
			out_byte[7 + 8*Addr[1:0] -: 8] = Byte;
		end
	 endfunction

	reg [31:0] dm [1023:0];
	integer i;
	
	assign DMOut = (DMSel == `DMW)? dm[Addr[11:2]] :
						(DMSel == `DMH)? {{16{dm[Addr[11:2]][15 + 16*Addr[1]]}} , dm[Addr[11:2]][15 + 16*Addr[1] -: 16]} :
						(DMSel == `DMB)? {{24{dm[Addr[11:2]][7 + 8*Addr[1:0]]}} , dm[Addr[11:2]][7 + 8*Addr[1:0] -: 8]} :
						(DMSel == `DMHU)? {{16{1'b0}} , dm[Addr[11:2]][15 + 16*Addr[1] -: 16]} ://becareful 1'b0
						(DMSel == `DMBU)? {{24{1'b0}} , dm[Addr[11:2]][7 + 8*Addr[1:0] -: 8]} :
						0;
						
	always@(posedge clk)begin
		if(reset)begin
			for(i = 0; i < 1024; i = i + 1)
				dm[i] <= 0;
		end
		else if(DWE)begin
			if(DMSel == `DMW)begin
				dm[Addr[11:2]] <= RD2;
				$display("@%h: *%h <= %h", PC, Addr, RD2);
			end
			else if(DMSel == `DMH)begin
				dm[Addr[11:2]][15 + 16*Addr[1] -: 16] <= RD2[15:0];
				$display("@%h: *%h <= %h", PC, {Addr[31:2] , 2'b00}, out_half(dm[Addr[11:2]], RD2[15:0]));
			end
			else if(DMSel == `DMB)begin
				dm[Addr[11:2]][7 + 8*Addr[1:0] -: 8] <= RD2[7:0];
				$display("@%h: *%h <= %h", PC,{Addr[31:2] , 2'b00}, out_byte(dm[Addr[11:2]], RD2[7:0]));
			end
		end
	end

endmodule
