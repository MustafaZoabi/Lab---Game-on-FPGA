module test_mux (     // mux made for pages
    input  logic        clk,
    input  logic        resetN,
    
    input  logic        request1,
    input  logic [7:0]  RGB1, 

    input  logic        request2,
    input  logic [7:0]  RGB2, 

    input  logic        request3,
    input  logic [7:0]  RGB3, 

    input  logic        request4,
    input  logic [7:0]  RGB4, 

    input  logic        request5,
    input  logic [7:0]  RGB5, 

    input  logic        request6,
    input  logic [7:0]  RGB6, 

    input  logic        request7,
    input  logic [7:0]  RGB7,

    input  logic        request8,
    input  logic [7:0]  RGB8,

    input  logic        request9,
    input  logic [7:0]  RGB9,
	 
	 
    input  logic        request10,
    input  logic [7:0]  RGB10,
	 
	 
	 
    input  logic        request11,
    input  logic [7:0]  RGB11,
	 
	 input  logic        request12,
    input  logic [7:0]  RGB12,
	 
	 input  logic        request13,
    input  logic [7:0]  RGB13,
	 
    input  logic [7:0]  MIF_RGB,

    output logic [7:0]  RGBOut
);

always_ff @(posedge clk or negedge resetN) begin
    if (!resetN) begin
        RGBOut <= 8'hff;
    end else begin
        if (request1)       RGBOut <= RGB1;
        else if (request2)  RGBOut <= RGB2;
        else if (request3)  RGBOut <= RGB3;
        else if (request4)  RGBOut <= RGB4;
        else if (request5)  RGBOut <= RGB5;
        else if (request6)  RGBOut <= RGB6;
        else if (request7)  RGBOut <= RGB7;
        else if (request8)  RGBOut <= RGB8;
        else if (request9)  RGBOut <= RGB9;
		  else if (request10)  RGBOut <= RGB10;
		  else if (request11)  RGBOut <= RGB11;
		  else if (request12)  RGBOut <= RGB12;
		  else if (request13)  RGBOut <= RGB13;
        else    RGBOut <= MIF_RGB;
    end
end

endmodule
