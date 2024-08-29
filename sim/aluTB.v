module aluTB;

reg [3:0] opCode;
reg [31:0] inpA, inpB;
wire C, Z;
wire [31:0] Y;

alu DUT (opCode, inpA, inpB, C, Z, Y);

initial begin

	$dumpfile("aluTrace.vcd");
	$dumpvars(0, aluTB);

	//1. XOR; Expected Y = 0x00000066;
	opCode = 4'b0011; inpA = 32'hD00000A5; inpB = 32'hF00000C3; #10;
	//2. ADD; Expected Result = 0x00000118; C = 1
	opCode = 4'b0000; inpA = 32'h800000A9; inpB = 32'h8000006F; #10;
	//3. SLT; Expected Result = 0x00000000;
	opCode = 4'b1000; inpA = 32'h000000FD; inpB = 32'h00000100; #10;
	//4. SRL; Expected Result = 32'd5;
	opCode = 4'b0100; inpA = 32'h00000BD6; inpB = 32'd9; #10;
	//5. BNE; Z = 1;
	opCode = 4'b1001; inpA = 32'h00121182; inpB = 32'h00111182; #10;

	$finish;

end

endmodule