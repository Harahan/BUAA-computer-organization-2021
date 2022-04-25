`timescale 1ns / 1ps

module id_fsm(
    input [7:0] char,
    input clk,
    output reg out
    );
reg [64:0] sum;
initial begin
	sum=0;
end
always @(posedge clk) begin
	if((65 <= char && char <= 90)||(97 <= char && char <= 122)) begin
		sum <= 1;
		out <= 0;
		end
	else if((sum == 1)&&(char >= 48 && char <= 57)) begin
		out <= 1;
	end
	else begin
		sum <= 0;
		out <= 0;
	end
end

endmodule
