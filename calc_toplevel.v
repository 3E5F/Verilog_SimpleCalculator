//Issued by Zachary B. and Albert C.
//CMPE125 Lab7_Task3
`timescale 1ns / 1ps
module DP2(in1, in2, Go, Op, clk, out, CSout, Done);
input Go, clk; 
input[1:0] Op; 
input[2:0] in1, in2; 
wire [1:0] s1, wa, raa, rab, c; 
wire we, rea, reb, s2;

output  [2:0] out; 
output  [3:0] CSout;  
output  Done;
DP U0 (.in1(in1), .in2(in2), .s1(s1), .clk(clk), .wa(wa), .we(we), .raa(raa), .rea(rea), .rab(rab), .reb(reb), .c(c), .s2(s2), .out(out));
FSM U1 (.Go(Go), .Op(Op), .CLK(clk), .CS_out(CSout), .Done_out(Done), .s1(s1), .WA(wa), .WE(we), .RAA(raa), .REA(rea), .RAB(rab), .REB(reb), .c(c), .s2(s2));
endmodule
