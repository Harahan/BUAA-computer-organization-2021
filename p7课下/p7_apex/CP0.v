`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:14 12/13/2018 
// Design Name: 
// Module Name:    CP0 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CP0(
	 input[4:0] A1,//��CP0�Ĵ������ ִ��MFC0ָ��ʱ����
	 input[4:0] A2,//дCP0�Ĵ������ ִ��MTC0ָ��ʱ����
	 input[31:0] DIn,//CP0�Ĵ�����д������ ִ��MTC0ָ��ʱ���� ��������GPR
	 input[31:0] PC,//�ж�/�쳣ʱ��PC 
	 input[31:0] IR_M,//ָ��
	 input[31:0] IR_W,//ָ��
	 input Zero,
	 input more,
	 input less,
	 input if_bd,
	 input[6:2] ExcCode,//�ж�/�쳣������ 
	 input[5:0] HWInt,//6���豸�ж� 
	 input We,//CP0дʹ�� ִ��MTC0ָ��ʱ����
	 input EXLSet,//������λSR��EXL(EXLΪ1) ��ˮ����M�׶β���
	 input EXLClr,//�������SR��EXL(EXLΪ0) ִ��ERETָ��ʱ����
    input clk,
    input reset,
	 output Interrupt,//�жϺ��쳣 ��HWInt/IM/EXL/IE�ĺ���
	 output[31:0] EPC,//EPC�Ĵ��������NPC
	 output[31:0] DOut //CP0�Ĵ������������ ִ��MFC0ָ��ʱ���������������GRF
    );
	 
	`define SR 12 
	`define CAUSE 13 
	`define EPC 14
	`define PRID 15
	
	`define R 6'b000000
	`define beq 6'b000100
	`define bne 6'b000101
	`define bgtz 6'b000111
	`define blez 6'b000110
	`define jal 6'b000011
	`define jr 6'b001000
	`define j 6'b000010
	`define jalr 6'b001001
	
	//SR  {16'b0, im, 8'b0, exl, ie}
	reg[15:10] im; //6λ�ж�����λ���ֱ��Ӧ6���ⲿ�ж� 1-�����жϣ�0-��ֹ�ж�
	reg exl;//EXL���쳣�� 1-�����쳣�����������жϣ�0-�����ж�
	reg ie;//ȫ���ж�ʹ�� 1-�����жϣ�0-��ֹ�ж�
	//CAUSE {bd, 15'b0, hwint_pend[15:10], 3'b0, exccode[6:2], 2'b0}
	reg bd;//�쳣�������ӳٲ۵�ָ��Ļ� bd=1
	reg[6:2] exccode;
	reg[15:10] hwint_pend;//��clock�����ز��ϵı����ⲿ6���ж�(HWInt[5:0])
	//EPC
	reg[31:0] epc;
	//PRID
	reg[31:0] prid = 32'h12345678;
	wire Exception;//�쳣
	wire IntReq;//�ж�
	assign EPC = epc;
	//��  ����SR/Cause/EPC/PRId�⣬���õļĴ���һ�����0
	assign DOut = (A1==`SR) ? {16'b0, im, 8'b0, exl, ie} :
					  (A1==`CAUSE) ? {bd, 15'b0, hwint_pend[15:10], 3'b0, exccode[6:2], 2'b0} :
					  (A1==`EPC) ? epc :
				     (A1==`PRID) ? prid : 0;
	assign IntReq = (|(HWInt[5:0] & im[15:10])) & ie & !exl ;
	assign Exception = (ExcCode>0) ? 1'b1 : 1'b0;
	assign Interrupt = IntReq||Exception;
		
	wire BD;
	assign BD = ((IR_M[31:26]==`j)||(IR_M[31:26]==`jal)||(IR_M[31:26]==`beq)||(IR_M[31:26]==`bne)||(IR_M[31:26]==`blez)||(IR_M[31:26]==`bgtz)
					||(IR_M[31:26]==`R&&(IR_M[5:0]==`jr||IR_M[5:0]==`jalr))||(IR_M[31:26]==6'b000001&&IR_M[20:16]==5'b00000)||(IR_M[31:26]==6'b000001&&IR_M[20:16]==5'b00001));
	integer i;
	always@(posedge clk) begin
		hwint_pend <= HWInt;//��clock�����ز��ϵı����ⲿ6���ж�(HWInt[5:0])
		if(reset) begin
			im<=6'b0;//SR
			exl<=1'b0;
			ie<=1'b0;
			hwint_pend<=6'b0;//CAUSE
			bd<=0;
			exccode<=0;
			epc<=0;//EPC
		end
		else begin
			epc <= (Interrupt&&bd) ? {PC[31:2], 2'b00} - 4 : 
					 (Interrupt&&!bd) ? {PC[31:2], 2'b00} :
					 epc;
			if(BD) begin
				bd<=1'b1;
			end
			if(We) begin //д��
				case(A2)
					`SR: begin
						{im, exl, ie} <= {DIn[15:10], DIn[1], DIn[0]};
					end
					`CAUSE: begin
						hwint_pend <= DIn[15:10];
					end
					`EPC: begin
						epc <= DIn;
					end
					`PRID: begin
						prid <= DIn;
					end
					default: begin
					end
				endcase
			end
			if(EXLSet||Interrupt) begin
				exl<=1'b1;
				exccode<=ExcCode;
			end
			if(EXLClr) begin
				exl<=1'b0;
				bd<=1'b0;
			end
		end
	end
endmodule
