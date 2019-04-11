module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, KEY, GPIO_0, SW, start);
	input logic CLOCK_50; // 50MHz clock.
	input logic [9:0]SW;
	input logic [3:3]KEY;
	output logic [35:12]GPIO_0;
	output logic [6:0] HEX0, HEX1, HEX2;
	logic [7:0][7:0] red = 0;
	logic [7:0][7:0] green = 0;
	logic key3;
	output logic start;
	logic [7:0] pattern;
	logic score, crash;
	logic next, incre1, incre2;
	
	//logic [31:0] clk;
	//parameter whichClock = 14;
	//clock_divider cdiv (CLOCK_50, clk);	 

	userInput pressedKey(CLOCK_50, SW[9], ~KEY[3], key3);
	
	assign start = 1;
	//activeGame game(CLOCK_50, SW[9], start, out);
	
	patternGenerator generateRandomPattern(CLOCK_50, SW[9], pattern);	
	
 	led_matrix_driver matrixPanelControl (CLOCK_50, red, green, GPIO_0[27:20], GPIO_0[35:28], GPIO_0[19:12]);
	
	pipe generatePipes(CLOCK_50, SW[9], start, pattern, green, score, red[3], crash, gameOver);
	
	//logic gameOver;
	controlBirdMovement moveBird(CLOCK_50, SW[9], start, key3, crash, red[3], gameOver);
	
	updateScore firstDigit (CLOCK_50, SW[9], start, HEX0, score, next, gameOver, crash);
	updateScore secondDigit (CLOCK_50, SW[9], start, HEX1, next, incre1, gameOver, crash);
	updateScore thirdDigit (CLOCK_50, SW[9], start, HEX2, incre1, incre2, gameOver, crash);
	
endmodule

//// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...  
//module clock_divider (clock, divided_clocks);
//	input logic clock;
//	output logic [31:0] divided_clocks;
//	
//	initial begin
//		divided_clocks <= 0;
//	end
//	
//	always_ff @(posedge clock) begin
//		divided_clocks <= divided_clocks + 1;
//	end
//	
//endmodule

module DE1_SoC_testbench();
	logic CLOCK_50; // 50MHz clock.
	logic [9:0]SW;
	logic [3:3]KEY;
	logic [35:12]GPIO_0;
	logic [6:0] HEX0, HEX1, HEX2;	 
	
	DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, KEY, GPIO_0, SW,start);
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0; 
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	// Set up the inputs to the design. Each line is a clock cycle.
	integer i;
	initial begin
		SW[9] <= 0; KEY[3] <= 0;										@(posedge CLOCK_50);
		SW[9] <= 1;							                        @(posedge CLOCK_50);
																				@(posedge CLOCK_50);
		SW[9] <= 0;															@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
		
		for(i = 0; i < 12; i++) begin
							KEY[3] <= 0;									@(posedge CLOCK_50);
							KEY[3] <= 1;									@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
		end
							KEY[3] <= 0;									@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);
																				@(posedge CLOCK_50);

																								
	$stop; // End the simulation.
	end
endmodule 

	