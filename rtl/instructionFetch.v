//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//		IF-Unit consists of:
//			1. Program Counter	2. PC Next logic	3. Instruction Memory
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module instructionFetch	(input			clk, rst_, PCEnable, PCSrc,
			input		[31:0]	PC_Plus_Immediate,
			output		[31:0]	PC_Copy,
			output		[31:0]	curInstrn
			);

	reg	[31:0]	PC;
	assign		PC_Copy	=	PC;

	wire	[31:0]	PCNext;
	
	//In case of branch detect
	assign PCNext		=	(PCSrc)				?	(PC_Plus_Immediate)	:	(PC + 4);
	
	//Program Counter
	always @ (posedge clk or negedge rst_)
		if(!rst_)
			PC		<=	32'd0;
		else if(PCEnable)
			PC		<=	PCNext;
		else
			PC		<=	PC;
 
	//Instruction Memory
	iMem	instrnMem1KB	(
	       			.addr(PC),
				.instrn(curInstrn)
       				);    
endmodule
