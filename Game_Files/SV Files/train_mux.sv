module train_mux (
    input  logic [10:0] offsetX1,
    input  logic [10:0] offsetY1,
    input  logic        draw_1_request,
	 input logic [2:0] num_1_line,

    input  logic [10:0] offsetX2,
    input  logic [10:0] offsetY2,
    input  logic        draw_2_request,
	 input logic [2:0] num_2_line,

	 

    output logic [10:0] offsetX_out,
    output logic [10:0] offsetY_out,
    output logic        draw_request_out,
	 output logic [2:0] num_of_line
);

    always_comb begin
        if (draw_1_request) begin
            offsetX_out      = offsetX1;
            offsetY_out      = offsetY1;
            draw_request_out = 1'b1;
				num_of_line = num_1_line;
        end else if (draw_2_request) begin
            offsetX_out      = offsetX2;
            offsetY_out      = offsetY2;
            draw_request_out = 1'b1;
				num_of_line = num_2_line;


        end else begin
            offsetX_out      = 11'd0;
            offsetY_out      = 11'd0;
            draw_request_out = 1'b0;
				num_of_line = 3'd0;

        end
    end

endmodule
