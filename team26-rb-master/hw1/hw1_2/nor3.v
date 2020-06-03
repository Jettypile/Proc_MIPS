/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    3 input NOR
*/
module nor3 (in1,in2,in3,out);
    input  in1,in2,in3;
    output out;
    assign out = ~(in1 | in2 | in3);
endmodule
