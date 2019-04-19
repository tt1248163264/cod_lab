`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 10:43:50
// Design Name: 
// Module Name: sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim();
reg [4:0] ra0;
reg [4:0] ra1;
reg [4:0] wa;
reg [31:0] wd;
reg we,rst,clk;
wire [31:0] rd0;
wire [31:0] rd1;
RegFile RF(.ra0(ra0),.ra1(ra1),.wa(wa),.wd(wd),.we(we),.rst(rst),.clk(clk),.rd0(rd0),.rd1(rd1));
initial begin
    clk = 1'b0;rst = 1'b0;we = 1'b0;
    #5 rst = 1'b1;#5 rst = 1'b0;
    ra0 = 5'b00000;
    ra1 = 5'b10000;
    #3 we = 1'b1; wa = 5'b0_0000;wd = 32'h87654321;
    #3 we = 1'b0; 
    #3 we = 1'b1; wa = 5'b1_0000;wd = 32'h12345678;
end
always #2 clk = ~clk;
endmodule
