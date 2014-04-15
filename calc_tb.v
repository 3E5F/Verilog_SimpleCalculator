//Issued by Zachary B. and Albert C.
//CMPE125 Lab7_Task3
module tb_calculator();
reg Go, clk; 
reg[1:0] Op; 
reg[2:0] in1, in2; 
wire [2:0] out;
wire [3:0] CSout; 
wire Done;
initial
	begin
		clk = 0; 
		Go = 0;
		in1 = 3'b101;
		in2 = 3'b010;
#10	Go = 1'b1; 
		Op = 2'b11; 
#55	$stop; 
#10	$finish; 	 
	end
always #5 clk = ~clk ; 
DP2 U0(.in1(in1), .in2(in2), .Go(Go), .Op(Op), .clk(clk), .out(out), .CSout(CSout), .Done(Done));
endmodule
