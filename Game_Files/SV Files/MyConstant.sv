


module	MyConstant	 // constant module 
#(parameter int size = 9,  
				int MyValue= 0)
  
( output logic	[size-1:0] value ) ;



assign value = MyValue ;	 	 

endmodule