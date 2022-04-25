`timescale 1ns / 1ps
`include "const.v"
`define wd dm[dwa[13:2]]//word
`define bt `wd[7 + 8*dwa[1:0]-:8]
`define hf `wd[15 + 16*dwa[1]-:16]
`define sign_bt `wd[7 + 8*dwa[1:0]]
`define sign_hf `wd[15 + 16*dwa[1]]


module M_DM(
    input clk,
    input reset,
    input dwe,
    output [31:0] dm_out,
	 output reg ch_lhw,//lhw
	 output [4:0] lrm_a,//lrm
    input [2:0] dm_sel,
    input [31:0] dwd,//dm_write_data
    input [31:0] dwa,//dm_write_address
	 input [31:0] M_pc // for test
    );
	 reg [31:0] dm[3071:0];

	 
	 //for test
	 function [31:0]out_hf;
		input [31:0] wd;
		input [31:0] dwd;
		begin
			out_hf = wd;
			out_hf[15 + 16*dwa[1]-:16] = dwd[15:0];
		end
	 endfunction
	 
	 function [31:0]out_bt;
		input [31:0] wd;
		input [31:0] dwd;
		begin
			out_bt = wd;
			out_bt[7 + 8*dwa[1:0]-:8] = dwd[7:0];
		end
	 endfunction
	 
	 wire [15:0] h = `hf;//lhw
	 reg [4:0] z = 5'b0;
	 reg [4:0] o = 5'b0;
	 integer j;
	 always@(*)begin
		o = 0;
		z = 0;
		for(j = 0 ; j < 16; j = j + 1)begin
			if(h[j] == 1'b0) z = z + 1;
			else o = o + 1;
		end
		if(o > z)ch_lhw = 1;
		else ch_lhw = 0;
	 end
	 
	 assign dm_out = (dm_sel == `dm_w)? `wd:
						  (dm_sel == `dm_h)? {{16{`sign_hf}}, `hf}:
						  (dm_sel == `dm_b)? {{24{`sign_bt}}, `bt}:
						  (dm_sel == `dm_hu)? {{16{1'b0}}, `hf}:
						  (dm_sel == `dm_bu)? {{24{1'b0}}, `bt}:
						  (dm_sel == `dm_lrm)? dwd :// lrm
						  32'b0;
	
	assign lrm_a = `wd[4:0];//lrm
						  
	 integer i;
	 always@(posedge clk)begin
		if(reset)begin
			for(i = 0; i < 3072; i = i + 1)
				dm[i] <= 0;
		end
		else if(dwe)begin
			if(dm_sel == `dm_w)begin
				`wd <= dwd;
				 $display("%d@%h: *%h <= %h", $time, M_pc, dwa, dwd);
			end
			else if(dm_sel == `dm_h)begin
				`hf <= dwd[15:0];
				$display("%d@%h: *%h <= %h", $time, M_pc, {dwa[31:2],2'b0}, out_hf(`wd, dwd));
			end
			else if(dm_sel == `dm_b)begin
				`bt <= dwd[7:0];
				$display("%d@%h: *%h <= %h", $time, M_pc, {dwa[31:2],2'b0}, out_bt(`wd, dwd));
			end
		end
	 end
						  
endmodule	 
	
//`default_nettype none
