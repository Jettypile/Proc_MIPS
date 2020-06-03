/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 2

    A 16-bit ALU module combined with clkrst.
*/
module alu_hier(InA, InB, Cin, Op, invA, invB, sign, Out, Ofl, Zero);

   // declare constant for size of inputs, outputs (N),
   // and operations (O)
   parameter    N = 16;
   parameter    O = 3;

   input [N-1:0] InA;
   input [N-1:0] InB;
   input Cin;
   input [O-1:0] Op;
   input invA;
   input invB;
   input sign;
   output [N-1:0] Out;
   output Ofl;
   output Zero;

   wire clk;
   wire rst;
   wire err;

   assign err = 1'b0;
 
   clkrst c0(
             // Outputs
             .clk                       (clk),
             .rst                       (rst),
             // Inputs
             .err                       (err)
            );

    alu a0(
          // Outputs
          .Out                          (Out[15:0]),
          .Ofl                          (Ofl),
          .Zero                         (Zero),
          // Inputs
          .InA                          (InA[15:0]),
          .InB                          (InB[15:0]),
          .Cin                          (Cin),
          .Op                           (Op[2:0]),
          .invA                         (invA),
          .invB                         (invB),
          .sign                         (sign)
         ); 
endmodule // alu_hier
