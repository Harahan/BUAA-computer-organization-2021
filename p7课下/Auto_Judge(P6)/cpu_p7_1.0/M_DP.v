`timescale 1ns / 1ps
`include "const.v"
`define start_dm 32'h0000_0000
`define end_dm 32'h0000_2fff
`define start_tc1 32'h0000_7f00
`define end_tc1 32'h0000_7f0b
`define start_tc2 32'h0000_7f10
`define end_tc2 32'h0000_7f1b


module M_DP(
    input load,
    input ex_ov_dm,
    output ex_adel,//load
    input [31:0] dm_temp,
    input [2:0] dp_sel,
    input [31:0] dwa,
	input [31:0] dp_a,
    output [31:0] dm_out
    );
	 wire[31:0] word = dm_temp;
	 
    wire[15:0] hf = word[15 + dp_a[1]*16-: 16];
	 
    wire[7:0] bt = word[7 + dp_a[1:0]*8-: 8];
	 
    wire sign_hf = word[15 + dp_a[1]*16];
	 
    wire sign_bt = word[7 + dp_a[1:0]*8];
	 
	 assign dm_out =    (dp_sel == `dp_w)? word :
                        (dp_sel == `dp_h)? {{16{sign_hf}}, hf} :
                        (dp_sel == `dp_b)? {{24{sign_bt}}, bt} :
                        (dp_sel == `dp_hu)? {{16{1'b0}}, hf} :
                        (dp_sel == `dp_bu)? {{24{1'b0}}, bt} :
                        word;

    //error: address alignment
    wire err_align =    ((dp_sel == `dp_w) && (|dwa[1:0])) ||
					    (((dp_sel == `dp_h) || (dp_sel == `dp_hu))&& (dwa[0]));
    //error: out of range
    wire err_out_of_range = !(((dwa >= `start_dm) && (dwa <= `end_dm)) ||
							((dwa >= `start_tc1) && (dwa <= `end_tc1)) ||
							((dwa >= `start_tc2) && (dwa <= `end_tc2)));
	//error: lh, lb can't be done in timer 
	wire err_timer = (dp_sel != `dp_w) && (dwa >= `start_tc1);
	
	assign ex_adel = load && (err_align || err_out_of_range || ex_ov_dm || err_timer);

endmodule
