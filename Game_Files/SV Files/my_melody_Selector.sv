//
// Game Sound Controller Module with FSM
module my_melody_selector (
    input  logic clk,
    input  logic resetN,

    // Game event inputs
    input  logic Collision_Win,         // Win event trigger
    input  logic Collision_Lose,        // Lose event trigger  
    input  logic Collision_Coin,        // Coin collection event trigger

    // Outputs to melody player
    output logic startMelody,           // Single-cycle melody trigger
    output logic [3:0] melodySelect     // Selected melody number
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        WAIT = 2'b01
    } state_t;

    state_t curr_state, next_state;

    // Sequential Logic (State Register)
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN)
            curr_state <= IDLE;
        else
            curr_state <= next_state;

    // Combinational Logic (Next State Logic + Output Logic)
        // Defaults
        startMelody  = 1'b0;
        next_state   = curr_state;

        case (curr_state)
            IDLE: begin
                if (Collision_Win) begin
                    melodySelect = 4'd8;
                    startMelody  = 1'b1;
                    next_state   = WAIT;
                end else if (Collision_Lose) begin
                    melodySelect = 4'd6;
                    startMelody  = 1'b1;
                    next_state   = WAIT;
                end else if (Collision_Coin) begin
                    melodySelect = 4'd5;
						  startMelody  = 1'b1;

               
                end
            end

            WAIT: begin
                // Stay in WAIT, suppress melody output
                startMelody  = 1'b0;
                // Optional: you could latch a default melody or hold previous
                melodySelect = melodySelect; // Hold previous value
            end

            default: begin
                next_state   = IDLE;
                startMelody  = 1'b0;
                melodySelect = 4'd0;
            end
        endcase
    end

endmodule
