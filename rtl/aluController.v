//--------------------------------------------------//
//      **Project: 5-Stage pipelined RISC-V softcore    
//      
//      **Module name and description:
//
//      **Author: Adithya Ramesh, aramesh1@wpi.edu
//--------------------------------------------------//

module aluController	(input			funct7,
                        input		[1:0]	aluOp,
                        input		[2:0]	funct3,
                        input		[6:0]	instrnOpcode,
                        output	reg	[3:0]	aluControl
                        );
                     
localparam	memoryInst = 2'b00,	bitwiseOrShift = 2'b01,
		branch = 2'b10,		upperImmediate = 2'b11;

/*  aluControl determines which operation takes place at the ALU
    add = 4'b0000	sub = 4'b0001		sll = 4'b0010		bxor = 4'b0011  
    srl = 4'b0100	sra = 4'b0101		bor = 4'b0110		band = 4'b0111
    slt = 4'b1000 
    please note that just for I type shifts - The MSB - (1 bit) has to be 1 for SRAI which would be represented by funct7
*/

always @ (*) begin
    case(aluOp)
        memoryInst: 
            aluControl = 4'b0000;
        bitwiseOrShift:begin
		if(funct7 && instrnOpcode == 7'b0110011)
                	aluControl = (funct3 == 3'b101) ? 4'b0101 : 4'b0001;
		else if(funct7 && funct3 == 3'b101 && instrnOpcode == 7'b0010011)
                	aluControl = 4'b0101;
		else begin
                	case(funct3)
				3'b000:	 aluControl = 4'b0000;
				3'b001:  aluControl = 4'b0010;
				3'b010:  aluControl = 4'b1000;
				3'b100:  aluControl = 4'b0011;
				3'b101:  aluControl = 4'b0100;
				3'b110:  aluControl = 4'b0110;
				3'b111:  aluControl = 4'b0111;
				default: aluControl = 4'b0000;
			endcase
		end                    
	end
        branch:begin
            aluControl = (funct3 == 000) ? 4'b1010 : 4'b1001;
        end
        upperImmediate:
            aluControl = 4'b1011;
    endcase
end

endmodule
