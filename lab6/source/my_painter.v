module my_painter(
    input rst,clk,draw,
    input Bt_Up,Bt_Down,Bt_Left,Bt_Right,
    output en_paint,
    output [15:0] paint_addr
);

wire mu,md,ml,mr;
integer Ucnt,Dcnt,Rcnt,Lcnt;
reg [7:0] h_pos,v_pos;
reg [15:0] clean_screen_cnt;

assign paint_addr = rst ? clean_screen_cnt : ({v_pos,h_pos});
//assign en_paint = ((mu && v_pos > 0) || (md && v_pos < 254) || (ml && h_pos > 0) || (mr && h_pos < 256)) && draw;
assign en_paint = (mu || md || ml || mr) && draw;

always @ (posedge clk)begin
    if(rst)
        clean_screen_cnt <= clean_screen_cnt + 1;
end

always @ (posedge clk)begin
    if(rst)begin
        h_pos <= 127;
        v_pos <= 127;
    end
    else begin
        if(mu && (Ucnt%5_000_000==0) && v_pos > 0)     v_pos <= v_pos - 1;
        if(md && (Dcnt%5_000_000==0) && v_pos < 255)   v_pos <= v_pos + 1;
        if(ml && (Lcnt%5_000_000==0) && h_pos > 0)     h_pos <= h_pos - 1;
        if(mr && (Rcnt%5_000_000==0) && h_pos < 255)   h_pos <= h_pos + 1;
    end
end
always @ (posedge clk)begin
    if(rst)begin
        Ucnt <= 0;
        Dcnt <= 0;
        Lcnt <= 0;
        Rcnt <= 0;
    end
    else begin
        if(Bt_Up)   Ucnt <= Ucnt + 1;
        else        Ucnt <= 0;
        if(Bt_Down) Dcnt <= Dcnt + 1;
        else        Dcnt <= 0;
        if(Bt_Left) Lcnt <= Lcnt + 1;
        else        Lcnt <= 0;
        if(Bt_Right)Rcnt <= Rcnt + 1;
        else        Rcnt <= 0;
    end
end
assign mu = (Ucnt == 1) || (Ucnt >= 100_000_000);
assign md = (Dcnt == 1) || (Dcnt >= 100_000_000);
assign ml = (Lcnt == 1) || (Lcnt >= 100_000_000);
assign mr = (Rcnt == 1) || (Rcnt >= 100_000_000);
/*
assign mu = (Ucnt == 1) || ((Ucnt >= 100_000_000) && (Ucnt % 5_000_000 == 0));
assign md = (Dcnt == 1) || ((Dcnt >= 100_000_000) && (Dcnt % 5_000_000 == 0));
assign ml = (Lcnt == 1) || ((Lcnt >= 100_000_000) && (Lcnt % 5_000_000 == 0));
assign mr = (Rcnt == 1) || ((Rcnt >= 100_000_000) && (Rcnt % 5_000_000 == 0));
*/
endmodule