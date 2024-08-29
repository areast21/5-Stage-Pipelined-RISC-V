//--------------------------------------------------//
//	**Project: 5-Stage pipelined RISC-V softcore
//	
//	**Module name and description:
//
//	**Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module alu	(input		[3:0]	opcode,
		input		[31:0]	A, B,
		output			carry, zero,
		output	reg	[31:0]	Y
		);

reg adder_out;

localparam	add = 4'b0000,	sub = 4'b0001,	sll  = 4'b0010,
		bxor = 4'b0011,	srl = 4'b0100,	sra  = 4'b0101,
		bor  = 4'b0110,	band = 4'b0111,	sltu = 4'b1000,
		bne = 4'b1001,	beq = 4'b1010,	lui  = 4'b1011;

always @ (*) begin
	case(opcode)
		//Bitwise operations
		add:	{adder_out, Y} = A + B;
		sub: 	Y = A - B;
		bxor: 	Y = A ^ B;
		bor:  	Y = A | B;
		band: 	Y = A & B;

		//Shift operations
		srl: 	Y = A >> B;
		sll: 	Y = A << B;
		sra: 	Y = {A[31], 31'd0} | (A >> B);

		//Set operations
		sltu: 	Y = (A < B)	? 1'b1 : 1'b0;

		//Branch operations
		bne: 	Y = (A != B)	? 1'b0 : 1'b1;
		beq: 	Y = (A == B)	? 1'b1 : 1'b0;

		//Load Upper Immediate
		lui:	Y = B;

		default: Y = 4'd0;
	endcase
end

assign carry	=	(opcode == add && adder_out == 1)	?	1'b1 :
			(opcode == beq && Y == 1	)	?	1'b1 :
									1'b0;
assign zero	=	(Y == 32'd0			)	?	1'b1 : 1'b0;

endmodule
