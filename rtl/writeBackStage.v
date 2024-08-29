//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//		Mux used to drive selected data between: 
//		1. Data Mem Out 2. ALU o/p 3. PC + Immediate (for branch)
//		into chosen register
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module writeBackStage	(input	[1:0]	memToReg,
			input	[31:0]	rdDataMem, Y, PC_Plus_Immediate,
			output	[31:0]	regWrtData);

	assign regWrtData	=	(memToReg == 4'b00) ? Y			:
					(memToReg == 4'b01) ? rdDataMem		:
					(memToReg == 4'b10) ? PC_Plus_Immediate	: 32'd0;
		
endmodule
