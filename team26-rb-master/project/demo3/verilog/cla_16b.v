/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
module cla_16b(A, B, C_in, S, C_out);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
    output         C_out;

    // YOUR CODE HERE
    wire [3:0] G, P;
    genPropLogic GP0(.A(A[3:0]), .B(B[3:0]), .superG(G[0]), .superP(P[0]), .g(), .p());
    genPropLogic GP1(.A(A[7:4]), .B(B[7:4]), .superG(G[1]), .superP(P[1]), .g(), .p());
    genPropLogic GP2(.A(A[11:8]), .B(B[11:8]), .superG(G[2]), .superP(P[2]), .g(), .p());
    genPropLogic GP3(.A(A[15:12]), .B(B[15:12]), .superG(G[3]), .superP(P[3]), .g(), .p());

    wire [3:0] sub_carry;
    claLogicBlock carryLogic(.G(G), .P(P), .C_in(C_in), .C_out(sub_carry));
    assign C_out = sub_carry[3];

    cla_4b cla_4b_0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .C_out());
    cla_4b cla_4b_1(.A(A[7:4]), .B(B[7:4]), .C_in(sub_carry[0]), .S(S[7:4]), .C_out());
    cla_4b cla_4b_2(.A(A[11:8]), .B(B[11:8]), .C_in(sub_carry[1]), .S(S[11:8]), .C_out());
    cla_4b cla_4b_3(.A(A[15:12]), .B(B[15:12]), .C_in(sub_carry[2]), .S(S[15:12]), .C_out(C_out));

endmodule
