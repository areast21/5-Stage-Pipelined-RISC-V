//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//		EX-Unit consists of:
//			1. PC + Immediate	2. ALU (Operand 2) MUX
//			3. ALU Control		4. ALU
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module executeStage	(input		aluSrc,		
			input	[1:0]	aluOp, srcA, srcB,
			input	[31:0]	immediate, instruction, PC, rdData1, rdData2, dataMemAddr, wrtBackData,
			output		C, Z,
			output	[3:0]	aluOpcode,
			output 	[31:0]	PC_Plus_Immediate, Y, newRdData2);

	wire	[3:0]	aluControl;
	wire	[31:0]	A, B;      
	assign	aluOpcode = aluControl;

	//PC+Immediate
	assign PC_Plus_Immediate	= PC + immediate;

	//ALU (Operand 2) MUX
	assign B			= (aluSrc) ? immediate : newRdData2;

	//Mitigating RaW through forwarding mechanism
	assign A			= (srcA == 2'b10)	?	dataMemAddr	:
	       				  (srcA == 2'b01)	?	wrtBackData	:
				  	  rdData1;
	assign newRdData2		= (srcB == 2'b10)	?	dataMemAddr	:
	       				  (srcB == 2'b01)	?	wrtBackData	:
				  	  rdData2;

	//ALU Control unit - chooses operator
	aluController	aluControlUnit	(
					.funct7(instruction[30]),
					.funct3(instruction[14:12]),
					.instrnOpcode(instruction[6:0]),
					.aluOp(aluOp),
					.aluControl(aluControl)
					);

	//ALU
	alu	ALU	(
			.opcode(aluControl),
			.A(A),
			.B(B),
			.Y(Y),
			.carry(C),
			.zero(Z)
			);

endmodule
