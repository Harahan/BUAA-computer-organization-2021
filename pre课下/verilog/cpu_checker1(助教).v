module x(
	input [7:0]c,
	output reg o
	);
	reg [8*16-1:0]t="0123456789abcdef";
	reg f;
	integer i,j;
	always@(c)begin
		o=0;
		for(i=0;i<16;i=i+1)begin
			f=1;for(j=0;j<8;j=j+1)f=f&(c[j]==t[i*8+j]);
			o=o|f;
		end
	end
endmodule
module d(
	input [7:0]c,
	output reg o
	);
	reg [8*10-1:0]t="0123456789";
	reg f;
	integer i,j;
	always@(c)begin
		o=0;
		for(i=0;i<10;i=i+1)begin
			f=1;for(j=0;j<8;j=j+1)f=f&(c[j]==t[i*8+j]);
			o=o|f;
		end
	end
endmodule
module t(
	input [7:0]c,
	output[1:0]o
	);
	assign o = c==36? 1 :
			   c==42? 2 : 0;
endmodule
module cpu_checker(
	input clk,reset,
	input[7:0]char,
	output [1:0]format_type,
	output [5:0] os,
	output [1:0]ow
	);
	wire [1:0]tt;
	reg [5:0]s;
	reg [1:0]w;
	wire xx,dd;reg nspc;
	x ux(.c(char),.o(xx));
	d ud(.c(char),.o(dd));
	t ut(.c(char),.o(tt));
	initial begin
		w=0;s=0;nspc=1;
	end
	always @(posedge clk)begin
		if(reset)s=0;
		else begin
			if(char=="^")s=1;//^
			else if(s>=1&&s<5&&dd&&nspc)s=s+1;//_10
			else if(1<s&&s<6&&char=="@")s=6;//@
			else if(s>=6&&s<14&&xx)s=s+1;//_16
			else if(s==14&&char==":")s=15;//:
			else if((s==15||s>=17&&s<=20&&w==1||s==24||s==26)&&char==" ")s=s;//14,19,23,25 , ' ' 
			else if(s==15&&tt)begin	s=16;w=tt; end
			else if(s>=16&&w==1&&s<20&&dd&&nspc)s=s+1;//_10
			else if(s>=16&&w==2&&s<24&&xx)s=s+1;//_16
			else if(s>16&&w==1&&s<=20&&char=="<")s=25;//<
			else if(s==24&&char=="<")s=25;//<
			else if(s==25&&char=="=")s=26;//=
			else if(s>=26&&s<34&&xx)s=s+1;//_16
			else if(s==34&&char=="#")s=35;//#
			else s=0;
			nspc = char==" " ? 0:1;
		end
	end
	assign format_type = s!=35? 0:w;
	assign os=s;
	assign ow=w;
endmodule