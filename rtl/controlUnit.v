//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    
//      
//      **Module name and description:
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module controller	(input 		[31:0]	instruction,
		   	output reg 		aluSrc, branch, jump, memRd, memWrt, regWrt,
		   	output reg 	[1:0]	aluOp, memToReg);

//aluSrc (0, 1) = (rdData2, immediate), memToReg (0, 1, 2) = (ALU Output, Load Data Out, PC + ImmGenOut)

localparam	iType = 7'b0010011, lType = 7'b0000011, rType = 7'b0110011, sType = 7'b0100011, uType = 7'b0110111,
	   	sbType = 7'b1100011, ujType = 7'b1101111;

always @ (instruction) begin
	case(instruction[6:0])
		iType:	begin
						aluSrc = 1'b1;
						branch = 1'b0;
						jump = 1'b0;
						memRd = 1'b0;
						memWrt = 1'b0;
						regWrt = 1'b1;
						aluOp = 2'b01;
						memToReg = 2'b00;
			end
		lType:	begin
						aluSrc = 1'b1;
						branch = 1'b0;
						jump = 1'b0;
						memRd = 1'b1;
						memWrt = 1'b0;
						regWrt = 1'b1;
						aluOp = 2'b00;
						memToReg = 2'b01;
			end
		rType:	begin
						aluSrc = 1'b0;
						branch = 1'b0;
						jump = 1'b0;
						memRd = 1'b0;
						memWrt = 1'b0;
						regWrt = 1'b1;
						aluOp = 2'b01;
						memToReg = 2'b00;
			end
		sType:	begin
						aluSrc = 1'b1;
						branch = 1'b0;
						jump = 1'b0;
						memRd = 1'b0;
						memWrt = 1'b1;
						regWrt = 1'b0;
						aluOp = 2'b00;
						memToReg = 2'bxx;
			end
		sbType:	begin
						aluSrc = 1'b0;
						branch = 1'b1;
						jump = 1'b0;
						memRd = 1'b0;
						memWrt = 1'b0;
						regWrt = 1'b0;
						aluOp = 2'b10;
						memToReg = 2'bxx;
			end
		uType:	begin
						aluSrc = 1'b1;
						branch = 1'b0;
						jump = 1'b0;
						memRd = 1'b0;
						memWrt = 1'b0;
						regWrt = 1'b1;
						aluOp = 2'b11;
						memToReg = 2'b00;
			end
		ujType:	begin
						aluSrc = 1'b1;
						branch = 1'b0;
						jump = 1'b1;
						memRd = 1'b0;
						memWrt = 1'b0;
						regWrt = 1'b1;
						aluOp = 2'bxx;
						memToReg = 2'b10;
			end
		default:
			begin
						aluSrc = 1'b0;
                                                branch = 1'b0;
                                                jump = 1'b0;
                                                memRd = 1'b0;
                                                memWrt = 1'b0;
                                                regWrt = 1'b0;
                                                aluOp = 2'b00;
                                                memToReg = 2'b00;	
			end
	endcase
end

endmodule
