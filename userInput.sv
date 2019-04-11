module userInput (clk, reset, key, ctrl);
	input clk, reset;
	input key;
	output ctrl;
	
	reg ps, ns;
	
	always @(*)
		ns = key;
	
	assign ctrl = ps;
	
	always @(posedge clk)
		if (reset)
			ps <= 1'b0;
		else
			ps <= ns;
endmodule

module userInput_testbench();
	reg clk, reset;
	reg key;
	wire out;
	
	userInput dut (clk, reset, key, out);
	
	parameter CLOCK_PERIOD=100;
	initial clk=1;
	always begin
		#(CLOCK_PERIOD/2);
		clk = ~clk;
	end
	
	initial begin
		reset <= 1;	key <= 1;	@(posedge clk);
						key <= 0;	@(posedge clk);
		reset <= 0;					@(posedge clk);
						key <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						key <= 0;	@(posedge clk);
										@(posedge clk);
		$stop;
	end
endmodule
