/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    determine generate and propogate values for 4bits 
*/
module genPropLogic(A, B, g, p, superG, superP);

    //input / output
    input [3:0] A, B;
    output [3:0] g, p;
    output superG, superP;

    // Gen, Prop Vars
    wire g0_n, g1_n, g2_n, g3_n, p0_n, p1_n, p2_n, p3_n; // store out of nand and nor
    // Set Gen and Prop Vars
    // gi = ai * bi;    pi = ai + bi;    
    nand2 nand_g0(.in1(A[0]), .in2(B[0]), .out(g0_n));
    nand2 nand_g1(.in1(A[1]), .in2(B[1]), .out(g1_n));
    nand2 nand_g2(.in1(A[2]), .in2(B[2]), .out(g2_n));
    nand2 nand_g3(.in1(A[3]), .in2(B[3]), .out(g3_n));
    nor2 nor_p0(.in1(A[0]), .in2(B[0]), .out(p0_n));    
    nor2 nor_p1(.in1(A[1]), .in2(B[1]), .out(p1_n));
    nor2 nor_p2(.in1(A[2]), .in2(B[2]), .out(p2_n));    
    nor2 nor_p3(.in1(A[3]), .in2(B[3]), .out(p3_n));

    not1 not_g0(.in1(g0_n), .out(g[0]));
    not1 not_g1(.in1(g1_n), .out(g[1]));
    not1 not_g2(.in1(g2_n), .out(g[2]));
    not1 not_g3(.in1(g3_n), .out(g[3]));
    not1 not_p0(.in1(p0_n), .out(p[0]));
    not1 not_p1(.in1(p1_n), .out(p[1]));
    not1 not_p2(.in1(p2_n), .out(p[2]));
    not1 not_p3(.in1(p3_n), .out(p[3]));


    // set G = g3 + (p3*g2) + (p3*p2*g1) + (p3*p2*p1*g0)
    wire p2p1g0_nand, p2p1g0_and;
    nand3 nand_p2p1g0(.in1(p[1]), .in2(g[0]), .in3(p[2]), .out(p2p1g0_nand));
    not1 and_p2p1g0(.in1(p2p1g0_nand), .out(p2p1g0_and));
    wire p3p2p1g0_nand, p3p2p1g0_and;
    nand2 nand_p3p2p1g0(.in1(p2p1g0_and), .in2(p[3]), .out(p3p2p1g0_nand));
    not1 and_p3p2p1g0(.in1(p3p2p1g0_nand), .out(p3p2p1g0_and));
    wire p3p2g1_nand, p3p2g1_and;
    nand3 nand_p3p2g1(.in1(p[3]), .in2(p[2]), .in3(g[1]), .out(p3p2g1_nand));
    not1 and_p3p2g1(.in1(p3p2g1_nand), .out(p3p2g1_and));
    wire p3g2_nand, p3g2_and;
    nand2 nand_p3g2(.in1(p[3]), .in2(g[2]), .out(p3g2_nand));
    not1 and_p3g2(.in1(p3g2_nand), .out(p3g2_and));
    wire G_LHS_nor, G_LHS_or, G_RHS_nor;
    nor3 nor_G_LHS(.in1(g[3]), .in2(p3g2_and), .in3(p3p2g1_and), .out(G_LHS_nor));
    not1 or_G_LHS(.in1(G_LHS_nor), .out(G_LHS_or));
    nor2 nor_G_RHS(.in1(p3p2p1g0_and), .in2(G_LHS_or), .out(G_RHS_nor));
    not1 G_out(.in1(G_RHS_nor), .out(superG));

    // set P = p0*p1*p2*p3
    wire P_nand_RHS, P_and_RHS, P_nand_LHS;
    nand3 nand_P_RHS(.in1(p[0]), .in2(p[1]), .in3(p[2]), .out(P_nand_RHS));
    not1 not_P_RHS(.in1(P_nand_RHS), .out(P_and_RHS));
    nand2 nandP_LHS(.in1(P_and_RHS), .in2(p[3]), .out(P_nand_LHS));
    not1 not_P_LHS(.in1(P_nand_LHS), .out(superP)); 

endmodule
