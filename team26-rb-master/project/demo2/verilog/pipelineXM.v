/*
   CS/ECE 552 Spring '20
  
   Filename        : pipelineXM.v
   Description     : This module instantiates all X/M Pipeline Registers.
*/
module pipelineXM(clk, rst, HaltSel_CNTRL_IN, writeEnDecode_IN, memWriteEn_CNTRL_IN, memRead_CNTRL_IN,
                  writeRegSelDecode_IN, memData_IN, ALU_Output_IN, writeRegDataExecute_IN, HaltSel_CNTRL_OUT, 
                  writeEnDecode_OUT, memWriteEn_CNTRL_OUT, memRead_CNTRL_OUT, writeRegSelDecode_OUT, 
                  memData_OUT, ALU_Output_OUT, writeRegDataExecute_OUT, regSelRt_IN, regSelRt_OUT, flush);

   // Module Input/Output Variables
   input clk, rst, flush;
   input HaltSel_CNTRL_IN, writeEnDecode_IN, memWriteEn_CNTRL_IN, memRead_CNTRL_IN;
   input [2:0] writeRegSelDecode_IN, regSelRt_IN;
   input [15:0] memData_IN, ALU_Output_IN, writeRegDataExecute_IN;
   output HaltSel_CNTRL_OUT, writeEnDecode_OUT, memWriteEn_CNTRL_OUT, memRead_CNTRL_OUT;
   output [2:0] writeRegSelDecode_OUT, regSelRt_OUT;
   output [15:0] memData_OUT, ALU_Output_OUT, writeRegDataExecute_OUT;

   // Intermediate Variables
   wire [15:0] writeRegSelDecode_regOUT, regSelRt_regOUT;

   // Register Declarations
   // FOR Forwarding Logic
   register regSelRt(.In({{13{1'b0}}, regSelRt_IN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(regSelRt_regOUT)); // 3 bits
   assign regSelRt_OUT = regSelRt_regOUT[2:0];

   // FOR MEMORY carry from DECODE
   register memData_REG(.In(memData_IN), .Clk(clk), .Rst(rst | flush), .Out(memData_OUT)); // 16 bits
   dff HaltSel_CNTRL_DFF(.d(HaltSel_CNTRL_IN), .clk(clk), .rst(rst | flush), .q(HaltSel_CNTRL_OUT)); // 1 bit
   
   // FOR WRITEBACK carry from DECODE
   dff writeEnDecode_DFF(.d(writeEnDecode_IN), .clk(clk), .rst(rst | flush), .q(writeEnDecode_OUT)); // 1 bit
   register writeRegSelDecode_REG(.In({{13{1'b0}}, writeRegSelDecode_IN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(writeRegSelDecode_regOUT)); // 3 bits
   assign writeRegSelDecode_OUT = writeRegSelDecode_regOUT[2:0]; 
   
   // FOR MEMORY STAGE from EXECUTE
   register ALU_Output_REG(.In(ALU_Output_IN), .Clk(clk), .Rst(rst | flush), .Out(ALU_Output_OUT)); // 16 bits
   dff memWriteEn_CNTRL_DFF(.d(memWriteEn_CNTRL_IN), .clk(clk), .rst(rst | flush), .q(memWriteEn_CNTRL_OUT)); // 1 bit

   // FOR MEM AND WB STAGE from EXECUTE
   dff memRead_CNTRL_DFF(.d(memRead_CNTRL_IN), .clk(clk), .rst(rst | flush), .q(memRead_CNTRL_OUT)); // 1 bit

   // FOR WRITEBACK STAGE from EXECUTE
   register writeRegDataExecute_REG(.In(writeRegDataExecute_IN), .Clk(clk), .Rst(rst | flush), .Out(writeRegDataExecute_OUT)); // 16 bits
   

endmodule
