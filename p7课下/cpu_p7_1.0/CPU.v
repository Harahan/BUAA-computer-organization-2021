`timescale 1ns / 1ps
`include "const.v"
/*
`include "CTRL.v"
`include "D_CMP.v"
`include "D_EXT.v"
`include "D_GRF.v"
`include "D_NPC.v"
`include "D_REG.v"
`include "E_ALU.v"
`include "E_MDU.v"
`include "E_REG.v"
`include "F_PC.v"
`include "M_BE.v"
`include "M_DP.v"
`include "M_CP0.v"
`include "M_REG.v"
`include "SU.v"
`include "W_REG.v"
*/

module CPU(
    input clk,
    input reset,
    input [5:0] hwint,
    input [31:0] pr_rd,
    output pr_we,
    output [31:0] pr_a,
    output [31:0] pr_wd,
    output [31:0] M_pc_out,
	input [31:0] i_inst_rdata,//im
    input [31:0] m_data_rdata, 
    output [31:0] i_inst_addr,// im 
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
    );
	 
	 wire pwe = !stall;
	 wire D_we = !stall, E_we = 1'b1, M_we = 1'b1, W_we = 1'b1;//D\E\M\W reg_we
	 wire E_reset = stall;
	 wire [31:0] fw_E_wd, fw_M_wd, fw_W_wd;
	 wire stall, req;
	 
	 SU su(
    .D_instr(D_instr), 
    .E_instr(E_instr), 
    .M_instr(M_instr),
    .md_stall(E_md_stall),	 
    .stall(stall) //O
    );
	 
	 
	assign  fw_E_wd =   (E_gwd_sel == `gwd_pc8)? E_pc + 8:
							32'd0;
							
	assign  fw_M_wd =   (M_gwd_sel == `gwd_alu)? M_alu_out:
						(M_gwd_sel == `gwd_pc8)? M_pc + 8:
						(M_gwd_sel == `gwd_md)? M_md_out:
						32'd0;
							
	assign  fw_W_wd =   (W_gwd_sel == `gwd_alu)? W_alu_out:
						(W_gwd_sel == `gwd_dm)? W_dm_out:
						(W_gwd_sel == `gwd_pc8)? W_pc + 8:
						(W_gwd_sel == `gwd_md)? W_md_out:
                        (W_gwd_sel == `gwd_cp0)? W_cp0_out:
						32'd0;
	 
/********************************************************F**********************************************************/
	 
	 wire [31:0] F_pc, F_instr;
     wire [4:0] F_ex_code;
     wire F_ex_adel, F_bd;
	 
	 F_PC f_pc (
    .req(req),
    .eret(D_eret),
    .epc(M_epc),
    .ex_adel(F_ex_adel),// O
    .npc(D_npc), 
    .pc(F_pc),// O 
    .pwe(pwe),
    .reset(reset), 
    .clk(clk)
    );
	 
	//F_IM
	assign i_inst_addr = F_pc;
	 
	assign F_instr = (F_ex_adel)? 32'd0 : i_inst_rdata; // O

    // ex
    assign F_ex_code = (F_ex_adel)? `ex_adel : `ex_none;

    assign F_bd = (D_npc_sel != `ns_pc4);

/********************************************************D**********************************************************/	 
	 wire [31:0] D_pc, D_instr, D_ext_out, D_rs_d, D_rt_d, D_npc;
	 wire [4:0] D_rs, D_rt, D_rd, D_ex_code, D_ex_old_code;
	 wire [15:0] D_imm16;
	 wire [25:0] D_imm26;
	 wire [2:0] D_type, D_npc_sel;
	 wire D_ext_sel, D_b_j, D_eret, D_bd, D_ex_ri;
	 
	 
	 D_REG d_reg (
    .req(req),
    .ex_code_in(F_ex_code),
    .ex_code_out(D_ex_old_code), // O
    .bd_in(F_bd),
    .bd_out(D_bd), // O
    .reset(reset), 
    .clk(clk), 
    .we(D_we), 
    .instr_in(F_instr), 
    .instr_out(D_instr), // O
    .pc_in(F_pc), 
    .pc_out(D_pc)// O
    );
	 
	 CTRL d_ctrl (
    .instr(D_instr), 
    .rs(D_rs), // O
    .rt(D_rt), // O 
    .rd(D_rd), // O
    .imm16(D_imm16), //O 
    .imm26(D_imm26), // O
    .type(D_type), // O
    .ext_sel(D_ext_sel), // O 
    .npc_sel(D_npc_sel), // O
    .ex_ri(D_ex_ri), // O
    .eret(D_eret) // O
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
    .rs_d(fw_D_rs_d), //fw
    .rt_d(fw_D_rt_d), //fw
    .type(D_type), 
    .b_j(D_b_j)// O
    );
	 
	 D_EXT d_ext (
    .imm16(D_imm16), 
    .ext_sel(D_ext_sel), 
    .ext_out(D_ext_out)// O
    );
	 
	 D_GRF d_grf (//internal fw
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
	 
	 //for test
	 assign w_grf_we = W_gwe;
	 
	 assign w_grf_addr = W_gwa_res;
	 
	 assign w_grf_wdata = fw_W_wd;
	 
	 assign w_inst_addr = W_pc;
	 
	 D_NPC d_npc (
    .req(req),
    .eret(D_eret),
    .epc(M_epc),
    .D_pc(D_pc), 
    .F_pc(F_pc), 
    .imm26(D_imm26), 
    .imm16(D_imm16), 
    .rs_d(fw_D_rs_d), //fw
    .npc_sel(D_npc_sel), 
    .b_j(D_b_j), 
    .npc(D_npc)// O
    );

    //ex
    assign D_ex_code =  (D_ex_old_code)? D_ex_old_code :
                        (D_ex_ri)? `ex_ri :
                        `ex_none;
	 
/********************************************************E**********************************************************/
	 
	 wire [31:0] E_pc, E_ext_out, E_rs_d, E_rt_d, E_instr, E_alu_out, E_alu_a, E_alu_b, E_md_out;
	 wire [4:0] E_rs, E_rt, E_rd, E_shamt, E_alu_sel, E_gwa_res, E_ex_old_code, E_ex_code;
	 wire [3:0] E_md_sel;
	 wire [2:0] E_alu_b_sel, E_gwd_sel;
	 wire [1:0] E_alu_a_sel;
	 wire E_b_j, E_md_stall, E_bd, E_alu_ari_of, E_alu_dm_of, E_eret, E_ex_ov_ari, E_ex_ov_dm;
	 
	 E_REG e_reg (
    .req(req),
    .ex_code_in(D_ex_code),
    .ex_code_out(E_ex_old_code), // O
    .bd_in(D_bd),
    .bd_out(E_bd), // O
    .stall(stall),
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
	.b_j_out(E_b_j) //O
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
    .gwd_sel(E_gwd_sel), // O
	.md_sel(E_md_sel), // O
    .alu_ari_of(E_alu_ari_of), // O
    .alu_dm_of(E_alu_dm_of), // O
    .eret(E_eret) // O
    );
	 
	 //fw
	wire[31:0] fw_E_rs_d, fw_E_rt_d;
	 
	assign fw_E_rs_d =  (E_rs == 0)? 0:
						(E_rs == M_gwa_res)? fw_M_wd:
						(E_rs == W_gwa_res)? fw_W_wd:
						E_rs_d;
								
	assign fw_E_rt_d =  (E_rt == 0)? 0:
                        (E_rt == M_gwa_res)? fw_M_wd:
						(E_rt == W_gwa_res)? fw_W_wd:
						E_rt_d;
								
	assign E_alu_a =    (E_alu_a_sel == `alu_a_rt)? fw_E_rt_d:
					    (E_alu_a_sel == `alu_a_rs)? fw_E_rs_d:
						32'b0;
							
	assign E_alu_b =    (E_alu_b_sel == `alu_b_rt)? fw_E_rt_d:
	                    (E_alu_b_sel == `alu_b_ext)? E_ext_out:
						(E_alu_b_sel == `alu_b_rs_4_0)? {27'b0, fw_E_rs_d[4:0]}:
						(E_alu_b_sel == `alu_b_shamt)? {27'b0, E_shamt}:
						32'b0;
	 
	 E_ALU e_alu (
    .alu_ari_of(E_alu_ari_of),
    .alu_dm_of(E_alu_dm_of),
    .a(E_alu_a), //fw
    .b(E_alu_b), //fw
    .alu_out(E_alu_out), // O
    .alu_sel(E_alu_sel),
    .ex_ov_ari(E_ex_ov_ari), // O
    .ex_ov_dm(E_ex_ov_dm) // O
    );
	 
	 E_MDU e_mdu (
    .req(req),
    .clk(clk), 
    .reset(reset), 
    .d1(fw_E_rs_d), //fw
    .d2(fw_E_rt_d), //fw
    .md_sel(E_md_sel), 
    .md_stall(E_md_stall), // O
    .md_out(E_md_out) // O
    );

    //ex
    assign E_ex_code =  (E_ex_old_code)? E_ex_old_code :
                        (E_ex_ov_ari)? `ex_ov :
                        `ex_none;
	 
/********************************************************M**********************************************************/
	 	  
	 wire [31:0] M_epc, M_instr, M_pc, M_alu_out, M_rt_d, M_dm_out, M_dm_temp, M_md_out, be_out, M_cp0_out;
	 wire [4:0] M_rs, M_rt, M_rd, M_gwa_res, M_ex_old_code, M_ex_code;
	 wire [3:0] M_byteen;
	 wire [2:0]  M_be_sel, M_dp_sel, M_gwd_sel;
	 wire M_b_j, M_bd, M_ex_ov_dm, M_cwe, M_eret, M_load, M_store, M_ex_ades, E_int_en;
	 
	 M_REG m_reg (
    .req(req),
    .ex_code_in(E_ex_code),
    .ex_code_out(M_ex_old_code), // O
    .bd_in(E_bd), // O
    .bd_out(M_bd), // O
    .ex_ov_dm_in(E_ex_ov_dm),
    .ex_ov_dm_out(M_ex_ov_dm), // O
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
	.b_j_out(M_b_j),// O
	.md_in(E_md_out),
	.md_out(M_md_out) // O
    );
	 
	 CTRL m_ctrl (
    .instr(M_instr),
	.b_j(M_b_j),
    .rs(M_rs), // O
    .rt(M_rt),  // O
	.rd(M_rd), // O	 
    .be_sel(M_be_sel), // O
	.dp_sel(M_dp_sel),
	.gwa_res(M_gwa_res), // O 
    .gwd_sel(M_gwd_sel), // O
    .cwe(M_cwe), // O
    .eret(M_eret), // O
    .load(M_load), //O
    .store(M_store) // O
    );
	 
	 M_BE m_be (
    .ex_ov_dm(M_ex_ov_dm),
    .ex_ades(M_ex_ades), // O
    .store(M_store),
    .dwa(M_alu_out),
    .be_sel(M_be_sel),
    .dwd_temp(fw_M_rt_d),
    .byteen(M_byteen), // O
    .dwd(be_out) // O
	 );
	 
    //fw
    wire[31:0]fw_M_rt_d;
    
    assign fw_M_rt_d =  (M_rt == 0)? 0 :
                        (M_rt == W_gwa_res)? fw_W_wd :
                        M_rt_d;
                            
    //M_DM
    assign m_data_addr = (E_int_en)? 32'h0000_7f20 : M_alu_out; // dwa
    
    assign m_data_byteen = (E_int_en)? 1'b1 : M_byteen; //dwe and write where
    
    assign m_data_wdata = be_out; //dwd
    
    assign m_inst_addr = M_pc; //M_pc
    
    assign M_dm_temp = m_data_rdata;  // O
	 
	 M_DP m_dp(
    .load(M_load),
    .ex_ov_dm(M_ex_ov_dm), 
    .ex_adel(M_ex_adel), // O
    .dwa(M_alu_out),
    .dm_temp(M_dm_temp),
    .dp_sel(M_dp_sel),
    .dp_a(M_alu_out),
    .dm_out(M_dm_out) // O
	 );

    assign M_pc_out = M_pc;

    assign pr_we = (|M_byteen) & (!req) & (M_alu_out >= 32'h0000_7f00);

    assign pr_a = M_alu_out;

    assign pr_wd = fw_M_rt_d;

    M_CP0 m_cp0(
    .a1(M_rd),
    .a2(M_rd),
    .bd_in(M_bd),
    .cwd(fw_M_rt_d),
    .pc(M_pc),
    .ex_code_in(M_ex_code),
    .hwint(hwint),
    .cwe(M_cwe),
    .exl_clr(M_eret),
    .clk(clk),
    .reset(reset),
    .req(req), // O
    .epc_out(M_epc), // O
    .int_en(E_int_en), // O
    .cp0_out(M_cp0_out) // O
    );

    //ex
    assign M_ex_code =  (M_ex_old_code)? M_ex_old_code :
                        (M_ex_adel)? `ex_adel :
                        (M_ex_ades)? `ex_ades :
                        `ex_none;
	 
/********************************************************W**********************************************************/	 
	 wire[31:0] W_alu_out, W_pc, W_dm_out, W_instr, W_md_out, W_cp0_out;
	 wire [2:0] W_gwd_sel;
	 wire [4:0] W_gwa_res;
	 wire W_gwe;
	 wire W_b_j;
	 
	 W_REG w_reg (
    .req(req),
    .cp0_in(M_cp0_out),
    .cp0_out(W_cp0_out), // O
    .reset(reset), 
    .clk(clk), 
    .we(W_we), 
    .alu_in(M_alu_out), 
    .alu_out(W_alu_out), // O
    .pc_in(M_pc), 
    .pc_out(W_pc), // O
    .dm_in((M_alu_out >= 32'h0000_7f00) ? pr_rd : M_dm_out), 
    .dm_out(W_dm_out), // O
    .instr_in(M_instr), 
    .instr_out(W_instr), // O
    .b_j_in(M_b_j),
    .b_j_out(W_b_j), // O
    .md_in(M_md_out),
    .md_out(W_md_out) // O
    );
	 
	 CTRL w_ctrl (
    .instr(W_instr),
	.b_j(W_b_j),
    .gwe(W_gwe), // O
    .gwa_res(W_gwa_res), // O 
    .gwd_sel(W_gwd_sel) // O
	 
    );


endmodule
