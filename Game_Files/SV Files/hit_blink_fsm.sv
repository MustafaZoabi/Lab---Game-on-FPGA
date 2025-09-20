module hit_blink_fsm (
    input  logic clk,
    input  logic resetN,
    input  logic startOfFrame,    // One pulse per frame (e.g., 30Hz)
    input  logic hit_signal,
    input  logic draw_req,
    output logic visible,         // Output visibility signal
    output logic shield_on        // Active when in ON or OFF state
);

    // Parameters
    parameter int BLINK_PERIOD_FRAMES = 15; // 0.5 sec at 30FPS
    parameter int MAX_BLINK_CYCLES    = 5;  // Total ON/OFF pairs (3 sec total)

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        ON,
        OFF
    } state_t;

    state_t state, next_state;

    // Counters
    logic [7:0] frame_counter = 0;
    logic [7:0] blink_cycle_counter = 0;

    assign shield_on = (state != IDLE); // Shield is on during blinking

    // FSM state transitions and counter logic
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            state               <= IDLE;
            frame_counter       <= 0;
            blink_cycle_counter <= 0;
        end else begin
            state <= next_state;

            if (startOfFrame) begin
                case (state)
                    IDLE: begin
                        frame_counter       <= 0;
                        blink_cycle_counter <= 0;
                        if (hit_signal) begin
                            frame_counter       <= 0;
                            blink_cycle_counter <= 0;
                        end
                    end

                    ON, OFF: begin
                        frame_counter <= frame_counter + 1;

                        if (frame_counter >= BLINK_PERIOD_FRAMES) begin
                            frame_counter <= 0;
                            blink_cycle_counter <= blink_cycle_counter + 1;
                        end
                    end
                endcase
            end
        end
    end

    // FSM next-state logic
    always_comb begin
        next_state = state;

        case (state)
            IDLE: begin
                if (hit_signal)
                    next_state = ON;
            end

            ON: begin
                if (frame_counter >= BLINK_PERIOD_FRAMES)
                    next_state = OFF;
            end

            OFF: begin
                if (frame_counter >= BLINK_PERIOD_FRAMES) begin
                    if (blink_cycle_counter >= MAX_BLINK_CYCLES - 1)
                        next_state = IDLE;
                    else
                        next_state = ON;
                end
            end
        endcase
    end

    // Output logic
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN)
            visible <= 0;
        else begin
            case (state)
                IDLE: visible <= draw_req;  // normal rendering
                ON:   visible <= draw_req ;         // visible during ON
                OFF:  visible <= 0;         // not visible during OFF
            endcase
        end
    end

endmodule
