/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output       Out;

    // YOUR CODE HERE

    // Intermediate Variable Declarations
    wire Mux_sel_AB, Mux_sel_CD;

    // Module Declarations
    // S[0] --> mux1(A,B), mux2(C,D)
    mux2_1 mux_bit0_AB(.InA(InA), .InB(InB), .S(S[0]), .Out(Mux_sel_AB));
    mux2_1 mux_bit0_CD(.InA(InC), .InB(InD), .S(S[0]), .Out(Mux_sel_CD));

    // S[1] --> mux_out(mux1, mux2)
    mux2_1 mux_out(.InA(Mux_sel_AB), .InB(Mux_sel_CD), .S(S[1]), .Out(Out));

endmodule
