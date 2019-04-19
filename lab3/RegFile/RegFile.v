`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/02 02:47:54
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input [4:0] ra0,
    input [4:0] ra1,
    input [4:0] wa,
    input [31:0] wd,
    input we,
    input rst,
    input clk,
    output [31:0] rd0,
    output [31:0] rd1
    );
    reg [31:0] regs [31:0];
    always @ (posedge clk or posedge rst)begin
        if(rst)begin
            regs[0] <= 32'b0;
            regs[1] <= 32'b0;
            regs[2] <= 32'b0;
            regs[3] <= 32'b0;
            regs[4] <= 32'b0;
            regs[5] <= 32'b0;
            regs[6] <= 32'b0;
            regs[7] <= 32'b0;
            regs[8] <= 32'b0;
            regs[9] <= 32'b0;
            regs[10] <= 32'b0;
            regs[11] <= 32'b0;
            regs[12] <= 32'b0;
            regs[13] <= 32'b0;
            regs[14] <= 32'b0;
            regs[15] <= 32'b0;
            regs[16] <= 32'b0;
            regs[17] <= 32'b0;
            regs[18] <= 32'b0;
            regs[19] <= 32'b0;
            regs[20] <= 32'b0;
            regs[21] <= 32'b0;
            regs[22] <= 32'b0;
            regs[23] <= 32'b0;
            regs[24] <= 32'b0;
            regs[25] <= 32'b0;
            regs[26] <= 32'b0;
            regs[27] <= 32'b0;
            regs[28] <= 32'b0;
            regs[29] <= 32'b0;
            regs[30] <= 32'b0;
            regs[31] <= 32'b0;
        end
        else if(we)begin
            regs[wa] <= wd;
        end
    end
    assign rd0 = regs[ra0];
    assign rd1 = regs[ra1];
endmodule
