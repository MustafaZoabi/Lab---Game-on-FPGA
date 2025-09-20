module fire_move (
    input  logic         clk,
    input  logic         resetN,
    input  logic         follow_signal,  // Pulse: 1 clock cycle every 10 seconds
    input  logic         startOfFrame,   // frame tick (e.g. 30Hz)
    
    output logic signed [10:0] topLeftX,
    output logic signed [10:0] topLeftY
);

 parameter int OBJECT_WIDTH_X = 32;
    parameter int OBJECT_HEIGHT_Y = 32;


    parameter int INITIAL_X = 639;        // Dog starts off-screen right
    parameter int INITIAL_Y = 280;


    // Internal variables
    int currentX;
    int currentY;
   
    logic start = 0 ;
    typedef enum logic  {PAUSE, FOLLOW } state_t;
    state_t state;

    // Clamp helper

    // Main FSM
    always_ff @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            currentX   <= INITIAL_X;
            currentY   <= INITIAL_Y;
            state      <= PAUSE;
				start <= 0;
        end else begin

            // Detect when character reaches center
            if (follow_signal)
                start <= 1;

            if (startOfFrame)begin
                        if (start) 
                            state <= FOLLOW; 
         
            if(state == FOLLOW)
               currentX <= currentX - 1;end				
            // Handle follow_signal to toggle between PAUSE and FOLLOW
     end
	  end
    assign topLeftX = currentX;
    assign topLeftY = currentY;

endmodule
