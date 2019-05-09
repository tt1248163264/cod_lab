module alu(
input	signed	[31:0]	alu_a,
input	signed	[31:0]	alu_b,
input			[2:0]	alu_op,
output	reg	    [31:0]	alu_out,
output	reg				alu_zero
);

always@(*)
begin
	case(alu_op)
		3'h00: alu_out = 32'h0;
		3'h01: alu_out = alu_a + alu_b;
		3'h02: alu_out = alu_a - alu_b;
		3'h03: alu_out = alu_a & alu_b;
		3'h04: alu_out = alu_a | alu_b;
		3'h05: alu_out = alu_a ^ alu_b;
		3'h06: alu_out = ~(alu_a | alu_b);
		3'h07: alu_out = (alu_a < alu_b) | (alu_a[31] & ~alu_b[31]);
		default: alu_out = 32'h0;
	endcase
end

always@(*)
begin
	if(alu_out > 0)
		alu_zero = 1'h1;
	else
		alu_zero = 1'h0;
end

endmodule