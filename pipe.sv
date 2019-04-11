module pipe (Clock, reset, start, pattern, wall, score, bird, crash, gameOver);
   input logic [7:0] pattern;
	input logic Clock, reset, start, gameOver;
	input logic [7:0] bird;

	output logic [7:0] [7:0] wall;
	output logic crash, score;	

	logic [7:0] [7:0] ps, ns;
	logic [2:0] cycle; 
   
	assign wall[7:0] = ps[7:0];
	assign crashZero = ps[3][0] && bird[0],
			 crashOne = ps[3][1] && bird[1],
			 crashTwo = ps[3][2] && bird[2],
			 crashThree = ps[3][3] && bird[3],
			 crashFour = ps[3][4] && bird[4],
			 crashFive = ps[3][5] && bird[5],
			 crashSix = ps[3][6] && bird[6],
			 crashSeven = ps[3][7] && bird[7];
		
	parameter zero = 3'b000,
				 one = 3'b001,
				 two = 3'b010,
				 three = 3'b011,
				 four = 3'b100,
				 five = 3'b101,
				 six = 3'b110,
				 seven = 3'b111;
				 
   assign crash = crashZero || crashOne || crashThree || crashFour || crashFive || crashSix || crashSeven;
	
	always_comb begin
		case (cycle)
			zero:
				if (!crash && !gameOver) begin
					ns[7:1] = ps[6:0];
			      ns[0] = pattern;
				end else begin
					ns[7:0] = ps[7:0];
				end
			one, two, three, four, five, six, seven: 
				if (!crash && !gameOver) begin
					ns[7:1] = ps[6:0];
					ns[0] = ps[7];
				end else begin
					ns[7:0] = ps[7:0];
				end			
		endcase
	end	
		
   always_ff @(posedge Clock) begin
		if (reset) begin
			cycle <= 3'b000;
			ps[7:0] <= {8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0};
		end else if(start) begin
			cycle <= cycle + one;
			ps[7:0] <= ns[7:0];
		end
	end
	
	always_ff @(posedge Clock) begin
		if (wall[4] != 8'b00000000)
			score = 1'b1;
		else  
			score = 1'b0;
	end
endmodule


module pipe_testbench();
   logic Clock, reset, gameOver, start;
   logic [7:0] bird;
	logic [7:0] [7:0] wall;
	logic score, crash;
   logic [7:0] pattern;
	
	pipe dut(Clock, reset, start, pattern, wall, score, bird, crash, gameOver);
	 
	parameter CLOCK_PERIOD=100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end
	
	initial begin 
		gameOver <= 0;	start <= 1;		bird <= 8'b01000000;							@(posedge Clock);
		reset <= 1;              					                           @(posedge Clock);						
		reset <= 0;	pattern <= 8'b11110011;				                  	@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);

		reset <= 1;																			@(posedge Clock);
		reset <= 0;																			@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
																                        @(posedge Clock);
						pattern <= 8'b10011001;											@(posedge Clock);
						 											                     @(posedge Clock);
																								@(posedge Clock);
						bird <= 8'b00000010;		                              @(posedge Clock);
		reset <= 1;																			@(posedge Clock);
		reset <= 0;																			@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						pattern <= 8'b10100001;											@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						bird <= 	8'b00000110;											@(posedge Clock);
		reset <= 1;																			@(posedge Clock);
		reset <= 0;																			@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						pattern <= 8'b10111001;											@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						bird <= 	8'b01100110;											@(posedge Clock);
		reset <= 1;																			@(posedge Clock);
		reset <= 0;																			@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						pattern <= 8'b10111111;											@(posedge Clock);
																								@(posedge Clock);
																								@(posedge Clock);
						bird <= 	8'b01110110;											@(posedge Clock);

		$stop; 
	end
endmodule 
	
	