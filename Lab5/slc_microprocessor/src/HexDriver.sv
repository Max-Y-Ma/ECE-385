module HexDriver (
	input  logic [3:0]  In0,
	output logic [6:0]  Out0
	);
	
	always_comb
	begin
		unique case (In0)
	 	   4'b0000   : Out0 = 7'b1000000; // '0' = x40
	 	   4'b0001   : Out0 = 7'b1111001; // '1' = x79
		   4'b0010   : Out0 = 7'b0100100; // '2' = x24
	 	   4'b0011   : Out0 = 7'b0110000; // '3' = x30
	 	   4'b0100   : Out0 = 7'b0011001; // '4' = x19
		   4'b0101   : Out0 = 7'b0010010; // '5' = x12
	 	   4'b0110   : Out0 = 7'b0000010; // '6' = x02
	 	   4'b0111   : Out0 = 7'b1111000; // '7' = x78
	 	   4'b1000   : Out0 = 7'b0000000; // '8' = x00
		   4'b1001   : Out0 = 7'b0010000; // '9' = x10
	 	   4'b1010   : Out0 = 7'b0001000; // 'A' = x08
	 	   4'b1011   : Out0 = 7'b0000011; // 'b' = x03
	 	   4'b1100   : Out0 = 7'b1000110; // 'C' = x46
		   4'b1101   : Out0 = 7'b0100001; // 'd' = x21
	 	   4'b1110   : Out0 = 7'b0000110; // 'E' = x06
	 	   4'b1111   : Out0 = 7'b0001110; // 'F' = x0E
	 	   default   : Out0 = 7'bX;
	  	 endcase
	end

endmodule