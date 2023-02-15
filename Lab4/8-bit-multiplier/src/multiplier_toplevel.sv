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
	logic M;							// Input to FSM
	logic A_rst, B_rst;			// Output Controlled by FSM
	logic Ld_A, Ld_B;				// Output Controlled by FSM
	logic Shift_En;				// Output Controlled by FSM
	logic Add_Signal;				// Output Controlled by FSM
	
	logic [8:0] Adder_Out;		// Output of Adder
	
	logic A_LSB;					// LSB of Register A
	
	// X: Signed Bit of Multiplication Result
	always_ff @ (posedge Clk)
	begin
		Xval <= Adder_Out[8];
	end
	
	// Register Instantiation	
	reg_8 			reg_A(.Clk(Clk), 
								.Reset(A_rst), 
								.Shift_In(Xval), 
								.Load(Ld_A), 
								.Shift_En(Shift_En), 
								.Data_In(Adder_Out[7:0]), 
								.Shift_Out(A_LSB), 
								.Data_Out(Aval[7:0])
								);
									
	reg_8 			reg_B(.Clk(Clk), 
								.Reset(B_rst), 
								.Shift_In(A_LSB), 
								.Load(Ld_B), 
								.Shift_En(Shift_En), 
								.Data_In(SW_S[7:0]), 
								.Shift_Out(M), 
								.Data_Out(Bval[7:0])
								);
							
	// Adder Unit Instantiation
	adder_unit 		adder_9(.A(Aval[7:0]), 
								  .SW(SW[7:0]),
								  .Add_Signal(Add_Signal),
								  .Adder_Out(Adder_Out)
								  );
							
	// Control Unit Instantiation
	
	
	// Hex Driver Instantiation
	hex_driver HexAUpper(.In0(Aval[7:4]), .Out0(HEX3[6:0]));
	hex_driver HexALower(.In0(Aval[3:0]), .Out0(HEX2[6:0]));
	hex_driver HexBUpper(.In0(Bval[7:4]), .Out0(HEX1[6:0]));
	hex_driver HexBLower(.In0(Bval[3:0]), .Out0(HEX0[6:0]));

endmodule
