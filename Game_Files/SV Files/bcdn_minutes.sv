module bcddn_minutes
   
(
    input  logic clk,
    input  logic resetN,
    input  logic loadN,
    input  logic enable1,
    input  logic enable2,

    output logic [3:0] countL,   // Seconds: ones
    output logic [3:0] countH,   // Seconds: tens
    output logic [3:0] countM,   // Minutes
    output logic tc              // Terminal count signal
);

    logic sec_tc;  // terminal count from seconds (bcddn)
	 parameter logic [3:0] datainL = 4'h9;   // Seconds: ones
    parameter logic [3:0] datainH = 4'h9;   // Seconds: tens
    parameter logic [3:0] datainM = 4'h5;   // Minutes


    // Instantiate the seconds countdown module (99 to 00)
   bcddn #(
        .datainL(datainL),
        .datainH(datainH)
    ) seconds_counter (
        .clk(clk),
        .resetN(resetN),
        .loadN(loadN),
        .enable1(enable1),
        .enable2(enable2),
        .countL(countL),
        .countH(countH),
        .tc(sec_tc)
    );

    // Minutes counter
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            countM <= 4'd0;
        end
        else if (loadN == 1'b0) begin
            countM <= datainM;
        end
        else if (enable1 && enable2 && sec_tc) begin
            if (countM > 0) begin
                countM <= countM - 4'd1;
            end
        end
    end

    // Terminal count output (00:00)
    assign tc = (countM == 0 && countH == 0 && countL == 0);

endmodule
