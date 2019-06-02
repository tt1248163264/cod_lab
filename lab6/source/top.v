module top(
    input clk,//clock on board 
    input rst,//reset
    input [5:0] pixel,
    input Bt_Up,
    input Bt_Down,
    input Bt_Left,
    input Bt_Right,
    input draw,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output HSYNC,
    output VSYNC,
    output [15:0] dist
    );
/*
(1)log:
    data path should need changed: bne data-path
    debug control.v
    finish DDU
(2)To-Do-List:
    a.Data-Path: In_data 
        (1) In_data: How to decide the value
        (2) Memory address bits
    b.Controler: Extend instruction state machine
        Signal: In_ctrl in every state
    c.VGA module:
        (1)How to decide the ctrl signal 'In_ctrl'
        (2)VGA rgb data read
        (3)State 18 can be removed
*/ 
 
//wire clk_5mhz
/*
wire [31:0] ddu_data;
wire [31:0] ddu_reg_data;
wire [31:0] ddu_mem_data;
reg [4:0] ddu_reg_addr;
reg [6:0] ddu_mem_addr;
reg [2:0] flag;
reg [16:0] cnt;
reg [3:0] seg_data;
reg inc_flag;
reg dec_flag;
*/
reg [31:0] pc1;
reg [31:0] pc;
wire [31:0] pcjump;
wire [31:0] adr;
wire [31:0] rd;//reg data / memory out data 
wire [31:0] mem_data;
reg [31:0] instr;
reg [31:0] data;
wire iord;
wire memwrite;
wire irwrite;
wire pcwrite;
wire branch;
wire bne;
wire [1:0] pcsrc;
wire [2:0] alucontrol;
wire [1:0] alusrcb;
wire alusrca;
wire regwrite;
wire memtoreg;
wire regdst;
wire [31:0] rd1;
wire [31:0] rd2;
reg [31:0] a;
reg [31:0] b;
wire [31:0] result;
wire [4 :0] writereg;
reg [31:0] signimm;
wire [31:0] signimml2;
wire [31:0] srca;
reg [31:0] srcb;
wire zero;
wire [31:0] aluresult;
reg [31:0] aluout;
wire In_ctrl;//This is the control signal for the I/O input data read
wire [31:0] In_data;
wire [15:0] vga_addr;
wire [31:0] vga_data;
wire [15:0] paint_addr;
wire en_paint;
wire vga_en;
wire pcen;
wire [31:0] dist_blk_data;
/*-------------DDU module-----------------*/
/*
assign mem_rf_pc_addr = (mem_rf_pc) ? (pc[15:0]) : (mem_or_rf ? ddu_mem_addr : ddu_reg_addr);
assign clk = cont ? clk_100mhz : clk_swi;
assign ddu_data = mem_or_rf ? ddu_mem_data : ddu_reg_data;
always @ (posedge clk_5mhz)begin
    if(rst)begin
        ddu_mem_addr <= 0;
        ddu_reg_addr <= 0;
        inc_flag <= 1'b0;
        dec_flag <= 1'b0;
    end
    else if(inc && ~inc_flag)begin
        inc_flag <= 1'b1;
        if(mem_or_rf)
            ddu_mem_addr <= ddu_mem_addr + 1;
        else
            ddu_reg_addr <= ddu_reg_addr + 1;
    end
    else if(~inc && inc_flag)
        inc_flag <= 1'b0;
    else if(dec && ~dec_flag)begin
        dec_flag <= 1'b1;
        if(mem_or_rf)
            ddu_mem_addr <= ddu_mem_addr - 1;
        else
            ddu_reg_addr <= ddu_reg_addr - 1;
    end
    else if(~dec && dec_flag)
        dec_flag <= 1'b0;
    else begin
        ddu_mem_addr <= ddu_mem_addr;
        ddu_reg_addr <= ddu_reg_addr;
    end
end
always @ (posedge clk_5mhz)begin
    if(rst)
        cnt <= 17'd0;
    else if(cnt == 17'd9999)begin
        cnt <= 17'd0;
        flag <= flag + 1;
    end
    else 
        cnt <= cnt + 1;
end
always @ (*)begin
    case(flag)
        3'b000:begin
            an <= 8'b1111_1110;
            seg_data <= ddu_data[3:0];
        end
        3'b001:begin
            an <= 8'b1111_1101;
            seg_data <= ddu_data[7:4];
        end
        3'b010:begin
            an <= 8'b1111_1011;
            seg_data <= ddu_data[11:8];
        end
        3'b011:begin
            an <= 8'b1111_0111;
            seg_data <= ddu_data[15:12];
        end
        3'b100:begin
            an <= 8'b1110_1111;
            seg_data <= ddu_data[19:16];
        end
        3'b101:begin
            an <= 8'b1101_1111;
            seg_data <= ddu_data[23:20];
        end
        3'b110:begin
            an <= 8'b1011_1111;
            seg_data <= ddu_data[27:24];
        end
        3'b111:begin
            an <= 8'b0111_1111;
            seg_data <= ddu_data[31:28];
        end
    endcase
end
always @ (*)begin
    case(seg_data)
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
        4'b1010:seg <= 7'b0100_000;
        4'b1011:seg <= 7'b0000_011;
        4'b1100:seg <= 7'b1000_110;
        4'b1101:seg <= 7'b0100_001;
        4'b1110:seg <= 7'b0000_100;
        4'b1111:seg <= 7'b0001_110;
        default:seg <= 7'b1111_111;
    endcase
end
*/
assign dist = draw ? In_data[31:16] : In_data[15:0];
/*-----------------Painter-----------------*/
wire [11:0] In_vga;//it's a temp wire value for the In data

assign {vga_r,vga_g,vga_b} = vga_en ? vga_data : 12'h000;

assign In_vga = rst ? 12'hfff : {2'b00,pixel[5:4],2'b00,pixel[3:2],2'b00,pixel[1:0]};
assign In_data = {en_paint, en_paint, en_paint, en_paint, In_vga, paint_addr[15:0]};

/*-----------------------------------------*/

always@(posedge clk or posedge rst)
begin
	if(rst)
		pc <= 32'h0;
	else if(pcen)
		pc <= pc1;
end

assign adr = iord ? aluout : pc;

always@(posedge clk)
begin
	if(irwrite)
		instr <= rd;
end

always@(posedge clk)
begin
	data <= rd;
end

assign writereg = regdst ? instr[15:11] : instr[20:16];
assign result = memtoreg ? (In_ctrl ? In_data : data): aluout;

always@(*)
begin
	if(instr[15])
		signimm = 32'hffff0000 + instr[15:0];
	else
		signimm = 32'h00000000 + instr[15:0];
end

assign signimml2[31:2]= signimm[29:0];
assign signimml2[1:0] = 2'h0;

always@(posedge clk)
begin
	a <= rd1;
end

always@(posedge clk)
begin
	b <= rd2;
end

assign srca = alusrca ? a : pc;

always@(*)
begin
	case(alusrcb)
		2'b00: srcb = b;
		2'b01: srcb = 32'h4;
		2'b10: srcb = signimm;
		2'b11: srcb = signimml2;
	endcase
end

assign pcjump[31:28] = pc[31:28];
assign pcjump[27:2] = instr[25:0];
assign pcjump[1:0] = 2'h0;

assign pcen = pcwrite | (branch & ~zero) | (bne & zero);

always @ (posedge clk)
begin
	aluout <= aluresult;
end

always@(*)
begin
	case(pcsrc)
		2'b00: pc1 = aluresult;
		2'b01: pc1 = aluout;
		2'b10: pc1 = pcjump;
		default: pc1 = 32'h0;
	endcase
end

my_painter  u_painter(
.rst        (rst),
.clk        (clk),
.draw       (draw),
.Bt_Up      (Bt_Up),
.Bt_Down    (Bt_Down),
.Bt_Left    (Bt_Left),
.Bt_Right   (Bt_Right),
.en_paint   (en_paint),
.paint_addr (paint_addr)
);

my_vga      u_vga(
.clk        (clk                ),
.rst        (rst                ),
.en         (vga_en             ),
.vga_addr   (vga_addr           ),
.hsync      (HSYNC              ),
.vsync      (VSYNC              )
);

control		u_control(
.opcode		(instr[31:26]       ),
.funct		(instr[5:0]	        ),
.clk		(clk			    ),
.rst		(rst		        ),
.iord		(iord			    ),
.memwrite	(memwrite	        ),
.irwrite	(irwrite		    ),
.pcwrite	(pcwrite		    ),
.branch		(branch		        ),
.pcsrc		(pcsrc		        ),
.alucontrol	(alucontrol[2:0]    ),
.alusrcb	(alusrcb[1:0]       ),
.alusrca	(alusrca       		),
.regwrite	(regwrite			),
.memtoreg	(memtoreg			),
.regdst		(regdst				),
.bne        (bne                ),
.In_ctrl    (In_ctrl            )
);
blk_mem_gen_0   b_mem(
.addra      (dist_blk_data[15:0]),//adr[17:2]
.clka       (clk),
.dina       (dist_blk_data[27:16]),//b[31:0]
.wea        (1),
.addrb      (vga_addr),//vga_addr[15:0]
.clkb       (clk),
.doutb      (vga_data)//vga_data[31:0]
);

dist_mem_gen_0  d_mem(
.clk		(clk				),
.we		    (memwrite		    ),
.a		    (adr[9:2]		    ),
.dpra       (8'b11111111        ),//dist_blk_addr
.d	     	(b[31:0]			),
.dpo		(dist_blk_data      ),//dpra
.spo        (rd                 )//a
);

REG_FILE	u_REG_FILE(
.clk		(clk				),
.rst        (rst                ),
.r1_addr	(instr[25:21]	    ),
.r2_addr	(instr[20:16]	    ),
.r3_addr	(),
.w_addr     (writereg           ),
.w_din		(result			    ),
.w_en		(regwrite		    ),
.r1_dout	(rd1				),
.r2_dout	(rd2				),
.r3_dout    ()
);

alu			u_alu(
.alu_a		(srca				),
.alu_b		(srcb				),
.alu_op		(alucontrol		    ),
.alu_out	(aluresult     		),
.alu_zero	(zero				)
);

endmodule