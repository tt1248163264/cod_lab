`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/02 03:13:35
// Design Name: 
// Module Name: counter
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


module counter(
    input [7:0] d,
    input pe,
    input ce,
    input rst,
    input clk,
    output reg [7:0] q
    );
    reg flag;
    always @ (posedge clk or posedge rst)begin
        if(rst)begin
            q <= 8'b0000_0000;
            flag <= 1'b1;
        end
        else if(pe)begin
            q <= d;
            flag <= 1'b1;
        end
        else if(ce & flag)begin
            q <= q + 8'b1;
            flag <= 1'b0;
        end
        else if(~ce & ~flag)begin
            flag <= 1'b1;
        end
        else begin
            q <= q;
        end
            
    end
    //assign q = temp;
endmodule
