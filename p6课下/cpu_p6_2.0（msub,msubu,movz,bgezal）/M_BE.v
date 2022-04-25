`timescale 1ns / 1ps
`include "const.v"


module M_BE(
    input [31:0] dwa,
	 input [31:0] dwd_temp,
    input [2:0] be_sel,
    output [3:0] byteen,
	 output [31:0] dwd
    );
	 
	 wire [4:0] wd = 4'b1111;// becarefure [4:0]
	 
	 wire [4:0] hf = (dwa[1] == 1'b1)? 4'b1100 : 
				         4'b0011;
				  
	 wire [4:0] bt = (dwa[1:0] == 2'b00)? 4'b0001 :
				        (dwa[1:0] == 2'b01)? 4'b0010 :
				        (dwa[1:0] == 2'b10)? 4'b0100 :
				        4'b1000;
	 
	 assign byteen = (be_sel == `be_w)? wd :
						  (be_sel == `be_h)? hf :
						  (be_sel == `be_b)? bt :
						  4'b0;
						  
	reg[31:0] word = 32'b0 ;

	always@(*)begin
		if(be_sel == `be_w) word = dwd_temp;
		else if(be_sel == `be_h) word[15 + 16*dwa[1]-: 16] = dwd_temp[15:0];
		else word[7 + 8*dwa[1:0]-: 8] = dwd_temp[7:0];
	end
						  
	assign dwd = word; 
	
endmodule
