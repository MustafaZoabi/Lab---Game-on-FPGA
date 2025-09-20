module reset_controller (
    input  logic clk,
    input  logic resetN,         // Active-low global reset
    input  logic start_signal,   // Active-high 1-cycle pulse
    output logic safe_resetN     // Active-low system reset
);
    parameter int STRETCH_CYCLES = 3;

    logic [1:0] counter;
    logic start_d, start_rise;

    // Detect rising edge of start_signal
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN)
            start_d <= 0;
        else
            start_d <= start_signal;
    end

    assign start_rise = start_signal & ~start_d;

    // Counter logic to stretch reset
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN)
            counter <= 0;
        else if (start_rise)
            counter <= STRETCH_CYCLES;
        else if (counter != 0)
            counter <= counter - 1;
    end

    // Reset stays active (low) during global reset OR stretch period
    assign safe_resetN = resetN & (counter == 0);

endmodule
