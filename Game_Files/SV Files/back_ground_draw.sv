

module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq 
);

const int	xFrameSize	=	635;
const int	yFrameSize	=	475;
const int	bracketOffset =	32;
const int   COLOR_MARTIX_SIZE  = 16*8 ; // 128 

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;
logic [10:0] shift_pixelX;


localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

 
localparam  int RED_TOP_Y  = 156 ;
localparam  int RED_LEFT_X  = 256 ;
localparam  int GREEN_RIGHT_X  = 32 ;
localparam  int BLUE_BOTTOM_Y  = 300 ;
localparam  int BLUE_RIGHT_X  = 200 ;
 
parameter  logic [10:0] COLOR_MATRIX_TOP_Y  = 100 ; 
parameter  logic [10:0] COLOR_MATRIX_LEFT_X = 100 ;

 

// this is a block to generate the background 
//it has four sub modules : 

	// 1. draw the yellow borders
	// 2. draw four lines with "bracketOffset" offset from the border 
	// 3. draw a matrix of 256  rectangles with all the colors, each rectangle 16 *2 pixels    	

 
 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
	end 
	else begin

	// defaults 
		greenBits <= 3'b000 ; 
		redBits <= 3'b000 ;
		blueBits <= 2'b00;//LIGHT_COLOR;
		boardersDrawReq <= 	1'b1 ; 
		
	   if ((pixelX < 444) && (pixelX >=190) &&(pixelY < 254) && (pixelY >= 220))begin 
		  greenBits <= 3'b111 ; 
		  redBits <= 3'b111 ;
		  blueBits <= 2'b11;//LIGHT_COLOR;
		end
		if((pixelX < 439) && (pixelX >=195) &&(pixelY < 249) && (pixelY >= 225))begin 
		greenBits <= 3'b000 ; 
		redBits <= 3'b000 ;
		blueBits <= 2'b00;//LIGHT_COLOR;
		end
	
	BG_RGB <=  { blueBits, redBits, greenBits } ; //collect color nibbles to an 8 bit word		


	end; 	
end 
endmodule

