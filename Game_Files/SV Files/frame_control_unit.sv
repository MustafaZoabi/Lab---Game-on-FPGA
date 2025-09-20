module frame_control_unit #(
    parameter int FRAME_COUNT = 8,     // Number of frames before advancing MoveFrameChar
    parameter int CHAR_MAX    = 6      // Number of values MoveFrameChar can cycle through (0 to CHAR_MAX-1)
)(
    input  logic clk,
    input  logic resetN,
    input  logic startOfFrame,         // 30 Hz pulse
	 input  logic coin_collected,
    output logic [2:0] MoveFrameChar   // Note: Adjust size if CHAR_MAX > 8
);

logic [2:0] frame_counter; // counts from 0 to FRAME_COUNT-1

always_ff @(posedge clk or negedge resetN) begin
    if (!resetN) begin
        frame_counter <= 0;
        MoveFrameChar <= 0;
    end else if (startOfFrame) begin
        if (frame_counter == FRAME_COUNT - 1) begin
            frame_counter <= 0;
            MoveFrameChar <= (MoveFrameChar == CHAR_MAX - 1) ? 3'd0 : MoveFrameChar + 1;
        end else begin
            frame_counter <= frame_counter + 1;
        end
    end
end

endmodule
