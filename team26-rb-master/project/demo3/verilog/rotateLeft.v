/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A rotate left module. Rotates a given input left by
    a specified number of bits.

 */

module rotateLeft(In, Cnt, Out);

    // variable declaration
    input [15:0] In;
    input [3:0] Cnt;
    output [15:0] Out;

    wire [15:0] inter1, inter2, inter3;
    assign inter1 = Cnt[3] ? {In[7:0], In[15:8]} : In;
    assign inter2 = Cnt[2] ? {inter1[11:0], inter1[15:12]} : inter1;
    assign inter3 = Cnt[1] ? {inter2[13:0], inter2[15:14]} : inter2;
    assign Out = Cnt[0] ? {inter3[14:0], inter3[15]} : inter3;

endmodule
