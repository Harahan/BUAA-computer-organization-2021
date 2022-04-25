`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:49:14 10/27/2021 
// Design Name: 
// Module Name:    cscore 
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
module cscore(
    input [7:0] char,
    input reset,
    input clk,
    output out
    );
	 function is_c;
	 input [7:0] char;
	 is_c = (char=="c"||char=="C")?1:0;
	 endfunction
	 
	 function is_s;
	 input [7:0] char;
	 is_s = (char=="s"||char=="S")?1:0;
	 endfunction
	 
	 function is_o;
	 input [7:0] char;
	 is_o = (char=="o"||char=="O")?1:0;
	 endfunction
	
	 function is_r;
	 input [7:0] char;
	 is_r = (char=="R"||char=="r")?1:0;
	 endfunction
	 function is_e;
	 input [7:0] char;
	 is_e = (char=="e"||char=="E")?1:0;
	 endfunction
	 reg [31:0]status;
	 always@(posedge clk or posedge reset)begin
		if(reset)status <= 0;
		else begin
			case(status)
				0:if(is_c(char))status<=1;
				else status <=0;
				1:if(is_s(char))status<=2;
				else if(is_c(char))status<=1;
				else status<=0;
				2:if(is_c(char))status<=3;
				else status<=0;
				3:if(is_o(char))status<=4;
				else if(is_s(char))status<=2;
				else if(is_c(char))status<=1;
				else status<=0;
				4:if(is_r(char))status<=5;
				else if(is_c(char))status<=1;
				else status<=0;
				5:if(is_e(char))status<=6;
				else if(is_c(char))status<=1;
				else status<=0;
				6:if(is_c(char))status<=1;
				else status <=0;
			endcase
		end
	end
	assign out =(status==6)?1:0;
endmodule
