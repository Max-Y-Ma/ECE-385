//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------

// 3 WAIT STATESSSSSS

module ISDU (   
	input logic				Clk, 
								Reset,
								Run,
								Continue,
									
	input logic [3:0]  	Opcode, 
	input logic         	IR_5,
	input logic         	IR_11,
	input logic [9:0]    ledVect12,
	input logic         	BEN,
				  
	output logic        	LD_MAR,
								LD_MDR,
								LD_IR,
								LD_BEN,
								LD_CC,
								LD_REG,
								LD_PC,
								LD_LED, // for PAUSE instruction
									
	output logic        	GatePC,
								GateMDR,
								GateALU,
								GateMARMUX,
									
	output logic [1:0]  	PCMUX,
	output logic        	DRMUX,
								SR1MUX,
								SR2MUX,
								ADDR1MUX,
	output logic [1:0]  	ADDR2MUX,
								ALUK,
				  
	output logic       	Mem_OE,
								Mem_WE,
								
	output logic [9:0]   LED
);
	
	// Internal state logic
	enum logic [4:0] { 	Halted, 	 	// 0: HALT
								PauseIR1, 	// 1: Pause #1
								PauseIR2, 	// 2: Pause #2
								S_18,	    	// 3: MAR <- PC ; PC <- PC + 1
								S_33_1,   	// 4: MDR <- M
								S_33_2,		// 5: MDR M Wait
								S_33_3, 		// 6: MDR M Wait
								S_35, 		// 7: IR <- MDR
								S_32, 		// 8: Decode
								S_01,			// 9: ADD
								S_05, 		// 10: AND
								S_09, 		// 11: NOT
								S_06,			// 12: LDR
								S_25_1, S_25_2, S_25_3,		// LDR M Wait
								S_27, 							// 
								S_07, 							// 
								S_23,								//
								S_16_1, S_16_2, S_16_3,
								S_04, 
								S_21, 
								S_12,
								S_00, 
								S_22}   State, Next_state;
								
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b0;
		Mem_WE = 1'b0;
		
		LED = 10'b0000000000;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_33_3;
			S_33_3 :
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;	//was PauseIR1	
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0001 : 
						Next_state = S_01;

					// You need to finish the rest of opcodes.....
					4'b0101 : 
						Next_state = S_05;
						
					4'b1001 :
						Next_state = S_09;
						
					4'b0110 :
						Next_state = S_06;
						
					4'b0111 :
						Next_state = S_07;
						
					4'b0100 :
						Next_state = S_04;
						
					4'b1100 :
						Next_state = S_12;
						
					4'b0000 :
						Next_state = S_00;
						
					4'b1101 :
						Next_state = PauseIR1;

					default : 
						Next_state = PauseIR1;			//something went wrong
				endcase
				
			S_01 : 
				Next_state = S_18;
				
			S_05 :
				Next_state = S_18;
				
			S_09 :
				Next_state = S_18;
				
			S_06 :
				Next_state = S_25_1;
				
			S_25_1 :
				Next_state = S_25_2;
				
			S_25_2 :
				Next_state = S_25_3;
				
			S_25_3 :
				Next_state = S_27;
				
			S_27 :
				Next_state = S_18;
				
			S_07 :
				Next_state = S_23;
				
			S_23 :
				Next_state = S_16_1;
				
			S_16_1 :
				Next_state = S_16_2;
				
			S_16_2 :
				Next_state = S_16_3;
				
			S_16_3 :
				Next_state = S_18;
				
			S_04 :
				Next_state = S_21;
				
			S_21 :
				Next_state = S_18;
				
			S_12 :
				Next_state = S_18;
				
			S_00 :
				if(BEN)						//does this need to be comb??
					Next_state = S_22;
				else
					Next_state = S_18;
					
			S_22 : 
				Next_state = S_18;

			// You need to finish the rest of states..... - should be done

			default : Next_state = PauseIR1;		//something went wrong

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;		//defaults
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b1;
			S_33_2 : 
				Mem_OE = 1'b1;
			S_33_3 : 
				begin 
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: 
				LED = ledVect12;
			PauseIR2: 
				LED = ledVect12;
			S_32 : 
				LD_BEN = 1'b1;
			S_01 : 
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					// incomplete...
					DRMUX = 1'b0;			//SR2 register value should be passed in via datapath
					SR1MUX = 1'b1;
					LD_CC = 1'b1;
										
				end

			// You need to finish the rest of states.....
			
			S_05 :
				begin
					SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;			//SR2 register value should be passed in via datapath
					SR1MUX = 1'b1;
					LD_CC = 1'b1;
				end
				
			S_09 :
				begin
					SR1MUX = 1'b1;
					ALUK = 2'b10;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			
			S_06:
				begin
					ADDR1MUX = 1'b1;
					SR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
				end
				
			S_25_1:
				Mem_OE = 1'b1;
				
			S_25_2:
				Mem_OE = 1'b1;
				
			S_25_3:
				begin
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
				
			S_27:
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
				
			S_07:
				begin
					ADDR1MUX = 1'b1;
					SR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
				end
				
			S_23:
				begin
					LD_MDR = 1'b1;
					Mem_OE = 1'b0;		//BUS -> MDR
					SR1MUX = 1'b0;
					ALUK = 2'b11;
					GateALU = 1'b1;
				end
				
			S_16_1:						//all I have to do is WE right??
				Mem_WE = 1'b1;
					
			S_16_2:
				Mem_WE = 1'b1;
				
			S_16_3:
				Mem_WE = 1'b1;
				
			S_04:
				begin
					DRMUX = 1'b1;
					LD_REG = 1'b1;
					GatePC = 1'b1;
				end
				
			S_21:
				begin
					PCMUX = 2'b10;
					LD_PC = 1'b1;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b11;
				end
				
			S_12:
				begin
					LD_PC = 1'b1;
					PCMUX = 2'b10;		//passing internally
					ADDR2MUX = 2'b00;
					ADDR1MUX = 1'b1;
					SR1MUX = 1'b1;					
				end
				
			S_00: ;						//BEN - do nothing
			
			S_22:
				begin
					PCMUX = 2'b10;
					LD_PC = 1'b1;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b10;
				end

			default : ;					//do nothing
		endcase
	end 

	
endmodule
