module my_vga(
    input clk,rst,
    output hsync,vsync,
    output [9:0] h_pos,v_pos,
    output en
);
parameter hd = 800, hf = 56, hs = 120, hb = 64;
parameter vd = 600, vf = 37, vs = 6,   vb = 23;
reg [10:0] hcnt,vcnt;
reg clk_50mhz;
assign en = (hcnt < hd) && (vcnt < vd);
assign h_pos = en ? hcnt : 0;
assign v_pos = en ? vcnt : 0;
assign hsync = ~((hcnt >= hd + hf) && (hcnt < hd + hf + hs));
assign vsync = ~((vcnt >= vd + vf) && (vcnt < vd + vf + vs));
//50mhz clk
always @ (posedge clk)begin
    if(rst)
        clk_50mhz <= 1'b0;
    else
        clk_50mhz <= ~clk_50mhz;
end 

always @ (posedge clk)begin
    if(rst)begin
        hcnt <= 0;
        vcnt <= 0;
    end 
    else if(clk_50mhz)begin
        if(hcnt >= hd + hf + hs + hb - 1)begin
            hcnt <= 0;
            if(vcnt >= vd + vf + vs + vb - 1)
                vcnt <= 0;
            else
                vcnt <= vcnt + 1;
        end
        else
            hcnt <= hcnt + 1;
    end
end
endmodule