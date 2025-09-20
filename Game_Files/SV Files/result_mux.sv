module result_mux (
    input  logic        clk,
    input  logic        resetN,
    input  logic        draw_req,
    input  logic [7:0]  rgb,
    input  logic [7:0]  default_rgb,    // New input for the else case
    output logic [7:0]  out_RGB
);

    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            out_RGB <= 8'd0;
        end else begin
            if (draw_req) begin
                out_RGB <= rgb;
        
            end 
            else begin
                out_RGB <= default_rgb; // Use the new input here
            end
        end
    end

endmodule
	  