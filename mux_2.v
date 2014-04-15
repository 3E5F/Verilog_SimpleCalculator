`timescale 1ns / 1ps
module MUX_2(in1, in2, s2, m2out);
input [2:0] in1, in2; 
input s2; 
output reg [2:0] m2out; 
always @ (in1, in2, s2)
begin
	case(s2)
		1'b1: m2out = in2; 
		default m2out = in1;
	endcase
end
endmodule
