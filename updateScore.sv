module updateScore (Clock, reset, start, hex, score, next, fail, crush);
	input logic Clock, reset, start, score, fail, crush;
	output logic next;
	output logic [6:0] hex;

	logic [6:0] ps, ns;
	
	always_comb begin
      if(score && !crush && !fail)
	      case(ps)
	         7'b1000000:		ns = 7'b1111001;
				7'b1111001:		ns = 7'b0100100;
				7'b0100100:		ns = 7'b0110000;
				7'b0110000:		ns = 7'b0011001;
				7'b0011001:		ns = 7'b0010010;
				7'b0010010:		ns = 7'b0000010;
				7'b0000010:		ns = 7'b1111000;
				7'b1111000:		ns = 7'b0000000;
				7'b0000000:		ns = 7'b0010000;
				7'b0010000:		ns = 7'b1000000;
				default:	ns = 7'b1111001;
			endcase
		else 
		   ns = ps;
	 end 				
	 
	 assign hex = ps;
	 assign next = (ps == 7'b0010000 & ns == 7'b1000000);
	 
	 always_ff @(posedge Clock) begin
	    if(reset)
		    ps <= 7'b1000000;
		 else if(start)
		    ps <= ns;
	end 
endmodule

module updateScore_testbench();
	  logic Clock, reset, start, score, fail, crush;
	  logic next;
	  logic [6:0] hex;
	
	updateScore dut(Clock, reset, start, hex, score, next, fail, crush);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end
	
	initial begin 
      fail <= 0;	start <= 1;	crush <= 0; @(posedge Clock);
		reset <= 1;  					      	@(posedge Clock);						
		reset <= 0;	 					 			@(posedge Clock);
														@(posedge Clock);
		score <= 1;				 					@(posedge Clock);
		score <= 1;					 				@(posedge Clock);

														@(posedge Clock);
														@(posedge Clock);
		$stop; 
	end
endmodule 