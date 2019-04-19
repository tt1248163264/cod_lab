`timescale 1ns / 1ps

module top(
    input en_out,
    input [3:0] in,
    input en_in,
    input rst,
    input clk,
    output reg [7:0] an,
    output reg [6:0] seg,
    output reg dp,
    output [3:0] out,
    output empty,
    output full//,
    //output [3:0] out0,
    //output [3:0] out1,
    //output [3:0] out2,
    //output [3:0] out3,
    //output [3:0] out4,
    //output [3:0] out5,
    //output [3:0] out6,
    //output [3:0] out7,
    //output reg [3:0] counter,
    //output reg [2:0] head_add,
    //output reg [2:0] tail_add
    );
    wire clk_5mhz;
    wire rst_n;
    reg [3:0] counter;
    reg [2:0] head_add = 3'b111;
    reg [2:0] tail_add = 3'b111;
    reg [3:0] in_data;
    reg [2:0] in_add;
    reg [16:0] cnt;
    reg [2:0] ra1 = 3'b000;
    reg [3:0] seg_data;
    wire [3:0] rd1;
    reg flag_in;
    integer index;
    reg flagin,flagout;
    clk_wiz_0 Clk(.reset(rst),.clk_in1(clk),.clk_out1(clk_5mhz),.locked(rst_n));
    RegFile Reg(.ra0(head_add),.ra1(ra1),.wa(in_add),.wd(in_data),.we(en_in | en_out),.rst(rst),.clk(clk_5mhz),.rd0(out),.rd1(rd1));//,.out0(out0),.out1(out1),.out2(out2),.out3(out3),.out4(out4),.out5(out5),.out6(out6),.out7(out7));
    always @ (negedge rst_n or posedge clk_5mhz)begin
        if(~rst_n)begin
            head_add <= 3'b111;
            tail_add <= 3'b000;
            counter  <= 4'b0000;
            in_add <= 3'b111;
            in_data <= 4'b1111;
            flagin <= 1'b0;
            flagout <= 1'b1;
        end
        else if(en_in & ~flagin)begin
            flagin <= 1'b1;
            if(~full)begin
            in_add <= tail_add - 1'b1;
            in_data <= in;
            end
        end
        else if(~en_in & flagin)begin
            flagin <= 1'b0;
            if(~full)begin
            tail_add <= tail_add - 1'b1;
            counter <= counter + 1'b1;
            end
        end
        else if(en_out & flagout)begin
            flagout <= 1'b0;
            if(~empty)begin
            in_add <= head_add;
            in_data <= 4'b1111;
            head_add <= head_add - 1'b1;
            counter <= counter - 1'b1;
            end
        end
        else if(~en_out & ~flagout)begin
                flagout <= 1'b1;
        end
        //else if(~en_out & ~flagout)begin
        //    flagout <= 1'b1;
        //end
    end
/*always @ (negedge rst_n or posedge clk_5mhz)begin
    if(~rst_n)begin
        head_add <= 3'b111;
        tail_add <= 3'b000;
        counter  <= 4'b0000;
        in_add <= 3'b111;
        in_data <= 4'b1111;
        flagin <= 1'b0;
        flagout <= 1'b0;
    end
    else if(en_in & ~flagin)begin
        flagin <= 1'b1;
        in_add <= tail_add - 1'b1;
        in_data <= in;
    end
    else if(~en_in & flagin)begin
        flagin <= 1'b0;
        if(~full)begin
            tail_add <= tail_add - 1'b1;
            counter <= counter + 1'b1;
        end
    end
    else if(en_out & ~flagout)begin
        flagout <= 1'b1;
        in_add <= head_add;
        in_data <= 4'b1111;
    end
    else if(~en_out & flagout)begin
        if(head_add != tail_add)begin
            //in_add <= head_add;
            //in_data <= 4'b1111;
            flagout <= 1'b0;
            head_add <= head_add - 1'b1;
            counter <= counter - 1'b1;
        end
        else begin
            flagout <= 1'b0;
        end
    end
    //else if(~en_out & ~flagout)begin
    //    flagout <= 1'b1;
    //end
end*/
/*
always @ (*)begin
    if(head_add >= tail_add)begin
        if(ra1 >= tail_add & ra1 <= head_add)begin
            seg_data <= rd1;
        end
        else begin
            seg_data <= 4'b1111;
        end
    end
    else begin
        if(ra1 >= tail_add | ra1 <= head_add)begin
            seg_data <= rd1;
        end
        else begin
            seg_data <= 4'b1111;
        end
    end
end
*/
always @ (posedge clk_5mhz)begin
    if(~rst_n)begin
        cnt<=17'd0;
    end
    else if(cnt == 17'd9999)begin
        cnt <= 17'd0;
        ra1 <= ra1 + 1'b1;
    end
    else begin
        cnt <= cnt + 1'b1;
    end
end

always @ (*)begin
    case(ra1)
        3'b000:begin
            an = 8'b1111_1110;
            if(head_add == 3'b000)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b001:begin 
            an = 8'b1111_1101;
            if(head_add == 3'b001)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b010:begin
            an = 8'b1111_1011;
            if(head_add == 3'b010)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b011:begin 
            an = 8'b1111_0111;
            if(head_add == 3'b011)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b100:begin
            an = 8'b1110_1111;
            if(head_add == 3'b100)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b101:begin
            an = 8'b1101_1111;
            if(head_add == 3'b101)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b110:begin
            an = 8'b1011_1111;
            if(head_add == 3'b110)dp = 1'b0;
            else dp = 1'b1;
        end
        3'b111:begin
            an = 8'b0111_1111;
            if(head_add == 3'b111)dp = 1'b0;
            else dp = 1'b1;
        end
    endcase
end

always @ (*)begin
    case(rd1)
        4'b0000:seg <= 7'b1000_000;
        4'b0001:seg <= 7'b1111_001;
        4'b0010:seg <= 7'b0100_100;
        4'b0011:seg <= 7'b0110_000;
        4'b0100:seg <= 7'b0011_001;
        4'b0101:seg <= 7'b0010_010;
        4'b0110:seg <= 7'b0000_010;
        4'b0111:seg <= 7'b1111_000;
        4'b1000:seg <= 7'b0000_000;
        4'b1001:seg <= 7'b0010_000;
        default:seg <= 7'b1111_111;
    endcase
end
assign full = (counter == 4'b1000 ) ? 1'b1:1'b0;
assign empty = (counter== 4'b0000) ? 1'b1:1'b0;
endmodule
