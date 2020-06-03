/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/

module register(In, Clk, Rst, Out);

   // size of register
   parameter regSize = 16;

   // Input/Output Instantiation
   input [regSize-1:0] In;
   input Clk, Rst;
   output [regSize-1:0] Out;

   dff regFF [regSize-1:0] (.d(In), .clk(Clk), .rst(Rst), .q(Out));

endmodule
