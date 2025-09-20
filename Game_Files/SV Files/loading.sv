module loading ( 
    input  logic               clk,
    input  logic               resetN,
    input  logic               startOfFrame, // current VGA pixel
    input  logic               start_signal,
    output logic signed [10:0] widthX,
    output logic               loading_complete
);

logic [3:0] count;

// Width update and count logic
always_ff @(posedge clk or negedge resetN) begin
    if (!resetN) begin
        widthX <= 11'sd0;
        count  <= 4'd0;
    end
    else if (start_signal) begin
        widthX <= 11'sd0;
        count  <= 4'd0;
    end
    else begin
        if (startOfFrame) begin
            count <= count + 4'd1;
            if (widthX < 11'd230 && count == 4'd1) begin
                widthX <= widthX + 11'd10;
            end
        end
    end
end

assign loading_complete = (widthX >= 11'sd220) ? 1'b1 : 1'b0;

endmodule
