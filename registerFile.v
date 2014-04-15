`timescale 1ns / 1ps
module RegisterFile(clk, rea, reb, raa, rab, we, wa, din, douta, doutb);
input[1:0] wa, raa, rab; 
input[2:0] din; 
input clk, we, rea,reb; 
output[2:0] douta, doutb;
reg [2:0]RF[3:0]; 
assign douta = (rea) ? RF[raa]: 0; 
assign doutb = (reb) ? RF[rab]: 0; 
always @ (posedge clk) 
	begin
		if(we)
			RF[wa] = din; 
		else
			RF[wa] = RF[wa]; 
	end
endmodule
