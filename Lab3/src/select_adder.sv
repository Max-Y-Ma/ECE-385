module select_adder_single (
	input  [3:0] A, B,
	input         cin,
	output logic [3:0] S,
	output logic cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  //single CSA unit
		logic [3:0] S_0, S_1;
//		logic	[3:0] S_1;
		logic cout_0, cout_1;		//internal logic signals
	  
	  ripple_adder_4bit RA_0 (.A(A[3:0]), .B(B[3:0]), .cin(1'b0), .S(S_0[3:0]), .cout(cout_0));
	  ripple_adder_4bit RA_1 (.A(A[3:0]), .B(B[3:0]), .cin(1'b1), .S(S_1[3:0]), .cout(cout_1));
	  
	  always_comb
	  begin
	    
	  cout =  cout_0 | (cout_1 & cin);
	  case(cin)															//switch case
	  
			1'b0: S = S_0;
			1'b1: S = S_1;
	  
	  endcase
end
endmodule


module select_adder (			//top layer
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);


	logic c0, c1, c2;

	ripple_adder_4bit m0 (.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(c0));
	select_adder_single m1 (.A(A[7:4]), .B(B[7:4]), .cin(c0), .S(S[7:4]), .cout(c1));
	select_adder_single m2 (.A(A[11:8]), .B(B[11:8]), .cin(c1), .S(S[11:8]), .cout(c2));
	select_adder_single m3 (.A(A[15:12]), .B(B[15:12]), .cin(c2), .S(S[15:12]), .cout(cout));

endmodule 