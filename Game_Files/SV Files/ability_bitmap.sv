



module	ability_bitmap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 4;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 4;  // 2^6 = 64 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;


// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1][0:OBJECT_WIDTH_X-1][7:0] object_colors = {
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hdb, 8'hb7, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h49, 8'h4e, 8'h6e, 8'h6e, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h2e, 8'h33, 8'hdf, 8'hfb, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h72, 8'h2e, 8'h53, 8'hdb, 8'hdb, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h96, 8'h72, 8'hff, 8'h53, 8'h72, 8'hb6, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hdb, 8'h4d, 8'hb6, 8'h53, 8'h72, 8'hdb, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hb7, 8'h49, 8'h4d, 8'hb7, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
};




//////////--------------------------------------------------------------------------------------------------------------=
 

 
 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'hff;

	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  

		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket 
		   RGBout <= object_colors[offsetY][offsetX];

		
		end  	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule  