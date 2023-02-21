module datapath(
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	input logic SR2MUX, ADDR1MUX, MARMUX,
	input logic BEN, MIO_EN, DRMUX, SR1MUX,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic [15:0] MDR_In,
	input logic [15:0] MAR, MDR, IR
);

	// Local Signals
	logic [15:0] PC, BUS;
	logic [3:0] encoded_case;
	
	always_comb: Bus_Load
	begin
			
		unique case({GatePC, GateMDR, GateALU, GateMARMUX})
			4'b1000 : BUS = PC;
			
			4'b0100 : BUS = MDR;
			
			4'b0010 : BUS = 16'h0000;		//week 2
			
			4'b0001 : BUS = 16'h0000;		//week 2
			
			default: BUS = 16'hFFFF;		//Something went wrong - BUS heavy
		endcase
		
	end
	
	always_comb: Pull_Bus
	begin
		if(LD_MAR)
			MAR = BUS;
		if(LD_MDR)
		begin
			unique case(MIO_EN)
				
			endcase
		end
	end
	
endmodule
