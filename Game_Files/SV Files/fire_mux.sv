module fire_mux (	
	input  logic clk,
	input  logic resetN,

	// First source
	input  logic [10:0] offsetX_first,
	input  logic [10:0] offsetY_first,
	input  logic        request1,

	// Second source
	input  logic [10:0] offsetX2,
	input  logic [10:0] offsetY2,
	input  logic        request2,

	// Third source
	input  logic [10:0] offsetX3,
	input  logic [10:0] offsetY3,
	input  logic        request3,

	// Fourth source
	input  logic [10:0] offsetX4,
	input  logic [10:0] offsetY4,
	input  logic        request4,

	// Fifth source
	input  logic [10:0] offsetX5,
	input  logic [10:0] offsetY5,
	input  logic        request5,

	// Output
	output logic [10:0] offsetX,
	output logic [10:0] offsetY,
	output logic        req
);

always_ff @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		offsetX <= 0;
		offsetY <= 0;
		req     <= 0;
	end else begin
		if (request1) begin
			offsetX <= offsetX_first;
			offsetY <= offsetY_first;
			req     <= 1;
		end else if (request2) begin
			offsetX <= offsetX2;
			offsetY <= offsetY2;
			req     <= 1;
		end else if (request3) begin
			offsetX <= offsetX3;
			offsetY <= offsetY3;
			req     <= 1;
		end else if (request4) begin
			offsetX <= offsetX4;
			offsetY <= offsetY4;
			req     <= 1;
		end else if (request5) begin
			offsetX <= offsetX5;
			offsetY <= offsetY5;
			req     <= 1;
		end else begin
			offsetX <= 0;
			offsetY <= 0;
			req     <= 0;
		end
	end
end

endmodule
