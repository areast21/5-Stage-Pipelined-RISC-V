module mainTestBench;

reg clk = 0, rst_;

risc_v_toplevel DUT (clk, rst_);

always
	#5 clk = ~clk;

initial begin
	
	$dumpfile("mainTestTrace.vcd");
	$dumpvars(0, mainTestBench);

	rst_ = 0; #30;
	rst_ = 1; #2000;

	$finish;

end

endmodule
