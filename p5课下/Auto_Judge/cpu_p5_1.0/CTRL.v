`timescale 1ns / 1ps
`include "const.v"


module CTRL(
    input [31:0] instr,
	 //decode
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [15:0] imm16,
    output [25:0] imm26,
	 output [4:0] shamt,
	 //classify
	 output load,
	 output store,
	 output count_i,
	 output count_r,
	 output branch,
	 output shifts,
	 output shiftv,
	 output j_r,
	 output j_i,
	 output j_l,
	 //signal
	 //cmp
	 output [2:0] type,
	 //ext
    output ext_sel,
	 //grf
	 output gwe,
	 output [4:0]gwa_res,//out of module
	 output [2:0]gwd_sel,//out of module
	 //npc
	 output [2:0]npc_sel,
	 //alu
	 output [4:0]alu_sel,
	 output [1:0]alu_a_sel,
	 output [2:0]alu_b_sel,
	 //dm
	 output dwe,
	 output [2:0]dm_sel
    );
	 
	//decode
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
	assign imm16 = instr[15:0];
	assign imm26 = instr[25:0];
	assign shamt = instr[10:6];
	
	wire [5:0]func = instr[5:0];
	wire [5:0]op = instr[31:26];
	
	wire addu = (op == `op_r) && (func == `func_addu); 
	wire subu = (op == `op_r) && (func == `func_subu);
	wire jr = (op == `op_r) && (func == `func_jr);
	
	wire ori = (op == `op_ori);
	wire lui = (op == `op_lui);
	wire lw = (op == `op_lw);
	wire sw = (op == `op_sw);
	wire jal = (op == `op_jal);
	wire j = (op == `op_j);
	wire beq = (op == `op_beq);
	
	
	//classify  becareful jalr!!!!
	assign load = lw | 0;
	assign store = sw | 0;
	assign count_r = addu | subu | 0;
	assign count_i = ori | lui | 0;
	assign branch = beq | 0;
	assign shifts = 0;//shift shamt
	assign shiftv = 0;//shift $x
	assign j_r = jr | 0;//jump $x
	assign j_i = jal | j | 0;//jump imm26
	assign j_l = jal | 0;//link
	
	
	//signal
	/**********D**********/
	//cmp
	assign type = (beq)? `cmp_beq : `cmp_beq;
	//ext
	assign ext_sel =  (store | load)? 1'b1 : 1'b0;
	//npc
	assign npc_sel = (j_i)? `ns_j : (j_r)? `ns_rs : (branch)? `ns_b : `ns_pc4;
	
	
	/**********E**********/
	//alu
	assign alu_sel = (subu)?`alu_sub : (ori)? `alu_or : (lui)? `alu_lui : `alu_add;
	assign alu_a_sel = `alu_a_rs;
	assign alu_b_sel =  (count_i | load | store)? `alu_b_ext : `alu_b_rt;
	
	
	/**********M**********/
	//dm
	assign dm_sel =(lw | sw)? `dm_w : `dm_w;
	assign dwe = (store)? 1'b1 : 1'b0;  
	
	
	/**********W**********/
	//grf
	assign gwe = (count_r | count_i |load | j_l)? 1'b1 : 1'b0;
	assign gwa_res = (count_r)? rd : (count_i | load)? rt :(jal)? 5'd31 : 5'b0; 
	assign gwd_sel =  (load)? `gwd_dm :(jal)? `gwd_pc8 : `gwd_alu;


endmodule
