module datapath(
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic SR2MUX, ADDR1MUX, MARMUX,
	input logic MIO_EN, DRMUX, SR1MUX,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	output logic [15:0] MAR, MDR, IR,
	output logic BEN
);

	// Local Signals
	logic [15:0] PC, BUS, REG_IN, ALU_OUT, SR1_OUT, SR2_OUT, SR2MUX_OUT, PC_MUX_OUT;
	
	// Bus Load
	always_comb
	begin
		unique case({GatePC, GateMDR, GateALU, GateMARMUX})
			4'b1000 : BUS = PC;
			
			4'b0100 : BUS = MDR;
			
			4'b0010 : BUS = ALU_OUT;
			
			4'b0001 : BUS = 16'h0000;		//week 2
			
			default: BUS = 16'hFFFF;		//Something went wrong - BUS heavy
		endcase
	end
	
	
	// Register File
	assign REG_IN = BUS;
	register_file RegFile(.*);
	
	// ALU
	ALU ALU(.A(SR1_OUT), .B(SR2MUX_OUT), .*);
	
	
	
	always_ff @ (posedge LD_MAR)
	begin
		MAR = BUS;
	end
	
	always_ff @ (posedge LD_MDR)
	begin
		unique case(MIO_EN)
			1'b0 : MDR = BUS;
			1'b1 : MDR = MDR_In;
		endcase
	end
	
	always_ff @ (posedge LD_IR)
	begin
		IR = BUS;
	end
	
	always_ff @ (posedge LD_PC)
	begin
		PC = PC_MUX_OUT;
	end
	
	always_comb
	begin
		unique case(PCMUX)
			2'b00 : PC_MUX_OUT = PC + 16'h0001;
			2'b01 : PC_MUX_OUT = BUS;
			2'b10 : PC_MUX_OUT = 16'h0000;		//should be address adder output
			default : PC_MUX_OUT = 16'h0000;
		endcase
	end
	
	always_comb
	begin
		unique case(SR2MUX)
			1'b0 : SR2MUX_OUT = SR2_OUT;
			1'b1 : SR2MUX_OUT = {{11{IR[4]}}, IR[4:0] };
		endcase
	end
	
endmodule
