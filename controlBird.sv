module controlBirdMovement(Clock, reset, start, key, crash, position, gameOver);
	input logic Clock, reset, start;
	input logic key, crash;

	output logic gameOver;
	output logic [7:0]position;
   
	logic [7:0] ps, ns;

	always_comb begin
		case(ps)
			8'b10000000: if (crash) ns = 8'b10000000;
				else if (key) ns = 8'b01000000;
				else ns = 8'b00000000;			
			8'b01000000: if (crash) ns = 8'b01000000;
				else if (key) ns = 8'b00100000;
				else ns = 8'b10000000;			
			8'b00100000: if (crash) ns = 8'b00100000;
				else if (key) ns = 8'b00010000;
				else ns = 8'b01000000;
			8'b00010000: if (crash) ns = 8'b00010000;
				else if (key) ns = 8'b00001000;
				else ns = 8'b00100000;					
			8'b00001000: if (crash) ns = 8'b00001000;
				else if (key) ns = 8'b00000100;
				else ns = 8'b00010000;				
			8'b00000100: if (crash) ns = 8'b00000100;
				else if (key) ns = 8'b00000010;
				else ns = 8'b00001000;			
			8'b00000010: if (crash) ns = 8'b00000010;
				else if (key) ns = 8'b00000001;
				else ns = 8'b00000100;				
			8'b00000001: if (crash) ns = 8'b00000001;
				else if (key) ns = 8'b00000000;
				else ns = 8'b00000010;				
			8'b00000000 : ns = 8'b00000000;		
			default: ns = 8'b00010000;
		endcase
	end
	
	assign gameOver = (ps == 8'b00000000);
	assign position = ps;
	
	
	always_ff @(posedge Clock) begin
		if(reset)
			ps <= 8'b00010000;
		else if(start)
			ps <= ns;
	end
	
endmodule

module controlBirdMovement_testbench();
   logic Clock, reset, start, key, crash;
	logic [7:0] position;
	logic gameOver;
	
	controlBirdMovement dut(Clock, reset, start, key, crash, position, gameOver);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end
	
	initial begin 
		start <= 1;		crash <= 0; 	key <= 1;@(posedge Clock);
		reset <= 1; 									@(posedge Clock);					
		reset <= 0;		key <= 0;					@(posedge Clock);
															@(posedge Clock);
										      	      @(posedge Clock);
										 	            @(posedge Clock);
										         	   @(posedge Clock);
															@(posedge Clock);
					 crash <= 1;						@(posedge Clock);
		reset <= 1; 									@(posedge Clock);					
		reset <= 0;					 					@(posedge Clock);
															@(posedge Clock);
															@(posedge Clock);
															@(posedge Clock);
															@(posedge Clock);
															@(posedge Clock);

		$stop; 
	end
endmodule 