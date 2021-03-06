/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (clk, rst, ALU_output, memData, 
               HaltSel_CNTRL, memWriteEn_CNTRL, memRead_CNTRL, 
               memDataOut, stall, done, cacheHit, err);

   // TODO: Your code here
   
   // Module Input/Output Instantiation
    input clk, rst, memWriteEn_CNTRL, HaltSel_CNTRL, memRead_CNTRL;
    input [15:0] ALU_output, memData;
    output stall, done, cacheHit, err;
    output [15:0] memDataOut;
    
   // Intermediate Variables 

   // Instantiate Memory
   /* memory2c DataMemory(.data_out(memDataOut), .data_in(memData), .addr(ALU_output), 
                       .enable((memWriteEn_CNTRL | memRead_CNTRL) & ~HaltSel_CNTRL), 
                       .wr(memWriteEn_CNTRL), .createdump(HaltSel_CNTRL), .clk(clk), .rst(rst)); */

   mem_system #1 DataMemory(/*AUTOARG*/
      // Outputs
      .DataOut(memDataOut), .Done(done), .Stall(stall), .CacheHit(cacheHit), .err(err), 
      // Inputs
      .Addr(ALU_output), .DataIn(memData), .Rd(memRead_CNTRL & ~HaltSel_CNTRL), .Wr(memWriteEn_CNTRL & ~HaltSel_CNTRL), .createdump(HaltSel_CNTRL), .clk(clk), .rst(rst)
      );  

endmodule
