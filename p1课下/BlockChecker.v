`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:10:04 10/21/2021 
// Design Name: 
// Module Name:    BlockChecker 
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
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
function is_e;
	input [7:0] in;
	is_e = (in == "E" || in== "e")? 1 : 0;
endfunction
function is_n;
	input [7:0] in;
	is_n = (in == "N" || in== "n")? 1 : 0;
endfunction
function is_d;
	input [7:0] in;
	is_d = (in == "D" || in== "d")? 1 : 0;
endfunction
function is_b;
	input [7:0] in;
	is_b = (in == "B" || in== "b")? 1 : 0;
endfunction
function is_g;
	input [7:0] in;
	is_g = (in == "g" || in== "G")? 1 : 0;
endfunction
function is_i;
	input [7:0] in;
	is_i = (in == "I" || in== "i")? 1 : 0;
endfunction
function is_black;
	input [7:0] in;
	is_black = (in == " " )? 1 : 0;
endfunction
reg [31:0] status,flag,tag;
reg signed[32:0] count;
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			status <= 0;
			count <= 0;
			flag <= 0;
			tag <= 0;
		end
		else begin
			case(status)
				 0:if(is_b(in))
						status <= 2;
					else if(is_e(in))
						status <= 7;
					else if(is_black(in))
						status <= 0;
					else
						status <= 1;
				1:if(is_black(in))
						status <= 0;
					else
						status <= 1;
				2:if(is_e(in))
					status <= 3;
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				3:if(is_g(in))
					status <= 4;
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				4:if(is_i(in))
					status <= 5;
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				5:if(is_n(in))begin
					status <= 6;
					count <= count + 1;
				end
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				6:if(is_black(in))
					status <= 0;
				else begin
					status <= 1;
					count <= count - 1;
				end
				7:if(is_n(in))
					status <= 8;
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				8:if(is_d(in))begin
					status <= 9;
					count <= count - 1;
					if(count == 0 && tag == 0)begin
						flag <= 1;
						tag <= 1;
					end
				end
				else if(is_black(in))
					status <= 0;
				else
					status <= 1;
				9:if(is_black(in))begin
					status <= 0;
					if(tag == 1)
						tag <= 2;
					end
				else begin
					status <= 1;
					count <= count + 1;
					if(count == -1 && tag == 1)begin
						flag <= 0;
						tag <= 0;
					end
				end
			endcase	
		end
	end
assign result = (count == 0 && flag == 0)? 1 : 0;
endmodule
