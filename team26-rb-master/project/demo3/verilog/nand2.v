/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    2 input NAND
*/
module nand2 (in1,in2,out);
    input in1,in2;
    output out;
    assign out = ~(in1 & in2);
endmodule
