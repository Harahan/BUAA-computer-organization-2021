`timescale 1ns / 1ps


//D
//D_NPC
`define ns_pc4 3'd0
`define ns_j 3'd1
`define ns_rs 3'd2
`define ns_b 3'd3
`define ns_bonall 3'd4 // bonall

//D_CMP
`define cmp_beq 3'd0
`define cmp_bne 3'd1
`define cmp_blez 3'd2
`define cmp_bgez 3'd3
`define cmp_bltz 3'd4
`define cmp_bgtz 3'd5
`define cmp_bonall 3'd6// bonall

//GRF
`define gwd_alu 3'd0
`define gwd_dm 3'd1
`define gwd_pc8 3'd2



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
`define alu_clz 5'd12

`define alu_a_rs 2'b0
`define alu_a_rt 2'b1

`define alu_b_rt 3'd0
`define alu_b_ext 3'd1
`define alu_b_rs_4_0 3'd2
`define alu_b_shamt 3'd3



//M
//M_DM
`define dm_w 3'd0
`define dm_h 3'd1
`define dm_b 3'd2
`define dm_hu 3'd3
`define dm_bu 3'd4
`define dm_lrm 3'd5
`define dm_lhw 3'd6 // lhw



//CTRL
`define op_r 6'h0
`define func_addu 6'h21
`define func_subu 6'h23
`define func_jr 6'h8
`define func_sll 6'h0

`define op_r_2 6'h1c



`define op_lw 6'h23
`define op_sw 6'h2b

`define op_beq 6'h4
`define op_bltzal 6'h1//conditionally!!!
`define rt_bltzal 5'h10


`define op_j 6'h2
`define op_jal 6'h3

`define op_lui 6'hf
`define op_ori 6'hd

`define func_clz 6'h20//clz
`define op_bonall 6'h5// bonall == bne
`define op_lrm 6'h3f  // lrm
`define op_lhw 6'h21  // lhw =lh