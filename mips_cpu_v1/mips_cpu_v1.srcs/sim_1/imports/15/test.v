module test;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] dout;
	wire [1:0] pcsrc;
    wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.dout(dout),
		.pcsrc(pcsrc)
	);

	always #1 clk	=	~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		// Wait 100 ns for global reset to finish
		#10;
        rst	= 0;
		// Add stimulus here
	end
endmodule