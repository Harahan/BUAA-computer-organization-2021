`timescale 1ns / 1ps
`include "const.v"

module CPU (
    input         clk,
    input         reset,
    input [5:0]   HWInt,
    input [31:0]  PrRD,
    output        PrWE,
    output [31:2] PrAddr,
    output [31:0] PrWD,
    output [31:0] M_PCout
);

    wire stall;
    wire F_pc_en = !stall, D_reg_en = !stall, E_reg_en = 1'b1, M_reg_en = 1'b1, W_reg_en = 1'b1; // Reg En
    wire D_reg_reset = 1'b0, E_reg_reset = stall, M_reg_reset = 1'b0, W_reg_reset = 1'b0;

    wire [31:0] F_instr, D_instr, E_instr, M_instr, W_instr;
    wire E_HILObusy;
    _SU _su(
        .D_instr(D_instr),
        .E_instr(E_instr),
        .M_instr(M_instr),
        .E_HILObusy(E_HILObusy),
        .stall(stall)
    );

    wire [31:0] E_RFWD, M_RFWD, W_RFWD;
    wire [4:0] E_RFDst, M_RFDst, W_RFDst;
    wire [2:0] E_RFWDSrc, M_RFWDSrc, W_RFWDSrc;
    wire W_RFWE;

    assign E_RFWD = // (E_RFWDSrc == `RFWD_ALUout) ? E_ALUout :
                    // (E_RFWDSrc == `RFWD_DMout) ? E_DMout :
                    // (E_RFWDSrc == `RFWD_HILOout) ? E_HILOout :
                    (E_RFWDSrc == `RFWD_EXTout) ? E_EXTout :
                    (E_RFWDSrc == `RFWD_PC8) ? E_pc + 8 :
                    0; // don't forward

    assign M_RFWD = (M_RFWDSrc == `RFWD_ALUout) ? M_ALUout :
                    (M_RFWDSrc == `RFWD_HILOout) ? M_HILOout :
                    (M_RFWDSrc == `RFWD_EXTout) ? M_EXTout :
                    // (M_RFWDSrc == `RFWD_DMout) ? M_DMout :
                    (M_RFWDSrc == `RFWD_PC8) ? M_pc + 8 :
                    0;

    assign W_RFWD = (W_RFWDSrc == `RFWD_ALUout) ? W_ALUout :
                    (W_RFWDSrc == `RFWD_HILOout) ? W_HILOout :
                    (W_RFWDSrc == `RFWD_EXTout) ? W_EXTout :
                    (W_RFWDSrc == `RFWD_DMout) ? W_DMout :
                    (W_RFWDSrc == `RFWD_PC8) ? W_pc + 8 :
                    (W_RFWDSrc == `RFWD_CP0) ? W_CP0out :
                    0;

    wire [4:0] F_excCode, D_excCode, E_excCode, M_excCode, D_old_excCode, E_old_excCode, M_old_excCode;
    wire F_excAdEL, D_excRI, E_excOvAri, E_excOvDM, M_excOvDM, M_excAdEL, M_excAdES;
    wire F_bd, D_bd, E_bd, M_bd;
    wire D_eret, E_eret, M_eret;
    wire [31:0] EPC, M_CP0out, W_CP0out;
    wire req;

    assign F_excCode = F_excAdEL ? `EXC_AdEL : `EXC_None;

    assign D_excCode =  D_old_excCode ? D_old_excCode :
                        D_excRI ? `EXC_RI :
                        `EXC_None;

    assign E_excCode =  E_old_excCode ? E_old_excCode :
                        E_excOvAri ? `EXC_Ov :
                        `EXC_None;

    assign M_excCode =  M_old_excCode ? M_old_excCode :
                        M_excAdEL ? `EXC_AdEL :
                        M_excAdES ? `EXC_AdES :
                        `EXC_None;

    assign F_bd = (D_Br != `BR_pc4);

    /// StageF
    wire [31:0] F_pc, npc;
    F_IFU F_ifu(
        .req(req),
        .D_eret(D_eret),
        .EPC(EPC),
        .excAdEL(F_excAdEL),

        .clk(clk),
        .reset(reset),
        .WE(F_pc_en),
        .npc(npc),
        .instr(F_instr),
        .pc(F_pc)
    );

    /// StageD
    wire [31:0] D_pc;
    D_REG D_reg (
        .req(req),
        .stall(stall),
        .excCode_in(F_excCode),
        .bd_in(F_bd),
        .excCode_out(D_old_excCode),
        .bd_out(D_bd),

        .clk(clk),
        .reset(reset || D_reg_reset),
        .WE(D_reg_en),

        .instr_in(F_instr),
        .pc_in(F_pc),

        .instr_out(D_instr),
        .pc_out(D_pc)
    );

    wire [4:0] D_rs_addr, D_rt_addr;
    wire [15:0] D_imm;
    wire [25:0] D_addr;
    wire D_b_jump;
    wire [2:0] D_EXTOp;
    wire [2:0] D_Br, D_B_type;
    wire [31:0] D_rs, D_rt, D_EXTout, D_type;

    _CU D_cu(
        .instr(D_instr),
        .rs_addr(D_rs_addr),
        .rt_addr(D_rt_addr),
        .imm(D_imm),
        .addr(D_addr),
        .EXTOp(D_EXTOp),
        .Br(D_Br),
        .B_type(D_B_type),
        .excRI(D_excRI),
        .eret(D_eret)
    );

    wire [31:0] W_pc;

    D_GRF D_grf (
        .WPC(W_pc),
        .clk(clk),
        .reset(reset),
        .WE(W_RFWE),
        .A1(D_rs_addr),
        .A2(D_rt_addr),
        .A3(W_RFDst),
        .WD(W_RFWD),
        .RD1(D_rs),
        .RD2(D_rt)
    );

    D_EXT D_ext (
        .imm(D_imm),
        .EXTOp(D_EXTOp),
        .EXTout(D_EXTout)
    );
    // FORWARD
    wire [31:0] FWD_D_RS =  (D_rs_addr == 0) ? 0 :
                            (D_rs_addr == E_RFDst) ? E_RFWD :
                            (D_rs_addr == M_RFDst) ? M_RFWD :
                            D_rs;
                            // W has been forwarded inside

    wire [31:0] FWD_D_RT =  (D_rt_addr == 0) ? 0 :
                            (D_rt_addr == E_RFDst) ? E_RFWD :
                            (D_rt_addr == M_RFDst) ? M_RFWD :
                            D_rt;
                            // W has been forwarded inside

    D_CMP D_cmp (
        .rs(FWD_D_RS),
        .rt(FWD_D_RT),
        .type(D_B_type),
        .b_jump(D_b_jump)
    );

    D_NPC D_npc (
        .req(req),
        .eret(D_eret),
        .EPC(EPC),

        .D_pc(D_pc),
        .F_pc(F_pc),
        .imm26(D_addr),
        .rs(FWD_D_RS),
        .Br(D_Br),
        .b_jump(D_b_jump),
        .npc(npc)
    );

    /// StageE
    wire [31:0] E_pc, E_EXTout, E_rs, E_rt;
    E_REG E_reg (
        .req(req),
        .excCode_in(D_excCode),
        .bd_in(D_bd),
        .excCode_out(E_old_excCode),
        .bd_out(E_bd),

        .clk(clk),
        .reset(reset || E_reg_reset),
        .stall(stall),
        .WE(E_reg_en),

        .instr_in(D_instr),
        .pc_in(D_pc),
        .EXT_in(D_EXTout),
        .rs_in(FWD_D_RS),
        .rt_in(FWD_D_RT),
        .instr_out(E_instr),

        .pc_out(E_pc),
        .EXT_out(E_EXTout),
        .rs_out(E_rs),
        .rt_out(E_rt)
    );


    wire [3:0] E_ALUControl, E_HILOType;
    wire [1:0] E_ALUASrc;
    wire [2:0] E_ALUBSrc;
    wire [4:0] E_rs_addr, E_rt_addr;
    wire E_ALUAriOverflow, E_ALUDMOverflow;

    _CU E_cu (
        .instr(E_instr),
        .rs_addr(E_rs_addr),
        .rt_addr(E_rt_addr),
        .ALUControl(E_ALUControl),
        .ALUASrc(E_ALUASrc),
        .ALUBSrc(E_ALUBSrc),
        .RFDst(E_RFDst),
        .RFWDSrc(E_RFWDSrc),
        .HILO_type(E_HILOType),
        .ALUAriOverflow(E_ALUAriOverflow),
        .ALUDMOverflow(E_ALUDMOverflow),
        .eret(E_eret)
    );

    wire [31:0] E_ALUA, E_ALUB, E_ALUout;

    // FORWARD
    wire [31:0] FWD_E_RS =  (E_rs_addr == 0) ? 0 :
                            (E_rs_addr == M_RFDst) ? M_RFWD :
                            (E_rs_addr == W_RFDst) ? W_RFWD :
                            E_rs;

    wire [31:0] FWD_E_RT =  (E_rt_addr == 0) ? 0 :
                            (E_rt_addr == M_RFDst) ? M_RFWD :
                            (E_rt_addr == W_RFDst) ? W_RFWD :
                            E_rt;

    assign E_ALUA = (E_ALUASrc == `ALUASrcRT) ? FWD_E_RT :
                    (E_ALUASrc == `ALUASrcRS) ? FWD_E_RS :
                    0;

    assign E_ALUB = (E_ALUBSrc == `ALUBSrcShamt) ? {27'b0, E_instr[10:6]} :
                    (E_ALUBSrc == `ALUBSrcRS_4_0) ? {27'b0, FWD_E_RS[4:0]} :
                    (E_ALUBSrc == `ALUBSrcRT) ? FWD_E_RT :
                    (E_ALUBSrc == `ALUBSrcExt) ? E_EXTout :
                    0;

    E_ALU E_alu (
        .ALUAriOverflow(E_ALUAriOverflow),
        .ALUDMOverflow(E_ALUDMOverflow),
        .excOvAri(E_excOvAri),
        .excOvDM(E_excOvDM),
        .ALUControl(E_ALUControl),
        .A(E_ALUA),
        .B(E_ALUB),
        .ALUout(E_ALUout)
    );

    wire [31:0] E_HILOout;

    E_HILO E_hilo (
        .req(req),

        .clk(clk),
        .reset(reset),
        .rs(FWD_E_RS),
        .rt(FWD_E_RT),
        .HILOtype(E_HILOType),
        .HILObusy(E_HILObusy),
        .HILOout(E_HILOout)
    );

    /// StageM
    wire [31:0] M_pc, M_ALUout, M_rt, M_HILOout, M_EXTout;
    M_REG M_reg(
        .req(req),
        .excCode_in(E_excCode),
        .bd_in(E_bd),
        .excOvDM_in(E_excOvDM),
        .excCode_out(M_old_excCode),
        .bd_out(M_bd),
        .excOvDM_out(M_excOvDM),

        .clk(clk),
        .reset(reset || M_reg_reset),
        .WE(M_reg_en),

        .instr_in(E_instr),
        .pc_in(E_pc),
        .ALU_in(E_ALUout),
        .HILO_in(E_HILOout),
        .rt_in(FWD_E_RT),
        .EXT_in(E_EXTout),

        .instr_out(M_instr),
        .pc_out(M_pc),
        .ALU_out(M_ALUout),
        .HILO_out(M_HILOout),
        .rt_out(M_rt),
        .EXT_out(M_EXTout)
    );

    wire [4:0] M_rt_addr, M_rd_addr;
    wire [2:0] M_DMType;
    wire M_WE, M_CP0Wr, M_load, M_store;

    _CU M_cu (
        .instr(M_instr),
        .rt_addr(M_rt_addr),
        .rd_addr(M_rd_addr),
        .DMType(M_DMType),
        .DMWr(M_WE),
        .RFDst(M_RFDst),
        .RFWDSrc(M_RFWDSrc),
        .CP0Wr(M_CP0Wr),
        .eret(M_eret),
        .load(M_load),
        .store(M_store)
    );

    // FORWARD
    wire [31:0] M_DMout;

    wire [31:0] FWD_M_RT =  (M_rt_addr == 0) ? 0 :
                            (M_rt_addr == W_RFDst) ? W_RFWD :
                            M_rt;

    M_DM M_dm (
        .excOvDM(M_excOvDM),
        .excAdEL(M_excAdEL),
        .excAdES(M_excAdES),

        .pc(M_pc),
        .clk(clk),
        .reset(reset),
        .WE(M_WE & (!req)),
        .DMType(M_DMType),
        .addr(M_ALUout),
        .WD(FWD_M_RT),
        .DMout(M_DMout),
        .load(M_load),
        .store(M_store)
    );

    /// M-CP0
    assign M_PCout = M_pc;
    assign PrWE = M_WE & (!req) & (M_ALUout >= 32'h0000_7f00);
    assign PrAddr = M_ALUout[31:2];
    assign PrWD = FWD_M_RT;

    CP0 _cp0(
        .A1(M_rd_addr),
        .A2(M_rd_addr),
        .bdIn(M_bd),
        .DIn(FWD_M_RT),
        .PC(M_pc[31:2]),
        .ExcCodeIn(M_excCode),
        .HWInt(HWInt),
        .WE(M_CP0Wr),
        .EXLClr(M_eret),
        .clk(clk),
        .reset(reset),

        .Req(req),
        .EPCout(EPC),
        .Dout(M_CP0out)
    );
    /// END_M_CP0

    /// StageW
    wire [31:0] W_ALUout, W_DMout, W_HILOout, W_EXTout;
    W_REG W_reg(
        .req(req),
        .CP0_in(M_CP0out),
        .CP0_out(W_CP0out),

        .clk(clk),
        .reset(reset || W_reg_reset),
        .WE(W_reg_en),

        .instr_in(M_instr),
        .pc_in(M_pc),
        .ALU_in(M_ALUout),
        .DM_in((M_ALUout >= 32'h0000_7f00) ? PrRD : M_DMout),
        .HILO_in(M_HILOout),
        .EXT_in(M_EXTout),

        .instr_out(W_instr),
        .pc_out(W_pc),
        .ALU_out(W_ALUout),
        .DM_out(W_DMout),
        .HILO_out(W_HILOout),
        .EXT_out(W_EXTout)
    );

    _CU W_cu(
        .instr(W_instr),
        .RFDst(W_RFDst),
        .RFWr(W_RFWE),
        .RFWDSrc(W_RFWDSrc)
    );

    /// Write Back To D_GRF

endmodule