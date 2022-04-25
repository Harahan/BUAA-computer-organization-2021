`timescale 1ns / 1ps
`include "const.v"


module CTRL(
    input [31:0] instr,
	 input b_j,
	 input alu_zero, 
	 input [31:0]rt_d,
	 input [31:0]mem_word,
	 input lhonez_ch,
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
	 output md,
	 output mf,
	 output mt,
	 output jap,
	 output lwer,
	 output shl,
	 output lhonez,
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
	 //mdu
	 output [3:0]md_sel,
	 //be
	 output [2:0] be_sel,
	 //dp
	 output [2:0] dp_sel
    );
	 
	//decode
	assign rs = (jap)? 5'd29: instr[25:21];
	assign rt = instr[20:16];
	assign rd = instr[15:11];
	assign imm16 = instr[15:0];
	assign imm26 = instr[25:0];
	assign shamt = instr[10:6];
	
	wire [5:0]func = instr[5:0];
	wire [5:0]op = instr[31:26];
	
	wire mult = (op == `op_r) && (func == `func_mult); 
	wire multu = (op == `op_r) && (func == `func_multu); 
	wire div = (op == `op_r) && (func == `func_div); 
	wire divu = (op == `op_r) && (func == `func_divu); 
	
	wire add = (op == `op_r) && (func == `func_add); 
	wire addu = (op == `op_r) && (func == `func_addu);
	wire sub = (op == `op_r) && (func == `func_sub);
	wire subu = (op == `op_r) && (func == `func_subu);
	wire And = (op == `op_r) && (func == `func_and);
	wire Or = (op == `op_r) && (func == `func_or);
	wire Xor = (op == `op_r) && (func == `func_xor);
	wire Nor = (op == `op_r) && (func == `func_nor);
	wire slt = (op == `op_r) && (func == `func_slt);
	wire sltu = (op == `op_r) && (func == `func_sltu);
	
	wire mfhi = (op == `op_r) && (func == `func_mfhi); 
	wire mflo = (op == `op_r) && (func == `func_mflo); 
	wire mthi = (op == `op_r) && (func == `func_mthi); 
	wire mtlo = (op == `op_r) && (func == `func_mtlo); 

	wire jr = (op == `op_r) && (func == `func_jr);
	wire jalr = (op == `op_r) && (func == `func_jalr);

	wire sll = (op == `op_r) && (func == `func_sll);
	wire srl = (op == `op_r) && (func == `func_srl);
	wire sra = (op == `op_r) && (func == `func_sra);
	wire sllv = (op == `op_r) && (func == `func_sllv);
	wire srlv = (op == `op_r) && (func == `func_srlv);
	wire srav = (op == `op_r) && (func == `func_srav);
	
	wire lb = (op == `op_lb);
	wire lh = (op == `op_lh);
	wire lw = (op == `op_lw);
	wire lbu = (op == `op_lbu);
	wire lhu = (op == `op_lhu);

	wire sb = (op == `op_sb);
	wire sh = (op == `op_sh);
	wire sw = (op == `op_sw);

	wire bltz = (op == `op_bltz) && (rt == `rt_bltz);
	wire bgez = (op == `op_bgez) && (rt == `rt_bgez);

	wire beq = (op == `op_beq);
	wire bne = (op == `op_bne);
	wire blez = (op == `op_blez);
	wire bgtz = (op == `op_bgtz);
	
	wire j = (op == `op_j);
	wire jal = (op == `op_jal);

    wire addi = (op == `op_addi);
	wire addiu = (op == `op_addiu);
	wire andi = (op == `op_andi);
	wire ori = (op == `op_ori);
	wire xori = (op == `op_xori);
	wire lui = (op == `op_lui);
	wire slti = (op == `op_slti);
	wire sltiu = (op == `op_sltiu);

	wire bltzal = (op == `op_bltzal && rt == `rt_bltzal);
	wire msub = (op == `op_special_2 && func == `func_msub);
	wire msubu = (op == `op_special_2 && func == `func_msubu);
	wire movz = (op == `op_r && func == `func_movz);
	wire bgezal = (op == `op_bgezal && rt == `rt_bgezal);
	
	assign jap = (op == `op_jap);
	assign lwer = (op == `op_lwer);
	assign shl = (op == `op_r && func == `func_shl);
	
	assign lhonez = (op == `op_lhonez);
	
	
	//classify  becareful jalr!!!!
	assign load =  lw | lh | lb | lhu | lbu | 0;

	assign store = sw | sh | sb | 0;

	assign count_r = movz | add | addu | sub | subu | sll | sllv | srl |
	                 srlv | sra | srav | And | Or | Xor | Nor | 
					     slt | sltu | 0; 

	assign count_i = addi | addiu | andi | ori | xori | lui | 
					     slti | sltiu | 0;

	assign branch = bgezal | bltzal | beq | bne | blez | bgtz | bgez | bltz | 0;

	assign shifts = sll | srl | sra | 0; //shift shamt

	assign shiftv = sllv | srlv | srav | 0; //shift $x

	assign j_r = jalr | jr | 0; //jump $x

	assign j_i = jal | j | 0; //jump imm26

	assign j_l = bgezal | bltzal | jal | jalr | 0; //link
	
	assign md = msubu | msub | mult | multu | div | divu | 0;
	
	assign mt = mthi | mtlo | 0;
	
	assign mf = mfhi | mflo | 0;
	
	
	/**********D**********/
	
	//cmp
	assign type = (bltzal | bltz)? `cmp_bltz :
					  (bgezal | bgez)? `cmp_bgez :
					  (blez)? `cmp_blez :
					  (bgtz)? `cmp_bgtz :
					  (bne)? `cmp_bne :
					  (beq)? `cmp_beq : 
					  `cmp_beq;
	//ext
	assign ext_sel =  (lhonez | lwer | store | load | addi | addiu | slti | sltiu)? 1'b1 : 
							1'b0;
	//npc
	assign npc_sel = (j_i | jap)? `ns_j : 
						  (j_r)? `ns_rs : 
						  (branch)? `ns_b : 
						  `ns_pc4;
	
	/**********E**********/
	
	//alu
	assign alu_sel = (subu | sub)?`alu_sub : 
						  (And | andi)?`alu_and :
						  (ori | Or)? `alu_or : 
						  (Nor)? `alu_nor :
						  (Xor | xori)? `alu_xor :
						  (lui)? `alu_lui : 
						  (sll | sllv)? `alu_sll : 
						  (srl | srlv)? `alu_srl :
						  (sra | srav)? `alu_sra :
						  (slt | slti)? `alu_slt :
						  (sltu | sltiu)? `alu_sltu :
						  (movz)? `alu_movz :
						  (jap)? `alu_jap : 
						  `alu_add;
						  
	assign alu_a_sel = (shifts | shiftv)? `alu_a_rt : 
							 `alu_a_rs;
							 
	assign alu_b_sel =  (count_i | load | store | lwer | lhonez)? `alu_b_ext :
							  (shifts)? `alu_b_shamt : 
							  (shiftv)? `alu_b_rs_4_0 : 
							  `alu_b_rt;
							  
	assign md_sel = (mult)? `md_mult :
							(multu)? `md_multu :
							(div)? `md_div :
						   (divu)? `md_divu :
							(mfhi)? `md_mfhi :
							(mflo)? `md_mflo :
							(mthi)? `md_mthi :
							(mtlo)? `md_mtlo :
							(msub)? `md_msub :
							(msubu)? `md_msubu :
							(shl)? `md_shl :
							`md_none;
		
	/**********M**********/
	
	//be
	assign be_sel = (sw | jap)? `be_w :
	                (sh)? `be_h :
					    (sb)? `be_b :
				       `be_none;
	//dp
	assign dp_sel = (lw | lwer)? `dp_w :
						 (lh | lhonez)? `dp_h :
						 (lb)? `dp_b :
						 (lhu)? `dp_hu :
						 (lbu)? `dp_bu :
						 `dp_w;
	
	/**********W**********/
	
	wire [4:0] movz_a = (alu_zero === 1'b1)? rd : 0;
	wire [4:0] lhonez_a = (lhonez_ch === 1'bz || lhonez_ch === 1'bx)? 0 : (lhonez_ch === 1'b1)? rt : 32'd31;
	wire lwer_ch = lwer && mem_word && rt_d;
	
	//grf
	assign gwe = (count_r | count_i |load | j_l | mf | jap | lwer | lhonez)? 1'b1 : 
				    1'b0;
					 
	assign gwa_res = ((count_r && !movz)| jalr | mf)? rd : 
					     (count_i | load)? rt :
					     (jal)? 5'd31 :
					     (bgezal | bltzal)?((b_j)?5'd31: 5'b0 ):
						  (movz)? movz_a :
						  (jap)? 5'd29 : 
						  (lwer)? ((lwer_ch !== 1'bz && lwer_ch !== 1'bx)?((mem_word + rt_d)& 5'h1e) : 5'b0) : 
						  (lhonez)? lhonez_a :
					     5'b0; 
						  
	assign gwd_sel =  (load | lwer)? `gwd_dm :
	                  (bgezal | bltzal |jal | jalr)? `gwd_pc8 :
							(mf)? `gwd_md :
							(lhonez)?((lhonez_ch === 1'b1)? `gwd_dm : `gwd_pc4):
					      `gwd_alu;

endmodule
