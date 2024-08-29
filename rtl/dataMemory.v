//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore
//      
//      **Module name and description:
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module dMem	#(parameter addrWidth = 32, ramHeight = 2048, ramWidth = 32)	
		(input				clk, rst_, memRd, memWrt,
		input	[addrWidth - 1: 0]	addr,
		input	[ramWidth - 1: 0]	dataIn,
		output	[ramWidth - 1: 0]	dataOut
		);

reg [ramWidth - 1 : 0] memory [ramHeight - 1: 0];

assign dataOut = memRd ? memory[addr] : 32'd0;

always @ (negedge clk or negedge rst_) begin
	if(!rst_) begin
		for(integer i = 0; i < ramHeight; i++)
			memory[i] = 32'd0;
	end
	else if(memWrt) begin
		memory[addr] = dataIn;
	end
end

endmodule
