/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module shifter (In, Cnt, Op, Out);

    // declare constant for size of inputs, outputs (N) and # bits to shift (C)
    parameter   N = 16;
    parameter   C = 4;
    parameter   O = 2;

    input [N-1:0]   In;
    input [C-1:0]   Cnt;
    input [O-1:0]   Op;
    output [N-1:0]  Out;

    /* YOUR CODE HERE */
    wire [15:0] interOut1, interOut2, interOut3, interOut4;

    rotateLeft barrel00(.In(In), .Cnt(Cnt), .Out(interOut1));
    shiftLeft barrel01(.In(In), .Cnt(Cnt), .Out(interOut2));
    shiftRightArithmetic barrel10(.In(In), .Cnt(Cnt), .Out(interOut3));
    shiftRightLogical barrel11(.In(In), .Cnt(Cnt), .Out(interOut4)); 

    assign Out = Op[1] ? (Op[0] ? interOut4 : interOut3) : (Op[0] ? interOut2 : interOut1);

endmodule
