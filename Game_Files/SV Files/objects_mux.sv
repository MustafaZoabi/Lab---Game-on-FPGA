
// (c) Technion IIT, Department of Electrical Engineering 2025 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					
		         input    logic squareDrawRequest,
					input    logic [7:0] RGB_Box,
		  // b
					input		logic	[7:0] RGB_MIF, 
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		
		 
		 if (squareDrawRequest == 1'b1)
				RGBOut <= RGB_Box ;
		else RGBOut <= RGB_MIF ;// last priority 
		end ; 
	end

endmodule


