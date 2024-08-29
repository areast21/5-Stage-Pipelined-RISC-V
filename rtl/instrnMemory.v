//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    /
//      
//      **Module name and description:
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module iMem	(input	[31:0]	addr,
		output	[31:0]	instrn
		);

//32 bits may have been allcoated for the address location, but the totatl no. of available locations are 128.

reg [7:0] memory [127:0];

// 1 Kb instruction memory - upto 32 unique instructions, can be easily scaled depending on program requirements

initial begin
	for(integer i = 0; i < 128; i = i + 1)
		memory[i] = 32'd0;
	//Fibonacci Series Program for n = 23
	//(i,n,p,q,sum) -> (X5,X9,X6,X7,X8)
	//		ADDI		X5,	X0,	0X001
	memory[0]	=	8'b10010011;
	memory[1]	=	8'b00000010;
	memory[2]	=	8'b00010000;
	memory[3]	=	8'b00000000;
	//		ADDI		X7,	X0,	0X001
	memory[4]	=	8'b10010011;
	memory[5]	=	8'b00000011;
	memory[6]	=	8'b00010000;
	memory[7]	=	8'b00000000;	
	//		ADDI		X9,	X0,	0X011
	memory[8]	=	8'b10010011;
	memory[9]	=	8'b00000100;
	memory[10]	=	8'b01110000;
	memory[11]	=	8'b00000001;
	//		BEQ		X9,	X6,	(HALT_INS)
	memory[12]	=	8'b01100011;
	memory[13]	=	8'b10000010;
	memory[14]	=	8'b01100100;
	memory[15]	=	8'b00000010;
	//		BEQ		X9,	X7,	(N_eqv_1)
	memory[16]	=	8'b01100011;
	memory[17]	=	8'b10000000;
	memory[18]	=	8'b01110100;
	memory[19]	=	8'b00000010;
	//DEFAULT:	ADD		X8,	X7,	X6
	memory[20]	=	8'b00110011;
	memory[21]	=	8'b10000100;
	memory[22]	=	8'b01100011;
	memory[23]	=	8'b00000000;
	//		ADD		X6,	X0,	X7
	memory[24]	=	8'b00110011;
	memory[25]	=	8'b00000011;
	memory[26]	=	8'b01110000;
	memory[27]	=	8'b00000000;
	//		ADD		X7,	X0,	X8
	memory[28]	=	8'b10110011;
	memory[29]	=	8'b00000011;
	memory[30]	=	8'b10000000;
	memory[31]	=	8'b00000000;
	//		ADDI		X5,	X5,	0X001
	memory[32]	=	8'b10010011;
	memory[33]	=	8'b10000010;
	memory[34]	=	8'b00010010;
	memory[35]	=	8'b00000000;
	//		BNE		X9,	X5,	(DEFAULT)
	memory[36]	=	8'b11100011;
	memory[37]	=	8'b10011000;
	memory[38]	=	8'b01010100;
	memory[39]	=	8'b11111110;
	//		JAL		(HALT_INS)
	memory[40]	=	8'b01101111;
	memory[41]	=	8'b00000110;
	memory[42]	=	8'b10000000;
	memory[43]	=	8'b00000000;
	//N_eqv_1:	ADDI		X8,	X0,	0x001
	memory[44]	=	8'b00010011;
	memory[45]	=	8'b00000100;
	memory[46]	=	8'b00010000;
	memory[47]	=	8'b00000000;
	//HALT_INS:	HALT
	memory[52]	=	8'b01111111;
	memory[53]	=	8'b00000000;
	memory[54]	=	8'b00000000;
	memory[55]	=	8'b00000000;
end

assign instrn = {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr]};

endmodule
