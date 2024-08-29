//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//      	Top Level module consists of:
//      		1. Instantiating IF, ID, MEM, EX, WB, Forwarding and Data  Hazard unit modules.
//      		2. Drawing module interconnects.
//      		3. Instantiating State Registers.
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module risc_v_toplevel	(input	clk, rst_);

/*------------------------------ Instantiating State Registers ------------------------------*/
	//STAGE - 2; IF/ID
	reg	[31:0]	instrnAddr_IF_ID, instruction_IF_ID;

	//STAGE - 3; ID/EX
	reg		aluSrc_ID_EX, branch_ID_EX, jump_ID_EX, memRd_ID_EX, memWrt_ID_EX, regWrt_ID_EX;
	reg	[1:0]	aluOp_ID_EX, memToReg_ID_EX;
	reg	[4:0]	rs1_ID_EX, rs2_ID_EX;
	reg	[31:0]	immGenOut_ID_EX, instrnAddr_ID_EX, instruction_ID_EX, rdData1_ID_EX, rdData2_ID_EX;

	//STAGE - 4; EX/MEM
	reg		C_EX_MEM, Z_EX_MEM, branch_EX_MEM, jump_EX_MEM, memRd_EX_MEM, memWrt_EX_MEM, regWrt_EX_MEM;
	reg	[1:0]	aluOp_EX_MEM, memToReg_EX_MEM;
	reg	[3:0]	aluOpcode_EX_MEM;
	reg	[31:0]	instruction_EX_MEM, PC_PlusImmediate_EX_MEM, Y_EX_MEM, rdData2_EX_MEM;

	//STAGE - 5; MEM/WB
	reg		regWrt_MEM_WB;
	reg	[1:0]	memToReg_MEM_WB;
	reg	[31:0]	instruction_MEM_WB, rdDataMem_MEM_WB, Y_MEM_WB, PC_Plus_Immediate_MEM_WB;

/*------------------------------ Instantiating Module Interconnects ------------------------------*/
	//IF - Stage ins and outs
	wire		PCUpdateEnable_IF_IN, assertBOJ_IF_IN;
	wire	[31:0]	curInstrn_IF_OUT, curInstrnAddr_IF_OUT, PC_Plus_Immediate_IF_IN;
	
	//ID - Stage ins and outs
	wire		aluSrc_ID_OUT, branch_ID_OUT, jump_ID_OUT, memRd_ID_OUT, memWrt_ID_OUT, regWrt_ID_OUT, regWrt_ID_IN; 
	wire	[1:0]	aluOp_ID_OUT, memToReg_ID_OUT;
	wire	[4:0]	rdReg1_ID_IN, rdReg2_ID_IN, wrtReg_ID_IN;
	wire	[31:0]	rdData1_ID_OUT, rdData2_ID_OUT, wrtData_ID_IN, immGenOut_ID_OUT, instruction_ID_IN;
	
	//EX - Stage ins and outs
	wire		aluSrc_EX_IN, C_EX_OUT, Z_EX_OUT;
	wire	[1:0]	aluOp_EX_IN;
	wire	[3:0]	aluOpcode_EX_OUT;
	wire	[31:0]	PC_Plus_Immediate_EX_OUT, immediate_EX_IN, instruction_EX_IN, curInstrnAddr_EX_IN, Y_EX_OUT;
	wire	[31:0]	rdData1_EX_IN, rdData2_EX_IN, newRdData2_EX_OUT;

	//MEM - Stage ins and outs
	wire		C_MEM_IN, Z_MEM_IN, branch_MEM_IN, jump_MEM_IN, memRd_MEM_IN, memWrt_MEM_IN, assertBOJ_MEM_OUT;
	wire	[3:0]	aluOpcode_MEM_IN;
	wire	[31:0]	dataMemAddr_MEM_IN, wrtDataMem_MEM_IN, rdDataMem_MEM_OUT;	

	//WB - Stage ins and outs
	wire	[1:0]	memToReg_WB_IN;
	wire	[31:0]	rdDataMem_WB_IN, regWrtData_WB_OUT, Y_WB_IN, PC_Plus_Immediate_WB_IN;

	//Hardware added for forwarding unit
	wire		regWrt_fromEXMEM_FW_IN, regWrt_fromMEMWB_FW_IN;
	wire	[1:0]	sel1_FW_OUT, sel2_FW_OUT;
	wire	[4:0]	rs1_FW_IN,  rs2_FW_IN, rdst_fromEXMEM_FW_IN, rdst_fromMEMWB_FW_IN;

	//Hardware added for hazard detection unit
	wire		memRd_fromID_EX_HD_IN, PCUpdateEnable_HD_OUT, IF_ID_UpdateEnable_HD_OUT, NOP_ID_EX_State_Reg;
	wire	[4:0]	rs1_fromIF_ID_HD_IN, rs2_fromIF_ID_HD_IN, rdst_fromID_EX_HD_IN;

	//Reset Condition for control state registers
	wire		rst_ins_IF_ID, rst_ctrl_ID_EX, rst_ctrl_EX_MEM, rst_ctrl_MEM_WB;
	wire		haltDetect_MEM;
/*------------------------------ Instantiating Unit Modules ------------------------------*/
	instructionFetch	IF	(
					.clk(clk),
					.rst_(rst_),
					.PCEnable(PCUpdateEnable_IF_IN),
					.PCSrc(assertBOJ_IF_IN),
					.PC_Plus_Immediate(PC_Plus_Immediate_IF_IN),
					.PC_Copy(curInstrnAddr_IF_OUT),
					.curInstrn(curInstrn_IF_OUT)
					);

	instructionDecode	ID	(
					.clk(clk),
					.rst_(rst_),
					.regWrtIn(regWrt_ID_IN),
					.rdReg1(rdReg1_ID_IN),
					.rdReg2(rdReg2_ID_IN),
					.wrtReg(wrtReg_ID_IN),
					.instruction(instruction_ID_IN),
					.wrtData(wrtData_ID_IN),
					.aluSrc(aluSrc_ID_OUT),
					.branch(branch_ID_OUT),
					.jump(jump_ID_OUT),
					.memRd(memRd_ID_OUT),
					.memToReg(memToReg_ID_OUT),
					.memWrt(memWrt_ID_OUT),
					.regWrtOut(regWrt_ID_OUT),
					.aluOp(aluOp_ID_OUT),
					.rdData1(rdData1_ID_OUT),
					.rdData2(rdData2_ID_OUT),
					.immediate(immGenOut_ID_OUT)
					);

	forwarding		FW	(
					.regWrt_EX_MEM(regWrt_fromEXMEM_FW_IN),
					.regWrt_MEM_WB(regWrt_fromMEMWB_FW_IN),
					.rs1(rs1_FW_IN),
					.rs2(rs2_FW_IN),
					.rdst_EX_MEM(rdst_fromEXMEM_FW_IN),
					.rdst_MEM_WB(rdst_fromMEMWB_FW_IN),
					.srcA(sel1_FW_OUT),
					.srcB(sel2_FW_OUT)					
					);

	hazardDetection		HD	(
					.memRd_ID_EX(memRd_fromID_EX_HD_IN),
					.rs1(rs1_fromIF_ID_HD_IN),
					.rs2(rs2_fromIF_ID_HD_IN),
					.rdst_ID_EX(rdst_fromID_EX_HD_IN),
					.PCUpdateEnable(PCUpdateEnable_HD_OUT),
					.IF_ID_UpdateEnable(IF_ID_UpdateEnable_HD_OUT),
					.controlSelect(NOP_ID_EX_State_Reg)
					);

	executeStage		EX	(
					.aluSrc(aluSrc_EX_IN),
					.aluOp(aluOp_EX_IN),
					.srcA(sel1_FW_OUT),
					.srcB(sel2_FW_OUT),
					.immediate(immediate_EX_IN),
					.instruction(instruction_EX_IN),
					.PC(curInstrnAddr_EX_IN),
					.rdData1(rdData1_EX_IN),
					.rdData2(rdData2_EX_IN),
					.dataMemAddr(dataMemAddr_MEM_IN),
					.wrtBackData(regWrtData_WB_OUT),
					.C(C_EX_OUT),
					.Z(Z_EX_OUT),
					.aluOpcode(aluOpcode_EX_OUT),
					.PC_Plus_Immediate(PC_Plus_Immediate_EX_OUT),
					.Y(Y_EX_OUT),
					.newRdData2(newRdData2_EX_OUT)
					);

	memoryStage		MEM	(
					.clk(clk),
					.rst_(rst_),
					.C(C_MEM_IN),
					.Z(Z_MEM_IN),
					.branch(branch_MEM_IN),
					.jump(jump_MEM_IN),
					.memRd(memRd_MEM_IN),
					.memWrt(memWrt_MEM_IN),
					.aluOpcode(aluOpcode_MEM_IN),
					.dataMemAddr(dataMemAddr_MEM_IN),
					.wrtDataMem(wrtDataMem_MEM_IN),
					.assertBOJ(assertBOJ_MEM_OUT),
					.rdDataMem(rdDataMem_MEM_OUT)
					);

	writeBackStage		WB	(
					.memToReg(memToReg_WB_IN),
					.rdDataMem(rdDataMem_WB_IN),
					.Y(Y_WB_IN),
					.PC_Plus_Immediate(PC_Plus_Immediate_WB_IN),
					.regWrtData(regWrtData_WB_OUT)
					);

/*------------------------------ Updating Unit Modules Input* 
* 		Input wires get updated at each positive clock edge ------------------------------*/
	
	//IF INPUTS
	assign insAddrInvalid_IF_OUT	= (curInstrnAddr_IF_OUT >= 32'd128);
	assign PCUpdateEnable_IF_IN	= (PCUpdateEnable_HD_OUT & ~haltDetect_MEM) ;
	assign assertBOJ_IF_IN		= assertBOJ_MEM_OUT;
	assign PC_Plus_Immediate_IF_IN	= PC_PlusImmediate_EX_MEM;
	//ID INPUTS
	assign regWrt_ID_IN		= regWrt_MEM_WB;
	assign rdReg1_ID_IN		= instruction_IF_ID[19:15];
	assign rdReg2_ID_IN		= instruction_IF_ID[24:20];
	assign wrtReg_ID_IN		= instruction_MEM_WB[11:7];
	assign wrtData_ID_IN		= regWrtData_WB_OUT;
	assign instruction_ID_IN	= instruction_IF_ID;
	//EX INPUTS
	assign aluSrc_EX_IN		= aluSrc_ID_EX;
	assign aluOp_EX_IN		= aluOp_ID_EX;
	assign immediate_EX_IN		= immGenOut_ID_EX;
	assign instruction_EX_IN	= instruction_ID_EX;
	assign curInstrnAddr_EX_IN	= instrnAddr_ID_EX;
	assign rdData1_EX_IN		= rdData1_ID_EX;
	assign rdData2_EX_IN		= rdData2_ID_EX;
	//MEM INPUTS
	assign C_MEM_IN			= C_EX_MEM; 
	assign Z_MEM_IN			= Z_EX_MEM;
	assign branch_MEM_IN		= branch_EX_MEM;
	assign jump_MEM_IN		= jump_EX_MEM;
	assign memRd_MEM_IN		= memRd_EX_MEM;
	assign memWrt_MEM_IN		= memWrt_EX_MEM;
	assign aluOpcode_MEM_IN		= aluOpcode_EX_MEM;
	assign dataMemAddr_MEM_IN	= Y_EX_MEM;
	assign wrtDataMem_MEM_IN	= rdData2_EX_MEM;
	//WB INPUTS
	assign memToReg_WB_IN		= memToReg_MEM_WB;
	assign rdDataMem_WB_IN		= rdDataMem_MEM_WB;
	assign Y_WB_IN			= Y_MEM_WB;
	assign PC_Plus_Immediate_WB_IN	= PC_Plus_Immediate_MEM_WB;
	//FW INPUTS
	assign regWrt_fromEXMEM_FW_IN	= regWrt_EX_MEM; 
	assign regWrt_fromMEMWB_FW_IN	= regWrt_MEM_WB;
	assign rs1_FW_IN		= rs1_ID_EX;
	assign rs2_FW_IN		= rs2_ID_EX;
	assign rdst_fromEXMEM_FW_IN	= instruction_EX_MEM[11:7];
	assign rdst_fromMEMWB_FW_IN	= instruction_MEM_WB[11:7];
	//HD INPUTS
	assign memRd_fromID_EX_HD_IN	= memRd_ID_EX;
	assign rs1_fromIF_ID_HD_IN	= instruction_IF_ID[19:15];
	assign rs2_fromIF_ID_HD_IN	= instruction_IF_ID[24:20];
	assign rdst_fromID_EX_HD_IN	= instruction_ID_EX[11:7];
	//Reset Condition for program counter and state register
	assign rst_ins_IF_ID		= (~rst_ || assertBOJ_MEM_OUT || insAddrInvalid_IF_OUT);
	assign rst_ctrl_ID_EX		= (~rst_ || NOP_ID_EX_State_Reg || assertBOJ_MEM_OUT || haltDetect_MEM);
	assign rst_ctrl_EX_MEM		= (~rst_ || assertBOJ_MEM_OUT || haltDetect_MEM);
	assign rst_ctrl_MEM_WB		= (~rst_ || haltDetect_MEM);

	assign haltDetect_MEM		= &(instruction_EX_MEM[6:0] & 7'h7F);
/*------------------------------ Updating State Registers * 
* 		Clocking data into state register with unit modules output ------------------------------*/

	//IF/ID - Stage 	
	always @ (posedge clk) begin
		instrnAddr_IF_ID	<=	(!rst_)							?	32'd0			:
						(haltDetect_MEM)					?	instrnAddr_IF_ID	:	
						(IF_ID_UpdateEnable_HD_OUT)				?	curInstrnAddr_IF_OUT	:
						instrnAddr_IF_ID;
		
		instruction_IF_ID	<=	(rst_ins_IF_ID)						?	32'd0			:
						(haltDetect_MEM)					?	instruction_IF_ID	:
						(IF_ID_UpdateEnable_HD_OUT)				?	curInstrn_IF_OUT	:
						instruction_IF_ID;
	end

	//ID/EX - Stage
	always @ (posedge clk) begin
		//CTRL Signals
		aluSrc_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: aluSrc_ID_OUT;
		branch_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: branch_ID_OUT;
		jump_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: jump_ID_OUT;
		memRd_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: memRd_ID_OUT;
		memToReg_ID_EX		<= (rst_ctrl_ID_EX)	?	2'd0			: memToReg_ID_OUT;
		memWrt_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: memWrt_ID_OUT;
		regWrt_ID_EX		<= (rst_ctrl_ID_EX)	?	1'b0			: regWrt_ID_OUT;
		aluOp_ID_EX		<= (rst_ctrl_ID_EX)	?	2'd0			: aluOp_ID_OUT;
		//DATAPTH Signals
		rs1_ID_EX		<= (!rst_)		?	5'd0			:	
					   (haltDetect_MEM)	?	rs1_ID_EX		: rdReg1_ID_IN;			
		rs2_ID_EX		<= (!rst_)		?	5'd0			:
					   (haltDetect_MEM)     ?       rs2_ID_EX		: rdReg2_ID_IN;
		immGenOut_ID_EX		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       immGenOut_ID_EX		: immGenOut_ID_OUT; 
		instrnAddr_ID_EX	<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       instrnAddr_ID_EX	: instrnAddr_IF_ID;
		instruction_ID_EX	<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       instruction_ID_EX	: instruction_IF_ID; 
		rdData1_ID_EX		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       rdData1_ID_EX		: rdData1_ID_OUT;
		rdData2_ID_EX		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       rdData2_ID_EX		: rdData2_ID_OUT;
	end

	//EX/MEM - Stage
	always @ (posedge clk) begin
		//CTRL Signals
		branch_EX_MEM		<= (rst_ctrl_EX_MEM)	?	1'b0	:	branch_ID_EX;
		jump_EX_MEM		<= (rst_ctrl_EX_MEM)	?	1'b0	:	jump_ID_EX;
		memRd_EX_MEM		<= (rst_ctrl_EX_MEM)	?	1'b0	:	memRd_ID_EX;
		memToReg_EX_MEM		<= (rst_ctrl_EX_MEM)	?	2'd0	:	memToReg_ID_EX;
		memWrt_EX_MEM		<= (rst_ctrl_EX_MEM)	?	1'b0	:	memWrt_ID_EX;
		regWrt_EX_MEM		<= (rst_ctrl_EX_MEM)	?	1'b0	:	regWrt_ID_EX;
		aluOp_EX_MEM		<= (rst_ctrl_EX_MEM)	?	2'd0	:	aluOp_ID_EX;
		//DATAPTH Signals
		C_EX_MEM		<= (!rst_)		?	1'b0			:
					   (haltDetect_MEM)     ?       C_EX_MEM		: C_EX_OUT; 
		Z_EX_MEM		<= (!rst_)		?	1'b0			:
					   (haltDetect_MEM)     ?       Z_EX_MEM		: Z_EX_OUT;
		aluOpcode_EX_MEM	<= (!rst_)		?	4'd0			:
					   (haltDetect_MEM)     ?       aluOpcode_EX_MEM	: aluOpcode_EX_OUT;
		instruction_EX_MEM	<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       instruction_EX_MEM	: instruction_ID_EX;
		PC_PlusImmediate_EX_MEM	<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       PC_PlusImmediate_EX_MEM	: PC_Plus_Immediate_EX_OUT;
		Y_EX_MEM		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       Y_EX_MEM		: Y_EX_OUT;
		rdData2_EX_MEM		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       rdData2_EX_MEM		: newRdData2_EX_OUT;
	end

	//MEM/WB - Stage
	always @ (posedge clk) begin
		//CTRL Signals
		memToReg_MEM_WB		<= (rst_ctrl_MEM_WB)	?	2'd0	:	memToReg_EX_MEM;
		regWrt_MEM_WB		<= (rst_ctrl_MEM_WB)	?	1'b0	:	regWrt_EX_MEM;
		//DATAPTH Signals 
		instruction_MEM_WB	<= (!rst_)		?	32'd0			:
					(haltDetect_MEM)	?       instruction_MEM_WB	: instruction_EX_MEM;
		rdDataMem_MEM_WB	<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       rdDataMem_MEM_WB	: rdDataMem_MEM_OUT;
	       	Y_MEM_WB		<= (!rst_)		?	32'd0			:
					   (haltDetect_MEM)     ?       Y_MEM_WB		: dataMemAddr_MEM_IN; 
		PC_Plus_Immediate_MEM_WB<= (!rst_)		?	32'd0			: 
					   (haltDetect_MEM)     ?       PC_Plus_Immediate_MEM_WB: PC_PlusImmediate_EX_MEM;
	end

endmodule
