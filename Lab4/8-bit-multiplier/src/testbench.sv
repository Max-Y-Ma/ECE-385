///////////////////Top-Level Testbench/////////////////////////
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

// Input Signals
logic Reset_Load_Clear;
logic Run;
logic [7:0] SW;

// Output Signals
logic [6:0] HEX0, HEX1, HEX2, HEX3; 
logic [7:0] Aval, Bval;
logic Xval;

initial begin: SIGNAL_INITIALIZATION
#1 Reset_Load_Clear = 1'b0;
	Run = 1'b0;
	SW = 7'b0000000;
end

// Unit Under Test
multiplier_toplevel UUT(.Clk(Clk),
								.Reset_Load_Clear(Reset_Load_Clear), 
								.Run(Run),
								.SW(SW),
								.HEX0(HEX0), 
								.HEX1(HEX1), 
								.HEX2(HEX2), 
								.HEX3(HEX3),
								.Aval(Aval), 
								.Bval(Bval),
								.Xval(Xval)
								);

initial begin: TESTS
// Test 1: Normal Test
#2 SW = 8'hC5;
	Reset_Load_Clear = 1'b1;
	
#8 Run = 1'b1;
	Reset_Load_Clear = 1'b0;
	
#4 SW = 8'h07;

#4 if ({Xval, Aval, Bval} != 17'h00019)
			ErrorCnt++;

#2 Run = 1'b0;
	Reset_Load_Clear = 1'b0;
			
// Console Output in ModelSim
if (ErrorCnt == 0)
	$display("Success!");  
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
	
end

endmodule

/////////////////Adder-Unit Testbench/////////////////////////

//module testbench();
//
//timeunit 10ns;	// Half clock cycle at 50 MHz
//timeprecision 1ns;
//
//// Error Tracking
//integer ErrorCnt = 0;
//
//// Clock
//logic Clk;
//
//initial begin: CLOCK_INITIALIZATION
//    Clk = 0;
//end 
//
//always begin : CLOCK_GENERATION
//	#1 Clk = ~Clk;
//end
//
//// Signals
//logic [7:0] A, SW;
//logic Add_Signal;
//logic [8:0] Adder_Out;
//
//initial begin: SIGNAL_INITIALIZATION
//#1 A = 8'h00;
//   SW = 8'h00;
//   Adder_Out = 9'h000;
//	Add_Signal = 1'b1;
//end
//
//// Unit Under Test
//adder_unit A0(.A(A), .SW(SW), .Add_Signal(Add_Signal), .Adder_Out(Adder_Out));
//
//initial begin: TESTS
//// Test 1: Normal Test
//#2 A = 8'h038;
//   SW = 8'h038;
//	Add_Signal = 1'b0;
//
//#4 if (Adder_Out[8:0] != 9'h000)
//			ErrorCnt++;		
//
//// Test 2: Normal Test
//#2 A = 8'h038;
//   SW = 8'h038;
//	Add_Signal = 1'b1;
//
//#4 if (Adder_Out[8:0] != 9'h070)
//			ErrorCnt++;	
//			
//// Test 3: SEXT Addition Test
//#2 A = 8'h078;
//   SW = 8'h0FF;
//	Add_Signal = 1'b1;
//
//#4 if (Adder_Out[8:0] != 9'h077)
//			ErrorCnt++;	
//			
//// Test 4: SEXT Subtraction Test
//#2 A = 8'h078;
//   SW = 8'h0FF;
//	Add_Signal = 1'b0;
//
//#4 if (Adder_Out[8:0] != 9'h079) 
//			ErrorCnt++;	
//			
//// Test 5: SEXT Subtraction Test
//#2 A = 8'b11000100;
//   SW = 8'b11000001;
//	Add_Signal = 1'b1;
//
//#4 if (Adder_Out[8:0] != 9'b110000101) 
//			ErrorCnt++;	
//			
//// Console Output in ModelSim
//if (ErrorCnt == 0)
//	$display("Success!");  
//else
//	$display("%d error(s) detected. Try again!", ErrorCnt);
//	
//end
//
//endmodule

///////////////////////////////////////////////////////////////////////////