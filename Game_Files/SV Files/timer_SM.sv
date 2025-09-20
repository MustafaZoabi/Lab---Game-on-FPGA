// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 
// Updated September 2020 Dudy.
// Updated by Mor Dahan - January 2022
// Updated by Aviad Etzion - October 2023
// 
// Implements the state machine of the bomb mini-project

module bomb
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 
	input logic waitN, 
	input logic OneSecPulse, 
	input logic timerEnd,
	
	output logic countLoadN, 
	output logic countEnable, 
	output logic lampEnable,
	output logic lamptestEnable
   );

//-------------------------------------------------------------------------------------------

// state machine declaration 
   enum logic [3:0] {s_idle, s_arm, s_run, s_pause, s_lampOff, s_lampOn, s_delay} SMbomb;
	logic [2:0] timer;

 	
//--------------------------------------------------------------------------------------------
//  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
		SMbomb <= s_idle;
		countLoadN <= 1'b1;
		countEnable <= 1'b0;
		lampEnable  <= 1'b0;
		timer <= 3'b000;
		lamptestEnable <= 1'b0;


		end 

   
	else 		// Synchronic logic FSM
		begin
		// default outputs 
		countLoadN <= 1'b1;
		countEnable <= 1'b1;
		lampEnable  <= 1'b1; 
		lamptestEnable <= 1'b0; // added

		
		
	case (SMbomb) // logically defining what is the next state, and the ouptput
		
			//Note: the implementation of the idle state is already given you as an example
//      ======		
			s_idle: begin
//      ======		
				if (startN == 1'b1) 
					SMbomb <= s_arm; 
			end // idle
//--------------------------------------------------------------------------------------------------------------------
// &&&&&&&&&&&&&&  fill your code and paste to the report #1 
//--------------------------------------------------------------------------------------------------------------------			
			s_arm: begin
//      ======		
				   
					SMbomb <= s_run;
				   countEnable <= 0;
					countLoadN <= 1'b0;	
			end // idle	
		 
		   s_run: begin
//      ======	
            countEnable <= 1;

				if (waitN == 1'b0)begin 
					SMbomb <= s_pause; 
					countEnable <= 1'b0;
            end 
				if(timerEnd == 1'b1 )begin 
					 SMbomb <= s_lampOff;
					 countEnable <= 1'b0;

				end
				   	
			end 
		
	
         s_pause: begin
//      ======		
				if (waitN == 1'b1)begin
					SMbomb <= s_delay; 
					//countEnable <= 1'b1; 
			end 
			end
		
	
         s_lampOff: begin
//      ======	
               lampEnable <= 0;
             	if(OneSecPulse)begin
					   SMbomb <= s_lampOn;
					   lampEnable <= 1;

         
			end		
			end 
	
         s_lampOn: begin
//      ======	
               lamptestEnable <= 1'b1; // shows 88
	            if(OneSecPulse)begin
					   SMbomb <= s_lampOff;
			         lampEnable <= 0;
	
			end
			end
			
			s_delay: begin 
			
			      if(OneSecPulse)begin 
					   timer <= timer + 'b1;
						if (timer == 3'b111)begin
					      countEnable <= 1'b1;
						   SMbomb <= s_run;
							timer <= 3'b000;
				   end
					end
			end
			
			      

//--------------------------------------------------------------------------------------------------------------------
// &&&&&&&&&&&&&&  end of paste SM to the report #1 
//--------------------------------------------------------------------------------------------------------------------			

//  		  =========		
			  default : begin   
//         =========			
					SMbomb <= s_idle;  
			 end // default
			 
			 
			  
						
		endcase
	end //else
		
	end // always sync
	
		
endmodule
