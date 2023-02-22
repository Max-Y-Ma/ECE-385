module reg_16(
	input logic Clk,
	input logic [15:0] D,
	input logic Load,
	output logic [15:0] Q
);
	// Standard 16-bit Register
	always_ff @ (negedge Clk)
	begin
		if (Load)
			Q <= D;
	end

endmodule

module bus_gate(
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic [15:0] PC, MDR, ALU_OUT,
	output logic [15:0] BUS
);

	// Bus Gates
	always_comb
	begin
		unique case({GatePC, GateMDR, GateALU, GateMARMUX})
			4'b0000 : BUS = 16'h1234;
		
			4'b1000 : BUS = PC;
			
			4'b0100 : BUS = MDR;
			
			4'b0010 : BUS = ALU_OUT;
			
			4'b0001 : BUS = 16'h0000;		//week 2
			
			default: BUS = 16'hFFFF;		//Something went wrong - BUS heavy
		endcase
	end
	
endmodule

module pcmux(
	input logic [1:0] PCMUX,
	input logic [15:0] PC, BUS,
	output logic [15:0] PC_MUX
	
);
	// PCMUX Logic
	always_comb
	begin
		unique case(PCMUX)
			2'b00 : PC_MUX = PC + 16'h0001;
			2'b01 : PC_MUX = BUS;
			2'b10 : PC_MUX = 16'h0000;		//should be address adder output
			default : PC_MUX = 16'h0000;
		endcase
	end
	
endmodule



module datapath(
	input logic Clk,
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic SR2MUX, ADDR1MUX,
	input logic MIO_EN, DRMUX, SR1MUX,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	output logic [15:0] MAR, MDR, IR,
	output logic [15:0] PC, BUS,
	output logic BEN
);
	///////////////////
	// Local Signals //
	///////////////////
	
	logic [15:0] ALU_OUT, SR1_OUT, SR2_OUT; //PC, BUS, 
	logic [15:0] MDR_MUX, SR2_MUX, PC_MUX;
	
	initial
	begin
		PC = 16'h000F;
	end
	
	//////////////////
	// Simple MUXes //
	//////////////////
	
	// MDRMUX Logic
	always_comb
	begin
		unique case(MIO_EN)
			1'b0 : MDR_MUX = BUS;
			1'b1 : MDR_MUX = MDR_In;
		endcase
	end
	
	// SR2MUX Logic
	always_comb
	begin
		unique case(SR2MUX)
			1'b0 : SR2_MUX = SR2_OUT;
			1'b1 : SR2_MUX = {{11{IR[4]}}, IR[4:0] };
		endcase
	end
	
	//////////////////////////
	// Module Instantiation //
	//////////////////////////

	// Register File
	register_file RegFile_(.*);
	
	// Gates
	bus_gate BUS_(.*);
	
	// PCMUX
	pcmux PCMUX_(.*);
	
	// ALU
	ALU ALU(.A(SR1_OUT), .B(SR2_MUX), .*);
	
	// Datapath Registers
	reg_16 MAR_(.Clk(Clk), .D(BUS), .Load(LD_MAR), .Q(MAR));
	
	reg_16 MDR_(.Clk(Clk), .D(MDR_MUX), .Load(LD_MDR), .Q(MDR));
	
	reg_16 IR_(.Clk(Clk), .D(BUS), .Load(LD_IR), .Q(IR));
	
	reg_16 PC_(.Clk(Clk), .D(PC_MUX), .Load(LD_PC), .Q(PC));
	
endmodule
