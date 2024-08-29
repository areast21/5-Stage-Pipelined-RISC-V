//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    
//      
//      **Module name and description:
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module immediateGen	(input		[31:0]	instruction,
			output	reg	[31:0]	immediate);

localparam	iType = 7'b0010011, lType = 7'b0000011, sType = 7'b0100011, 
		sbType = 7'b1100011, uType = 7'b0110111, ujType = 7'b1101111;

//Going with I - Type instruction as default

always @ (instruction) begin
	case(instruction[6:0])
		(iType | lType):	immediate = {{20{instruction[31]}}, instruction[31:20]};
		sType:			immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
		sbType:			immediate = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
		uType:			immediate = {instruction[31:12],{12{1'b0}}};
		ujType:			immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
		default:		immediate = 32'd0;
	endcase
end

endmodule
