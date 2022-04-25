`timescale 1ns / 1ps


//D
//D_NPC
`define ns_pc4 3'd0
`define ns_j 3'd1
`define ns_rs 3'd2
`define ns_b 3'd3


//D_CMP
`define cmp_beq 3'd0
`define cmp_bne 3'd1
`define cmp_blez 3'd2
`define cmp_bgez 3'd3
`define cmp_bltz 3'd4
`define cmp_bgtz 3'd5

//GRF
`define gwd_alu 3'd0
`define gwd_dm 3'd1
`define gwd_pc8 3'd2
`define gwd_md 3'd3
`define gwd_cp0 3'd4



//E
//E_ALU
`define alu_add 5'd0
`define alu_sub 5'd1
`define alu_or 5'd2
`define alu_and 5'd3
`define alu_xor 5'd4
`define alu_nor 5'd5
`define alu_sll 5'd6
`define alu_srl 5'd7
`define alu_sra 5'd8
`define alu_slt 5'd9
`define alu_sltu 5'd10
`define alu_lui 5'd11

`define alu_a_rs 2'b0
`define alu_a_rt 2'b1

`define alu_b_rt 3'd0
`define alu_b_ext 3'd1
`define alu_b_rs_4_0 3'd2
`define alu_b_shamt 3'd3

//MDU
`define md_mult 4'd0
`define md_multu 4'd1
`define md_div 4'd2
`define md_divu 4'd3
`define md_mfhi 4'd4
`define md_mflo 4'd5
`define md_mthi 4'd6
`define md_mtlo 4'd7
`define md_none 4'd8

//M
//M_BE
`define be_w 3'd0
`define be_h 3'd1
`define be_b 3'd2
`define be_none 3'd3

//M_DP
`define dp_w 3'd0
`define dp_h 3'd1
`define dp_hu 3'd2
`define dp_b 3'd3
`define dp_bu 3'd4



//CTRL
`define op_r 6'h0
`define func_mult 6'h18
`define func_multu 6'h19
`define func_div 6'h1a
`define func_divu 6'h1b
`define func_add 6'h20
`define func_addu 6'h21
`define func_sub 6'h22
`define func_subu 6'h23
`define func_and 6'h24
`define func_or 6'h25
`define func_xor 6'h26
`define func_nor 6'h27 
`define func_slt 6'h2a
`define func_sltu 6'h2b

`define func_mfhi 6'h10
`define func_mflo 6'h12
`define func_mthi 6'h11
`define func_mtlo 6'h13


`define func_jr 6'h8
`define func_jalr 6'h9

`define func_sll 6'h0
`define func_srl 6'h2
`define func_sra 6'h3
`define func_sllv 6'h4
`define func_srlv 6'h6
`define func_srav 6'h7



`define op_lb 6'h20
`define op_lh 6'h21
`define op_lw 6'h23
`define op_lbu 6'h24
`define op_lhu 6'h25

`define op_sb 6'h28
`define op_sh 6'h29
`define op_sw 6'h2b

`define rt_bltz 5'h0
`define rt_bgez 5'h1
`define op_bltz 6'h1
`define op_bgez 6'h1


`define op_beq 6'h4
`define op_bne 6'h5
`define op_blez 6'h6
`define op_bgtz 6'h7
 
`define op_j 6'h2
`define op_jal 6'h3

`define op_addi 6'h8
`define op_addiu 6'h9
`define op_andi 6'hc
`define op_ori 6'hd
`define op_xori 6'he
`define op_lui 6'hf
`define op_slti 6'ha
`define op_sltiu 6'hb

`define op_cop0 6'h10
`define func_eret 6'h18

//exc
`define ex_int 5'd0
`define ex_adel 5'd4
`define ex_ades 5'd5
`define ex_ri 5'd10
`define ex_ov 5'd12
`define ex_none 5'd0

