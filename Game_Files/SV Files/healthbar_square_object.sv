


module	healthbar_square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,//  current VGA pixel 
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] topLeftX, //position on the screen 
					input 	logic	signed [10:0] topLeftY,   // can be negative , if the object is partliy outside
				   input    logic singlehit,	
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout, //optional color output for mux 
					output   logic start_fire,
					output   logic game_over
);

parameter  int OBJECT_WIDTH_X = 64;
parameter  int OBJECT_HEIGHT_Y = 64;
parameter  logic [7:0] OBJECT_COLOR = 8'h00 ;
parameter  logic [7:0] BAR_COLOR = 8'h1c ; 
 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 
logic insidebar;
parameter int BAR_MARGIN = 2;
logic signed [10:0] health_change;

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // math is made with SIGNED variables  
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; // as the top left position can be negative
	
assign	insidebar  = 	 ( (pixelX  >= topLeftX + BAR_MARGIN ) &&  (pixelX < rightX - health_change) // math is made with SIGNED variables  
						   && (pixelY  >= topLeftY + BAR_MARGIN) &&  (pixelY < bottomY - BAR_MARGIN) )  ; // as the top left position can be negative
		
assign game_over = (topLeftX >= (rightX - health_change)) ;


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
		health_change <= 10'h2;
		start_fire <= 1'b0;
	end
	else begin 
		// DEFUALT outputs
		   if (singlehit)
				 if(health_change < 128 )
				 	health_change <= health_change + 15; // You can adjust how much is lost per hit 

	      RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
			start_fire <= health_change >= 10'h30 ? 1'b1 : 1'b0;

	
 
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number 
			offsetY	<= (pixelY - topLeftY);
		end
	   
	   if(insidebar)
	   begin 
		   RGBout  <= BAR_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number 
			offsetY	<= (pixelY - topLeftY);
	      	
		end

		
	end
end 
endmodule 