module patternGenerator (Clock, reset, pattern);
   input logic reset, Clock;
	logic [2:0] generateBits;
	logic getResponse;
	
	output logic [7:0]pattern; 
	
	assign getResponse = ~(generateBits[1] ^ generateBits[0]);
	
	always_ff @(posedge Clock) begin
	   if(reset)
		   generateBits <= 3'b000;
		else 
		   generateBits <= {getResponse, generateBits[2],generateBits[1]};
	end
	
	always_comb begin
		case(generateBits)
			3'b001: pattern = 8'b00011111;
			3'b010: pattern = 8'b10001111;
			3'b011: pattern = 8'b11000111;
			3'b100: pattern = 8'b11100011;
			3'b101: pattern = 8'b11110001;
			3'b110: pattern = 8'b11111000;
			default:pattern = 8'b00000000;
		endcase
	end
endmodule

module patternGenerator_testbench();
	logic Clock, reset;
	logic [7:0] pattern;
	
	patternGenerator dut(Clock, reset, pattern);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end
	
	initial begin
		reset <= 1;							@(posedge Clock);
		reset <= 0;							@(posedge Clock);
												@(posedge Clock);
												@(posedge Clock);
												@(posedge Clock);
												@(posedge Clock);

	end
endmodule