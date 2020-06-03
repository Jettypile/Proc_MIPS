/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A shift left module. Shifts a given input left by
    a specified number of bits.
 */

module shiftLeft(In, Cnt, Out);

    // variable declaration
    input [15:0] In;
    input [3:0] Cnt;
    output [15:0] Out;

    wire [15:0] inter1, inter2, inter3;
    assign inter1 = Cnt[3] ? {In[7:0], 8'b0} : In;
    assign inter2 = Cnt[2] ? {inter1[11:0], 4'b0} : inter1;
    assign inter3 = Cnt[1] ? {inter2[13:0], 2'b0} : inter2;
    assign Out = Cnt[0] ? {inter3[14:0], 1'b0} : inter3;

endmodule
