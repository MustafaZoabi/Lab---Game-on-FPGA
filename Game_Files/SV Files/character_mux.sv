module character_mux (
    input  logic        select, 
    input  logic        draw_request_a,
	 // 1 = pick A, 0 = pick B
    input  logic [7:0]  rgb_a,
	     input  logic        draw_request_b,

    input  logic [7:0]  rgb_b,
    
    output logic [7:0]  rgb_out,
    output logic        draw_request_out
);

    always_comb begin
        if (select) begin
            rgb_out = rgb_a;
            draw_request_out = draw_request_a;
        end else begin
            rgb_out = rgb_b;
            draw_request_out = draw_request_b;
        end
    end

endmodule
