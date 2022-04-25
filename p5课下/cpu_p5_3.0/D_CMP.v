`timescale 1ns / 1ps
`include "const.v"


module D_CMP(
    input [31:0] rs_d,
    input [31:0] rt_d,
    input [2:0] type,
	 /*output cmp_clear,*/
    output [0:0] b_j
    );
	 
	 wire eq = (rs_d == rt_d)?1:0;
	 wire ez = (rs_d == 0)?1:0;
	 wire lz = !ez && rs_d[31];
	 wire gz = !ez && !rs_d[31];
	 
	 //
	 wire [32:0]res;
	 wire bonall;
	 assign res = {rs_d[31], rs_d} + {rt_d[31], rt_d};
	 assign bonall = (res == 33'b0)? 1: 0;
	 //
	 
	 assign b_j = (type == `cmp_beq & eq) | (type == `cmp_bne & !eq) | (type == `cmp_blez & (ez | lz)) |
					  (type == `cmp_bgez & (ez | gz)) | (type == `cmp_bltz & lz) | (type == `cmp_bgtz & gz)|(type ==
					  `cmp_bonall & bonall);// bonall
		

endmodule
