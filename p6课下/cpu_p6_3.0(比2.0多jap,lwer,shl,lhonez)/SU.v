`timescale 1ns / 1ps
`include "const.v"

module SU(
	input [31:0] D_instr,
	input [31:0] E_instr,
	input [31:0] M_instr,
	input  md_stall,
	output stall
    );
	 
	 wire [2:0] Tuse_rs, Tuse_rt, Tnew_E, Tnew_M;
	 wire stall_rs_E, stall_rs_M, stall_rs, stall_rt_E, stall_rt_M, stall_rt, stall_hl;
	 
	  /*********************D**********************/
	  
	  wire [4:0] D_rs, D_rt;
	  wire D_load, D_store, D_count_i, D_count_r, D_branch, D_shifts, D_j_r, D_md, D_mt, D_mf, D_jap, D_lwer, D_shl, D_lhonez;
	  
	  CTRL D_ctrl (
    .instr(D_instr), 
    .rs(D_rs), 
    .rt(D_rt), 
    .load(D_load), 
    .store(D_store), 
    .count_i(D_count_i), 
    .count_r(D_count_r), 
    .branch(D_branch), 
    .shifts(D_shifts), //shfits��shiftv����count_r
    .j_r(D_j_r),
	 .md(D_md),
	 .mt(D_mt),
	 .mf(D_mf),
	 .jap(D_jap),
	 .lwer(D_lwer),
	 .shl(D_shl),
	 .lhonez(D_lhonez)
    );
	 
	 assign Tuse_rs = (D_branch | D_j_r)? 3'd0 :
							((D_count_r & !D_shifts) | D_count_i | D_load | D_store | D_mt | D_md | D_jap | D_lwer | D_lhonez)? 3'd1:
							3'd3;
	
	 assign Tuse_rt = (D_branch)? 3'd0:
						   (D_count_r | D_md)? 3'd1:
						   (D_store | D_lwer)? 3'd2:
						    3'd3;
	 
	 
	 /*********************E**********************/
	 
	 wire [4:0] E_rs, E_rt, E_gwa_res;
	 wire E_load, E_count_i, E_count_r, E_mf, E_jap, E_lwer, E_lhonez;
	  
	  CTRL E_ctrl (
    .instr(E_instr), 
    .rs(E_rs), 
    .rt(E_rt), 
    .load(E_load),  
    .count_i(E_count_i), 
    .count_r(E_count_r),
	 .gwa_res(E_gwa_res),
	 .mf(E_mf),
	 .jap(E_jap),
	 .lwer(E_lwer),
	 .lhonez(E_lhonez)
    );
	 
	 assign Tnew_E = (E_count_i | E_count_r | E_mf | E_jap)? 3'd1:
						  (E_load | E_lwer | E_lhonez)? 3'd2:
						  3'd0;
	 
	 
	 /*********************M**********************/
	 
	 wire [4:0] M_rs, M_rt, M_gwa_res;
	 wire M_load, M_lwer, M_lhonez;
	  
	  CTRL M_ctrl (
    .instr(M_instr), 
    .rs(M_rs), 
    .rt(M_rt), 
    .load(M_load),
	 .gwa_res(M_gwa_res),
	 .lwer(M_lwer),
	 .lhonez(M_lhonez)
    );
	 
	 assign Tnew_M = (M_load | M_lwer | M_lhonez)? 3'd1:
							3'd0;
							
	/*********************************************stall**************************************************/	

	assign stall_rs_E = (Tuse_rs < Tnew_E)&&(D_rs != 5'd0 && D_rs == E_gwa_res);
	assign stall_rs_M = (Tuse_rs < Tnew_M)&&(D_rs != 5'd0 && D_rs == M_gwa_res);
	assign stall_rs = stall_rs_E | stall_rs_M | 0;
	
	assign stall_rt_E = (Tuse_rt < Tnew_E)&&(D_rt != 5'd0 && D_rt == E_gwa_res);
	assign stall_rt_M = (Tuse_rt < Tnew_M)&&(D_rt != 5'd0 && D_rt == M_gwa_res);
	assign stall_rt = stall_rt_E | stall_rt_M | 0;
	
	assign stall_hl = md_stall && (D_mf | D_md | D_mt | D_shl);
	
	assign stall_lwer = (E_lwer && (((D_rs[0] == 5'd0) && (D_rs != 5'd0) && (Tuse_rs < Tnew_E)) || ((D_rt[0] == 5'd0) && (D_rt != 5'd0) && (Tuse_rt < Tnew_E))));
	
	assign stall_lhonez = (E_lhonez && (((D_rs == E_rt || D_rs == 5'd31) && (D_rs != 5'd0) && (Tuse_rs < Tnew_E)) || ((D_rt == E_rt || D_rt == 5'd31) && (D_rs != 5'd0) && (Tuse_rt < Tnew_E))));
	
	assign stall = stall_rs | stall_rt | stall_hl | stall_lwer | stall_lhonez;
	
endmodule						
