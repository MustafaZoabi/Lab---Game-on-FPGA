// System-Verilog constant  dudy February 2025
// (c) Technion IIT, Department of Electrical Engineering 2025 



module	MyConstant	
#(parameter int size = 9,  
				int MyValue= 0)
  
( output logic	[size-1:0] value ) ;



assign value = MyValue ;	 	 

endmodule