module regTB;

reg clk = 0, rst_, wrtEn;
reg [4:0]rdReg1, rdReg2, wrtReg;
wire [31:0] rdData1, rdData2;
reg [31:0] wrtData;

registers DUT (clk, rst_, wrtEn, rdReg1, rdReg2, wrtReg, wrtData, rdData1, rdData2);

always
	#5 clk = ~clk;

initial begin
	
	$dumpfile("regTrace.vcd");
	$dumpvars(0, regTB);

	rst_ = 0; #15;
	rst_ = 1; wrtEn = 1; wrtReg = 5'd15; wrtData = 32'h000000FF; #10;
	wrtEn = 0; wrtReg = 5'd10; wrtData = 32'h00000045; #10;
	wrtEn = 1; wrtReg = 5'd14; wrtData = 32'h00001234; #10;
	wrtEn = 1; wrtReg = 5'd1;  wrtData = 32'h00006789; rdReg1 = 5'd14; rdReg2 = 5'd10; #10;

	$finish;

end

endmodule