/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (memDataOut, writeRegDataExecute, memRead_CNTRL, writeRegSel, writeRegData, 
           writeRegEn, writeRegSelDecode, writeEnDecode);

   // TODO: Your code here

   // Module Input/Output Variables   
   input memRead_CNTRL, writeEnDecode;
   input [2:0] writeRegSelDecode;
   input [15:0] memDataOut, writeRegDataExecute;
   output writeRegEn;
   output [2:0] writeRegSel;
   output [15:0] writeRegData;

   // Memory Output Logic
   assign writeRegData = (memRead_CNTRL) ? memDataOut : writeRegDataExecute;  
   assign writeRegSel = writeRegSelDecode;
   assign writeRegEn = writeEnDecode;

endmodule
