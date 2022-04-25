`timescale 1ns / 1ps
`include "const.v"
`define start_dm 32'h0000_0000
`define end_dm 32'h0000_2fff
`define start_tc1 32'h0000_7f00
`define end_tc1 32'h0000_7f0b
`define start_tc2 32'h0000_7f10
`define end_tc2 32'h0000_7f1b



module M_BE(
	input ex_ov_dm,
	output ex_ades,//store
    input [31:0] dwa,
	input store,
	input [31:0] dwd_temp,
    input [2:0] be_sel,
    output [3:0] byteen,
	output [31:0] dwd
    );
	 
	wire [4:0] wd = 4'b1111;// becareful [4:0]
	 
	wire [4:0] hf = (dwa[1] == 1'b1)? 4'b1100 : 
				    4'b0011;
				  
	wire [4:0] bt = (dwa[1:0] == 2'b00)? 4'b0001 :
					(dwa[1:0] == 2'b01)? 4'b0010 :
					(dwa[1:0] == 2'b10)? 4'b0100 :
					4'b1000;
	
	wire [3:0] temp_byteen = (be_sel == `be_w)? wd :
						     (be_sel == `be_h)? hf :
						     (be_sel == `be_b)? bt :
						     4'b0;

	assign byteen = (!ex_ades)? temp_byteen : 4'b0;
						  
	reg[31:0] word = 32'b0 ;

	always@(*)begin
		if(be_sel == `be_w) word = dwd_temp;
		else if(be_sel == `be_h) word[15 + 16*dwa[1]-: 16] = dwd_temp[15:0];
		else word[7 + 8*dwa[1:0]-: 8] = dwd_temp[7:0];
	end
						  
	assign dwd = word; 
	//error: address alignment
	wire err_align = ((be_sel == `be_w) && (|dwa[1:0])) ||
					((be_sel == `be_h) && (dwa[0]));
	//error: out of range
	wire err_out_of_range = !(((dwa >= `start_dm) && (dwa <= `end_dm)) ||
							((dwa >= `start_tc1) && (dwa <= `end_tc1)) ||
							((dwa >= `start_tc2) && (dwa <= `end_tc2)));
	//error: the mem[2] in timer can only be read
	wire err_save_timer = (dwa >= 32'h0000_7f08 && dwa <= 32'h0000_7f0b) ||
						  (dwa >= 32'h0000_7f18 && dwa <= 32'h0000_7f1b);
	//error: sh, sb can't be done in timer 
	wire err_timer = (be_sel != `be_w) && (dwa >= `start_tc1);
	
	assign ex_ades = store && (err_align || err_out_of_range || ex_ov_dm || err_timer || err_save_timer);
	
endmodule
