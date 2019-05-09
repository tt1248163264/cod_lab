`timescale 1ns / 1ps
module test;

	// Inputs
	reg rst;
    reg clk_100mhz;
    reg clk_swi;
    reg cont;
    reg mem_or_rf;
    reg inc;
    reg dec;
    reg mem_rf_pc;
    
	// Outputs
	wire [15:0] mem_rf_pc_addr;
	wire [1:0] pcsrc;
    wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk_100mhz(clk_100mhz), 
		.clk_swi(clk_swi),
		.cont(cont),
		.rst(rst), 
		.mem_or_rf(mem_or_rf),
		.inc(inc),
        .dec(dec),
        .mem_rf_pc(mem_rf_pc),
        .mem_rf_pc_addr(mem_rf_pc_addr)
	);
    always #1 clk_100mhz = ~clk_100mhz;
	always #1 clk_swi	=	~clk_swi;

	initial begin
		// Initialize Inputs
		clk_swi = 0;
		clk_100mhz = 0;
		rst = 1;
		// Wait 100 ns for global reset to finish
		#10;
        rst	= 0;
        cont = 0;
		// Add stimulus here
		#9 inc = 1; #1 inc = 0;
		#9 inc = 1; #1 inc = 0;
		#9 inc = 1; #1 inc = 0;
		#9 inc = 1; #1 inc = 0;
		#9 inc = 1; #1 inc = 0;
		#9 inc = 1; #1 inc = 0;
	end
endmodule