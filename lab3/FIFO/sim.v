`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/02 15:53:43
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
reg en_out,en_in,rst,clk;
reg [3:0] in;
//wire [3:0] out0;wire [3:0] out1;
//wire [3:0] out2;wire [3:0] out3;
//wire [3:0] out4;wire [3:0] out5;
//wire [3:0] out6;wire [3:0] out7;wire [3:0] counter;
//wire [2:0] head;
//wire [2:0] tail;
wire empty,full;
wire [3:0] out;
top DUT(
    .en_out(en_out),.in(in),.en_in(en_in),.rst(rst),.clk(clk),
    .an(),.seg(),.dp(),
    .out(out),.empty(empty),.full(full)
    //.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7),
    //.counter(counter),.head_add(head),.tail_add(tail)
);
    initial begin
        clk = 1'b0;
        rst = 1'b0;
        #6  rst = 1'b0;
        #6  rst = 1'b1;
        #5 en_in = 1'b1;#1 en_in = 1'b1;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_in = 1'b1;#1 en_in = 1'b0;
        #5 en_out = 1'b1;#1 en_out = 1'b0;
        #5 en_out = 1'b1;#1 en_out = 1'b0;
        #5 en_out = 1'b1;#1 en_out = 1'b0;
        #5 en_out = 1'b1;#1 en_out = 1'b0;
    end
    initial begin
        in = 4'h1;
        #7 in = 4'h1;
        #7 in = 4'h2;
        #7 in = 4'h3;
        #7 in = 4'h4;
        #7 in = 4'h5;
        #7 in = 4'h6;
        #7 in = 4'h7;
        #7 in = 4'h8;
    end
    always #1 clk = ~clk;
endmodule
