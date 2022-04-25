`timescale 1ns / 1ps
`include "const.v"
`define im sr[15:10]
`define exl sr[1]
`define ie sr[0]
`define bd cause[31]
`define ip cause[15:10]
`define ex_code cause[6:2]


module M_CP0(
    input [4:0] a1, //mfc0 read addr
    input [4:0] a2, // mtc0 write addr
    input bd_in, //ex hanppens in branch delay slot
    input [31:0] cwd,
    input [31:0] pc,//affected pc
    input [4:0] ex_code_in,
    input [5:0] hwint, //6 hardware int
    input cwe,
    // input exl_set,
    input exl_clr, //eret, sr[1] = 0
    input clk,
    input reset,
    output req,
    output [31:0] epc_out, //epc
    output int_en, 
    output [31:0] cp0_out //read from cp0
    );

    assign int_en = ((|(hwint[2] & sr[12])) & !`exl & `ie);
    
    /*
        int(ok), adel_1(ok), adel_2(ok), ades(ok), ri(ok), ov(ok)
        int > exc
    */

    /*  
        sr:
            sr[15:10] - im[7:2] (6 hardware int enable)
            sr[0] - ie (global interrupt enable)
            sr[1] - exl (exception state)

        cause:
            cause[15:10] - ip[7:2] (6 hardware int req)
            cause[6:2] - ex_code[6:2] (exc code)
            cause[31] - bd (exc hanppens in branch delay slot)

        epc:
            epc - pc (exc pc, no request of align)

        prid:
            id (...)
    */

    /* 
        when receive exc or external int:       |                  when process:                                     
            external:                           |                     req, exl, bd
                im, ip, exl, ie                 |                     epc (if instr in branch delay solt, save pc - 4)            
            internal:                           |                  when end:
                exl                             |                     exl
    */

    reg [31:0] sr;
    reg [31:0] cause;
    reg [31:0] epc_reg;//
    reg [31:0] prid;

    wire int_req = ((|(hwint & `im)) & !`exl & `ie);

    wire ex_req = (|ex_code_in) & !`exl;

    assign req = int_req | ex_req;

    wire [31:0] temp_pc = (req)? ((bd_in)? pc - 32'h4 : pc)
                        : epc_reg;//

    assign epc_out = temp_pc;//

    initial begin
        sr = 0;
        cause = 0;
        epc_reg = 0;
        prid = 32'h2001_1006;
    end

    always @(posedge clk) begin
        if(reset)begin
            sr <= 0;
            cause <= 0;
            epc_reg <= 0;
            prid <= 32'h2001_1006;
        end
        else begin
            if(exl_clr)begin // eret in M
                `exl <= 1'b0;
            end
            if(req)begin // int | ex
                `ex_code <= int_req? 5'b0 : ex_code_in;
                `exl <= 1'b1;
                epc_reg <= temp_pc;
                `bd <= bd_in;
            end
            else if(cwe)begin // mtc0 & !(int | ex)
                if(a2 == 5'd12)begin
                    sr <= cwd;
                end
                else if(a2 == 5'd14)begin
                    epc_reg <= cwd;//
                end
            end
            `ip <= hwint;
        end
    end

assign cp0_out =    (a1 == 5'd12)? sr :
                    (a1 == 5'd13)? cause :
                    (a1 == 5'd14)? epc_out :
                    (a1 == 5'd15)? prid :
                    0;

endmodule
