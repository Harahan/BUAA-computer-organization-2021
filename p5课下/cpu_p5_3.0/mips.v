`timescale 1ns / 1ps
`include "const.v"

module mips(
    input clk,
    input reset
    );
	 
	 wire pwe = !stall;
	 wire D_we = !stall, E_we = 1'b1, M_we = 1'b1, W_we = 1'b1;//D\E\M\W reg_we
	 wire E_reset = stall;
	 wire [31:0] fw_E_wd, fw_M_wd, fw_W_wd;
	 wire stall;
	 
	 SU su(
    .D_instr(D_instr), 
    .E_instr(E_instr), 
    .M_instr(M_instr), 
    .stall(stall) //O
    );
	 
	 
	 assign fw_E_wd = (E_gwd_sel == `gwd_pc8)? E_pc + 8:
							32'd0;
							
	 assign fw_M_wd = (M_gwd_sel == `gwd_alu)? M_alu_out:
							(M_gwd_sel == `gwd_pc8)? M_pc + 8:
							32'd0;
							
	 assign fw_W_wd = (W_gwd_sel == `gwd_alu)? W_alu_out:
							(W_gwd_sel == `gwd_dm)? W_dm_out:
							(W_gwd_sel == `gwd_pc8)? W_pc + 8:
							32'd0;
	 
	 /*********************F**********************/
	 
	 wire [31:0] F_pc, F_instr;
	 
	 F_PC f_pc (
    .npc(D_npc), 
    .pc(F_pc),// O 
    .pwe(pwe),
    .reset(reset), 
    .clk(clk)
    );
	 
	 F_IM f_im (
    .PC(F_pc), 
    .instr(F_instr) // O
    );

	 /*********************D**********************/
	 
	 wire [31:0] D_pc, D_instr, D_ext_out, D_rs_d, D_rt_d, D_npc;
	 wire [4:0] D_rs, D_rt, D_rd;
	 wire [15:0] D_imm16;
	 wire [25:0] D_imm26;
	 wire [2:0] D_type, D_npc_sel;
	 wire D_ext_sel, D_b_j, D_flush; //bonall
	 
	 
	 D_REG d_reg (
    .reset(reset| (D_flush && D_we)), // bonall
    .clk(clk), 
    .we(D_we), 
    .instr_in(F_instr), 
    .instr_out(D_instr), // O
    .pc_in(F_pc), 
    .pc_out(D_pc)// O
    );
	 
	 CTRL d_ctrl (
    .instr(D_instr), 
	 .b_j(D_b_j),
    .rs(D_rs), // O
    .rt(D_rt), // O 
    .rd(D_rd), // O
    .imm16(D_imm16), //O 
    .imm26(D_imm26), // O
    .type(D_type), // O
    .ext_sel(D_ext_sel), // O 
    .npc_sel(D_npc_sel), // O
	 .flush(D_flush) // O bonall
    );
	 
	 //fw
	 wire[31:0] fw_D_rs_d, fw_D_rt_d;
	 
	 assign fw_D_rs_d = (D_rs == 0)? 0:
							(D_rs == E_gwa_res)? fw_E_wd:
							(D_rs == M_gwa_res)? fw_M_wd:
							 D_rs_d;
	 assign fw_D_rt_d = (D_rt == 0)? 0:
						     (D_rt == E_gwa_res)? fw_E_wd:
						     (D_rt == M_gwa_res)? fw_M_wd:
							   D_rt_d;
							

	 D_CMP d_cmp (
    .rs_d(fw_D_rs_d), //转发接收
    .rt_d(fw_D_rt_d), //转发接收
    .type(D_type), 
    .b_j(D_b_j)// O
    );
	 
	 D_EXT d_ext (
    .imm16(D_imm16), 
    .ext_sel(D_ext_sel), 
    .ext_out(D_ext_out)// O
    );
	 
	 D_GRF d_grf (//内部转发解决
    .rs(D_rs), 
    .rt(D_rt), 
    .gwa(W_gwa_res), 
    .gwd(fw_W_wd), 
    .rs_d(D_rs_d), // O
    .rt_d(D_rt_d), // O
    .gwe(W_gwe), 
    .reset(reset), 
    .clk(clk), 
    .W_pc(W_pc)
    );
	 
	 D_NPC d_npc (
    .D_pc(D_pc), 
    .F_pc(F_pc), 
    .imm26(D_imm26), 
    .imm16(D_imm16), 
    .rs_d(fw_D_rs_d), //转发接收
    .npc_sel(D_npc_sel), 
    .b_j(D_b_j), 
    .npc(D_npc)// O
    );
	 
	 /*********************E**********************/
	 
	 wire [31:0] E_pc, E_ext_out, E_rs_d, E_rt_d, E_instr, E_alu_out, E_alu_a, E_alu_b;
	 wire [4:0] E_rs, E_rt, E_rd, E_shamt, E_alu_sel, E_gwa_res;
	 wire [2:0] E_alu_b_sel, E_gwd_sel;
	 wire [1:0] E_alu_a_sel;
	 wire E_b_j;
	 
	 E_REG e_reg (
    .reset(reset | E_reset), 
    .clk(clk), 
    .we(E_we), 
    .instr_in(D_instr), 
    .instr_out(E_instr), // O
    .pc_in(D_pc), 
    .pc_out(E_pc), // O 
    .ext_in(D_ext_out), 
    .ext_out(E_ext_out), // O
    .rs_d_in(fw_D_rs_d), 
    .rs_d_out(E_rs_d), // O
    .rt_d_in(fw_D_rt_d), 
    .rt_d_out(E_rt_d), // O
	 .b_j_in(D_b_j),
	 .b_j_out(E_b_j)
    );
	 
	 CTRL e_ctrl (
    .instr(E_instr), 
	 .b_j(E_b_j),
    .rs(E_rs), // O
    .rt(E_rt),  // O
	 .rd(E_rd), // O
    .shamt(E_shamt), // O 
    .alu_sel(E_alu_sel), // O
    .alu_a_sel(E_alu_a_sel), // O
    .alu_b_sel(E_alu_b_sel), // O
	 .gwa_res(E_gwa_res), // O 
    .gwd_sel(E_gwd_sel) // O
    );
	 
	 //fw
	  wire[31:0] fw_E_rs_d, fw_E_rt_d;
	 
	 assign fw_E_rs_d = (E_rs == 0)? 0:
							  (E_rs == M_gwa_res)? fw_M_wd:
							  (E_rs == W_gwa_res)? fw_W_wd:
							   E_rs_d;
								
	 assign fw_E_rt_d = (E_rt == 0)? 0:
						     (E_rt == M_gwa_res)? fw_M_wd:
						     (E_rt == W_gwa_res)? fw_W_wd:
							   E_rt_d;
								
	 assign E_alu_a = (E_alu_a_sel == `alu_a_rt)? fw_E_rt_d:
							(E_alu_a_sel == `alu_a_rs)? fw_E_rs_d:
							32'b0;
							
	  assign E_alu_b = (E_alu_b_sel == `alu_b_rt)? fw_E_rt_d:
	                   (E_alu_b_sel == `alu_b_ext)? E_ext_out:
							 (E_alu_b_sel == `alu_b_rs_4_0)? {27'b0, fw_E_rs_d[4:0]}:
							 (E_alu_b_sel == `alu_b_shamt)? {27'b0, E_shamt}:
							  32'b0;
	 
	 E_ALU e_alu (
    .a(E_alu_a), //转发接收
    .b(E_alu_b), //转发接收
    .alu_out(E_alu_out), // O
    .alu_sel(E_alu_sel)
    );
	 
	 /*********************M**********************/
	 
	 wire [31:0] M_instr, M_pc, M_alu_out, M_rt_d, M_dm_out;
	 wire [4:0] M_rs, M_rt, M_rd, M_gwa_res, M_lrm_a;//lrm
	 wire [2:0] M_dm_sel, M_gwd_sel;
	 wire M_dwe, M_ch_lhw;//lhw
	 wire M_b_j;
	 
	 M_REG m_reg (
    .reset(reset), 
    .clk(clk), 
    .we(M_we), 
    .instr_in(E_instr), 
    .instr_out(M_instr), // O
    .pc_in(E_pc), 
    .pc_out(M_pc), // O
    .alu_in(E_alu_out), 
    .alu_out(M_alu_out), // O
    .rt_d_in(fw_E_rt_d), 
    .rt_d_out(M_rt_d), // O
	 .b_j_in(E_b_j),
	 .b_j_out(M_b_j)
    );
	 
	 CTRL m_ctrl (
    .instr(M_instr),
	 .b_j(M_b_j),
	 .lrm_a(M_lrm_a),//lrm
	 .ch_lhw(M_ch_lhw),//lhw
    .rs(M_rs), // O
    .rt(M_rt),  // O
	 .rd(M_rd), // O	 
    .dwe(M_dwe), // O
    .dm_sel(M_dm_sel), // O
	 .gwa_res(M_gwa_res), // O 
    .gwd_sel(M_gwd_sel) // O
    );
	 
	 //fw
	 wire[31:0]fw_M_rt_d;
	 
	 assign fw_M_rt_d = (M_rt == 0)? 0 :
							  (M_rt == W_gwa_res)? fw_W_wd :
							  M_rt_d;
							  
	 
	 M_DM m_dm (
    .clk(clk), 
    .reset(reset), 
    .dwe(M_dwe), 
    .dm_out(M_dm_out), // O
    .dm_sel(M_dm_sel), 
    .dwd(fw_M_rt_d), //转发接收
    .dwa(M_alu_out), 
	 .lrm_a(M_lrm_a),// O  lrm
	 .ch_lhw(M_ch_lhw),//O lhw
    .M_pc(M_pc)
    );

	 /*********************W**********************/
	 
	 wire[31:0] W_alu_out, W_pc, W_dm_out, W_instr;
	 wire [2:0] W_gwd_sel;
	 wire [4:0] W_gwa_res, W_lrm_a;//lrm
	 wire W_gwe;
	 wire W_b_j;
	 wire W_ch_lhw;//lhw
	 
	 W_REG w_reg (
    .reset(reset), 
    .clk(clk), 
    .we(W_we), 
    .alu_in(M_alu_out), 
    .alu_out(W_alu_out), // O
    .pc_in(M_pc), 
    .pc_out(W_pc), // O
    .dm_in(M_dm_out), 
    .dm_out(W_dm_out), // O
    .instr_in(M_instr), 
    .instr_out(W_instr), // O
	 .lrm_a_in(M_lrm_a),//lrm
	 .lrm_a_out(W_lrm_a),// O lrm
	 .ch_lhw_in(M_ch_lhw),//lhw
	 .ch_lhw_out(W_ch_lhw),// O lhw
	 .b_j_in(M_b_j),
	 .b_j_out(W_b_j)
    );
	 
	 CTRL w_ctrl (
    .instr(W_instr),
	 .b_j(W_b_j),
	 .lrm_a(W_lrm_a),//lrm
	 .ch_lhw(W_ch_lhw),//lhw
    .gwe(W_gwe), // O
    .gwa_res(W_gwa_res), // O 
    .gwd_sel(W_gwd_sel) // O
	 
    );


endmodule
