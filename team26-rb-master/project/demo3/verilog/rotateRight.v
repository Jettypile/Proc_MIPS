/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A rotate right module. Rotates a given input right by
    a specified number of bits.

 */

module rotateRight(In, Cnt, Out);

    // variable declaration
    input [15:0] In;
    input [3:0] Cnt;
    output [15:0] Out;

    wire [15:0] inter1, inter2, inter3;
    assign inter1 = Cnt[3] ? {In[7:0], In[15:8]} : In;
    assign inter2 = Cnt[2] ? {inter1[3:0], inter1[15:4]} : inter1;
    assign inter3 = Cnt[1] ? {inter2[1:0], inter2[15:2]} : inter2;
    assign Out = Cnt[0] ? {inter3[0], inter3[15:1]} : inter3;

endmodule

/*
 0010 0000 0010 1000 ROR 0101
 1000 0010 0000 0010
 0100 0001 0000 0001 

*/