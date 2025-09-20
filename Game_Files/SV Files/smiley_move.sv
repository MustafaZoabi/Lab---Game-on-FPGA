// (c) Technion IIT, Department of Electrical Engineering 2025 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updated Eyal Lev April 2023
// updated to state machine Dudy March 2023 
// update the hit and collision algoritm - Eyal MAR 2024

module	smiley_move	(	
 
				input	 logic clk,
				input	 logic resetN,
				input	 logic startOfFrame,      //short pulse every start of frame 30Hz 
				input	 logic Y_direction_key_up,   //move Y Up 
      input  logic Y_direction_key_down, // move Y down 	
				input	 logic x_direction_key_right,      //move x right 
         input  logic x_direction_key_left, 		// move x left
				input  logic collision,         //collision if smiley hits an object
				input  logic [2:0] HitEdgeCode, 
				output logic signed 	[10:0] topLeftX, // output the top left corner 
				output logic signed	[10:0] topLeftY,  // can be negative , if the object is partliy outside 
				output logic [3:0] MoveFrameChar
				
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 280;
parameter int INITIAL_X_SPEED = 104;
parameter int INITIAL_Y_SPEED = 104;

const int MAX_Y_SPEED = 100;
const int	FIXED_POINT_MULTIPLIER = 64; // note it must be 2^n 

const int	OBJECT_WIDTH_X = 32;
const int	OBJECT_HIGHT_Y = 32;
const int	SafetyMargin   = 2;

const int	x_FRAME_LEFT	= (SafetyMargin)* FIXED_POINT_MULTIPLIER; 
const int	x_FRAME_RIGHT	= (639 - SafetyMargin - OBJECT_WIDTH_X)* FIXED_POINT_MULTIPLIER; 
const int	y_FRAME_TOP	= (SafetyMargin) * FIXED_POINT_MULTIPLIER;
const int	y_FRAME_BOTTOM	= (479 -SafetyMargin - OBJECT_HIGHT_Y ) * FIXED_POINT_MULTIPLIER; 

const logic [4:0] CORNER = 5'b10000; 
const logic [3:0] TOP = 4'b1000; 
const logic [3:0] RIGHT = 4'b0100; 
const logic [3:0] LEFT = 4'b0010; 
const logic [3:0] BOTTOM = 4'b0001; 


enum  logic [2:0] {IDLE_ST,
						 MOVE_ST,
						 START_OF_FRAME_ST,
						 POSITION_CHANGE_ST,
						 POSITION_LIMITS_ST,
						 PAUSE_ST
					}  SM_Motion ;

int Xspeed_right;
int Xspeed_left;
int Yspeed_up;   
int Yspeed_down;
int Xposition;
int Yposition;

logic toggle_x_key_D;
logic [4:0] hit_reg = 5'b00000;

logic [2:0] frame_tick_counter = 0;
logic [3:0] current_frame = 0;
logic [3:0] frame_base = 0;

always_ff @(posedge clk or negedge resetN)
begin : fsm_sync_proc

	if (resetN == 1'b0) begin 
		SM_Motion <= IDLE_ST ; 
		Xspeed_left <= 0   ; 
		Xspeed_right <= 0 ;
		Yspeed_down <= 0  ; 
		Yspeed_up <= 0;
		Xposition <= 0  ; 
		Yposition <= 0   ; 
		toggle_x_key_D <= 0 ;
		hit_reg <= 5'b0 ;	
		frame_tick_counter <= 0;
		current_frame <= 0;
		frame_base <= 0;
	end 	
	
	else begin
		toggle_x_key_D <= x_direction_key_right ;

		case(SM_Motion)
			IDLE_ST: begin
				Xspeed_right  <= 0 ;
			   Xspeed_left  <= 0 ; 
				Yspeed_up  <= 0  ; 
				Yspeed_down  <= 0  ; 
				Xposition <= INITIAL_X*FIXED_POINT_MULTIPLIER; 
				Yposition <= INITIAL_Y*FIXED_POINT_MULTIPLIER; 

				if (startOfFrame) 
					SM_Motion <= MOVE_ST ;
			end

			MOVE_ST:  begin
				if ((Y_direction_key_up) && (Y_direction_key_down == 0) && (x_direction_key_right ==0) && (x_direction_key_left == 0)) begin
					Yspeed_up <= INITIAL_Y_SPEED;
					frame_base <= 4;
				end else 
					Yspeed_up <= 0;	

				if ((Y_direction_key_up==0) && (Y_direction_key_down) && (x_direction_key_right ==0) && (x_direction_key_left == 0)) begin
					Yspeed_down <= -INITIAL_Y_SPEED;
					frame_base <= 12;
				end else 
					Yspeed_down <= 0;
				
				if ((Y_direction_key_up == 0) && (Y_direction_key_down == 0) && (x_direction_key_right) && (x_direction_key_left == 0)) begin
					Xspeed_right <= INITIAL_X_SPEED;
					frame_base <= 8;
				end else 
					 Xspeed_right <= 0 ;

				if ((Y_direction_key_up==0) && (Y_direction_key_down == 0) && (x_direction_key_right ==0) && (x_direction_key_left)) begin
					Xspeed_left <= -INITIAL_X_SPEED;
					frame_base <= 0;
				end else 
					Xspeed_left <= 0;

				if (collision) begin
					hit_reg[HitEdgeCode]<=1'b1;
				end

				if (startOfFrame) begin
					frame_tick_counter <= frame_tick_counter + 1;
					if (frame_tick_counter == 3'd6) begin
						frame_tick_counter <= 0;
						current_frame <= frame_base + ((current_frame - frame_base + 1) % 4);
						if(Xspeed_left == 0 && Xspeed_right == 0 && Yspeed_down ==0 && Yspeed_up == 0 )
						  current_frame <= frame_base ;
					end
					SM_Motion <= POSITION_CHANGE_ST ; 
				end
			end

			POSITION_CHANGE_ST : begin
				Xposition <= Xposition + Xspeed_right + Xspeed_left ; 
				Yposition <= Yposition + Yspeed_up + Yspeed_down ;
				SM_Motion <= POSITION_LIMITS_ST ; 
			end

			POSITION_LIMITS_ST : begin
				if (Xposition < x_FRAME_LEFT) 
						Xposition <= x_FRAME_LEFT ; 
				if (Xposition > x_FRAME_RIGHT)
						Xposition <= x_FRAME_RIGHT ; 
				if (Yposition < y_FRAME_TOP) 
						Yposition <= y_FRAME_TOP ; 
				if (Yposition > y_FRAME_BOTTOM) 
						Yposition <= y_FRAME_BOTTOM ; 
				SM_Motion <= MOVE_ST ; 
			end
		endcase
	end
end

assign 	topLeftX = Xposition / FIXED_POINT_MULTIPLIER ;   
assign 	topLeftY = Yposition / FIXED_POINT_MULTIPLIER ;

assign MoveFrameChar = current_frame;

endmodule
