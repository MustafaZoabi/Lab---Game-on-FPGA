
// (c) Technion IIT, Department of Electrical Engineering 2025 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	page1_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					
					     
		  // add the box here
		        
		  // background 
		         input    logic cage_draw,
					input    logic [7:0] RGB_CAGE,
					
					input    logic male_draw,
					input    logic [7:0] RGB_male,
					 
					 
					input    logic female_draw,
					input    logic [7:0] RGB_female,
					
					
					input		logic	boardersDrawReq,
					input		logic	[7:0] BG_RGB,

					output   logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		
		 if( cage_draw == 1'b1 )
		      RGBOut <= RGB_CAGE ;
		else if ( male_draw == 1'b1 )
		      RGBOut <= RGB_male ;
		else if ( female_draw == 1'b1 )
		      RGBOut <= RGB_female ;
		else if ( boardersDrawReq == 1'b1 )
		      RGBOut <= BG_RGB ;
	   else  
	         RGBOut <= 8'hFF;  
	end
	
end

endmodule


