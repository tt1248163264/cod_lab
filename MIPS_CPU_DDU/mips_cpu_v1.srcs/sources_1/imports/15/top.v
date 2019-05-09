module top(
input clk_100mhz,//clock on board 
input clk_swi,//clock by switch 
input cont,//choose for clk_100mhz or switch
input rst,//reset
input mem_or_rf,//watch memory or reg files
input inc,//increase the address
input dec,//decrease the address
input mem_rf_pc,
output [15:0] mem_rf_pc_addr,
output reg [7:0] an,
output reg [6:0] seg
//output [31:0] dout
    );
/*
 *log:data path should need changed: bne data-path
 * debug control.v
 * finish DDU
 */
wire clk,clk_5mhz;
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

reg [31:0] pc1;
reg [31:0] pc;
wire [31:0] pcjump;
wire [31:0] adr;
wire [31:0] rd;
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

wire pcen;

/*-------------DDU module-----------------*/

clk_wiz_0 CLK(.clk_in1(clk_100mhz),.clk_out1(clk_5mhz));

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
assign result = memtoreg ? data : aluout;

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

//assign dout = aluresult;

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
.bne        (bne                )
);

dist_mem_gen_0			u_mem(
.clk		(clk				),
.we		    (memwrite		    ),
.a		    (adr[8:2]		    ),
.dpra       (ddu_mem_addr[6:0]  ),//DDU_mem_addr
.d	     	(b[31:0]			),
.dpo		(ddu_mem_data[31:0] ),//dpra
.spo        (rd                 )//a
);

REG_FILE	u_REG_FILE(
.clk		(clk				),
.rst        (rst                ),
.r1_addr	(instr[25:21]	    ),
.r2_addr	(instr[20:16]	    ),
.r3_addr	(ddu_reg_addr[4:0]	),
.w_addr     (writereg           ),
.w_din		(result			    ),
.w_en		(regwrite		    ),
.r1_dout	(rd1				),
.r2_dout	(rd2				),
.r3_dout    (ddu_reg_data[31:0] )
);

alu			u_alu(
.alu_a		(srca				),
.alu_b		(srcb				),
.alu_op		(alucontrol		    ),
.alu_out	(aluresult     		),
.alu_zero	(zero				)
);

endmodule