// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2025
// (c) Technion IIT, Department of Electrical Engineering 2025 



module	loading_word	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
				   output   logic	[2:0] HitEdgeCode 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 6;  // 2^6 = 64 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

 logic	[10:0] HitCodeX ;// offset of Hitcode 
 logic	[10:0] HitCodeY ; 
assign HitCodeX = offsetX >> ( OBJECT_NUMBER_OF_X_BITS - 4 );	// hitedge code MSB of the offset
assign HitCodeY = offsetY >> ( OBJECT_NUMBER_OF_Y_BITS - 4 );	 	 

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1][7:0] object_colors = {
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h92, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6d, 8'h6d, 8'h6e, 8'h6e, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6d, 8'h6d, 8'h6e, 8'h6e, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6d, 8'h6d, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6e, 8'h6e, 8'h6d, 8'h6d, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6d, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h92, 8'h92, 8'h6e, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h92, 8'h92, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6d, 8'hff, 8'hff, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'hff, 8'hff, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6d, 8'hff, 8'hff, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h92, 8'hff, 8'hff, 8'h92, 8'h6e, 8'h6e, 8'h6e, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'hff, 8'hff, 8'hff, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'hff, 8'hff, 8'h92, 8'hff, 8'h92, 8'hff, 8'hff, 8'h92, 8'hff, 8'h92, 8'hff, 8'hff, 8'h92, 8'hff, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h6e, 8'h6d, 8'h6d, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6e, 8'h6d, 8'h6d, 8'h6d, 8'h6e, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'h92, 8'h6e, 8'h92, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6e, 8'h6d, 8'h92, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'h92, 8'h6d, 8'h6e, 8'h6e, 8'h6e, 8'h92, 8'h6e, 8'h92, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff},
{8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff, 8'hff}
};




//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one encoding per edge:  hit_colors[2:0] =   
 
logic [0:15] [0:15] [2:0] hit_colors = 
		  {48'o0004444444444000,     
			48'o0004444444444000,    
			48'o0000444444444000, 
			48'o2200044444400033,
			48'o2220004444000333,
			48'o2222000440003333,
			48'o2222200000033333,
			48'o2222220003333333,
			48'o2222200000333333,
			48'o2222000100033333,
			48'o2220001110003333,
			48'o2200011111000333,
			48'o2000111111100033,
			48'o0001111111110000,
			48'o0001111111111000,
			48'o0001111111111000};
 
 
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
		HitEdgeCode <= 3'h0;

	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  
		HitEdgeCode <= 3'h0;

		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];
			HitEdgeCode <= hit_colors[HitCodeY][HitCodeX];	//get hitting edge code from the colors table  
		
		end  	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule