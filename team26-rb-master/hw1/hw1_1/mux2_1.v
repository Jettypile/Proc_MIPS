/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1

    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    // YOUR CODE HERE
    // Out = ~S*A + S*B = nor(S, ~A) + nor(~S, ~B) = nand(~nor(S, ~A), ~nor(~S, ~B))

    // Declare additional intermediate variables
    wire S_n, A_n, B_n, Sel_1_n, Sel_2_n; // Not Variables
    wire Nor_sel_1, Nor_sel_2; // Selection intermediates for nor gate

    // Module Declarations for intermediates
    not1 not1_S(.in1(S), .out(S_n));
    not1 not1_A(.in1(InA), .out(A_n));
    not1 not1_B(.in1(InB), .out(B_n));

    nor2 nor_S_An(.in1(S), .in2(A_n), .out(Nor_sel_1));
    nor2 nor_Sn_Bn(.in1(S_n), .in2(B_n), .out(Nor_sel_2));

    not1 not1_norSel1(.in1(Nor_sel_1), .out(Sel_1_n));
    not1 not1_norSel2(.in1(Nor_sel_2), .out(Sel_2_n));

    nand2 nand2_out(.in1(Sel_1_n), .in2(Sel_2_n), .out(Out));

endmodule
