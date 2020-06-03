/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    determines CLA carry logic given 4 bits
*/

module claLogicBlock(G, P, C_in, C_out);

    // input / output instantiation
    input [3:0] G, P;
    input C_in;
    output [3:0] C_out;

    // Determine Carry In's per respective full adder

    // c1 = g0 + p0*c0
    wire pc0_nand, pc0_and;
    nand2 nand_pc0(.in1(P[0]), .in2(C_in), .out(pc0_nand));
    not1 and_pc0(.in1(pc0_nand), .out(pc0_and));
    wire g0_nor;
    nor2 nor_g0(.in1(pc0_and), .in2(G[0]), .out(g0_nor));
    not1 or_g0(.in1(g0_nor), .out(C_out[0]));

    // c2 = g1 + (p1*g0) + (p1*p0*c0)
    wire p1_nand, p1_and;
    nand2 nand_p1p0c0(.in1(pc0_and), .in2(P[1]), .out(p1_nand));
    not1 and_p1p0c0(.in1(p1_nand), .out(p1_and));
    wire p1g0_nand, p1g0_and;
    nand2 nand_p1g0(.in1(P[1]), .in2(G[0]), .out(p1g0_nand));
    not1 and_p1g0(.in1(p1g0_nand), .out(p1g0_and));
    wire c2_nor;
    nor3 nor_c2(.in1(G[1]), .in2(p1g0_and), .in3(p1_and), .out(c2_nor));
    not1 or_c2(.in1(c2_nor), .out(C_out[1]));

    // c3 = g2 + (p2*g1) + (p2*p1*g0) + (p2*p1*p0*c0)
    wire p2_nand, p2_and;
    nand2 nand_p2(.in1(P[2]), .in2(p1_and), .out(p2_nand));
    not1 and_p2(.in1(p2_nand), .out(p2_and));
    wire p2g0_nand, p2g0_and;
    nand2 nand_p2g0(.in1(P[2]), .in2(p1g0_and), .out(p2g0_nand));
    not1 and_p2g0(.in1(p2g0_nand), .out(p2g0_and));
    wire p2g1_nand, p2g1_and;
    nand2 nand_p2g1(.in1(P[2]), .in2(G[1]), .out(p2g1_nand));
    not1 and_p2g1(.in1(p2g1_nand), .out(p2g1_and));
    wire c3_nor3_RHS, c3_or3_RHS;
    nor3 nor_RHS_c3(.in1(G[2]), .in2(p2g1_and), .in3(p2g0_and), .out(c3_nor3_RHS));
    not1 or_RHS_c3(.in1(c3_nor3_RHS), .out(c3_or3_RHS));
    wire c3_nor;
    nor2 nor_c3(.in1(p2_and), .in2(c3_or3_RHS), .out(c3_nor));
    not1 or_c3(.in1(c3_nor), .out(C_out[2]));

    // c4 = g3 + (p3*g2) + (p3*p2*g1) + (p3*p2*p1*g0) + (p3*p2*p1*p0*c0)
    wire p3_nand, p3_and;
    nand2 nand_p3(.in1(P[3]), .in2(p2_and), .out(p3_nand));
    not1 and_p3(.in1(p3_nand), .out(p3_and));
    wire p3g0_nand, p3g0_and;
    nand2 nand_p3g0(.in1(P[3]), .in2(p2g0_and), .out(p3g0_nand));
    not1 and_p3g0(.in1(p3g0_nand), .out(p3g0_and));
    wire p3g1_nand, p3g1_and;
    nand2 nand_p3g1(.in1(P[3]), .in2(p2g1_and), .out(p3g1_nand));
    not1 and_p3g1(.in1(p3g1_nand), .out(p3g1_and));
    wire p3g2_nand, p3g2_and;
    nand2 nand_p3g2(.in1(P[3]), .in2(G[2]), .out(p3g2_nand));
    not1 and_p3g2(.in1(p3g2_nand), .out(p3g2_and));
    wire c4_LHS_nor, c4_LHS_or;
    nor3 nor_LHS_c4(.in1(G[3]), .in2(p3g2_and), .in3(p3g1_and), .out(c4_LHS_nor));
    not1 or_LHS_c4(.in1(c4_LHS_nor), .out(c4_LHS_or));
    wire c4_RHS_nor;
    nor3 nor_RHS_c4(.in1(c4_LHS_or), .in2(p3g0_and), .in3(p3_and), .out(c4_RHS_nor));
    not1 or_RHS_c4(.in1(c4_RHS_nor), .out(C_out[3]));   

endmodule
