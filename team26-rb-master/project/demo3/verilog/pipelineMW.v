/*
   CS/ECE 552 Spring '20
  
   Filename        : pipelineMW.v
   Description     : This module instantiates all M/W Pipeline Registers.
*/
module pipelineMW(clk, rst, writeEnDecode_IN, memRead_CNTRL_IN, writeRegSelDecode_IN, writeRegDataExecute_IN, 
                  memDataOut_IN, writeEnDecode_OUT, memRead_CNTRL_OUT, 
                  writeRegSelDecode_OUT, writeRegDataExecute_OUT, memDataOut_OUT, HaltSel_CNTRL_IN, HaltSel_CNTRL_OUT, err, err_out, flush);

   // Module Input/Output Variables
   input clk, rst, HaltSel_CNTRL_IN, err, flush;
   input writeEnDecode_IN, memRead_CNTRL_IN;
   input [2:0] writeRegSelDecode_IN;
   input [15:0] writeRegDataExecute_IN, memDataOut_IN;
   output writeEnDecode_OUT, memRead_CNTRL_OUT, HaltSel_CNTRL_OUT, err_out;
   output [2:0] writeRegSelDecode_OUT;
   output [15:0] writeRegDataExecute_OUT, memDataOut_OUT;

   // Intermediate Variables
   wire [15:0] writeRegSelDecode_regOUT;

   // Register Declarations
   // Error
   dff errDFF(.d(err), .clk(clk), .rst(rst | flush), .q(err_out));

   // FOR WB from D
   dff HaltSel_CNTRL_DFF(.d(HaltSel_CNTRL_IN), .clk(clk), .rst(rst | flush), .q(HaltSel_CNTRL_OUT)); // 1 bit
   dff writeEnDecode_DFF(.d(writeEnDecode_IN), .clk(clk), .rst(rst | flush), .q(writeEnDecode_OUT)); // 1 bit
   register writeRegSelDecode_REG(.In({{13{1'b0}}, writeRegSelDecode_IN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(writeRegSelDecode_regOUT)); // 3 bits
   assign writeRegSelDecode_OUT = writeRegSelDecode_regOUT[2:0];      
   
   // FOR WB from X
   dff memRead_CNTRL_DFF(.d(memRead_CNTRL_IN), .clk(clk), .rst(rst | flush), .q(memRead_CNTRL_OUT)); // 1 bit
   register writeRegDataExecute_REG(.In(writeRegDataExecute_IN), .Clk(clk), .Rst(rst | flush), .Out(writeRegDataExecute_OUT)); // 16 bits

   // FOR WRITEBACK from M
   register memDataOut_REG(.In(memDataOut_IN), .Clk(clk), .Rst(rst | flush), .Out(memDataOut_OUT)); // 16 bits   

endmodule
