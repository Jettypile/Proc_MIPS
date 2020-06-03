/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A shift right arithmetic module. signed shift a 
    given input right by a specified number of bits.
 */

module shiftRightArithmetic(In, Cnt, Out);

    // variable declaration
    input [15:0] In;
    input [3:0] Cnt;
    output [15:0] Out;

    wire [15:0] inter1, inter2, inter3;
    assign inter1 = Cnt[3] ? {{8{In[15]}}, In[15:8]} : In;
    assign inter2 = Cnt[2] ? {{4{inter1[15]}}, inter1[15:4]} : inter1;
    assign inter3 = Cnt[1] ? {{2{inter2[15]}}, inter2[15:2]} : inter2;
    assign Out = Cnt[0] ? {{1{inter3[15]}}, inter3[15:1]} : inter3;

endmodule
