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
    output [1:0] format_type
    );
reg [4:0] count,temp;
reg [3:0] status;
initial begin
	count <= 0;
	temp <= 0;
end
always@(posedge clk) begin
	if(reset == 1) begin
      status <= `s0;
		count <= 0;
		temp <= 0;
	end
	else begin
		case(status)
		`s0: begin
			if( char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
		`s1:begin
			if( char <="9"&&char >="0") begin
				status <= `s2;
				count <= count + 1;
			end
			else if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end//不会出现连续的"^"
		`s2:begin
			if( char == "@" && count <= 4) begin
				status <= `s3;
				count <= 0;
			end
			else if( char <="9" && char >= "0"&& count < 4) begin
				status <= `s2;
				count <= count + 1;
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
			else if(char == "*") begin
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
			end
			else if((char == "#") && (count == 8) && (temp == 1)) begin
				status <= `s15;
				count <= 0;
				temp <= 0;
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
			end
			else begin
				status <= `s0;
			end
		end
		`s13: begin
			if((char>= "0" && char <= "9")||(char >= "a" && char <= "f")) begin
				status <= `s14; 
				count <= count + 1;
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
			end
			else if((count ==7 ) && ((char>= "0" && char <= "9")||(char >= "a" && char <= "f"))) begin
				status <= `s8;
				temp <= 1;
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
		`s15: begin
			if(char == "^") begin
				status <= `s1;
			end
			else begin
				status <= `s0;
			end
		end
			
		endcase
	end
end

assign format_type = (status == `s12)? 2'b01:
							(status == `s15)? 2'b10:
							                  2'b00;

endmodule
