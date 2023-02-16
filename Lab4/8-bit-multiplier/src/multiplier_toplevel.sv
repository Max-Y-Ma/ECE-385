module multiplier_toplevel (
	input  logic			Clk, 
								Reset_Load_Clear, 
								Run,
	input  logic [7:0]	SW,
	output logic [6:0]	HEX0, 
								HEX1, 
								HEX2, 
								HEX3,
	output logic [7:0]   Aval, 
								Bval,
	output logic 			Xval
	);
	
	// Asynchronous Inputs: {Reset_Load_Clear, Run_Sync, [7:0] SW_Sync}
	logic Reset_Load_Clear_S, Run_S;
	logic [7:0] SW_S;
	
	// Schronizer Instantiation
	synchronizer RLC_Sync(.Clk(Clk), .d(Reset_Load_Clear), .q(Reset_Load_Clear_S));
	synchronizer Run_Sync(.Clk(Clk), .d(Run), .q(Run_S));
	synchronizer SW_Sync[7:0](.Clk(Clk), .d(SW[7:0]), .q(SW_S[7:0]));

	// Internal Logic
	logic M;								// Input to FSM
	logic A_rst, B_rst, X_rst;		// Output Controlled by FSM
	logic LoadA, LoadB;				// Output Controlled by FSM
	logic Shift_En;					// Output Controlled by FSM
	logic Add_Signal;					// Output Controlled by FSM
	
	logic [8:0] Adder_Out;			// Output of Adder
	
	logic A_LSB;						// LSB of Register A
	
	// X: Signed Bit of Multiplication Result
	always_ff @ (posedge Clk)
	begin
		if (X_rst) 
		begin
			Xval <= 1'b0;
		end else begin
			Xval <= Adder_Out[8];
		end
	end
	
	// Register Instantiation	
	reg_8 			reg_A(.Clk(Clk), 
								.Reset(A_rst), 
								.Shift_In(Xval), 
								.Load(LoadA), 
								.Shift_En(Shift_En), 
								.Data_In(Adder_Out[7:0]), 
								.Shift_Out(A_LSB), 
								.Data_Out(Aval[7:0])
								);
									
	reg_8 			reg_B(.Clk(Clk), 
								.Reset(B_rst), 
								.Shift_In(A_LSB), 
								.Load(LoadB), 
								.Shift_En(Shift_En), 
								.Data_In(SW_S[7:0]), 
								.Shift_Out(M), 
								.Data_Out(Bval[7:0])
								);
							
	// Adder Unit Instantiation
	adder_unit 		adder_9(.A(Aval[7:0]), 
								  .SW(SW_S[7:0]),
								  .Add_Signal(Add_Signal),
								  .Adder_Out(Adder_Out)
								  );
							
	// Control Unit Instantiation
	
	control_unit   FSM(.Clk(Clk), 
							 .Reset_Load_Clear(Reset_Load_Clear_S), 
							 .Run(Run_S), 
							 .M(M),
							 .LoadA(LoadA), 
							 .LoadB(LoadB), 
							 .Shift_En(Shift_En), 
							 .Add_Signal(Add_Signal),
							 .A_rst(A_rst), 
							 .B_rst(B_rst), 
							 .X_rst(X_rst)
							 );
	
	// Hex Driver Instantiation
	hex_driver HexAUpper(.In0(Aval[7:4]), .Out0(HEX3[6:0]));
	hex_driver HexALower(.In0(Aval[3:0]), .Out0(HEX2[6:0]));
	hex_driver HexBUpper(.In0(Bval[7:4]), .Out0(HEX1[6:0]));
	hex_driver HexBLower(.In0(Bval[3:0]), .Out0(HEX0[6:0]));

endmodule
