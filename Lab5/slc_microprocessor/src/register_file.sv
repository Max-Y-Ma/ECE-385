module register_file (
	input logic [15:0] BUS, IR,
	input logic SR1MUX, DRMUX, LD_REG,
	output logic [15:0] SR1_OUT, SR2_OUT
);
	
	// Registers
	logic [15:0] Reg [7:0];
	
	// Source and Destination Registers
	logic [2:0] DR, SR1, SR2;
	always_comb
	begin
		case (DRMUX)
			1'b0 : DR = IR[11:9];
			1'b1 : DR = 3'b111;
		endcase
	end
	
	always_comb
	begin
		case (SR1MUX)
			1'b0 : SR1 = IR[11:9];
			1'b1 : SR1 = IR[8:6];
		endcase
	end
	
	assign SR2 = IR[2:0];
	
	// Store BUS to DR 
	always_ff @ (posedge LD_REG)
	begin
		case (DR)
			3'b000 : Reg[0] = BUS;
			3'b001 : Reg[1] = BUS;
			3'b010 : Reg[2] = BUS;
			3'b011 : Reg[3] = BUS;
			3'b100 : Reg[4] = BUS;
			3'b101 : Reg[5] = BUS;
			3'b110 : Reg[6] = BUS;
			3'b111 : Reg[7] = BUS;
		endcase
	end
	
	// Output SR1
	always_comb
	begin
		// Output
		case (SR1)
			3'b000 : SR1_OUT = Reg[0];
			3'b001 : SR1_OUT = Reg[1];
			3'b010 : SR1_OUT = Reg[2];
			3'b011 : SR1_OUT = Reg[3];
			3'b100 : SR1_OUT = Reg[4];
			3'b101 : SR1_OUT = Reg[5];
			3'b110 : SR1_OUT = Reg[6];
			3'b111 : SR1_OUT = Reg[7];
		endcase
	end
	
	// Output SR2
	always_comb
	begin
		// Output
		case (SR2)
			3'b000 : SR2_OUT = Reg[0];
			3'b001 : SR2_OUT = Reg[1];
			3'b010 : SR2_OUT = Reg[2];
			3'b011 : SR2_OUT = Reg[3];
			3'b100 : SR2_OUT = Reg[4];
			3'b101 : SR2_OUT = Reg[5];
			3'b110 : SR2_OUT = Reg[6];
			3'b111 : SR2_OUT = Reg[7];
		endcase
	end

endmodule
