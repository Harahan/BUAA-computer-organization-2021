`timescale 1ns / 1ps
`include "const.v"
`define start_tc1 32'h0000_7f00
`define end_tc1 32'h0000_7f0b
`define start_tc2 32'h0000_7f10
`define end_tc2 32'h0000_7f1b  


module BRIDGE(
    input [31:0] pr_a,
    input pr_we,
    input interrupt,
    input irq1,
    input irq2,
    input [31:0] tc1_out,
    input [31:0] tc2_out,
    output tc1_we,
    output tc2_we,
    output [31:0] pr_rd,
    output [5:0] hwint
    );

wire [31:0] r_addr = {pr_a[31:2], 2'b00};

wire sel_tc1 = (r_addr >= `start_tc1) && (r_addr <= `end_tc1);

wire sel_tc2 = (r_addr >= `start_tc2) && (r_addr <= `end_tc2);

assign tc1_we = sel_tc1 && pr_we;

assign tc2_we = sel_tc2 && pr_we;

assign pr_rd =  (sel_tc1) ? tc1_out :
                (sel_tc2) ? tc2_out :
                0;

assign hwint = {3'b0, interrupt, irq2, irq1};

endmodule