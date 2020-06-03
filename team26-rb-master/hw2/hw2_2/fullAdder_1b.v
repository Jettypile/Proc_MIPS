/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, C_out);
    input  A, B;
    input  C_in;
    output S;
    output C_out;

    // YOUR CODE HERE
    // Assign SUM value
    xor3 xor_sum(.in1(A), .in2(B), .in3(C_in), .out(S));

    // Assign CARRY_OUT value
    wire nand_bc, nand_ac, nand_ab, and_bc, and_ac, and_ab;
    nand2 nand2_bc(.in1(B), .in2(C_in), .out(nand_bc));
    nand2 nand2_ac(.in1(A), .in2(C_in), .out(nand_ac));
    nand2 nand2_ab(.in1(A), .in2(B), .out(nand_ab));
    not1 not1_bc(.in1(nand_bc), .out(and_bc));
    not1 not1_ac(.in1(nand_ac), .out(and_ac));
    not1 not1_ab(.in1(nand_ab), .out(and_ab));

    wire nor_res;
    nor3 sum_of_ands(.in1(and_bc), .in2(and_ac), .in3(and_ab), .out(nor_res));
    not1 res(.in1(nor_res), .out(C_out));

endmodule
