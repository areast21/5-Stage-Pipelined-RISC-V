//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//		MEM-Unit consists of:
//			1. Assert Branch Control Signal
//			2. Data Memory
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module	memoryStage	(input		clk, rst_, C, Z, branch, jump, memRd, memWrt,
			input	[3:0]	aluOpcode,
			input	[31:0]	dataMemAddr, wrtDataMem,
			output		assertBOJ,
			output	[31:0]	rdDataMem);

	wire	branchCondition;
	
	//Branching / Jumping logic
        assign branchCondition  =       (aluOpcode === 4'b1010 && C == 1)	?	1			:
                                        (aluOpcode === 4'b1001 && Z == 1)	?	1			: 0;
        assign assertBOJ        =       (branchCondition & branch) | jump;
        
	//Data Memory
	dMem	dataMem8KB	(
				.clk(clk),
				.rst_(rst_),
				.memRd(memRd),
				.memWrt(memWrt),
				.addr(dataMemAddr),
				.dataIn(wrtDataMem),
				.dataOut(rdDataMem)
				);
endmodule
