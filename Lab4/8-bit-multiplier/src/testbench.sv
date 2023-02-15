module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
timeprecision 1ns;

// Error Tracking
integer ErrorCnt = 0;

// Clock
logic Clk;

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

// Signals
logic [7:0] A, SW;
logic Add_Signal;
logic [8:0] Adder_Out;

initial begin: SIGNAL_INITIALIZATION
#1 A = 8'h00;
   SW = 8'h00;
   Adder_Out = 9'h000;
	Add_Signal = 1'b1;
end

// Unit Under Test
adder_unit A0(.A(A), .SW(SW), .Add_Signal(Add_Signal), .Adder_Out(Adder_Out));

initial begin: TESTS
// Test 1: Normal Test
#2 A = 8'h038;
   SW = 8'h038;
	Add_Signal = 1'b0;

#4 if (Adder_Out[8:0] != 9'h000)
			ErrorCnt++;		

// Console Output in ModelSim
if (ErrorCnt == 0)
	$display("Success!");  
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
	
end

endmodule
