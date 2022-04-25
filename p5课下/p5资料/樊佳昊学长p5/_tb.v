`timescale 1ns / 1ps

module _tb;
	reg clk;
	reg reset;

	mips uut (
		.clk(clk),
		.reset(reset)
	);

	initial begin
		clk = 0;
		reset = 1;

		#100;
		reset = 0;
	end

	always #2 clk=~clk;

endmodule
 
