module frame_control_unit_power #(
    parameter int CHAR_MAX = 5
)(
    input  logic clk,
    input  logic resetN,
    input  logic coin_collected,
    input  logic keypad_pressed,
    output logic [2:0] MoveFrameChar,
    output logic keypad_pressed_pulse
);

    logic keypad_pressed_d; // delayed version to detect rising edge

    // Frame control logic
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            MoveFrameChar <= 0;
        end else if (coin_collected) begin
            if (MoveFrameChar < CHAR_MAX - 1) begin
                MoveFrameChar <= MoveFrameChar + 1;
            end
        end else if (MoveFrameChar == CHAR_MAX - 1 && (keypad_pressed & ~keypad_pressed_d)) begin
            // Reset to frame 0 when key is pressed (rising edge)
            MoveFrameChar <= 0;
        end
    end

    // Rising edge detection for keypad_pressed
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            keypad_pressed_d <= 0;
            keypad_pressed_pulse <= 0;
        end else begin
            keypad_pressed_d <= keypad_pressed;
            keypad_pressed_pulse <= (MoveFrameChar == CHAR_MAX - 1) && (keypad_pressed & ~keypad_pressed_d);
        end
    end

endmodule
