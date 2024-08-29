//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    
//
//      **Module name and description:
//		Hazard Detection Unit:
//			Not all RaW instruction sequences can be solved through forwarding data.
//			Specifically for the instance when reading from a register whilst the previous instruction
//			loads data into the same register from the data memory, a stall would be required!
//			
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//
module hazardDetection	(input		memRd_ID_EX,
			input	[4:0]	rs1, rs2, rdst_ID_EX,
			output		PCUpdateEnable, IF_ID_UpdateEnable, controlSelect);
			wire 	check_rs1, check_rs2;
			assign	check_rs1		= memRd_ID_EX && (rs1 == rdst_ID_EX);
			assign	check_rs2		= memRd_ID_EX && (rs2 == rdst_ID_EX);
			assign	PCUpdateEnable		= ~(check_rs1 || check_rs2);
			assign	IF_ID_UpdateEnable	= ~(check_rs1 || check_rs2);
			assign	controlSelect		= (check_rs1 || check_rs2);	
endmodule
