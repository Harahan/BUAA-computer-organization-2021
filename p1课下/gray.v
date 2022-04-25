`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:48 10/21/2021 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output [2:0] Output,
    output Overflow
    );
	 reg [3:0] count,status,over_flow;
	 initial begin
		count = 0;
		status = 0;
		over_flow = 0;
	end
	 always@(posedge Clk)begin
		if(Reset)begin
			status <= 0;
			over_flow <= 0;
			count <= 0;
		end
		else if(En)begin
			case(status)
				0:if(count < 6)
						count <= count + 1;
					else begin
						count <= count + 1;
						status <= 1;
					end
				1:begin
					over_flow <= 1;
					status <= 0;
					count <= 0;
				end
			endcase
		end
	 end
assign Overflow = over_flow;
assign Output = {count[2],count[1:0]^(count[2:1])};

endmodule
