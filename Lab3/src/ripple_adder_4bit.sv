module ripple_adder_4bit (
	input [3:0] A, B,
	input         cin,
	output [3:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a 4 bit ripple adder.
	  * To be used for 16 bit ripple adder and carry-select adder
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  // Internal carries in the 4-bit adder
	logic c0, c1, c2;
	/*============================================*/
	// Netlists with named (explicit) port connection
	// Syntax: <module> <name>(.<parameter_name> (<connection_name>), …)
	fulladder_1_bit FA0 (.x (A[0]), .y (B[0]), .z (cin), .s (S[0]), .c (c0));
	fulladder_1_bit FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
	fulladder_1_bit FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
	fulladder_1_bit FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (cout));

     
endmodule 