module my_vga(
    input clk,rst,
    output en,
    output [15:0] vga_addr,
    output hsync,
    output vsync
);

wire vga_en;
wire [9:0] h_pos,v_pos;
parameter hd = 800, hf = 56, hs = 120, hb = 64;
parameter vd = 600, vf = 37, vs = 6,   vb = 23;
reg [10:0] hcnt,vcnt;
reg clk_50mhz;
wire [7:0] ra_h,ra_v;

//clk_wiz_0 Clk(.clk_in1(clk),.clk_out1(clk_50mhz));
assign vga_en = (hcnt < hd) && (vcnt < vd);
assign h_pos = vga_en ? hcnt : 0;
assign v_pos = vga_en ? vcnt : 0;
assign hsync = ~((hcnt >= hd + hf) && (hcnt < hd + hf + hs));
assign vsync = ~((vcnt >= vd + vf) && (vcnt < vd + vf + vs));

assign ra_h = h_pos - 272;
assign ra_v = v_pos - 172;
assign en = vga_en && (h_pos >= 272 && h_pos < 528 && v_pos >= 172 && v_pos < 428);
assign vga_addr = en ? {ra_v,ra_h} : 0;

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
    else if(clk_50mhz) begin
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