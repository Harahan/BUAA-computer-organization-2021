`timescale 1ns / 1ps

`define s0 0
`define s1 1
`define s2 2
`define s3 3
`define s4 4
`define s5 5
`define s6 6
`define s7 7
`define s8 8
`define s9 9
`define s10 10
`define s11 11
`define s12 12
`define s13 13
`define s14 14
`define s15 15



module cpu_checker(
    input clk,
    input reset,
    input [7:0] char,
	 input [15:0] freq,
    output [1:0] format_type,
	 output [3:0] error_code
    );
reg [4:0] count,temp;
reg [3:0] status;
reg [32:0] Time,Pc,Addr,Grf;
reg  GrfError,AddrError,PcError,TimeError;
initial begin
	status = `s0;
	temp = 0;
	count = 0;
	GrfError = 0;
	PcError = 0;
	 AddrError = 0;
	TimeError = 0;
	Time = 0;
	Pc =0;
	Addr =0;
	Grf =0;
end
always@(posedge clk) begin
	if(reset == 1) begin
      status <= `s0;
		temp <= 0;
		count <= 0;
		GrfError <= 0;
		PcError <= 0;
		AddrError <= 0;
		TimeError <= 0;
		Time <= 0;
		Pc <=0;
		Addr <=0;
		Grf <=0;
	end
	else begin
		case(status)
		`s0: begin
			Time <= 0;
			Pc <= 0;
			Addr <= 0;
			Grf <= 0;
			if( char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s1:begin
			Time <= 0;
			Pc <=0;
			Addr <=0;
			Grf <=0;
			if( char <="9"&&char >="0") begin
				status <= `s2;
				count <= count + 1;
				Time <= char - "0";
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s2:begin
			if( char == "@" && count <= 4) begin
				status <= `s3;
				count <= 0;
			end
			else if( char <="9" && char >= "0"&& count < 4) begin
				status <= `s2;
				count <= count + 1;
				Time <= (Time << 3) + (Time << 1) + (char - "0");
			end
			else if(char == "^") begin
				status <= `s1;
				count <= 0;
			end
			else begin
				status <= `s0;
				count <= 0;
			end
		end
		`s3: begin
			if((char>= "0" && char <= "9")||(char >= "a" && char <= "f")) begin
				status <= `s4;
				count <= count + 1;
				Pc <= (char <= "9") ? (char - "0") :(char - "a" + 10);
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s4: begin
			if(((char>= "0" && char <= "9")||(char >= "a" && char <= "f"))&& (count < 8) )begin
				status <= `s4;
				count <= count + 1;
				Pc <= (Pc << 4) + ((char <= "9") ? (char - "0") :(char - "a" + 10));
			end
			else if((char == ":") && (count == 8)) begin
				status <= `s5;
				count <= 0;
			end
			else if(char == "^") begin
				status <= `s1;
				count <= 0;
			end
			else begin
				status <= `s0;
				count <= 0;
			end
		end
		`s5: begin
			if( char == "$") begin
				status <= `s6;
			end
			else if(char == " ") begin
				status <= `s5;
			end
			else if(char == 8'd42) begin
				status <= `s13;
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s6: begin
			if(char <="9" && char >= "0" ) begin
				status <= `s7;
				count <= count + 1;
				Grf <= char - "0";
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s7:begin
			if( char == "<" && count <= 4) begin
				status <= `s9;
				count <= 0;
			end
			else if( char == " " && count <= 4 ) begin
				status <= `s8;
				count <= 0;
			end
			else if( char <="9" && char >= "0" && count < 4) begin
				status <= `s7;
				count <= count + 1;
				Grf <= (Grf << 3) + (Grf << 1) + (char - "0");
			end
			else if(char == "^") begin
				status <= `s1;
				count <= 0;
			end
			else begin
				status <= `s0;
				count <= 0;
			end
		end
		`s8: begin
			if(char == " ") begin
				status <= `s8;
			end
			else if(char == "<") begin
				status <= `s9;
			end
			else if(char == "^") begin
				status <= `s1;
				temp <= 0;
			end
			else begin
				status <= `s0;
				temp <= 0;
			end
		end
		`s9: begin
			if(char == "=") begin
				status <= `s10;
			end
			else if(char == "^") begin
				status <= `s1;
				temp <= 0;
			end
			else begin
				status <= `s0;
				temp <= 0;
			end
		end
		`s10: begin
			if(char == " ") begin
				status <= `s10;
			end
			else if((char>= "0" && char <= "9")||(char >= "a" && char <= "f")) begin
				status <= `s11; 
				count <= count + 1;
			end
			else if(char == "^") begin
				status <= `s1;
				temp <= 0;
			end
			else begin
				status <= `s0;
				temp <= 0;
			end
		end
		`s11: begin
			if(((char>= "0" && char <= "9")||(char >= "a" && char <= "f"))&& count < 8) begin
				status <= `s11;
				count <= count + 1;
			end
			else if((char == "#") && (count == 8) && (temp == 0)) begin
				status <= `s12;
				count <= 0;
				if(((Time & (-Time)) >= (freq>>1)) || (Time == 0));
				else TimeError <= 1;
				if(32'h0000_3000<= Pc && Pc <= 32'h0000_4fff && ((Pc & (-Pc)) >= 4));
				else PcError <= 1;
				if(0<=Grf && Grf <= 31) ;
				else GrfError <= 1;
			end
			else if((char == "#") && (count == 8) && (temp == 1)) begin
				status <= `s15;
				count <= 0;
				temp <= 0;
				if( ((Time & (-Time)) >= (freq>>1)) || (Time == 0));
				else TimeError <= 1;
				if(32'h0000_3000<= Pc && Pc <= 32'h0000_4fff && ((Pc & (-Pc)) >= 4));
				else PcError <= 1;
				if((32'h0000_0000<= Addr && Addr <= 32'h0000_2fff && ((Addr & (-Addr)) >= 4)) || Addr == 0);//注意lowbit判断不了为0的情况
				else AddrError <= 1;
			end
			else if(char == "^") begin
				status <= `s1;
				count <= 0;
				temp <= 0;
			end
			else begin
				status <= `s0;
				count <= 0;
				temp <= 0;
			end
		end
		`s12: begin
			if(char == "^") begin
				status <= `s1;
				GrfError <= 0;
				PcError <= 0;
				TimeError <= 0;
			end
			else begin
				status <= `s0;
				GrfError <= 0;
				PcError <= 0;
				TimeError <= 0;
			end
		end
		`s13: begin
			if((char>= "0" && char <= "9")||(char >= "a" && char <= "f")) begin
				status <= `s14; 
				count <= count + 1;
				Addr <= (char <= "9") ? (char - "0") :(char - "a" + 10);
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s14: begin
			if(((char>= "0" && char <= "9")||(char >= "a" && char <= "f")) &&(count < 7)) begin
				status <= `s14;
				count <= count + 1;
				Addr <= (Addr << 4) + ((char <= "9") ? (char - "0") :(char - "a" + 10));
			end
			else if((count ==7 ) && ((char>= "0" && char <= "9")||(char >= "a" && char <= "f"))) begin
				status <= `s8;
				temp <= 1;
				count <= 0;
				Addr <= (Addr << 4) + ((char <= "9") ? (char - "0") :(char - "a" + 10));
			end
			else if(char == "^") begin
				status <= `s1;
				count <= 0;
			end
			else begin
				status <= `s0;
				count <= 0;
			end
		end
		`s15: begin
			if(char == "^") begin
				status <= `s1;
				PcError <= 0;
				AddrError <= 0;
				TimeError <= 0;
			end
			else begin
				status <= `s0;
				PcError <= 0;
				AddrError <= 0;
				TimeError <= 0;
			end
		end
			
		endcase
	end
end

assign format_type = (status == `s12)? 2'b01:
					 (status == `s15)? 2'b10:
							           2'b00;
assign error_code = ( status == `s12 || status == `s15)? { GrfError,AddrError,PcError,TimeError}: 4'b0000;
endmodule
