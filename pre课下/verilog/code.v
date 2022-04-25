`timescale 1ns / 1ps

module code(
    input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0 = 0,
    output reg [63:0] Output1 = 0
    ); 
reg [63:0] count;
initial begin
	count<=0;
end
always @(posedge Clk ) begin
    if (Reset) begin
        Output0<=0;
        Output1<=0;
    end
    else begin
        if(En==1) begin
            if(Slt==0)begin
                Output0<=Output0+1;
            end
            else begin
                count=count+1;
                Output1=count/4;
            end
        end
    end    
    
end
endmodule
