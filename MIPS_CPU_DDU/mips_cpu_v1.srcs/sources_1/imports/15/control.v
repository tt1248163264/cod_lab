module control(
input [5:0] opcode,
input [5:0] funct,
input clk,
input rst,
output reg iord,
output reg memwrite,
output reg irwrite,
output reg pcwrite,
output reg branch,
output reg [1:0] pcsrc,
output reg [2:0] alucontrol,
output reg [1:0] alusrcb,
output reg alusrca,
output reg regwrite,
output reg memtoreg,
output reg regdst,
output reg bne
);

reg [4:0] curr_state;
reg [4:0] next_state;

always@(posedge clk or posedge rst)
begin
	if(rst)
		curr_state <= 5'h0;
	else
		curr_state <= next_state;
end

always@(*)
begin
	case(curr_state)
		5'd0:	
            next_state = 5'd1;
		5'd1:
        begin
			case(opcode)
			    6'b001000: next_state = 5'd11;//addi
			    6'b001100: next_state = 5'd12;//andi
			    6'b001101: next_state = 5'd13;//ori
			    6'b001110: next_state = 5'd14;//xori
			    6'b001010: next_state = 5'd15;//slti
			    
				6'b100011: next_state = 5'd2;//lw
				6'b101011: next_state = 5'd2;//sw
				
				6'b000000: next_state = 5'd6;//r-type
			
				6'b000100: next_state = 5'd8;//beq
				6'b000101: next_state = 5'd10;//bne
				6'b000010: next_state = 5'd9;//jump
				
				default  : next_state = 5'd0;
			endcase
		end
		5'd2:	
            begin
				case(opcode)
					6'b100011:	next_state = 5'd3;//lw
					6'b101011:	next_state = 5'd5;//sw
					default:	next_state = 5'd0;
				endcase
			end
		5'd3:	next_state = 5'd4;
		5'd4:	next_state = 5'd0;
		5'd5:	next_state = 5'd0;
		5'd6:	next_state = 5'd7;//write reg
		5'd7:	next_state = 5'd0;
		5'd8:	next_state = 5'd0;
		5'd9:	next_state = 5'd0;
		5'd10:	next_state = 5'd0;
		5'd11:	next_state = 5'd16;//write reg
		5'd12:	next_state = 5'd16;//write reg
		5'd13:	next_state = 5'd16;//write reg
		5'd14:	next_state = 5'd16;//write reg
		5'd15:	next_state = 5'd16;//write reg
		5'd16:  next_state = 5'd0;
		default:	next_state = 5'd0;
	endcase
end

always@(*)
begin
	case(curr_state)
		5'd0:	begin
            iord = 1'b0;
            memwrite = 1'b0;
            irwrite = 1'b1;
            pcwrite = 1'b1;
            branch = 1'b0;
            pcsrc = 2'b0;
            alucontrol = 3'b001;
            alusrcb = 2'b01;
            alusrca = 1'b0;
            regwrite = 1'b0;
            memtoreg = 1'b0;
            regdst = 1'b0;
            bne = 1'b0;
				end
		5'd1:	begin
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			alucontrol = 3'b001;
			alusrcb = 2'b11;
			alusrca = 1'b0;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd2:	begin
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			alucontrol = 3'b001;
			alusrcb = 2'b10;
			alusrca = 1'b1;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd3:begin//lw
			iord = 1'b1;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			alucontrol = 3'b000;
			alusrcb = 2'b0;
			alusrca = 1'b0;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
			end
		5'd4:	begin
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			alucontrol = 3'b000;
			alusrcb = 2'b0;
			alusrca = 1'b0;
			regwrite = 1'b1;
			memtoreg = 1'b1;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd5:	begin//sw
			iord = 1'b1;
			memwrite = 1'b1;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b00;
			alucontrol = 3'b000;
			alusrcb = 2'b00;
			alusrca = 1'b0;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd6:	begin//r-type
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			alusrcb = 2'b00;
			alusrca = 1'b1;
			regdst = 1'b0;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			bne = 1'b0;
			case(funct[5:0])
                6'b100000: alucontrol = 3'b001;//add
                6'b100010: alucontrol = 3'b010;//sub
                6'b100100: alucontrol = 3'b011;//and
                6'b100101: alucontrol = 3'b100;//or
                6'b100110: alucontrol = 3'b101;//xor
                6'b100111: alucontrol = 3'b110;//nor
                6'b101010: alucontrol = 3'b111;//slt
                default:alucontrol = 3'b000;//nop
            endcase
			end
		5'd7:	begin//reg write
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b0;
			regdst = 1'b1;
			alucontrol = alucontrol;
			alusrcb = 2'b0;
			alusrca = 1'b0;
			regwrite = 1'b1;
			memtoreg = 1'b0;
			bne = 1'b0;
				end
		5'd8:	begin//beq
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b1;
			pcsrc = 2'b01;
			alucontrol = 3'b010;
			alusrcb = 2'b00;
			alusrca = 1'b1;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd9:	begin//jump
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b1;
			branch = 1'b0;
			pcsrc = 2'b10;
			alucontrol = 3'b000;//3'b000
			alusrcb = 2'b00;
			alusrca = 1'b0;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b0;
				end
		5'd10:	begin//bne
			iord = 1'b0;
			memwrite = 1'b0;
			irwrite = 1'b0;
			pcwrite = 1'b0;
			branch = 1'b0;
			pcsrc = 2'b01;
			alucontrol = 3'b010;
			alusrcb = 2'b00;
			alusrca = 1'b1;
			regwrite = 1'b0;
			memtoreg = 1'b0;
			regdst = 1'b0;
			bne = 1'b1;
				end
		5'd11://addi
            begin
			    iord = 1'b0;
			    memwrite = 1'b0;
			    irwrite = 1'b0;
			    pcwrite = 1'b0;
			    branch = 1'b0;
			    pcsrc = 2'b00;
			    alucontrol = 3'b001;
			    alusrcb = 2'b10;
			    alusrca = 1'b1;
			    regwrite = 1'b0;
			    memtoreg = 1'b0;
			    regdst = 1'b0;
			    bne = 1'b0;
			end
		5'd12://andi
            begin
                iord = 1'b0;
                memwrite = 1'b0;
                irwrite = 1'b0;
                pcwrite = 1'b0;
                branch = 1'b0;
                pcsrc = 2'b00;
                alucontrol = 3'b011;
                alusrcb = 2'b10;
                alusrca = 1'b1;
                regwrite = 1'b0;
                memtoreg = 1'b0;
                regdst = 1'b0;
                bne = 1'b0;
            end
		5'd13://ori
            begin
                iord = 1'b0;
                memwrite = 1'b0;
                irwrite = 1'b0;
                pcwrite = 1'b0;
                branch = 1'b0;
                pcsrc = 2'b00;
                alucontrol = 3'b100;
                alusrcb = 2'b10;
                alusrca = 1'b1;
                regwrite = 1'b0;
                memtoreg = 1'b0;
                regdst = 1'b0;
                bne = 1'b0;
                
            end
		5'd14://xori
            begin
                iord = 1'b0;
                memwrite = 1'b0;
                irwrite = 1'b0;
                pcwrite = 1'b0;
                branch = 1'b0;
                pcsrc = 2'b00;
                alucontrol = 3'b101;
                alusrcb = 2'b10;
                alusrca = 1'b1;
                regwrite = 1'b0;
                memtoreg = 1'b0;
                regdst = 1'b0;
                bne = 1'b0;
            end
		5'd15://slti
            begin
                iord = 1'b0;
                memwrite = 1'b0;
                irwrite = 1'b0;
                pcwrite = 1'b0;
                branch = 1'b0;
                pcsrc = 2'b00;
                alucontrol = 3'b111;
                alusrcb = 2'b10;
                alusrca = 1'b1;
                regwrite = 1'b0;
                memtoreg = 1'b0;
                regdst = 1'b0;
                bne = 1'b0;
            end
		5'd16:	begin//reg write
            iord = 1'b0;
            memwrite = 1'b0;
            irwrite = 1'b0;
            pcwrite = 1'b0;
            branch = 1'b0;
            pcsrc = 2'b0;
            regdst = 1'b0;
            alucontrol = 3'b000;
            alusrcb = 2'b0;
            alusrca = 1'b0;
            regwrite = 1'b1;
            memtoreg = 1'b0;
            bne = 1'b0;
                end
		default:	
            begin
                iord = 1'b0;
                memwrite = 1'b0;
                irwrite = 1'b0;
                pcwrite = 1'b0;
                branch = 1'b0;
                pcsrc = 2'b00;
                alucontrol = 3'b0;
                alusrcb = 2'b0;
                alusrca = 1'b0;
                regwrite = 1'b0;
                memtoreg = 1'b0;
                regdst = 1'b0;
                bne = 1'b0;
			end
	endcase
end
endmodule