module my_painter(
    input [11:0] pixel,
    input draw,rst,clk,
    input Bt_Up,Bt_Down,Bt_Left,Bt_Right,
    output H_SYNC,V_SYNC,
    output [3:0] r,g,b
);
wire [15:0] vram_wa,vram_ra;
wire [11:0] vram_wd,vram_rd;
wire [7:0] ra_h,ra_v;
wire en,vga_en;
wire [9:0] vga_hd,vga_vd;
wire mu,md,ml,mr;
integer Ucnt,Dcnt,Rcnt,Lcnt;
reg [7:0] h_pos,v_pos;
reg [15:0] clean_screen_cnt;
my_vga VGA(.clk(clk),.rst(rst),.hsync(H_SYNC),.vsync(V_SYNC),.h_pos(vga_hd),.v_pos(vga_vd),.en(vga_en));
my_vram VRAM(.clk(clk),.we(draw),.ra(vram_ra),.wa(vram_wa),.wd(vram_wd),.rd(vram_rd));

assign vram_wd = rst ? 12'hfff : pixel;
assign vram_wa = rst ? clean_screen_cnt : {v_pos,h_pos};
assign ra_h = vga_hd - 272;
assign ra_v = vga_vd - 172;
assign en = vga_en && (vga_hd >= 272 && vga_hd < 528 && vga_vd >= 172 && vga_vd < 428);
assign vram_ra = en ? {ra_v,ra_h} : 0;
assign {r,g,b} = en ? ((ra_h == h_pos && ra_v == v_pos) ? 12'hfff : vram_rd) : 12'h0;

always @ (posedge clk)begin
    clean_screen_cnt <= clean_screen_cnt + 1;
end

always @ (posedge clk)begin
    if(rst)begin
        h_pos <= 0;
        v_pos <= 0;
    end
    else begin
        if(mu && v_pos > 0)     v_pos <= v_pos - 1;
        if(md && v_pos < 255)   v_pos <= v_pos + 1;
        if(ml && h_pos > 0)     h_pos <= h_pos - 1;
        if(mr && h_pos < 255)   h_pos <= h_pos + 1;
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
assign mu = (Ucnt == 1) || ((Ucnt >= 100_000_000) && (Ucnt % 5_000_000 == 0));
assign md = (Dcnt == 1) || ((Dcnt >= 100_000_000) && (Dcnt % 5_000_000 == 0));
assign ml = (Lcnt == 1) || ((Lcnt >= 100_000_000) && (Lcnt % 5_000_000 == 0));
assign mr = (Rcnt == 1) || ((Rcnt >= 100_000_000) && (Rcnt % 5_000_000 == 0));

endmodule