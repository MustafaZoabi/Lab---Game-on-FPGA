module follow_move (
    input  logic         clk,
    input  logic         resetN,
    input  logic         follow_signal,  // Pulse: 1 clock cycle every 10 seconds
    input  logic         startOfFrame,   // frame tick (e.g. 30Hz)
    input  logic [10:0]  x_location,     // Target X position
    input  logic [10:0]  y_location,     // Target Y position
    
    output logic signed [10:0] topLeftX,
    output logic signed [10:0] topLeftY,
    output logic flipSignal,
	 output logic show_signal
);

    // Parameters
    parameter int OBJECT_WIDTH_X = 64;
    parameter int OBJECT_HEIGHT_Y = 64;
    parameter int SafetyMargin = 2;

    parameter int MAX_X = 639 - SafetyMargin - OBJECT_WIDTH_X;
    parameter int MAX_Y = 479 - SafetyMargin - OBJECT_HEIGHT_Y;
    parameter int MIN_X = SafetyMargin;
    parameter int MIN_Y = SafetyMargin;

    parameter int INITIAL_X = 639;        // Dog starts off-screen right
    parameter int INITIAL_Y = 280;

    parameter int TARGET_ENTRY_X = 570;   // Target position to walk in from
    parameter int SMOOTH_FACTOR = 4;      // 64/256 = 0.25

    // Internal variables
    int currentX;
    int currentY;
    int deltaX;
    int deltaY;

    logic [10:0] save_x;
    logic [10:0] save_y;
    logic        start;

    typedef enum logic [1:0] { REACH, PAUSE, FOLLOW } state_t;
    state_t state;
	 
	 assign show_signal = (currentX < 630) ? 1'b1 : 1'b0;

    // Clamp helper
    function int clamp(input int val, input int min_val, input int max_val);
        if (val < min_val) return min_val;
        else if (val > max_val) return max_val;
        else return val;
    endfunction

    // Main FSM
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            currentX   <= INITIAL_X;
            currentY   <= INITIAL_Y;
            state      <= REACH;
            save_x     <= 10;
            save_y     <= 10;
            flipSignal <= 1;
            start      <= 0;
        end else begin

            // Detect when character reaches center
            if (x_location == 310)
                start <= 1;

            if (startOfFrame) begin
                case (state)
                    REACH: begin
                        if (start) begin
                            // Move dog toward entry position
                            if (currentX > TARGET_ENTRY_X)
                                currentX <= currentX - 1;
                            else
                                state <= PAUSE; // Stop when reached
                        end
                    end

                    FOLLOW: begin
                        deltaX = save_x - currentX;
                        deltaY = save_y - currentY;

                        currentX <= clamp(currentX + ((deltaX * SMOOTH_FACTOR) >>> 8), MIN_X, MAX_X);
                        currentY <= clamp(currentY + ((deltaY * SMOOTH_FACTOR) >>> 8), MIN_Y, MAX_Y);

                        flipSignal <= (deltaX < 0) ? 1'b1 : 1'b0;
                    end

                    PAUSE: begin
                        // Remain idle
                        flipSignal <= flipSignal; // maintain last direction
                    end
                endcase
            end

            // Handle follow_signal to toggle between PAUSE and FOLLOW
            if (follow_signal && state != REACH) begin
                save_x <= x_location;
                save_y <= y_location + 32;
                state <= (state == FOLLOW) ? PAUSE : FOLLOW;
            end
        end
    end

    assign topLeftX = currentX;
    assign topLeftY = currentY;

endmodule
