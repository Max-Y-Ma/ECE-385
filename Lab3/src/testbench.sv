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
logic [15:0] A, B;
logic [16:0] S;

initial begin: SIGNAL_INITIALIZATION
#1 A = 16'h0000;
   B = 16'h0000;
   S = 17'h00000;
end

// Unit Under Test
//lookahead_adder UUT(.A(A), .B(B), .cin(1'b0), .cout(S[16]), .S(S[15:0]) );
ripple_adder UUT(.A(A), .B(B), .cin(1'b0), .cout(S[16]), .S(S[15:0]) );

initial begin: TESTS
// Test 1: Normal Test
#2 A = 16'h0078;
   B = 16'h03AB;

#4 if (S[15:0] != 16'h0423 || S[16] != 1'b0)
			ErrorCnt++;	
			
// Test 2: Overflow Test #1
#2 A = 16'h0378;
   B = 16'hFFFF;

#4 if (S[15:0] != 16'h0377 || S[16] != 1'b1)
		ErrorCnt++;
		
// Test 3: Overflow Test #2
#2 A = 16'hC481;
   B = 16'hDD42;

#4 if (S[15:0] != 16'hA1C3 || S[16] != 1'b1)
		ErrorCnt++;
	
// Test 4: Edge Case #1
#2 A = 16'h1100;
   B = 16'h0010;

#4 if (S[15:0] != 16'h1110 || S[16] != 1'b0)
		ErrorCnt++;		
		
// Test 5: Edge Case #2
#2 A = 16'h0000;
   B = 16'h0000;

#4 if (S[15:0] != 16'h0000 || S[16] != 1'b0)
		ErrorCnt++;		

// Console Output in ModelSim
if (ErrorCnt == 0)
	$display("Success!");  
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
	
end

endmodule