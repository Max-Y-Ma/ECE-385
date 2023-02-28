module reg_16(
	input logic Clk, Reset,
	input logic [15:0] D,
	input logic Load,
	output logic [15:0] Q
);
	// Standard 16-bit Register
	always_ff @ (negedge Clk)
	begin
		if (Load)
			Q <= D;
		else if (Reset)
			Q <= 16'h0000;
	end

endmodule

module bus_gate(
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic [15:0] PC, MDR, ALU_OUT, MAR_MUX,
	output logic [15:0] BUS
);

	// Bus Gates
	always_comb
	begin
		unique case({GatePC, GateMDR, GateALU, GateMARMUX})
			4'b1000 : BUS = PC;
			
			4'b0100 : BUS = MDR;
			
			4'b0010 : BUS = ALU_OUT;
			
			4'b0001 : BUS = MAR_MUX;
			
			default: BUS = 16'hx;
		endcase
	end
	
endmodule

module pcmux(
	input logic [1:0] PCMUX,
	input logic [15:0] PC, BUS, MAR_MUX,
	output logic [15:0] PC_MUX
	
);
	// PCMUX Logic
	always_comb
	begin
		unique case(PCMUX)
			2'b00 : PC_MUX = PC + 16'h0001;
			2'b01 : PC_MUX = BUS;
			2'b10 : PC_MUX = MAR_MUX;		//net name for GateMARMUX wire
			default : PC_MUX = 16'h0000;
		endcase
	end
	
endmodule

module addr2mux(
	input logic [1:0] ADDR2MUX,
	input logic [15:0] IR,
	output logic [15:0] ADDR2_MUX
);
	always_comb
	begin
		unique case(ADDR2MUX)
			2'b00 : ADDR2_MUX = 16'h0000;
			2'b01 : ADDR2_MUX = {{10{IR[5]}}, IR[5:0] };
			2'b10 : ADDR2_MUX = {{7{IR[8]}}, IR[8:0] };
			2'b11 : ADDR2_MUX = {{5{IR[10]}}, IR[10:0] };
		endcase
	end
endmodule


module addr1mux(
	input logic ADDR1MUX,
	input logic [15:0] PC, SR1_OUT,
	output logic [15:0] ADDR1_MUX
);
	always_comb
	begin
		unique case(ADDR1MUX)
			1'b0 : ADDR1_MUX = PC;
			1'b1 : ADDR1_MUX = SR1_OUT;
		endcase
	end
endmodule

module cc(
	input logic [15:0] BUS,
	input logic LD_CC, Clk,
	output logic [2:0] CC
);
	logic [2:0] newCC;
	always_ff @ (negedge Clk)
	begin
		if(LD_CC)
			CC <= newCC;
	end
	
	always_comb
	begin
		if(BUS[15] == 1'b1)
			newCC = 3'b100;
		else if(BUS == 16'h0000)
			newCC = 3'b010;
		else
			newCC = 3'b001;
	end
	
endmodule

module benny(
	input logic [15:0] IR,
	input logic [2:0] CC,
	input logic Clk, LD_BEN,
	output logic BEN
);

	logic newBEN;
	
	always_ff @ (negedge Clk)
	begin
		if(LD_BEN)
			BEN <= newBEN;
	end
	
	always_comb
	begin
		newBEN = (IR[11] & CC[2]) | (IR[10] & CC[1]) | (IR[9] & CC[0]) ;
	end


endmodule

module datapath(
	input logic Clk, Reset,
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
	logic [15:0] MDR_MUX, SR2_MUX, PC_MUX, MAR_MUX, ADDR1_MUX, ADDR2_MUX;
	logic [2:0] CC;
	
	initial
	begin
		PC = 16'h0000;
	end
	
	
	//////////////////
	// Simple MUXes //
	//////////////////
	
	//GateMARMUX Net
	
	assign MAR_MUX = ADDR1_MUX + ADDR2_MUX;
	
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
			1'b1 : SR2_MUX = {{11{IR[4]}}, IR[4:0]};
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
	
	// ADDR2MUX
	addr2mux ADDR2MUX_(.*);
	
	// ADDR1MUX
	addr1mux ADDR1MUX_(.*);
	
	//SetCC
	cc CC_(.*);
	
	//BEN logic
	benny BENNY_(.*);
	
	// Datapath Registers
	reg_16 MAR_(.Clk(Clk), .Reset(Reset), .D(BUS), .Load(LD_MAR), .Q(MAR));
	
	reg_16 MDR_(.Clk(Clk), .Reset(Reset), .D(MDR_MUX), .Load(LD_MDR), .Q(MDR));
	
	reg_16 IR_(.Clk(Clk), .Reset(Reset), .D(BUS), .Load(LD_IR), .Q(IR));
	
	reg_16 PC_(.Clk(Clk), .Reset(Reset), .D(PC_MUX), .Load(LD_PC), .Q(PC));
	
endmodule
