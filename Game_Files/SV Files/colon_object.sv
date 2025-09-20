
module colon_object (
	input  logic clk,
	input  logic resetN,
	input  logic signed [10:0] pixelX,
	input  logic signed [10:0] pixelY,
	input  logic signed [10:0] topLeftX,
	input  logic signed [10:0] topLeftY,

	output logic [10:0] offsetX,
	output logic [10:0] offsetY,
	output logic drawingRequest,
	output logic [7:0] RGBout
);

	// Parameters
	parameter int OBJECT_WIDTH_X = 8;
	parameter int OBJECT_HEIGHT_Y = 32;
	parameter logic [7:0] DOT_COLOR = 8'b11100000;  // Red dot
	localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF;

	// Internal signals
	logic signed [10:0] relX, relY;
	logic insideObject, insideDot;

	// Rectangle limits
	logic signed [10:0] rightX, bottomY;
	assign rightX  = topLeftX + OBJECT_WIDTH_X;
	assign bottomY = topLeftY + OBJECT_HEIGHT_Y;

	// Relative pixel position
	assign relX = pixelX - topLeftX;
	assign relY = pixelY - topLeftY;

	// Inside the colon bounding box
	assign insideObject = (pixelX >= topLeftX) && (pixelX < rightX) &&
	                      (pixelY >= topLeftY) && (pixelY < bottomY);

	// Dot condition: two 3x3 dots, centered horizontally
	assign insideDot = insideObject &&
	                   (((relY >= 7) && (relY <= 9)) || ((relY >= 23) && (relY <= 25))) &&
	                   (relX >= 2) && (relX <= 5);

	// Output logic
	always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			RGBout         <= 8'h00;
			drawingRequest <= 1'b0;
			offsetX        <= 11'd0;
			offsetY        <= 11'd0;
		end else begin
			if (insideDot) begin
				RGBout         <= DOT_COLOR;
				drawingRequest <= 1'b1;
				offsetX        <= relX;
				offsetY        <= relY;
			end else begin
				RGBout         <= TRANSPARENT_ENCODING;
				drawingRequest <= 1'b0;
				offsetX        <= 11'd0;
				offsetY        <= 11'd0;
			end
		end
	end

endmodule
