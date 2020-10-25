`timescale 1ns / 1ps
module GCD_tb;

	// Inputs
	reg CLOCK_125_p = 1;
	reg [7:0] SW;
	reg [1:0] KEY;
	reg button = 0;
	reg rst = 0;

	// Outputs
	wire [7:0] LEDR;
	
	// Instantiate the Unit Under Test (UUT)
	baseline_c5gx uut (
		.CLOCK_125_p(CLOCK_125_p), 
		.SW(SW), 
		.KEY(KEY), 
		.LEDR(LEDR)
	);

		always #10 CLOCK_125_p <= !CLOCK_125_p;
	always #100 KEY[1] <= !KEY[1];


	initial begin
		// Initialize Inputs
		SW = -20;
		KEY = 0;
		// Wait 100 ns for global reset to finish
		#350;
        SW = 50;
		// Add stimulus here
	
	end
      
endmodule
