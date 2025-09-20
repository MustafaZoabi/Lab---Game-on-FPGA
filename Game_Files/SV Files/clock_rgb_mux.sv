module clock_rgb_mux ( 
 input logic clk ,
 input logic resetN,
 input logic req_column,
 input logic [7:0] rgb_column,
  input logic req_clock,
 input logic [7:0] rgb_clock,
 output logic req,
 output logic [7:0] RGB );
 
 
 
 always_ff @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		req <= 0;
		RGB <= 0;
	end else begin
		if (req_column == 1) begin
			req     <= req_column;
			RGB   <= rgb_column;
	   end else if ( req_clock == 1)begin 
		   req     <= req_clock;
		 	RGB   <= rgb_clock;
		end else begin 
		   req <= 0;
		   RGB <= 0;
	   end 
	end 
	end 
	
	endmodule 