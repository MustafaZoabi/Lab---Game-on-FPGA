module single_to_multi ( 
   input logic clk,
	input logic resetN,
	input logic select,
	output logic [1:0] select_multi );
	
	
	
	
	always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		select_multi			<=	2'b00;
	end
	else begin 
		// DEFUALT outputs
      if(select) select_multi <= 2'b00;
		else select_multi <= 2'b01;
		end
	end 
endmodule 