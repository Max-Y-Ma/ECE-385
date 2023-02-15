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

///////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////

module lookahead_adder_5_bit(
	input   			    Cin,
	input  		 [4:0] A,
	input  		 [4:0] B,
	output       [4:0] S,
	output logic       P_G,
	output logic       G_G
);

// Compute All Propagation (P) Bits and Generation (G) Bits
logic [4:0] P;
logic [4:0] G;
always_comb begin: COMPUTE_P_AND_G
	P = A ^ B;
	G = A & B;
end

// Compute All Carry Bits
logic [4:0] C;
always_comb begin: COMPUTE_CARRY
	C[0] = Cin;
	C[1] = (Cin & P[0]) | G[0];
	C[2] = (Cin & P[1] & P[0]) | (G[0] & P[1]) + G[1];
	C[3] = (Cin & P[2] & P[1] & P[0]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
	C[4] = (Cin & P[3] & P[2] & P[1] & P[0]) | (G[0] & P[1] & P[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[2] & P[3]) | G[3];
end

// Compute Sum Bits
lookahead_full_adder FA0(.A(A[0]), .B(B[0]), .Cin(C[0]), .S(S[0]));
lookahead_full_adder FA1(.A(A[1]), .B(B[1]), .Cin(C[1]), .S(S[1]));
lookahead_full_adder FA2(.A(A[2]), .B(B[2]), .Cin(C[2]), .S(S[2]));
lookahead_full_adder FA3(.A(A[3]), .B(B[3]), .Cin(C[3]), .S(S[3]));
lookahead_full_adder FA4(.A(A[4]), .B(B[4]), .Cin(C[4]), .S(S[4]));

// Compute Group Propagation and Generation Bits
always_comb begin: COMPUTE_GROUP
	P_G = P[4] & P[3] & P[2] & P[1] & P[0];
	G_G = G[4] | (G[3] & P[4]) | (G[2] & P[3] & P[4]) | (G[1] & P[3] & P[2] & P[4]) | (G[0] & P[4] & P[3] & P[2] & P[1]);
end

endmodule

///////////////////////////////////////////////////////

module adder_unit (
	input logic [7:0] A, SW,
	input logic Add_Signal,
	output logic [8:0] Adder_Out
	);
	
	// 2'S Complement Adder
	logic [7:0] SW_N;
	logic [7:0] Twos_Complement;
	logic [1:0] C;
	logic [1:0] P_G;
	logic [1:0] G_G;
	always_comb begin
		C[0] = 1'b1;
		C[1] = (C[0] & P_G[0]) | G_G[0];
	end
	assign SW_N = ~SW;
	
	lookahead_adder_4_bit CLA0(.Cin(C[0]), .A(SW_N[3:0]), .B(4'b0000), .S(Twos_Complement[3:0]), .P_G(P_G[0]), .G_G(G_G[0]));
	lookahead_adder_4_bit CLA1(.Cin(C[1]), .A(SW_N[7:4]), .B(4'b0000), .S(Twos_Complement[7:4]), .P_G(P_G[1]), .G_G(G_G[1]));
	
	// Add vs Subtract
	logic [8:0] Adder_In_S;
	always_comb
	begin
		case(Add_Signal)
			1'b0 : Adder_In_S = {Twos_Complement[7], Twos_Complement[7:0]};
			1'b1 : Adder_In_S = {SW[7], SW[7:0]};
		endcase
	end
	
	// 9-bit Adder
	logic [1:0] C_F;
	logic [1:0] P_G_F;
	logic [1:0] G_G_F;
	always_comb begin
		C_F[0] = 1'b0;
		C_F[1] = (C_F[0] & P_G_F[0]) | G_G_F[0];
	end
	
	lookahead_adder_5_bit CLA2(.Cin(C_F[0]), .A(A[4:0]), .B(Adder_In_S[4:0]), .S(Adder_Out[4:0]), .P_G(P_G_F[0]), .G_G(G_G_F[0]));
	lookahead_adder_4_bit CLA3(.Cin(C_F[1]), .A({A[7], A[7:5]}), .B(Adder_In_S[8:5]), .S(Adder_Out[8:5]), .P_G(P_G_F[1]), .G_G(G_G_F[1]));
	
endmodule
