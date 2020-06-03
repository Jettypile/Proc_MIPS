/*
   CS/ECE 552 Spring '20
  
   Filename        : pipelineDX.v
   Description     : This module instantiates all D/X Pipeline Registers.
*/
module pipelineDX(clk, rst, instr_op_ext_IN, ALUInA_IN, ALUInB_IN, writeRegDataDecode_IN, writeSetInDecode_IN, 
                  memData_IN, HaltSel_CNTRL_IN, writeEnDecode_IN, writeRegSelDecode_IN, ALUInA_OUT, ALUInB_OUT,
                  instr_op_ext_OUT, writeRegDataDecode_OUT, writeSetInDecode_OUT, memData_OUT, HaltSel_CNTRL_OUT,
                  writeEnDecode_OUT, writeRegSelDecode_OUT, flush, stall,
                  regSelRs_OUT, regSelRt_OUT, regSelRs_IN, regSelRt_IN,
                  regRsUpdate, regRtUpdate, memDataUpdate, writeDataDecodeUpdate);

   // Module Input/Output Variables
   input clk, rst, flush, stall;
   input writeSetInDecode_IN, HaltSel_CNTRL_IN, writeEnDecode_IN;
   input [2:0] writeRegSelDecode_IN, regSelRs_IN, regSelRt_IN;
   input [6:0] instr_op_ext_IN; // opcode + op extension (last 2 bits)
   input [15:0] ALUInA_IN, ALUInB_IN, writeRegDataDecode_IN, memData_IN;
   input [15:0] regRsUpdate, regRtUpdate, memDataUpdate, writeDataDecodeUpdate;
   output writeSetInDecode_OUT, HaltSel_CNTRL_OUT, writeEnDecode_OUT;
   output [2:0] writeRegSelDecode_OUT, regSelRs_OUT, regSelRt_OUT;
   output [6:0] instr_op_ext_OUT;
   output [15:0] ALUInA_OUT, ALUInB_OUT, writeRegDataDecode_OUT, memData_OUT;


   // Intermediate Variables
   wire writeSetInDecode_regIN, HaltSel_CNTRL_regIN, writeEnDecode_regIN;
   wire [2:0] writeRegSelDecode_regIN, regSelRs_regIN, regSelRt_regIN;
   wire [6:0] instr_op_ext_regIN;
   wire [15:0] ALUInA_regIN, ALUInB_regIN, writeRegDataDecode_regIN, memData_regIN;  
   wire [15:0] instr_op_ext_regOUT, writeRegSelDecode_regOUT, regSelRs_regOUT, regSelRt_regOUT;

   // Stall Conditions
   assign ALUInA_regIN = (stall) ? regRsUpdate : ALUInA_IN;
   assign ALUInB_regIN = (stall) ? regRtUpdate : ALUInB_IN;
   assign instr_op_ext_regIN = (flush | rst) ? 7'b0000100 : // set instr to NOP on reset
                               (stall) ? instr_op_ext_OUT : instr_op_ext_IN;
   assign writeRegDataDecode_regIN = (stall) ? writeDataDecodeUpdate : writeRegDataDecode_IN;
   assign writeSetInDecode_regIN = (stall) ? writeSetInDecode_OUT : writeSetInDecode_IN;
   assign memData_regIN = (stall) ? memDataUpdate : memData_IN;
   assign HaltSel_CNTRL_regIN = (stall) ? HaltSel_CNTRL_OUT : HaltSel_CNTRL_IN;
   assign writeEnDecode_regIN = (stall) ? writeEnDecode_OUT : writeEnDecode_IN;
   assign writeRegSelDecode_regIN = (stall) ? writeRegSelDecode_OUT : writeRegSelDecode_IN;
   assign regSelRs_regIN = (stall) ? regSelRs_OUT : regSelRs_IN;
   assign regSelRt_regIN = (stall) ? regSelRt_OUT : regSelRt_IN;
   
   // Register Declarations
   // FOR Forwarding Logic
   register regSelRs_REG(.In({{13{1'b0}}, regSelRs_regIN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(regSelRs_regOUT)); // 3 bits
   assign regSelRs_OUT = regSelRs_regOUT[2:0];
   register regSelRt(.In({{13{1'b0}}, regSelRt_regIN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(regSelRt_regOUT)); // 3 bits
   assign regSelRt_OUT = regSelRt_regOUT[2:0];

   // FOR EXECUTE STAGE
   register ALUInA_REG(.In(ALUInA_regIN), .Clk(clk), .Rst(rst | flush), .Out(ALUInA_OUT)); // 16 bits
   register ALUInB_REG(.In(ALUInB_regIN), .Clk(clk), .Rst(rst | flush), .Out(ALUInB_OUT)); // 16 bits

   register instr_op_ext_REG(.In({{9{1'b0}}, instr_op_ext_regIN}), .Clk(clk), .Rst(1'b0), .Out(instr_op_ext_regOUT)); // 7 bits
   assign instr_op_ext_OUT = instr_op_ext_regOUT[6:0]; 
   
   register writeRegDataDecode_REG(.In(writeRegDataDecode_regIN), .Clk(clk), .Rst(rst | flush), .Out(writeRegDataDecode_OUT)); // 16 bits
   dff writeSetInDecode_DFF(.d(writeSetInDecode_regIN), .clk(clk), .rst(rst | flush), .q(writeSetInDecode_OUT)); // 1 bit
   
   // USED IN X AND M STAGE
   register memData_REG(.In(memData_regIN), .Clk(clk), .Rst(rst | flush), .Out(memData_OUT)); // 16 bits

   // FOR MEMORY STAGE
   dff HaltSel_CNTRL_DFF(.d(HaltSel_CNTRL_regIN), .clk(clk), .rst(rst | flush), .q(HaltSel_CNTRL_OUT)); // 1 bit
   
   // FOR WRITEBACK STAGE
   dff writeEnDecode_DFF(.d(writeEnDecode_regIN), .clk(clk), .rst(rst | flush), .q(writeEnDecode_OUT)); // 1 bit
   register writeRegSelDecode_REG(.In({{13{1'b0}}, writeRegSelDecode_regIN}), 
                                  .Clk(clk), .Rst(rst | flush), .Out(writeRegSelDecode_regOUT)); // 3 bits
   assign writeRegSelDecode_OUT = writeRegSelDecode_regOUT[2:0];
   
endmodule
