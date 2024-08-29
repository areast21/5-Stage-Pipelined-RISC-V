module immGenTB;

reg [31:0] instruction;
wire [31:0] signExtnImmediate;

immediateGen DUT (instruction, signExtnImmediate);

initial begin
	
	$dumpfile("immGenTrace.vcd");
	$dumpvars(0, immGenTB);

	instruction = 32'b00000000011100000000000000010011; #10;//I-type. d7
	instruction = 32'b11100000011100000000000000010011; #10;//I-type. d3591
    instruction = 32'b11100000011100000000000000100011; #10;//S-type. d3584
    instruction = 32'b00000000011100000000000110100011; #10;//S-type. d3
    instruction = 32'b00000000000000000000000101100011; #10;//SB-type. d1
    instruction = 32'b00000010000000000000000001100011; #10;//SB-type. d16
    instruction = 32'b00000000000000000000000011100011; #10;//SB-type. d1024
    instruction = 32'b10000000000000000000000001100011; #10;//SB-type. d2048
    instruction = 32'b00000010000000000000000000110011; #10;//R-type. d0

end

endmodule