



module	male_character_bitmap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
               input logic [3:0] NumOfFrame,
					input logic character_picker,
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^6 = 64 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;


// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [15:0][0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1][7:0] object_colors = {
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h49, 8'h49, 8'h49, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h4d, 8'h97, 8'h92, 8'h97, 8'h72, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h49, 8'h6e, 8'h96, 8'h72, 8'h49, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h20, 8'h24, 8'h25, 8'h29, 8'h25, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h00, 8'h24, 8'h49, 8'h24, 8'h24, 8'h24, 8'h49, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h49, 8'h49, 8'h24, 8'h4d, 8'h72, 8'h6e, 8'h6e, 8'h6e, 8'h20, 8'h49, 8'h29, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h4e, 8'h4d, 8'h29, 8'h24, 8'h20, 8'h29, 8'h49, 8'h49, 8'h24, 8'h00, 8'h25, 8'h49, 8'h72, 8'h25, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h29, 8'h49, 8'h00, 8'h00, 8'h24, 8'h20, 8'h20, 8'h20, 8'h24, 8'h24, 8'h00, 8'h25, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h20, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h4e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h20, 8'h24, 8'h00, 8'h00, 8'h20, 8'h00, 8'h6e, 8'hbb, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h49, 8'h4d, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h25, 8'h24, 8'h24, 8'h04, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h00, 8'h05, 8'h29, 8'h49, 8'h49, 8'h25, 8'h00, 8'h25, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h29, 8'h49, 8'h49, 8'h24, 8'h00, 8'h25, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h29, 8'h24, 8'h24, 8'h24, 8'h20, 8'h00, 8'h25, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h49, 8'h49, 8'h49, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h25, 8'h25, 8'h72, 8'h72, 8'h6e, 8'h6e, 8'h25, 8'h01, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h72, 8'h49, 8'h00, 8'h00, 8'h00, 8'h25, 8'h05, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h6e, 8'h6e, 8'h49, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h29, 8'h6e, 8'h4d, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h29, 8'h29, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h4d, 8'h92, 8'h4e, 8'h92, 8'h72, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h49, 8'h92, 8'hb7, 8'h97, 8'h4d, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h25, 8'h49, 8'h49, 8'h29, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h49, 8'h24, 8'h4e, 8'h4e, 8'h4e, 8'h4e, 8'h6e, 8'h24, 8'h29, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h4e, 8'h4d, 8'h49, 8'h00, 8'h24, 8'h4d, 8'h4e, 8'h4e, 8'h49, 8'h00, 8'h29, 8'h49, 8'h4e, 8'h25, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h49, 8'h00, 8'h00, 8'h24, 8'h20, 8'h20, 8'h20, 8'h24, 8'h24, 8'h00, 8'h29, 8'h4d, 8'h04, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h96, 8'hb7, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h72, 8'hb7, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h6d, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h49, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h20, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h25, 8'h00, 8'h00, 8'h25, 8'h29, 8'h49, 8'h49, 8'h25, 8'h25, 8'h00, 8'h24, 8'h49, 8'h24, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h49, 8'h00, 8'h00, 8'h25, 8'h4e, 8'h72, 8'h4e, 8'h25, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h20, 8'h00, 8'h20, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h49, 8'h6e, 8'h6e, 8'h72, 8'h4d, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h4e, 8'h72, 8'h25, 8'h00, 8'h00, 8'h6e, 8'h6e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h24, 8'h29, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h20, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h20, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h25, 8'h00, 8'h20, 8'h4d, 8'h6e, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h92, 8'h49, 8'h00, 8'h24, 8'h92, 8'h6e, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h49, 8'h49, 8'h49, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h4d, 8'h97, 8'h92, 8'h97, 8'h72, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h49, 8'h6e, 8'h96, 8'h72, 8'h49, 8'h25, 8'h20, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h20, 8'h20, 8'h24, 8'h49, 8'h25, 8'h25, 8'h24, 8'h49, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h49, 8'h49, 8'h24, 8'h4d, 8'h72, 8'h72, 8'h6e, 8'h6e, 8'h24, 8'h49, 8'h29, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h4e, 8'h4e, 8'h49, 8'h20, 8'h24, 8'h29, 8'h49, 8'h49, 8'h25, 8'h00, 8'h25, 8'h49, 8'h6e, 8'h25, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h49, 8'h00, 8'h00, 8'h24, 8'h20, 8'h20, 8'h20, 8'h24, 8'h24, 8'h00, 8'h25, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h20, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h6e, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h25, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'hb7, 8'h97, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'h20, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h4d, 8'h25, 8'h24, 8'h24, 8'h24, 8'h24, 8'h20, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h20, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h25, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h04, 8'h05, 8'h4e, 8'h6e, 8'h49, 8'h05, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h29, 8'h04, 8'h00, 8'h49, 8'h4d, 8'h49, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'h24, 8'h24, 8'h24, 8'h29, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h49, 8'h49, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h05, 8'h05, 8'h4e, 8'h6e, 8'h4e, 8'h72, 8'h49, 8'h24, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h05, 8'h25, 8'h24, 8'h00, 8'h00, 8'h24, 8'h92, 8'h6e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h49, 8'h72, 8'h24, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h25, 8'h92, 8'h6e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h29, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h4d, 8'h96, 8'h6e, 8'h72, 8'h72, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h49, 8'h72, 8'hb7, 8'h97, 8'h4d, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h25, 8'h29, 8'h49, 8'h49, 8'h29, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h49, 8'h24, 8'h4d, 8'h4e, 8'h4e, 8'h49, 8'h6e, 8'h24, 8'h29, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h4e, 8'h4d, 8'h49, 8'h20, 8'h24, 8'h4d, 8'h4e, 8'h4e, 8'h49, 8'h00, 8'h29, 8'h49, 8'h4e, 8'h25, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h49, 8'h00, 8'h00, 8'h24, 8'h20, 8'h20, 8'h20, 8'h24, 8'h24, 8'h00, 8'h25, 8'h4d, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h92, 8'h97, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h72, 8'hb7, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h4d, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'h49, 8'h49, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h20, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h29, 8'h25, 8'h00, 8'h00, 8'h25, 8'h49, 8'h49, 8'h29, 8'h25, 8'h25, 8'h00, 8'h24, 8'h49, 8'h24, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h49, 8'h00, 8'h00, 8'h25, 8'h4e, 8'h72, 8'h4e, 8'h25, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h49, 8'h6e, 8'h72, 8'h92, 8'h4d, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h4d, 8'h72, 8'h25, 8'h00, 8'h24, 8'h6e, 8'h6e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h20, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h45, 8'h00, 8'h00, 8'h4d, 8'h6e, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h92, 8'h49, 8'h00, 8'h24, 8'h92, 8'h72, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h4d, 8'h49, 8'h29, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h72, 8'h6e, 8'h4e, 8'h25, 8'h49, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h49, 8'h92, 8'hbb, 8'hb7, 8'h49, 8'h6d, 8'h49, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h20, 8'h25, 8'h25, 8'h6e, 8'h4d, 8'h29, 8'h20, 8'h29, 8'h6d, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h00, 8'h20, 8'h49, 8'h6e, 8'h6e, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h4e, 8'h25, 8'h24, 8'h24, 8'h24, 8'h00, 8'h6e, 8'h96, 8'h6e, 8'h4e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h49, 8'h72, 8'h4d, 8'h24, 8'h00, 8'h00, 8'h00, 8'h25, 8'hb7, 8'h96, 8'h72, 8'h29, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h20, 8'h25, 8'h96, 8'h72, 8'h25, 8'h24, 8'h00, 8'h24, 8'h20, 8'h20, 8'h72, 8'hdb, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h4d, 8'h6e, 8'h4d, 8'h24, 8'h00, 8'h24, 8'h64, 8'h64, 8'h24, 8'h49, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'h6e, 8'h6e, 8'h44, 8'h88, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h25, 8'h25, 8'h92, 8'h72, 8'h8d, 8'h64, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'hb2, 8'hb2, 8'h89, 8'h40, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h72, 8'h4d, 8'h24, 8'h00, 8'h00, 8'h69, 8'had, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h72, 8'h97, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h29, 8'h24, 8'h00, 8'h00, 8'h00, 8'h25, 8'h92, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h29, 8'h00, 8'h00, 8'h29, 8'h25, 8'h24, 8'h4e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h24, 8'h29, 8'h2a, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h24, 8'h29, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h24, 8'h49, 8'h29, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h72, 8'h96, 8'h4d, 8'h20, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h29, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h24, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h49, 8'h72, 8'h6e, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h72, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h04, 8'h4d, 8'h6d, 8'h4d, 8'h29, 8'h25, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h97, 8'h97, 8'h96, 8'h29, 8'h4d, 8'h49, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h92, 8'h72, 8'h29, 8'h25, 8'h25, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h00, 8'h24, 8'h25, 8'h6e, 8'h6e, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h25, 8'h24, 8'h00, 8'h6e, 8'h92, 8'h6e, 8'h4d, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h49, 8'h24, 8'h20, 8'h20, 8'h00, 8'h49, 8'hdb, 8'h92, 8'h49, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h49, 8'h92, 8'h6e, 8'h24, 8'h00, 8'h00, 8'h24, 8'h20, 8'h29, 8'h97, 8'hbb, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h25, 8'h72, 8'h92, 8'h49, 8'h24, 8'h00, 8'h24, 8'h88, 8'h40, 8'h24, 8'h92, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h29, 8'h49, 8'h20, 8'h00, 8'h49, 8'h49, 8'h64, 8'h89, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h24, 8'h24, 8'h25, 8'h72, 8'h72, 8'hb1, 8'h88, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h49, 8'hb2, 8'hd6, 8'hd1, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'had, 8'hf5, 8'h88, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h24, 8'h92, 8'h6d, 8'h24, 8'h00, 8'h24, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h4d, 8'hb7, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h6e, 8'h25, 8'h00, 8'h00, 8'h00, 8'h49, 8'h4e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h00, 8'h04, 8'h24, 8'h00, 8'h4d, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h29, 8'h29, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h25, 8'h29, 8'h29, 8'h24, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h24, 8'h04, 8'h24, 8'h49, 8'h29, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h29, 8'h4e, 8'h6e, 8'h6e, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h6d, 8'h4e, 8'h4e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h72, 8'h72, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h4d, 8'h4d, 8'h29, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h72, 8'h6e, 8'h4e, 8'h25, 8'h49, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h29, 8'h92, 8'hb7, 8'hb7, 8'h49, 8'h6e, 8'h49, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h6e, 8'h49, 8'h49, 8'h24, 8'h29, 8'h6d, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h00, 8'h24, 8'h49, 8'h6e, 8'h6e, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h49, 8'h25, 8'h24, 8'h24, 8'h24, 8'h00, 8'h6e, 8'h97, 8'h6e, 8'h4e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h49, 8'h72, 8'h4d, 8'h24, 8'h00, 8'h00, 8'h00, 8'h25, 8'hb7, 8'h96, 8'h6e, 8'h29, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h29, 8'h96, 8'h72, 8'h24, 8'h24, 8'h00, 8'h24, 8'h24, 8'h20, 8'h72, 8'hdb, 8'h6d, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h6d, 8'h4d, 8'h24, 8'h00, 8'h24, 8'h64, 8'h64, 8'h24, 8'h49, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'h6e, 8'h6e, 8'h64, 8'h88, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h29, 8'h25, 8'h92, 8'h72, 8'h8d, 8'h64, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'hb2, 8'hb6, 8'h89, 8'h40, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h69, 8'h8d, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h29, 8'hb7, 8'h93, 8'h04, 8'h00, 8'h20, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h4d, 8'h4d, 8'h00, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h6d, 8'h6e, 8'h00, 8'h25, 8'h92, 8'h6e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h6e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h24, 8'h00, 8'h24, 8'h24, 8'h25, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h6e, 8'h92, 8'h93, 8'h4e, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h4e, 8'h49, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h4e, 8'h4d, 8'h49, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h72, 8'h72, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h29, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h04, 8'h4d, 8'h6d, 8'h6d, 8'h29, 8'h25, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h97, 8'h97, 8'h96, 8'h29, 8'h4d, 8'h49, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h24, 8'h49, 8'h92, 8'h72, 8'h49, 8'h25, 8'h25, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h00, 8'h24, 8'h24, 8'h4d, 8'h6e, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h24, 8'h24, 8'h24, 8'h25, 8'h24, 8'h00, 8'h6e, 8'h92, 8'h6e, 8'h4d, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h49, 8'h24, 8'h24, 8'h24, 8'h00, 8'h49, 8'hbb, 8'h92, 8'h49, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h49, 8'h92, 8'h6e, 8'h24, 8'h00, 8'h00, 8'h24, 8'h20, 8'h49, 8'h96, 8'hbb, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h24, 8'h72, 8'h72, 8'h49, 8'h24, 8'h00, 8'h24, 8'h88, 8'h40, 8'h24, 8'h92, 8'h49, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h29, 8'h29, 8'h00, 8'h00, 8'h49, 8'h49, 8'h64, 8'h69, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h24, 8'h24, 8'h24, 8'h72, 8'h72, 8'hb1, 8'h88, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h49, 8'hb2, 8'hd6, 8'had, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'had, 8'hf5, 8'h64, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h92, 8'h6d, 8'h24, 8'h00, 8'h24, 8'h44, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h24, 8'h6e, 8'h96, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h6e, 8'h25, 8'h00, 8'h00, 8'h00, 8'h49, 8'h4e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h00, 8'h00, 8'h24, 8'h00, 8'h49, 8'h4a, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h29, 8'h29, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h25, 8'h29, 8'h29, 8'h25, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'h00, 8'h25, 8'h24, 8'h24, 8'h49, 8'h29, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'h00, 8'h29, 8'h4e, 8'h6e, 8'h6e, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h6e, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h6d, 8'h6e, 8'h4d, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h92, 8'h92, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h49, 8'h49, 8'h49, 8'h49, 8'h20, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h25, 8'h92, 8'hbb, 8'h97, 8'h4e, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h49, 8'h49, 8'h00, 8'h49, 8'h4d, 8'h25, 8'h20, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h25, 8'h00, 8'h49, 8'h96, 8'h6e, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h25, 8'h24, 8'h29, 8'h6e, 8'h72, 8'h6e, 8'h4d, 8'h24, 8'h49, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h25, 8'h25, 8'h00, 8'h6e, 8'h97, 8'h4d, 8'h92, 8'h96, 8'h20, 8'h49, 8'h29, 8'h29, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h24, 8'h00, 8'h00, 8'h29, 8'hb7, 8'hdf, 8'hdf, 8'h4d, 8'h00, 8'h00, 8'h24, 8'h29, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h20, 8'h25, 8'h00, 8'h00, 8'h00, 8'h49, 8'hb2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h72, 8'h25, 8'h44, 8'h25, 8'h72, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h04, 8'h25, 8'h49, 8'h96, 8'h6e, 8'hd1, 8'h8d, 8'h76, 8'h49, 8'h49, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'h05, 8'h0e, 8'h0e, 8'h0e, 8'h0e},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h24, 8'h44, 8'hd1, 8'hfa, 8'hf6, 8'h69, 8'h24, 8'h6e, 8'h49, 8'h00, 8'hff, 8'h00, 8'h05, 8'h2a, 8'h53, 8'h37, 8'h3b, 8'h3f, 8'h1b, 8'h1b},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h88, 8'h69, 8'h00, 8'h49, 8'h97, 8'h49, 8'h00, 8'h2a, 8'h13, 8'h37, 8'h5b, 8'h1b, 8'h7f, 8'h7f, 8'h5b, 8'h37, 8'h2f},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h05, 8'h0e, 8'h1b, 8'h7f, 8'h9f, 8'h5f, 8'h1b, 8'h0f, 8'h2a, 8'h0a, 8'h05, 8'h00},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h20, 8'h05, 8'h12, 8'h1b, 8'h7f, 8'h9f, 8'h5b, 8'h57, 8'h33, 8'h0e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h29, 8'h6d, 8'h49, 8'h24, 8'h17, 8'h3f, 8'h7b, 8'h9b, 8'h97, 8'h0a, 8'h05, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h96, 8'h72, 8'h92, 8'h4d, 8'h13, 8'h53, 8'h0f, 8'h09, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h6d, 8'h6e, 8'h6e, 8'h29, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h49, 8'h00, 8'h29, 8'h29, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h29, 8'h4e, 8'h00, 8'h05, 8'h29, 8'h49, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h4d, 8'h92, 8'h49, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h49, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h20, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h6e, 8'h72, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h04, 8'h49, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h29, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h25, 8'h72, 8'hb7, 8'h92, 8'h4d, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h49, 8'h6e, 8'h49, 8'h4d, 8'h4e, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'h25, 8'h24, 8'h25, 8'h4d, 8'h49, 8'h24, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'h00, 8'hff, 8'h29, 8'h13, 8'h05, 8'hff, 8'h00, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h20, 8'h24, 8'h25, 8'h6e, 8'h96, 8'h72, 8'h49, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h13, 8'h1b, 8'h05, 8'hff, 8'h00, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h49, 8'h24, 8'h72, 8'h72, 8'h49, 8'h6e, 8'h72, 8'h24, 8'h49, 8'h25, 8'h25, 8'h00, 8'hff, 8'h05, 8'h17, 8'h1b, 8'h05, 8'hff, 8'h00, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h25, 8'h00, 8'h00, 8'h4d, 8'hbb, 8'hb7, 8'hdb, 8'h92, 8'h00, 8'h00, 8'h24, 8'h29, 8'h00, 8'h05, 8'h17, 8'h1f, 8'h1b, 8'h05, 8'hff, 8'h00, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h49, 8'hdb, 8'h92, 8'h24, 8'h00, 8'h00, 8'h25, 8'h24, 8'h00, 8'h12, 8'h1f, 8'h5f, 8'h33, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff},
{8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h6d, 8'h25, 8'h68, 8'h44, 8'h6e, 8'h25, 8'h00, 8'h04, 8'h00, 8'h05, 8'h1b, 8'h7f, 8'h57, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h97, 8'h4d, 8'hcd, 8'h69, 8'h97, 8'h49, 8'h24, 8'h20, 8'h05, 8'h37, 8'h9f, 8'hbf, 8'h2a, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff},
{8'h05, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h24, 8'h24, 8'h6d, 8'hd1, 8'hfa, 8'hf6, 8'h8d, 8'h25, 8'h72, 8'h2a, 8'h17, 8'h9f, 8'hbf, 8'h52, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff},
{8'h0f, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h72, 8'h96, 8'h29, 8'h20, 8'h8d, 8'hb1, 8'had, 8'h24, 8'h00, 8'h25, 8'h0e, 8'h9f, 8'hdf, 8'h37, 8'h05, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h25, 8'h6e, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h12, 8'h5f, 8'hbf, 8'h33, 8'h05, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'h00, 8'h0e, 8'h1f, 8'h7b, 8'h2e, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h24, 8'h49, 8'h00, 8'h00, 8'h00, 8'h24, 8'h49, 8'h29, 8'h00, 8'h13, 8'h17, 8'h2a, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h49, 8'h24, 8'h00, 8'h25, 8'h93, 8'h97, 8'h97, 8'h49, 8'h29, 8'h05, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h20, 8'h24, 8'h00, 8'h00, 8'h29, 8'h6e, 8'h4e, 8'h6e, 8'h4e, 8'h25, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h29, 8'h2a, 8'h24, 8'h29, 8'h29, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h49, 8'h4e, 8'h00, 8'h29, 8'h4e, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h25, 8'h6e, 8'h72, 8'h25, 8'h00, 8'h00, 8'h6e, 8'h72, 8'h6e, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h25, 8'h00, 8'h00, 8'h00, 8'h20, 8'h4d, 8'h24, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h49, 8'h4e, 8'h25, 8'h00, 8'h24, 8'h4d, 8'h49, 8'h00, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h72, 8'h72, 8'h00, 8'hff, 8'h00, 8'h6e, 8'h92, 8'h24, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h25, 8'h72, 8'hdf, 8'hbb, 8'h6e, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h92, 8'h00, 8'h00, 8'h2a, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h00, 8'h2a, 8'hdf, 8'hdf, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'h53, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h25, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h00, 8'h24, 8'h00, 8'h24, 8'hff, 8'hff, 8'hff, 8'h13, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2a, 8'h2a, 8'h25, 8'h00, 8'hb7, 8'hdf, 8'h6e, 8'h6e, 8'h92, 8'h24, 8'h25, 8'h00, 8'h25, 8'h24, 8'hff, 8'h13, 8'h1f, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2a, 8'h25, 8'h00, 8'h00, 8'h2a, 8'hbb, 8'hdf, 8'hdf, 8'h2a, 8'h00, 8'h00, 8'h00, 8'h25, 8'h00, 8'h53, 8'h13, 8'h1b, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h25, 8'hd1, 8'h40, 8'h00, 8'h2a, 8'h00, 8'h25, 8'h00, 8'h00, 8'h1f, 8'h1f, 8'h53, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'hb7, 8'h00, 8'h45, 8'h45, 8'hdf, 8'h25, 8'h00, 8'h00, 8'h00, 8'h13, 8'h1f, 8'h1f, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h92, 8'hff, 8'h00, 8'hf6, 8'hf6, 8'hff, 8'h24, 8'h24, 8'h72, 8'h13, 8'h1f, 8'hbf, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hb7, 8'h00, 8'h40, 8'hd1, 8'hf6, 8'hf6, 8'h45, 8'h45, 8'hdf, 8'h21, 8'h17, 8'h1f, 8'hbf, 8'h53, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hbb, 8'hbb, 8'h00, 8'h00, 8'h40, 8'h40, 8'h00, 8'h00, 8'h53, 8'h17, 8'hbf, 8'hbf, 8'h0a, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2a, 8'h2a, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h13, 8'hbf, 8'hbf, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h00, 8'h24, 8'h00, 8'h00, 8'h0a, 8'h1f, 8'hbf, 8'h13, 8'h0a, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h25, 8'h2e, 8'h17, 8'h0a, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h97, 8'h2a, 8'h2a, 8'h72, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h24, 8'h97, 8'h97, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h2e, 8'h24, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h2a, 8'h24, 8'h53, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hdf, 8'hb7, 8'h72, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'h00, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h25, 8'h6e, 8'h92, 8'h92, 8'h2e, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h25, 8'h72, 8'h00, 8'h00, 8'h2e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h00, 8'h24, 8'h00, 8'h24, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'h53, 8'h13, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h25, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'h13, 8'h1f, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h92, 8'h00, 8'h72, 8'h72, 8'h6e, 8'h6e, 8'h6e, 8'h25, 8'hdb, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'h1b, 8'h1f, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h00, 8'h00, 8'h25, 8'hdf, 8'hdf, 8'hdf, 8'h2e, 8'h24, 8'h00, 8'h00, 8'h25, 8'h24, 8'h13, 8'h1b, 8'h1b, 8'hbf, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h00, 8'h00, 8'h24, 8'h25, 8'hff, 8'hff, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'h00, 8'h53, 8'h1f, 8'h1f, 8'h1b, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hdf, 8'h00, 8'h89, 8'h89, 8'hdb, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h1b, 8'hbf, 8'h53, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'hff, 8'h2e, 8'h89, 8'h89, 8'hff, 8'h25, 8'h00, 8'h00, 8'h00, 8'h13, 8'hbf, 8'hbf, 8'h53, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h00, 8'h8d, 8'hf6, 8'hf6, 8'hf6, 8'h89, 8'h00, 8'hff, 8'h2e, 8'h1b, 8'hbf, 8'hbf, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hbb, 8'h72, 8'h2e, 8'h00, 8'h8d, 8'hf6, 8'hf6, 8'h00, 8'h00, 8'h00, 8'h21, 8'hbf, 8'hbf, 8'h53, 8'h53, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h1b, 8'h1b, 8'hbf, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h1b, 8'hbf, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2e, 8'h72, 8'h00, 8'h00, 8'h00, 8'h00, 8'h2e, 8'h2e, 8'h00, 8'h2e, 8'h13, 8'h2e, 8'h24, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h00, 8'h24, 8'h24, 8'h6e, 8'hbb, 8'hbb, 8'h25, 8'h25, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h25, 8'h25, 8'h92, 8'h72, 8'h25, 8'h25, 8'h00, 8'h00, 8'h24, 8'h21, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h24, 8'h00, 8'h24, 8'h25, 8'h53, 8'h24, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'h24, 8'h25, 8'h25, 8'h53, 8'h00, 8'h24, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h25, 8'hdf, 8'h24, 8'h00, 8'h00, 8'hdf, 8'h25, 8'h92, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'hff, 8'h00, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h21, 8'h25, 8'h2e, 8'h2e, 8'hff, 8'h00, 8'h2e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hbb, 8'hdf, 8'h00, 8'hff, 8'hff, 8'hdf, 8'hdf, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h21, 8'h25, 8'h25, 8'h2e, 8'h6e, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h25, 8'h2e, 8'h72, 8'h6e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hb7, 8'h25, 8'hdf, 8'hdf, 8'h93, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h00, 8'h24, 8'h6e, 8'h2e, 8'h6e, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6e, 8'h6e, 8'hb7, 8'h25, 8'h00, 8'h25, 8'h25, 8'h24, 8'h00, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h72, 8'h6e, 8'h92, 8'h72, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h2e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h6e, 8'h2e, 8'h24, 8'h00, 8'h24, 8'h24, 8'h25, 8'h92, 8'h92, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h92, 8'h92, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h89, 8'h89, 8'h24, 8'h00, 8'h00, 8'h72, 8'h25, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'hb2, 8'h21, 8'h24, 8'h92, 8'h72, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'had, 8'had, 8'hb2, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'h89, 8'h40, 8'h00, 8'h00, 8'h00, 8'h2e, 8'hb7, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hdf, 8'hbb, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2e, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h97, 8'hbb, 8'h00, 8'h00, 8'h24, 8'h00, 8'h25, 8'h2e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hdf, 8'h24, 8'h24, 8'h2e, 8'h00, 8'h00, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h2e, 8'h2e, 8'h2e, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h21, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h2e, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h21, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h24, 8'h00, 8'h24, 8'hdf, 8'hbb, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h2e, 8'h25, 8'h25, 8'h24, 8'h00, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h93, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'hdf, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h24, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h25, 8'h2a, 8'h6e, 8'h72, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h96, 8'h25, 8'h25, 8'h72, 8'h72, 8'hbb, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h6e, 8'h00, 8'h24, 8'h6e, 8'h2a, 8'h2a, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6e, 8'h6e, 8'h24, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h6e, 8'h6e, 8'h92, 8'h72, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h6e, 8'hff, 8'h72, 8'h00, 8'h00, 8'h00, 8'h00, 8'h2a, 8'h72, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h21, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h92, 8'h92, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hbb, 8'h00, 8'h40, 8'h40, 8'h00, 8'h00, 8'h25, 8'h25, 8'hdf, 8'hdf, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h8d, 8'h24, 8'h00, 8'h00, 8'h00, 8'h24, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'had, 8'h2e, 8'h25, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'hf6, 8'hd1, 8'hf6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h21, 8'h8d, 8'hf6, 8'h8d, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h21, 8'h24, 8'h00, 8'h00, 8'h25, 8'h6e, 8'hff, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hff, 8'hb7, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hb7, 8'hbb, 8'h00, 8'h24, 8'h00, 8'h00, 8'hbb, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h4e, 8'h25, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h2a, 8'h2e, 8'h2e, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h2a, 8'h25, 8'h25, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h2a, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'hdf, 8'h25, 8'h25, 8'h2e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h2a, 8'h25, 8'hbb, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hdf, 8'hdf, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h25, 8'h2e, 8'h6e, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h25, 8'h2e, 8'h72, 8'h6e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hb7, 8'h25, 8'hdf, 8'hdf, 8'hb6, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h00, 8'h24, 8'h6e, 8'h2e, 8'h6e, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6e, 8'h6e, 8'hb7, 8'h25, 8'h00, 8'h25, 8'h25, 8'h24, 8'h00, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h72, 8'h6e, 8'h92, 8'h72, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h6e, 8'h2e, 8'h24, 8'h00, 8'h24, 8'h00, 8'h25, 8'h92, 8'h72, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h92, 8'h92, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h89, 8'h89, 8'h25, 8'h00, 8'h00, 8'h72, 8'h25, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'hd2, 8'h00, 8'h24, 8'h72, 8'h72, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hb1, 8'had, 8'hd2, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'h89, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h97, 8'h97, 8'h2e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hbb, 8'h97, 8'h00, 8'h00, 8'hdf, 8'hdf, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hbb, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h2e, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2e, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h2e, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hbb, 8'hbb, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h2e, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h2e, 8'h25, 8'h2e, 8'hbb, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'hdf, 8'hdf, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
},
{
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h24, 8'h21, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h25, 8'h25, 8'h2a, 8'h72, 8'h6e, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h92, 8'h25, 8'h25, 8'h72, 8'h72, 8'hbb, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'h6e, 8'h00, 8'h24, 8'h6e, 8'h2a, 8'h6e, 8'h25, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6e, 8'h6e, 8'h24, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h72, 8'h6e, 8'h92, 8'h72, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h6e, 8'h6e, 8'hff, 8'h92, 8'h00, 8'h00, 8'h00, 8'h00, 8'h2a, 8'h6e, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h25, 8'hff, 8'hff, 8'h00, 8'h24, 8'h24, 8'h00, 8'h00, 8'h25, 8'h92, 8'h92, 8'h25, 8'h24, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hbb, 8'h00, 8'h40, 8'h8d, 8'h00, 8'h00, 8'h25, 8'h25, 8'hdf, 8'hdf, 8'h25, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h8d, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'had, 8'h2e, 8'h25, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h40, 8'hf6, 8'had, 8'hf6, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h8d, 8'hf6, 8'had, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h24, 8'h00, 8'h00, 8'h2a, 8'h6e, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hff, 8'hbb, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hbb, 8'hbb, 8'h00, 8'h24, 8'h00, 8'h00, 8'hbb, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h4e, 8'h0a, 8'h24, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h0a, 8'h2e, 8'h0a, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h00, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h2a, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'hdf, 8'h25, 8'h25, 8'h0a, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h2a, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'h24, 8'h00, 8'h00, 8'h24, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h00, 8'hff, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h00, 8'h2a, 8'h25, 8'hbb, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h24, 8'hdf, 8'hff, 8'h00, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
}
};
















































































 

































//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one encoding per edge:  hit_colors[2:0] =   
 

 
 
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;

	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  

		if (InsideRectangle == 1'b1 && character_picker == 1'b1 ) 
		begin // inside an external bracket 
			 case (NumOfFrame)
  4'd0:  RGBout <= object_colors[0][offsetY][offsetX];
  4'd1:  RGBout <= object_colors[1][offsetY][offsetX];
  4'd2:  RGBout <= object_colors[2][offsetY][offsetX];
  4'd3:  RGBout <= object_colors[3][offsetY][offsetX];
  4'd4:  RGBout <= object_colors[4][offsetY][offsetX];
  4'd5:  RGBout <= object_colors[5][offsetY][offsetX];
  4'd6:  RGBout <= object_colors[6][offsetY][offsetX];
  4'd7:  RGBout <= object_colors[7][offsetY][offsetX];
  4'd8:  RGBout <= object_colors[8][offsetY][offsetX];
  4'd9:  RGBout <= object_colors[9][offsetY][offsetX];
  4'd10: RGBout <= object_colors[10][offsetY][offsetX];
  4'd11: RGBout <= object_colors[11][offsetY][offsetX];
  4'd12: RGBout <= object_colors[12][offsetY][offsetX];
  4'd13: RGBout <= object_colors[13][offsetY][offsetX];
  4'd14: RGBout <= object_colors[14][offsetY][offsetX];
  4'd15: RGBout <= object_colors[15][offsetY][offsetX];
  default: RGBout <= TRANSPARENT_ENCODING;
endcase
		
		end  	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
