


module	page2_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	loading_square, // two set of inputs per unit
					input		logic	[7:0] RGB_square, 
					     
					input		logic	loading_word_req, // two set of inputs per unit
					input		logic	[7:0] RGB_word, 

		         input    logic loading_BG,
					input    logic [7:0] RGB_BG,

					
					output   logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (loading_square == 1'b1 )   
			RGBOut <= RGB_square;  //first priority 
	   else if ( loading_word_req == 1'b1 )
		      RGBOut <= RGB_word ;
		else if ( loading_BG == 1'b1 )
		      RGBOut <= RGB_BG ;
		
	   else 
	   RGBOut <= 8'hFF ;
		
	end
end

endmodule


