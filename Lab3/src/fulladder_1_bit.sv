module fulladder_1_bit( input x,y,z,
							output logic c,s);
	
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);

endmodule