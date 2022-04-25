`timescale 1ns / 1ps
`include "const.v"


module D_GRF(
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] gwa,//grf_write_address
    input [31:0] gwd,//grf_write_data
    output [31:0] rs_d,
    output [31:0] rt_d,
    input gwe,//grf_write_enable
    input reset,
    input clk,
	 input [31:0] W_pc
    );
	reg [31:0] grf [31:0];
	integer i;
	
	//内部转发
	assign rs_d = (gwa == rs && gwa && gwe)? gwd : grf[rs];
	assign rt_d = (gwa == rt && gwa && gwe)? gwd : grf[rt];
	
	always@(posedge clk)begin
		if(reset)begin
			for(i = 0; i < 32; i = i + 1)
				grf[i] <= 0;
		end
		else if(gwe)begin
			if(gwa != 0)begin//$0 == 0
				grf[gwa] <= gwd;
				$display("%d@%h: $%d <= %h", $time, W_pc, gwa, gwd);
			end
		end
	end

endmodule

