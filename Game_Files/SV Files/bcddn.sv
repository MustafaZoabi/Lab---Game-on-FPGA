// (c) Technion IIT, Department of Electrical Engineering 2022 
// Written By Liat Schwartz August 2018 
// Updated by Mor Dahan - January 2022

// Implements a BCD down counter 99 down to 0 with several enable inputs and loadN data
// having countL, countH and tc outputs
// by instantiating two one bit down-counters


module bcddn
	(
	input  logic clk, 
	input  logic resetN, 
	input  logic loadN, 
	input  logic enable1, 
	input  logic enable2, 
	
	output logic [3:0] countL, 
	output logic [3:0] countH,
	output logic tc
   );

// Parameters defined as external, here with a default value - to be updated 
// in the upper hierarchy file with the actial bomb down counting values
// -----------------------------------------------------------
	parameter  logic [3:0] datainL = 4'h7 ; 
	parameter  logic [3:0] datainH = 4'h1 ;
// -----------------------------------------------------------
	
	logic  tclow, tchigh;// internal variables terminal count 
	
// Low counter instantiation
	down_counter lowc(.clk(clk), 
							.resetN(resetN),
							.loadN(loadN),	
							.enable1(enable1), 
							.enable2(enable2),
							.enable3(1'b1), 	
							.datain(datainL), 
							.count(countL), 
							.tc(tclow) );
	
// High counter instantiation
//--------------------------------------------------------------------------------------------------------------------
// &&&&&&&&&&&&&&  fill your code and paste to the report #2 
//--------------------------------------------------------------------------------------------------------------------			
 //  ## initializing a variable to enable compilation, change if needed 

//------------------------------------------------------------------------------------------ 
 	//  ## initializing a variable to enable compilation, change if needed 
 
 
 
 always_ff @(posedge clk or negedge resetN)
   begin
	      
      if ( !resetN )	begin// Asynchronic reset
			
			countH <= 4'd9;
			
		end
				
      else 	begin		// Synchronic logic	
		   tc = 1'b0;	

         if ( countH == 4'd0 && countL == 4'd0) begin
	
         tc =  1'b1; 

		  end
		
	     if(loadN == 1'b0)begin 
			   
				countH <= datainH;
			end
			
			else if(enable1 == 1'b1 && enable2 == 1'b1)begin 
			
			   if(countH == 0 && countL == 0)begin
	          
				    countH <= 5; 
			
		      end 
			
			   else begin
			       if(tclow == 1'b1)begin 	
			       countH <= countH - 4'd1; 
			   end
	      end
	   end
	end
	end


	

	
	// Asynchronic tc


 
 
 
 
 
 
 
 
 
 
 
//--------------------------------------------------------------------------------------------------------------------
// &&&&&&&&&&&&&&  end of paste to the report #2
//--------------------------------------------------------------------------------------------------------------------			

endmodule
