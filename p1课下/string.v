`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:31:05 10/21/2021 
// Design Name: 
// Module Name:    string 
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
module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
	 reg [3:0] status;
	 initial begin
	 status <= 0;
	 end
	 always@(posedge clk or posedge clr)begin
		if(clr)status <= 0;
		else begin
			case(status)
				0:status <= ("0" <= in && in <= "9")? 1 : 2;
				1:status <= ("0" <= in && in <= "9")? 2 : 3;
				2:status <= 2;
				3:status <= ("0" <= in && in <= "9")? 1 : 2;
			endcase
		end
	 end
assign out = (status == 1)? 1 : 0;


endmodule
