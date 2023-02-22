////////////////////////////////////////////////
////// STATE DIAGRAM / DATAPATH TESTBENCH //////
////////////////////////////////////////////////

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
logic	Reset, Run, Continue;
logic [3:0]  	Opcode;
logic         	IR_5;
logic         	IR_11;
logic         	BEN;

// Output Signals
logic   			LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
									
logic        	GatePC, GateMDR, GateALU, GateMARMUX;
									
logic [1:0]  	PCMUX;
logic        	DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic [1:0]  	ADDR2MUX, ALUK;

logic [15:0] 	MAR, MDR, IR, PC, BUS;
logic [15:0] 	MDR_In;
				  
logic       	Mem_OE, Mem_WE;

logic MIO_EN;
assign MIO_EN = Mem_OE;

initial begin: SIGNAL_INITIALIZATION
#1 Run = 1'b1;
	Continue = 1'b1;
	Reset = 1'b1;
	Opcode = 4'h0;
	IR_5 = 1'b0;
	IR_11 = 1'b0;
	BEN = 1'b0;
end

// Unit Under Test

datapath UUT(.*);
ISDU UUT2(.*);
test_memory mem(.Reset(Reset), 
					 .Clk(Clk), 
					 .data(MDR), 
					 .address(MAR[9:0]), 
					 .rden(Mem_OE), 
					 .wren(Mem_WE), 
					 .readout(MDR_In));

initial begin: TESTS
// Test 1: Normal Test
	
#4 Reset = 1'b0;
	Run = 1'b1;

	
// if ()
//			ErrorCnt++;
//			
//// Console Output in ModelSim
//if (ErrorCnt == 0)
//	$display("Success!");  
//else
//	$display("%d error(s) detected. Try again!", ErrorCnt);
	
end

endmodule

////////////////////////////
////// SLC3 TESTBENCH //////
////////////////////////////

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
//// Input Signals
//logic [9:0] SW;
//logic Reset, Run, Continue;
//logic [15:0] Data_from_SRAM;
//
//// Output Signals
//logic [9:0] LED;
//logic OE, WE;
//logic [6:0] HEX0, HEX1, HEX2, HEX3;
//logic [15:0] ADDR;
//logic [15:0] Data_to_SRAM;
//
//initial begin: SIGNAL_INITIALIZATION
//	SW = 10'b0000000001;
//	Data_from_SRAM = 16'h6666;
//	Run = 1'b0;
//	Continue = 1'b0;
//	Reset = 1'b1;
//end
//
//// Unit Under Test
//slc3 UUT(.*);
//
//initial begin: TESTS
//// Test 1: Normal Test
//	
//#2 Reset = 1'b0;
//	Run = 1'b1;
//
//	
//// if ()
////			ErrorCnt++;
////			
////// Console Output in ModelSim
////if (ErrorCnt == 0)
////	$display("Success!");  
////else
////	$display("%d error(s) detected. Try again!", ErrorCnt);
//	
//end
//
//endmodule

///////////////////////////////////
////// REAL MEMORY TESTBENCH //////
///////////////////////////////////

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
//// Input Signals
//logic [9:0] SW;
//logic Run, Continue;
//
//// Output Signals
//logic [9:0] LED;
//logic [6:0] HEX0, HEX1, HEX2, HEX3;
//logic [15:0] ADDR;
//
//initial begin: SIGNAL_INITIALIZATION
//	SW = 10'b0000000001;
//	Run = 1'b1;
//	Continue = 1'b1;
//end
//
//// Unit Under Test
//slc3_testtop UUT(.*);
//
//initial begin: TESTS
//// Test 1: Normal Test
//	
//#2 Run = 1'b0;
//
//	
//// if ()
////			ErrorCnt++;
////			
////// Console Output in ModelSim
////if (ErrorCnt == 0)
////	$display("Success!");  
////else
////	$display("%d error(s) detected. Try again!", ErrorCnt);
//	
//end
//
//endmodule
