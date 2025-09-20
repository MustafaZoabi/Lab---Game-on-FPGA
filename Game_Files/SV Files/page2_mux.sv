
// (c) Technion IIT, Department of Electrical Engineering 2025 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	page2_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					input		logic	loading_square, // two set of inputs per unit
					input		logic	[7:0] RGB_square, 
					     
					input		logic	loading_word_req, // two set of inputs per unit
					input		logic	[7:0] RGB_word, 
		  // add the box here
		         input    logic loading_BG,
					input    logic [7:0] RGB_BG,
		  // background 
					
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


