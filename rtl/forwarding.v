//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//              Forwarding unit:
//              	Inorder to mitigate race condition caused by Read after Write (RAW) instruction
//              	sequence in hardware, we forward data from either the ALU or data memory to the
//              	required source register needed for the current ALU operation at ID stage.
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//
module forwarding	(input			regWrt_EX_MEM, regWrt_MEM_WB,
			input		[4:0]	rs1, rs2, rdst_EX_MEM, rdst_MEM_WB,
			output	reg	[1:0]	srcA, srcB);
		wire	check_EX_MEM, check_MEM_WB;
		assign 	check_EX_MEM	= regWrt_EX_MEM && (rdst_EX_MEM != 0);
		assign 	check_MEM_WB	= regWrt_MEM_WB && (rdst_MEM_WB != 0);
		always @ (*) begin
			srcA	<=	(check_EX_MEM && (rs1 == rdst_EX_MEM))	?	2'b10	:
					(check_MEM_WB && (rs1 == rdst_MEM_WB))	?	2'b01	:	2'b00;
			srcB	<=	(check_EX_MEM && (rs2 == rdst_EX_MEM))	?	2'b10	:
					(check_MEM_WB && (rs2 == rdst_MEM_WB))	?	2'b01	:	2'b00;
		end
endmodule
