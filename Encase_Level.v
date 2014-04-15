module Encase_Level(Op, in1, in2, CSout, Done, Out, Go_top, RST_db, clk50MHz, clk5KHz, rst, ledout, ledsel);
input clk50MHz, clk5KHz, rst;
input  Go_top, RST_db;
input[1:0]  Op;
input[2:0] in1, in2;
output  [2:0]  Out;
output  [3:0] CSout;
output  Done;
output [3:0] ledsel;
output [7:0] ledout;
wire Go;
wire we, rea, reb, s2;
wire DONT_USE, clk_5KHz, clksec4;
wire [7:0] state, result;
clk_gen U0 (.clk50MHz(clk50MHz), .rst(rst), .clksec4(clksec4), .clk_5KHz(clk_5KHz)); 
debounce U1(.pb_debounced(Go), .pb(Go_top), .clk(clk50MHz)); 
DP2 U2(.in1(in2), .in2(in1), .Go(Go), .Op(Op), .clk(clk50MHz), .out(Out), .CSout(CSout), .Done(Done));
led4BitTo7Seg U3 (.number(CSout[3:0]), .s0(state[0]), .s1(state[1]), .s2(state[2]), .s3(state[3]), .s4(state[4]), .s5(state[5]), .s6(state[6]));     //set led 0
led4BitTo7Seg U4 (.number(Out[2:0]), .s0(result[0]), .s1(result[1]), .s2(result[2]), .s3(result[3]), .s4(result[4]), .s5(result[5]), .s6(result[6]));      //set led 3
LED_MUX U5 (.clk(clk_5KHz), .rst(rst), .LED0(state), .LED1(result), .LED2(), .LED3(), .LEDOUT(ledout), .LEDSEL(ledsel));   //led mux - led 2 and 3 not used
endmodule


module clk_gen(clk50MHz, rst, clksec4, clk_5KHz);
input clk50MHz, rst;
output clksec4, clk_5KHz;
reg clksec4, clk_5KHz;
integer count, count1;
always@(posedge clk50MHz)
begin
  if(rst)
   begin
    count = 0;
    count1 = 0;
    clksec4 = 0;
    clk_5KHz =0;
end
else
begin
    if(count == 100000000)
     begin
      clksec4 = ~clksec4;
      count = 0;
     end
    if(count1 == 20000)
     begin
      clk_5KHz = ~clk_5KHz;
      count1 = 0;
    end
  count = count + 1;
  count1 = count1 + 1;
 end
end
endmodule

module debounce(pb_debounced, pb, clk); 
input pb, clk; 
output pb_debounced; 
reg [7:0] shift; 
reg pb_debounced; 
always @ (posedge clk) 
begin 
 shift[6:0] <= shift[7:1]; shift[7] <= pb; 
 if (shift==4'b0000) pb_debounced <= 1'b0; 
 else pb_debounced <= 1'b1; 
end 
endmodule

module led4BitTo7Seg(number, s0, s1, s2, s3, s4, s5, s6);
input [3:0] number;
output s0, s1, s2, s3, s4, s5, s6;
reg s0, s1, s2, s3, s4, s5, s6;
always @ (number)
 begin // BCD to 7-segment decoding
  case (number) // s0 - s6 are active low
   4'b0000: begin s0=0; s1=0; s2=0; s3=1; s4=0; s5=0; s6=0; end
   4'b0001: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=1; end
   4'b0010: begin s0=0; s1=1; s2=0; s3=0; s4=0; s5=1; s6=0; end
   4'b0011: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=1; s6=0; end
   4'b0100: begin s0=1; s1=0; s2=1; s3=0; s4=0; s5=0; s6=1; end
   4'b0101: begin s0=0; s1=0; s2=1; s3=0; s4=1; s5=0; s6=0; end
   4'b0110: begin s0=0; s1=0; s2=0; s3=0; s4=1; s5=0; s6=0; end
   4'b0111: begin s0=1; s1=0; s2=1; s3=1; s4=0; s5=1; s6=0; end
   4'b1000: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
   4'b1001: begin s0=0; s1=0; s2=1; s3=0; s4=0; s5=0; s6=0; end
   default: begin s0=0; s1=0; s2=0; s3=0; s4=0; s5=0; s6=0; end
  endcase
end
endmodule // end led


module LED_MUX (clk, rst, LED0, LED1, LED2, LED3, LEDOUT, LEDSEL);
reg [1:0] index = 0;
input clk, rst;
input [7:0] LED0, LED1, LED2, LED3;
output reg[3:0] LEDSEL;
output reg[7:0] LEDOUT;
always @(posedge clk)
 begin
  if(rst)
   index = 0;
  else
   index = index + 1;
 end
always @(index or LED0 or LED1 or LED2 or LED3)
 begin
  case(index)
  0: begin
    LEDSEL = 4'b1110;
    LEDOUT = LED0;
   end
  1: begin
    LEDSEL = 4'b1101;
    LEDOUT = LED1;
   end
  2: begin
    LEDSEL = 4'b1011;
    LEDOUT = LED2;
   end
  3: begin
    LEDSEL = 4'b0111;
    LEDOUT = LED3;
   end
  default: begin
    LEDSEL = 0; LEDOUT = 0;
   end
  endcase
 end
endmodule
