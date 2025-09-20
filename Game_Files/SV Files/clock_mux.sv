module clock_mux (	
	input  logic clk,
	input  logic resetN,

	input  logic [10:0] offsetX_first,
	input  logic [10:0] offsetY_first,
	input  logic        request1,
	input  logic [3:0]  digit1,

	input  logic [10:0] offsetX2,
	input  logic [10:0] offsetY2,
	input  logic        request2,
	input  logic [3:0]  digit2,

	input  logic [10:0] offsetX3,
	input  logic [10:0] offsetY3,
	input  logic        request3,
	input  logic [3:0]  digit3,

	output logic [10:0] offsetX,
	output logic [10:0] offsetY,
	output logic        req, 
	output logic [3:0]  digit
);

always_ff @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		offsetX <= 0;
		offsetY <= 0;
		req     <= 0;
		digit   <= 0;
	end else begin
		if (request1 == 1) begin
			offsetX <= offsetX_first;
			offsetY <= offsetY_first;
			req     <= request1;
			digit   <= digit1;
		end else if (request2 == 1) begin
			offsetX <= offsetX2;
			offsetY <= offsetY2;
			req     <= request2;
			digit   <= digit2;
		end else if (request3 == 1) begin
			offsetX <= offsetX3;
			offsetY <= offsetY3;
			req     <= request3;
			digit   <= digit3;
		end else begin
			offsetX <= 0;
			offsetY <= 0;
			req     <= 0;
			digit   <= 0;
		end
	end
end

endmodule
