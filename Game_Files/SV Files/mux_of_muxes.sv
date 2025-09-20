module	mux_of_muxes	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					input    logic [1:0] current_page,
					
					input		logic	[7:0] RGB_page_0, 
					     
					input		logic	[7:0] RGB_page_1, 
		  // background 
					input   logic [7:0] RGB_page_2,
					input   logic [7:0] RGB_page_3,
					output   logic [7:0] RGBOut

					

);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
	if     (current_page == 0 )
		   RGBOut <= RGB_page_0;  //first priority 
			
	else if (current_page == 1)
		   RGBOut <= RGB_page_1 ;
			
	else if (current_page == 2)
		   RGBOut <= RGB_page_2 ;
			
	else if (current_page == 3)
		   RGBOut <= RGB_page_3 ;
end
end
endmodule

       