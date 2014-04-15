`timescale 1ns / 1ps
module ALU(in1, in2, c, aluout);
input [2:0] in1, in2; 
input [1:0] c; 
output reg [2:0] aluout; 
always @ (in1, in2, c)
begin
	if (c == 2'b11) //Add
		aluout = in1 + in2;
	else if(c == 2'b10) //Subtract
		aluout = in1 - in2;
	else if(c == 2'b01) //And
		aluout = in1 & in2;
	else //Xor
		aluout = in1 ^ in2;
end
endmodule
