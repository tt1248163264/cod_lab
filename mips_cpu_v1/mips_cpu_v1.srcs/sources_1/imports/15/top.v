module top(
input clk,
input rst,
output [31:0] dout
    );
/*
 *log:data path should need changed: bne data-path
 * debug control.v
 * finish DDU
 */

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
wire [31:0] rd3;
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

assign dout = aluresult;

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
.dpra       (adr[8:2]           ),//there should be changed in the DDU
.d	     	(b[31:0]			),
.dpo		(rd				    )
);

REG_FILE	u_REG_FILE(
.clk		(clk				),
.rst        (rst                ),
.r1_addr	(instr[25:21]	    ),
.r2_addr	(instr[20:16]	    ),
.r3_addr	(		    ),
.w_addr     (writereg           ),
.w_din		(result			    ),
.w_en		(regwrite		    ),
.r1_dout	(rd1				),
.r2_dout	(rd2				),
.r3_dout    (rd3                )
);

alu			u_alu(
.alu_a		(srca				),
.alu_b		(srcb				),
.alu_op		(alucontrol		    ),
.alu_out	(aluresult     		),
.alu_zero	(zero				)
);

endmodule