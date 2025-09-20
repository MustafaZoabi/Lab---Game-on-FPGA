module square_object_power (
    input logic clk,
    input logic resetN,
    input logic [10:0] pixelX,         // current VGA pixel
    input logic [10:0] pixelY,
    input logic [10:0] topLeftX,       // position on the screen
    input logic [10:0] topLeftY,       // position on the screen (no signed)
    input logic power_on,              // Power signal to control object state
    output logic [10:0] offsetX,       // offset inside bracket from top left position
    output logic [10:0] offsetY,
    output logic drawingRequest,       // indicates pixel inside the bracket
    output logic [7:0] RGBout ,         // color output for the selected frame
	 output logic shield_activated
);

    // Parameters
    parameter int OBJECT_WIDTH_X = 64;
    parameter int OBJECT_HEIGHT_Y = 64;
    parameter logic [7:0] OBJECT_COLOR = 8'h00;   // Color for the object (default)
    parameter logic [7:0] BAR_COLOR = 8'h1C;      // Color for the border/bar (optional)
    localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF;  // bitmap for transparent pixels
    parameter int unsigned TIMER_MAX_COUNT = 31500;
    // States for the state machine
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        POWERED_ON = 2'b01
    } state_t;

    state_t current_state, next_state;
    int timer_count;

    // Shifted coordinates for positioning
    logic [10:0] topLeftX_shifted;
    logic [10:0] topLeftY_shifted;

    // Calculate rightX and bottomY for the bracket boundaries
    int rightX;
    int bottomY;
    logic insideBracket;

    assign topLeftX_shifted = topLeftX + 11'd8;  // Shift the X position
    assign topLeftY_shifted = topLeftY - 11'd16;  // Shift the Y position

    assign rightX = (topLeftX_shifted + OBJECT_WIDTH_X);
    assign bottomY = (topLeftY_shifted + OBJECT_HEIGHT_Y);

    // Inside rectangle condition: checks if current pixel is inside the bracket
    assign insideBracket = (pixelX >= topLeftX_shifted) && (pixelX < rightX) &&
                           (pixelY >= topLeftY_shifted) && (pixelY < bottomY);

    // State machine and timer logic
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            current_state <= IDLE;
            timer_count <= 0;
            RGBout <= TRANSPARENT_ENCODING;  // Set color to transparent initially
            drawingRequest <= 1'b0;
            offsetX <= 11'd0;
            offsetY <= 11'd0;
        end else begin
            // State transition logic
            current_state <= next_state;
				 drawingRequest <= 1'b0;

            // Timer logic for 10 seconds at 10 Hz
            if (current_state == POWERED_ON) begin
                if (timer_count < TIMER_MAX_COUNT) begin
                    timer_count <= timer_count + 1;
                end
            end else begin
                timer_count <= 0;  // Reset timer when not powered on
            end

            // Default outputs
            RGBout <= TRANSPARENT_ENCODING;
            drawingRequest <= 1'b0;
            offsetX <= 11'd0;
            offsetY <= 11'd0;

            // Drawing logic: if inside the bracket and powered on, show object
            if (insideBracket) begin
                // Only draw if powered on
                if (current_state == POWERED_ON) begin
                    RGBout <= OBJECT_COLOR;
                    offsetX <= pixelX - topLeftX_shifted;
                    offsetY <= pixelY - topLeftY_shifted;
                    drawingRequest <= 1'b1;  // Request to draw pixel
                end
            end
        end
    end

    // Next state logic (state machine transitions)
    always_comb begin
        case (current_state)
            IDLE: begin
				    shield_activated = 1'b0;
                if (power_on) begin
                    next_state = POWERED_ON;  // Transition to powered on state
                end else begin
                    next_state = IDLE;
                end
            end
            POWERED_ON: begin
				    shield_activated = 1'b1;
                if (timer_count == TIMER_MAX_COUNT) begin
                    next_state = IDLE;  // After 10 seconds, return to IDLE
                end else begin
                    next_state = POWERED_ON;
                end
            end
            default: next_state = IDLE;  // Default to IDLE state
        endcase
    end

endmodule
