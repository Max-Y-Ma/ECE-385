// Custom Full Adder w/o Cout for 4_bit Lookahead Adder
module lookahead_full_adder(
	input			 	A,
	input        	B,
	input        	Cin,
	output logic   S
);

// Full Adder Logic
always_comb begin: COMPUTE_SUM
	S = A ^ B ^ Cin;
end

endmodule

/////////////////////////////////////////////////////////////////////////////////////

// 4 Bit Module for 4x4 Hierarchial Carry-Lookahead Adder
module lookahead_adder_4_bit(
	input   			    Cin,
	input  		 [3:0] A,
	input  		 [3:0] B,
	output       [3:0] S,
	output logic       P_G,
	output logic       G_G
);

// Compute All Propagation (P) Bits and Generation (G) Bits
logic [3:0] P;
logic [3:0] G;
always_comb begin: COMPUTE_P_AND_G
	P = A ^ B;
	G = A & B;
end

// Compute All Carry Bits
logic [3:0] C;
always_comb begin: COMPUTE_CARRY
	C[0] = Cin;
	C[1] = (Cin & P[0]) | G[0];
	C[2] = (Cin & P[1] & P[0]) | (G[0] & P[1]) + G[1];
	C[3] = (Cin & P[2] & P[1] & P[0]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
end

// Compute Sum Bits
lookahead_full_adder FA0(.A(A[0]), .B(B[0]), .Cin(C[0]), .S(S[0]));
lookahead_full_adder FA1(.A(A[1]), .B(B[1]), .Cin(C[1]), .S(S[1]));
lookahead_full_adder FA2(.A(A[2]), .B(B[2]), .Cin(C[2]), .S(S[2]));
lookahead_full_adder FA3(.A(A[3]), .B(B[3]), .Cin(C[3]), .S(S[3]));

// Compute Group Propagation and Generation Bits
always_comb begin: COMPUTE_GROUP
	P_G = P[3] & P[2] & P[1] & P[0];
	G_G = (G[3]) | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);
end

endmodule

// Top Level Module for 4x4 Hierarchial Carry-Lookahead Adder
module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

/////////////////////////////////////////////////////////////////////////////////////

// Compute All Group Carry Bits
logic [3:0] C;
logic [3:0] P_G;
logic [3:0] G_G;
always_comb begin: COMPUTE_GROUP_CARRY
	C[0] = cin;
	C[1] = (cin & P_G[0]) | G_G[0];
	C[2] = (cin & P_G[0] & P_G[1]) | (G_G[0] & P_G[1]) + G_G[1];
	C[3] = (cin & P_G[0] & P_G[1] & P_G[2]) | (G_G[0] & P_G[1] & P_G[2]) | (G_G[1] & P_G[2]) | G_G[2];
end

// Compute Cout
assign cout = (cin & P_G[0] & P_G[1] & P_G[2] & P_G[3]) | (G_G[0] & P_G[1] & P_G[2] & P_G[3]) | (G_G[1] & P_G[2] & P_G[3]) | (G_G[2] & P_G[3]) | G_G[3];

// Compute Sum Bits
lookahead_adder_4_bit CLA0(.Cin(C[0]), .A(A[3:0]), .B(B[3:0]), .S(S[3:0]), .P_G(P_G[0]), .G_G(G_G[0]));
lookahead_adder_4_bit CLA1(.Cin(C[1]), .A(A[7:4]), .B(B[7:4]), .S(S[7:4]), .P_G(P_G[1]), .G_G(G_G[1]));
lookahead_adder_4_bit CLA2(.Cin(C[2]), .A(A[11:8]), .B(B[11:8]), .S(S[11:8]), .P_G(P_G[2]), .G_G(G_G[2]));
lookahead_adder_4_bit CLA3(.Cin(C[3]), .A(A[15:12]), .B(B[15:12]), .S(S[15:12]), .P_G(P_G[3]), .G_G(G_G[3]));

endmodule
