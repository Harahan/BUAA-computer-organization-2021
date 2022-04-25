`timescale 1ns / 1ps
`include "const.v"


module E_MDU(
	input req,
    input clk,
    input reset,
    input [31:0] d1,
    input [31:0] d2,
    input [3:0] md_sel,
	 output md_stall,
    output [31:0] md_out
    );
	 reg busy;
	 wire start;
	 reg[5:0] status;
	 reg [31:0] hi, lo, hi_temp, lo_temp;
	 
	 wire mult = (md_sel == `md_mult);
	 
	 wire multu = (md_sel == `md_multu);
	 
	 wire div = (md_sel == `md_div);
	
	 wire divu = (md_sel == `md_divu);
	 
	 wire mfhi = (md_sel == `md_mfhi);
	 
	 wire mflo = (md_sel == `md_mflo);
	 
	 wire mthi = (md_sel == `md_mthi);
	 
	 wire mtlo = (md_sel == `md_mtlo);
	 
	 assign start = mult | multu | div | divu | 0;
	 
	 assign md_stall = start | busy | 0;
	 
	 assign md_out = (mfhi)? hi :
						  (mflo)? lo :
						  32'd0;

	/*
		when M_instr is exc:
			md_instr is in W ,continue
		when M_instr is exc:
			md_instr is in E, stop
	*/
	 
	 always@(posedge clk)begin
		if(reset)begin
			status <= 5'd0;
			busy <= 1'd0;
			hi <= 0;
			lo <= 0;
			hi_temp <= 0;
			lo_temp <= 0;
		end
		else if(!req)begin
			if(status == 5'd0)begin
				if(mtlo)begin
					lo <= d1;
				end
				else if (mthi)begin
					hi <= d1;
				end
				else if(mult)begin
				busy <= 1'b1;
					{hi_temp, lo_temp} <= $signed(d1)*$signed(d2);
					status <= 5'd5;
				end
				else if(multu)begin
				busy <= 1'b1;
					{hi_temp, lo_temp} <= d1*d2;
					status <= 5'd5;
				end
				else if(div)begin
				busy <= 1'b1;
					lo_temp <= $signed(d1)/$signed(d2);
					hi_temp <= $signed(d1)%$signed(d2);
					status <= 5'd10;
				end
				else if(divu)begin
				busy <= 1'b1;
					lo_temp <= d1/d2;
					hi_temp <= d1%d2;
					status <= 5'd10;
				end
			end
			else if(status > 5'd1)begin
				status <= status - 5'd1;
			end
			else begin
				status <= 0;
				busy <= 0;
				lo <= lo_temp;
				hi <= hi_temp;
			end
		end
	 end
	 
	 


endmodule
