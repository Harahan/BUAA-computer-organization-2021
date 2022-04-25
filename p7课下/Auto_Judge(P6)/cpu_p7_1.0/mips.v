`timescale 1ns / 1ps
`include "const.v"
/*
`include "CPU.v"
`include "BRIDGE.v"
`include "TC.v"
*/


module mips(
    input clk,                       // 时钟信号
    input reset,                     // 同步复位信号
    input interrupt,                 // 外部中断信号
    output [31:0] macroscopic_pc,    // 宏观 PC

    output [31:0] i_inst_addr,       // 取指 PC
    input  [31:0] i_inst_rdata,      // i_inst_addr 对应�32 位指�

    output [31:0] m_data_addr,       // 数据存储器待写入地址
    input  [31:0] m_data_rdata,      // m_data_addr 对应�32 位数�
    output [31:0] m_data_wdata,      // 数据存储器待写入数据
    output [3 :0] m_data_byteen,     // 字节使能信号

    output [31:0] m_inst_addr,       // M 级PC

    output w_grf_we,                 // grf 写使能信�
    output [4 :0] w_grf_addr,        // grf 待写入寄存器编号
    output [31:0] w_grf_wdata,       // grf 待写入数�

    output [31:0] w_inst_addr        // W �PC
	);

	wire [31:0] pr_rd, pr_a, pr_wd, tc1_out, tc2_out;
	wire [5:0] hwint;
	wire pr_we, irq1, irq2;


	CPU cpu (
	.clk(clk),
	.reset(reset),
	//bridge
	.hwint(hwint), // I
	.pr_rd(pr_rd), // I
	.pr_we(pr_we),
	.pr_a(pr_a),
	.pr_wd(pr_wd),
	.M_pc_out(macroscopic_pc),
	//im
	.i_inst_rdata(i_inst_rdata),// I
	.i_inst_addr(i_inst_addr),
	//dm
	.m_data_addr(m_data_addr),
	.m_data_rdata(m_data_rdata), // I
	.m_data_wdata(m_data_wdata),
	.m_data_byteen(m_data_byteen),
	.m_inst_addr(m_inst_addr),
	//grf
	.w_grf_we(w_grf_we),
	.w_grf_addr(w_grf_addr),
	.w_grf_wdata(w_grf_wdata),
	.w_inst_addr(w_inst_addr)
	);

	BRIDGE bridge(
	.pr_a(pr_a),
	.pr_we(pr_we),
	.interrupt(interrupt),
	.irq1(irq1),
	.irq2(irq2),
	.tc1_out(tc1_out),
	.tc2_out(tc2_out),
	.pr_rd(pr_rd), // O
	.hwint(hwint) // O
	);

	TC tc1(
	.clk(clk),
	.reset(reset),
	.Addr(pr_a[31:2]),
	.WE(tc1_we),
	.Din(pr_wd),
	.Dout(tc1_out),
	.IRQ(irq1)
	);

	TC tc2(
	.clk(clk),
	.reset(reset),
	.Addr(pr_a[31:2]),
	.WE(tc2_we),
	.Din(pr_wd),
	.Dout(tc2_out),
	.IRQ(irq2)
	);


endmodule 