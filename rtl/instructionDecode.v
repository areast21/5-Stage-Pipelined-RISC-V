//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    
//      
//      **Module name and description:
//		ID-unit consists of:
//			1. Control Unit		2. Register File	3. Immediate Generator
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module instructionDecode	(input		clk, rst_, regWrtIn,
				input	[4:0]	rdReg1, rdReg2, wrtReg,
				input	[31:0]	instruction, wrtData,
				output		aluSrc, branch, jump, memRd, memWrt, regWrtOut,
				output	[1:0]	memToReg, aluOp,
				output	[31:0]	rdData1, rdData2, immediate
				);

	//Softcore control unit
	controller	controlUnit	(
	       				.instruction(instruction),
					.aluSrc(aluSrc),
					.branch(branch),
					.jump(jump),
					.memRd(memRd),
					.memToReg(memToReg),
					.memWrt(memWrt),
					.regWrt(regWrtOut),
					.aluOp(aluOp)
       					);
	
	//Register File
	registers	registerFile	(
					.clk(clk),
					.rst_(rst_),
					.wrtEn(regWrtIn),
					.rdReg1(rdReg1),
					.rdReg2(rdReg2),
					.wrtReg(wrtReg),
					.wrtData(wrtData),
					.rdData1(rdData1),
					.rdData2(rdData2)
					);
	//Immediate Generator
	immediateGen	immGenerator	(
					.instruction(instruction),
					.immediate(immediate)
					);

endmodule
