//Issued by Zachary B. and Albert C.
// CMPE125 Lab 7_Task2
`timescale 1ns / 1ps
module FSM(Go, Op, CLK, CS_out, Done_out, s1, WA, WE, RAA, REA, RAB, REB, c, s2);
input Go, CLK; 
input [1:0] Op;
output reg[3:0] CS_out; 
output reg [1:0] WA, RAA, RAB, c, s1; 
output reg WE, REA, REB, s2, Done_out; 	
parameter	Idle = 4'b0000,	//state 0
				R1write = 4'b0001,	//state 1
				R2write = 4'b0010, //state 2
				Wait = 4'b0011,		//state 3
				XOR = 4'b0100,		//state 4
				AND = 4'b0101,		//state 5
				Sub = 4'b0110,		//state 6
				Add = 4'b0111,		//state 7
				DONE = 4'b1000; 	//state 8
reg [3:0] CS, NS; 
// output logic
always @(CS)
begin
	case(CS)
		Idle:	begin
					s1 = 2'b00; 
					WA = 2'b00; 
					WE = 0; 
					RAA = 2'b10; 
					REA = 1; 
					RAB = 2'b10; 
					REB = 1;
					c = 2'b01; 
					s2 = 0; 
					CS_out = Idle; 
					Done_out = 1'b1; 
				end
		R1write:	begin
						s1 = 2'b11; 
						WA = 2'b00; 
						WE = 1; 
						RAA = 2'b00; 
						REA = 1'b0; 
						RAB = 2'b00; 
						REB = 1'b0;
						c = 2'b00; 
						s2 = 1'b1; 
						CS_out = R1write; 
						Done_out = 1'b0; 
					end
			
		R2write:	begin
						s1 = 2'b10; 
						WA = 2'b01; 
						WE = 1; 
						RAA = 2'b00; 
						REA = 1'b0; 
						RAB = 2'b00; 
						REB = 1'b0;
						c = 2'b00; 
						s2 = 1; 
						CS_out = R2write; 
						Done_out = 1'b0; 
					end
		Wait: begin
					s1 = 2'b00; 
					WA = 2'b00; 
					WE = 0; 
					RAA = 2'b00; 
					REA = 0; 
					RAB = 2'b00; 
					REB = 0;
					c = 2'b00; 
					s2 = 1; 
					CS_out = Wait; 
					Done_out = 1'b0; 
				end
		XOR:	begin
					s1 = 2'b00; 
					WA = 2'b10; 
					WE = 1; 
					RAA = 2'b00; 
					REA = 1'b1; 
					RAB = 2'b01; 
					REB = 1'b1;
					c = 2'b00; 
					s2 = 1'b1; 
					CS_out = XOR; 
					Done_out = 1'b0; 
				end
		AND:	begin
					s1 = 2'b00; 
					WA = 2'b10; 
					WE = 1; 
					RAA = 2'b00; 
					REA = 1'b1; 
					RAB = 2'b01; 
					REB = 1'b1;
					c = 2'b01; 
					s2 = 1'b1; 
					CS_out = AND; 
					Done_out = 1'b0; 
				end
		Sub: 	begin
					s1 = 2'b00; 
					WA = 2'b10; 
					WE = 1; 
					RAA = 2'b00; 
					REA = 1'b1; 
					RAB = 2'b01; 
					REB = 1'b1;
					c = 2'b10; 
					s2 = 1'b1; 
					CS_out = Sub; 
					Done_out = 1'b0; 
				end
		Add:  begin
					s1 = 2'b00; 
					WA = 2'b10; 
					WE = 1; 
					RAA = 2'b00; 
					REA = 1; 
					RAB = 2'b01; 
					REB = 1;
					c = 2'b11; 
					s2 = 1; 
					CS_out = Add; 
					Done_out =1'b0; 
				end
		DONE: begin
					s1 = 2'b00; 
					WA = 2'b00; 
					WE = 0; 
					RAA = 2'b10; 
					REA = 1; 
					RAB = 2'b10; 
					REB = 1;
					c = 2'b01; 
					s2 = 0; 
					CS_out = DONE; 
					Done_out = 1; 
				end
	endcase
end	

// Next state logic
always @ (CS, Go, Op)
begin
	NS = Idle; 
	case (CS)
		Idle: 	begin
					if(!Go) NS = Idle;	//reset
					else NS = R1write; 
					end
		R1write:	NS = R2write; 
								
		R2write:	NS = Wait; 
					
		Wait:	begin
				case(Op)
						2'b00:	NS = XOR;
						2'b01:	NS = AND;
						2'b10: 	NS = Sub;
						2'b11:	NS = Add;
						default: NS = Wait;
				endcase
				end
		XOR: NS = DONE; 
		AND: NS = DONE; 
		Sub: NS = DONE;
		Add: NS = DONE; 
		DONE:	NS = Idle; 	
	endcase
end
always @ (posedge CLK)
	CS = NS ; 
endmodule
