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
	logic [15:0] PC, BUS, REG_IN, ALU_OUT, SR1_OUT, SR2_OUT, SR2MUX_OUT;
	
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
	
	// Bus Store
	
	// Register File
	register_file RegFile(.*);
	
	// ALU
	ALU ALU(.A(SR1_OUT), .B(SR2MUX_OUT), .*);
	
	
//	always_comb // BUS_STORE
//	begin
//		if(LD_MAR)
//			MAR = BUS;
//		else
//			MAR = MAR;
//			
//		if(LD_MDR)
//		begin
//			unique case (MIO_EN)
//				1'b0 : MDR = BUS;
//				1'b1 : MDR = MDR_In;
//			endcase
//		end
//		
//		if (LD_IR)
//			IR = BUS;
//			
//		if (LD_BEN)
//			// Determine Logic: Does cc match IR[x:x]?
//		
//		if (LD_CC)
//			// Determine Logic: Check MSB of BUS?
//			
//		if (LD_REG)
//			REG_IN = BUS;
//			
//		if (LD_PC)
//			PC = BUS;
//		
////		if (LD_LED)
////			// Week 2
//		
//	end
	
endmodule
