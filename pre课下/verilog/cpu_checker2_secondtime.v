`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:16:00 10/26/2021 
// Design Name: 
// Module Name:    cpu_checker2_secondtime 
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
    input [15:0] freq,
    output [1:0] format_type,
    output [3:0] error_code
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
reg [31:0] time_error,pc_error,addr_error,grf_error;
reg  T,P,A,G;
always@(posedge clk)begin
	if(reset)begin
		status <= 0;
		count <= 0;
		flag <= 0;
		tag <=0;
		time_error <= 0;
		pc_error <= 0;
		addr_error <= 0;
		grf_error <= 0;
		T <= 0;
		P <= 0;
		G <= 0;
		A <= 0;
	end
	else begin
		case(status)
			0: if(char=="^")begin
				status <= 1;
				time_error <= 0;
				pc_error <= 0;
				addr_error <= 0;
				grf_error <= 0;
				T <= 0;
				P <= 0;
				G <= 0;
				A <= 0;
			end
			1: begin
				if(count<=3&&is_d(char))begin
					status <= 1;
					count <= count +1;
					time_error <= (time_error << 3)+(time_error << 1)+char - "0";
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
					pc_error <= (pc_error << 4)+ ((is_d(char))?(char -"0"):(char - "a"+10));
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
				else if( char ==8'd42)begin 
					status <= 5;
					flag <= 2;
				end
				else status <= 0;
			end
			4:begin
				if(count<=3&&is_d(char)&& tag==0)begin//小心
					status <= 4;
					count<= count +1;
					grf_error <= (grf_error << 3)+(grf_error << 1)+char - "0";
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
					addr_error <= (addr_error << 4)+ ((is_d(char))?(char -"0"):(char - "a"+10));
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
					T <=((time_error & ((freq>>1)-1))==0)?0:1;
					P <=(((pc_error & 3)==0)&&3000 <= pc_error && pc_error <=32'h0000_4fff)?0:1;
					A <=((((addr_error & 3)==0)&&0 <= addr_error && addr_error <=32'h0000_2fff)||(flag== 1))?0:1;
					G <=((grf_error<= 31&&grf_error>=0)||(flag == 2))?0:1;
				end
				else begin
					status <=0;
					count<= 0;
					flag <= 0;
				end
			end
			8:begin
				if(char=="^")begin
					time_error <= 0;
					pc_error <= 0;
					addr_error <= 0;
					grf_error <= 0;
					status<=1;
					flag<=0;
					T <= 0;
					P <= 0;
					G <= 0;
					A <= 0;
				end
				else begin
					status<=0;
					flag<=0;
					T <= 0;
					P <= 0;
					G <= 0;//注意清0，复位
					A <= 0;
				end
			end
		endcase
	end
end
assign format_type = (status==8)?flag:0;
assign error_code = {G,A,P,T};
endmodule



