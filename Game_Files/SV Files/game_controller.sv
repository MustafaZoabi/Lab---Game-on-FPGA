// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic num_1_pressed,
			input logic num_2_pressed,
			input logic loading_complete,
			input logic coin_req,
			input logic lightning_req,
			input logic character_req,
			input logic car_req,
			input logic fire_req,
			input logic boss_req,
			input logic shield_on,
			input logic game_ended,
			

//---------------------#1-add input drawing request of box/number
		
		
		

//---------------------#1-end input drawing request of box/number




//---------------------#2-add  drawing request of hart

		//	input	logic	drawing_request_hart,

//---------------------#2-end drawing request of hart		
 			output logic SingleHitPulse ,// critical code, generating A single pulse in a frame 
		   output logic coin_collected,
			output logic power_collected,
			output logic	[1:0] page_number,
			output logic    character_picker,
			output logic next_signal
			
			
			

//---------------------#3-add collision  smiley and hart   -------------------------------------


		//	output logic collision_Smiley_Hart // active in case of collision between Smiley and hart


//---------------------#3-end collision  smiley and hart	--------------------------------------
			


);

// drawing_request_smiley   -->  smiley
// drawing_request_boarders -->  brackets
// drawing_request_number   -->  number/box 



logic flag ; // a semaphore to set the output only once per frame regardless of number of collisions 
logic flag_coin;
logic flag_lightning;

logic collision;
logic collision_coin;
logic collision_power;


typedef enum logic [3:0] {
    PAGE1_ST,
    LOADING_ST,
    MAIN_sCREEN,
    WAIT_ST,
    DONE_ST       // <-- New state
} page_state_t;

page_state_t SM_PAGES;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
			page_number <= 2'b0 ; // default 
			character_picker<= 0;
			next_signal <= 0;
			SM_PAGES <= PAGE1_ST;
			next_signal <= 0;
			flag	<= 1'b0;
			flag_coin <= 1'b0;
			flag_lightning <= 1'b0;
		   SingleHitPulse <= 1'b0 ; 
			coin_collected <= 1'b0 ; 
			power_collected <= 1'b0;
			
		

		
	end 
	else begin 
	
//-------------------------- #7-add colision between Smiley and number-----------------

case(SM_PAGES)

//-------------------------- #7-end colision between Smiley and number-----------------	
		
		PAGE1_ST: begin
			page_number <= 2'b0 ; // default
			character_picker<= 0;
         //SM_PAGES <= MAIN_sCREEN; //remove later ***********
			if(startOfFrame)begin
		      
				if(num_1_pressed)begin
			     SM_PAGES <= WAIT_ST;
				  character_picker <= 0;
				  next_signal <= 1;
				  page_number <= 2'b01 ;

				  end
				  
				else if(num_2_pressed)begin
				  SM_PAGES <= WAIT_ST;
				  character_picker <= 1;
				  next_signal <= 1;
				  page_number <= 2'b01 ;


				  end
				  
			end
		end
	
     WAIT_ST:begin
	  
	      next_signal <= 0;
			if(startOfFrame)begin
			
				if(page_number == 1)
				   SM_PAGES <= LOADING_ST;
				else 
				   SM_PAGES <= MAIN_sCREEN;
		end
		
	
		end
		
	 LOADING_ST:begin 
			page_number <= 2'b01 ;
			if(startOfFrame)begin
		      if(loading_complete)
			     SM_PAGES <= WAIT_ST;
				  next_signal <= 1;
				  page_number <= 2'b10 ;


			end
		end
		
   MAIN_sCREEN:begin 
			page_number <= 2'b10 ;
			SingleHitPulse <= 1'b0 ; // default 
			coin_collected <= 1'b0 ; 
			power_collected <= 1'b0;
			if(startOfFrame) 
				flag	<= 1'b0;
			   flag_coin <= 1'b0;
			   flag_lightning <= 1'b0;
				
//	---#7 - change the condition below to collision between Smiley and number ---------

         if ( collision  && (flag == 1'b0)) begin 
			     flag	<= 1'b1; // to enter only once 
			     SingleHitPulse <= 1'b1 ; 
		        end ; 
			if ( collision_coin && (flag_coin == 1'b0))begin
			     flag_coin	<= 1'b1; // to enter only once 
			     coin_collected <= 1'b1 ; 
		        end ;
			if ( collision_power && (flag_lightning == 1'b0))begin
			     flag_lightning	<= 1'b1; // to enter only once 
			     power_collected <= 1'b1 ; 
		        end ; 
		   if(game_ended)begin
		    	page_number <= 2'b11;
			   SM_PAGES <=DONE_ST ;end

			     

	  end
      	
	DONE_ST : begin 
           page_number <= 2'b11;
			 end 
endcase
end
         
end


assign collision_coin = (character_req && coin_req ); 
assign collision_power = (character_req && lightning_req);
assign collision = ((character_req && car_req || character_req && fire_req || character_req && boss_req)&&( !shield_on));

endmodule



