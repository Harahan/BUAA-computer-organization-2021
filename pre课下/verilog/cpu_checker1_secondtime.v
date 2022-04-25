`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:59 10/23/2021 
// Design Name: 
// Module Name:    cpu_checker1_secondtime 
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
module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
    output [1:0] format_type
    );
function is_d;
	input [7:0] char;
	is_d = (char >= "0" && char <= "9")? 1 : 0;
endfunction
function is_h;
	input [7:0] char;
	is_h = ((char >= "0" && char <= "9")||(char >= "a" && char <= "f"))? 1 : 0;
endfunction
reg [5:0] status,count,flag,tag;
always@(posedge clk)begin
	if(reset)begin
		status <= 0;
		count <= 0;
		flag <= 0;
		tag <=0;
	end
	else begin
		case(status)
			0: if(char=="^")status <= 1;
			1: begin
				if(count<=3&&is_d(char))begin
					status <= 1;
					count <= count +1;
				end
				else if((count>=1&&count<=4)&&char=="@")begin
					status <=2;
					count <= 0;
				end
				else begin
					status <= 0;
					count <= 0;
				end
			end
			2:begin
				if(count <=7&&is_h(char))begin
					status <= 2;
					count <= count+1;
				end
				else if((count==8)&&char==":")begin
					status <= 3;
					count <= 0;
				end
				else begin
					status <=0;
					count<= 0;
				end
			end
			3:begin
				if(char ==" ")status <= 3;
				else if( char =="$")begin 
					status <= 4;
					flag <= 1;
				end
				else if( char =="*")begin 
					status <= 5;
					flag <= 2;
				end
				else status <= 0;
			end
			4:begin
				if(count<=3&&is_d(char)&& tag==0)begin//Ğ¡ĞÄ
					status <= 4;
					count<= count +1;
				end
				else if((count<=4&&count>=1)&&char ==" ")begin
					status <= 4;
					tag<=1;
				end
				else if((count<=4&&count>=1)&&char =="<")begin
					status <= 6;
					count <= 0;
					tag <=0;
				end
				else  begin
					status <=0;
					count<= 0;
					flag <=0;
					tag <=0;
				end
			end
			5:begin
				if(count <=7&&is_h(char))begin
					status <= 5;
					count <= count+1;
				end
				else if((count==8)&&char==" ")begin
					status <= 5;
				end
				else if(count==8&&char=="<")begin
					status<=6;
					count <= 0;
				end
				else  begin
					status <=0;
					count<= 0;
					flag <= 0;
				end
			end
			6:begin
				if(char=="=")status <= 7;
				else  begin
					status <=0;
					flag <= 0;
				end
			end
			7:begin
				if(char==" "&&count==0)status<=7;
				else if(count<=7&&is_h(char))begin
					status <=7;
					count<= count+1;
				end
				else if(count==8&&char=="#")begin
					status<=8;
					count<=0;
				end
				else begin
					status <=0;
					count<= 0;
					flag <= 0;
				end
			end
			8:begin
				if(char=="^")begin
					status<=1;
					flag<=0;
				end
				else begin
					status<=0;
					flag<=0;
				end
			end
		endcase
	end
end
assign format_type = (status==8)?flag:0;
endmodule
