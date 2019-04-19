`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/17 13:23:53
// Design Name: 
// Module Name: my_vram
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


module my_vram(
    input clk,
    input we,
    input [15:0] ra,
    input [15:0] wa,
    input [11:0] wd,
    output [11:0] rd
    );
blk_mem_gen_0 VRAM(.addra(wa),.clka(clk),.dina(wd),.ena(1),.wea(we),.addrb(ra),.clkb(clk),.doutb(rd),.enb(1));
endmodule
