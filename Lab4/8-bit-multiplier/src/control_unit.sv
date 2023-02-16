module control_unit (
	input logic Clk, Reset_Load_Clear, Run, M,
	output logic LoadA, LoadB, LoadX, Shift_En, Add_Signal, A_rst, B_rst, X_rst,
	output logic [3:0] State, 
	output logic [2:0] Counter
	);
	
	// 8 Possible States 
	//                 000     001    010   011   100    101         110      111
	enum logic [3:0] {START, LOAD_B, INIT, SHIFT, WAIT, ADD, SUBTRACT, LAST_SHIFT, HOLD, DONE} curr_state, next_state; 
	
	// Next State
	always_ff @ (posedge Clk)
	begin
	  if (Reset_Load_Clear)
			curr_state <= LOAD_B;
	  else 
			curr_state <= next_state;
	end
	
	// Counter State Transitions
	logic [2:0] C;
	logic [2:0] next_C;
	assign State = curr_state;
	assign Counter = C;
	always_ff @ (posedge Clk)
	begin
		if (Reset_Load_Clear)
			C <= 3'b000;
		else
			C <= next_C;
	end
	
	always_comb
	begin
		next_C  = C;	//required because I haven't enumerated all possibilities below

		case (C)
			3'b000 : if (next_state == SHIFT) 
							next_C = 3'b001;
							
			3'b001 : if (next_state == SHIFT) 
							next_C = 3'b010;
							
			3'b010 : if (next_state == SHIFT) 
							next_C = 3'b011;
							
			3'b011 : if (next_state == SHIFT) 
							next_C = 3'b100;
							
			3'b100 : if (next_state == SHIFT) 
							next_C = 3'b101;
							
			3'b101 : if (next_state == SHIFT) 
							next_C = 3'b110;
							
			3'b110 : if (next_state == SHIFT) 
							next_C = 3'b111;
							
			3'b111 : if (next_state == INIT) 
							next_C = 3'b000;
		endcase
	end
	
	// State Transition
	always_comb
	begin
	
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below
		
		// Next State Logic
		unique case (curr_state) 
				// Start State
            START :     if (Reset_Load_Clear)
							   begin
								 	next_state = LOAD_B;
							   end else begin
									next_state = START;
							   end
							  
				// Load B Register State			  
            LOAD_B :    if (Run)
								begin
									next_state = INIT;
								end else begin
									next_state = LOAD_B;
								end
				
				// X, A = 0 and C[2:0] = 0 
            INIT :    	if (M)
								begin
									next_state = ADD;
								end else begin
									next_state = SHIFT;
								end
								
				// Shift_En for Both Register A and B
            SHIFT :     next_state = WAIT;
								
				WAIT: 		if (C != 3'b111)
								begin
									if (M)
									begin
										next_state = ADD;
									end else begin
										next_state = SHIFT;
									end
								end else begin
									if (M)
									begin
										next_state = SUBTRACT;
									end else begin
										next_state = LAST_SHIFT;
									end
								end
				
				// ADD_SIGNAL = 1 and Load Adder into A Register
            ADD :   		next_state = SHIFT;
				
				// ADD_SIGNAL = 0
				SUBTRACT :	next_state = LAST_SHIFT;
				
				LAST_SHIFT : next_state = HOLD;
				
				HOLD : 		if (Run)
								begin
									next_state = HOLD;
								end else begin
									next_state = DONE;
								end
				
				// Loop back to LOAD_B or INIT and Final SHIFT
				DONE :  		if (Reset_Load_Clear)
								begin
									next_state = LOAD_B;
								end
								else if (Run)
								begin
									next_state = INIT;
								end else begin
									next_state = DONE;
								end
								
				default: 	next_state = DONE;
        endcase
   
	  // State Outputs LoadA, LoadB, Shift_En, Add_Signal, A_rst, B_rst, X_rst
	  case (curr_state) 
			START: 
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			LOAD_B: 
			begin
				LoadA = 1'b0;
				if (Reset_Load_Clear)
				begin
					LoadB = 1'b1;
					A_rst = 1'b1;
					X_rst = 1'b1;
				end else begin
					LoadB = 1'b0;
					A_rst = 1'b0;
					X_rst = 1'b0;
				end
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				B_rst = 1'b0;
			end
			
			INIT:
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b1;
				B_rst = 1'b0;
				X_rst = 1'b1;
			end
			
			SHIFT:
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b1;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			WAIT: 
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			ADD:
			begin
				LoadA = 1'b1;
				LoadB = 1'b0;
				LoadX = 1'b1;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			SUBTRACT:
			begin
				LoadA = 1'b1;
				LoadB = 1'b0;
				LoadX = 1'b1;
				Shift_En = 1'b0;
				Add_Signal = 1'b0;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			LAST_SHIFT:
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b1;
				Add_Signal = 1'b0;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			HOLD:
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			DONE:
			begin
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
			
			default:
			begin 
				LoadA = 1'b0;
				LoadB = 1'b0;
				LoadX = 1'b0;
				Shift_En = 1'b0;
				Add_Signal = 1'b1;
				A_rst = 1'b0;
				B_rst = 1'b0;
				X_rst = 1'b0;
			end
	  endcase
	  
	end
endmodule
