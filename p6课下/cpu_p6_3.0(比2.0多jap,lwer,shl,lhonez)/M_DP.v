`timescale 1ns / 1ps
`include "const.v"


module M_DP(
    input [31:0] dm_temp,
    input [2:0] dp_sel,
	 input [31:0] dp_a,
    output [31:0] dm_out,
	 output reg lhonez_ch
    );
	 wire[31:0] word = dm_temp;
	 
    wire[15:0] hf = word[15 + dp_a[1]*16-: 16];
	 
    wire[7:0] bt = word[7 + dp_a[1:0]*8-: 8];
	 
    wire sign_hf = word[15 + dp_a[1]*16];
	 
    wire sign_bt = word[7 + dp_a[1:0]*8];
	 
	 assign dm_out = (dp_sel == `dp_w)? word :
						  (dp_sel == `dp_h)? {{16{sign_hf}}, hf} :
						  (dp_sel == `dp_b)? {{24{sign_bt}}, bt} :
						  (dp_sel == `dp_hu)? {{16{1'b0}}, hf} :
						  (dp_sel == `dp_bu)? {{24{1'b0}}, bt} :
						  word;
						  
		integer i;
		reg [31:0] o = 0;
		reg [31:0] z = 0;
		always@(*)begin
			o = 0;
			z = 0;
			for(i = 0; i < 16; i = i + 1)begin
				if(hf[i] == 1'b1) o = o + 1;
				else z = z + 1;
			end
			if(o > z) lhonez_ch = 1'b1;
			else lhonez_ch = 1'b0;
		end


endmodule
