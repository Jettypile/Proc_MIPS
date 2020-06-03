/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
*/
module alu (InA, InB, Cin, Op, invA, invB, sign, Out, Zero, Ofl);

    // declare constant for size of inputs, outputs (N),
    // and operations (O)
    parameter    N = 16;
    parameter    O = 3;
   
    input [N-1:0] InA;
    input [N-1:0] InB;
    input         Cin;
    input [O-1:0] Op;
    input         invA;
    input         invB;
    input         sign;
    output [N-1:0] Out;
    output         Ofl;
    output         Zero;

    /* YOUR CODE HERE */

    // Determine Inversions
    wire [N-1:0] inter1A, inter1B;
    assign inter1A = invA ? ~InA : InA;
    assign inter1B = invB ? ~InB : InB;

    // Barrel Shift Operations
    wire [N-1:0] barrelOut;
    shifter barrelShft(.In(inter1A), .Cnt(inter1B[3:0]), .Op(Op[1:0]), .Out(barrelOut));
    
    // Adder
    wire [15:0] adderSum;
    wire C_out;
    cla_16b adder(.A(inter1A), .B(inter1B), .C_in(Cin), .S(adderSum), .C_out(C_out));
    
    // Muxes for ALU Out
    assign Out = Op[2] & Op[1] & Op[0] ? inter1A ^ inter1B :
                 Op[2] & Op[1] & ~Op[0] ? inter1A | inter1B :
                 Op[2] & ~Op[1] & Op[0] ? inter1A & inter1B :
                 Op[2] & ~Op[1] & ~Op[0] ? adderSum : barrelOut;

    assign signPosOfl = ~inter1A[15] & ~inter1B[15] & adderSum[15];
    assign signNegOfl = inter1A[15] & inter1B[15] & ~adderSum[15];
    assign Ofl = Op[2] & ~Op[1] & ~Op[0] & ((sign & (signPosOfl | signNegOfl)) | (~sign & C_out)); 
    assign Zero = ~|Out;


endmodule
