/*
Purpose: This module serves as a case statement for setting the next state in the FSM.
*/

module nextStateFSM(enable, rd, wr, state, victimway, hit1, dirty1, valid1, hit2, dirty2, valid2, nxt_state);

   /* Module Input / Outpus */
   // Inputs (GENERAL)
   input enable, rd, wr, victimway;
   input [4:0] state;
   // Inputs (CACHE)
   input hit1, dirty1, valid1, hit2, dirty2, valid2;
   // Outputs
   output reg [4:0] nxt_state;


   /* Internal Variables */
   // FSM State Names
   parameter INIT = 4'h0, LOAD = 4'h1, STORE = 4'h2, ACCESS_WRITE = 4'h3, WAIT_FOR_READ_0 = 4'h4, WAIT_FOR_READ_1 = 4'h5, 
             WAIT_FOR_READ_2 = 4'h6, WAIT_FOR_READ_3 = 4'h7, ACCESS_READ_0 = 4'h8, ACCESS_READ_1 = 4'h9, ACCESS_READ_2 = 4'ha, 
             ACCESS_READ_3 = 4'hb, WAIT_FOR_WRITE_0 = 4'hc, WAIT_FOR_WRITE_1 = 4'hd, WAIT_FOR_WRITE_2 = 4'he, WAIT_FOR_WRITE_3 = 4'hf,
             SET_DONE = 5'h10, ACCESS_WRITE1 = 5'h11;

   /* Cache Controller FSM */
   // Logic for Setting Next State
   always @ (*) begin
      case (state)
         INIT:
            nxt_state = (enable & rd) ? LOAD : 
                        (enable & wr) ? STORE : INIT;
         LOAD: 
            nxt_state = ((hit1 & valid1) | (hit2 & valid2)) ? INIT :
                        ((valid1 & valid2 & ~victimway & dirty1) 
                                 | (valid1 & valid2 & victimway & dirty2)) ? ACCESS_READ_0 : ACCESS_WRITE;
         STORE: 
            nxt_state = ((hit1 & valid1) | (hit2 & valid2)) ? INIT : WAIT_FOR_WRITE_0;
         ACCESS_WRITE: 
            nxt_state = ACCESS_WRITE1;
         ACCESS_WRITE1:
            nxt_state = WAIT_FOR_READ_0;
         WAIT_FOR_READ_0:
            nxt_state = WAIT_FOR_READ_1;
         WAIT_FOR_READ_1:
            nxt_state = WAIT_FOR_READ_2;
         WAIT_FOR_READ_2:
            nxt_state = WAIT_FOR_READ_3;
         WAIT_FOR_READ_3:
            nxt_state = INIT;
         SET_DONE:
            nxt_state = INIT;
         ACCESS_READ_0:
            nxt_state = ACCESS_READ_1;
         ACCESS_READ_1:
            nxt_state = ACCESS_READ_2;
         ACCESS_READ_2:
            nxt_state = ACCESS_READ_3;
         ACCESS_READ_3:
            nxt_state = WAIT_FOR_WRITE_0;
         WAIT_FOR_WRITE_0:
            nxt_state = WAIT_FOR_WRITE_1;
         WAIT_FOR_WRITE_1:
            nxt_state = WAIT_FOR_WRITE_2;
         WAIT_FOR_WRITE_2:
            nxt_state = WAIT_FOR_WRITE_3;
         WAIT_FOR_WRITE_3:
            nxt_state = (wr) ? INIT : ACCESS_WRITE;
         
         default: nxt_state = INIT;
      endcase
   end

endmodule
