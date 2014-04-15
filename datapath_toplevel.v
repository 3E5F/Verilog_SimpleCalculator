`timescale 1ns / 1ps
module DP(in1, in2, s1, clk, wa, we, raa, rea, rab, reb, c, s2, out);
parameter word_width = 3;
parameter rf_size = 4;
parameter addr_size = 2;
input [word_width-1:0] in1, in2;
input [addr_size-1:0] s1, wa, raa, rab, c;
input we, rea, reb, s2, clk;
output [word_width-1:0] out;
wire [word_width-1:0] m1out;
wire [word_width-1:0] douta;
wire [word_width-1:0] doutb;
wire [word_width-1:0] aluout;
MUX_1 U0(.in1(in1), .in2(in2), .in3(3'b000), .in4(aluout), .s1(s1), .m1out(m1out));
RegisterFile U1(.clk(clk), .rea(rea), .reb(reb), .raa(raa), .rab(rab), .we(we), .wa(wa), .din(m1out), .douta(douta), .doutb(doutb));
ALU U2(.in1(douta), .in2(doutb), .c(c), .aluout(aluout));
MUX_2 U3(.in1(aluout), .in2(3'b000), .s2(s2), .m2out(out));
endmodule
