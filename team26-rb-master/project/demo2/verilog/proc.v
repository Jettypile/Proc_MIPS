/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   // Intermediate Variables
   // Fetch
   wire BorJDecode_CNTRL_F, BorJSelDecode_CNTRL_F, HaltSel_CNTRL_F, JSelExecute_CNTRL_F; // Inputs
   wire SIIC_CNTRL_F, RTI_CNTRL_F, disablePC_CNTRL_F; // Inputs
   wire [15:0] BorJaddrDecode_F, JaddrExecute_F; // Inputs
   wire [15:0] PC_add_2_F, instr_F; // Outputs

   // Decode
   wire [15:0] PC_add_2_D, instr_D; // Inputs
   wire BorJDecode_CNTRL_D, BorJSelDecode_CNTRL_D, HaltSel_CNTRL_D, writeEnDecode_D, writeSetInDecode_D; // Outputs
   wire SIIC_CNTRL_D, RTI_CNTRL_D; // Outputs 
   wire [15:0] ALUInA_D, ALUInB_D, writeRegDataDecode_D, BorJaddrDecode_D, memData_D; // Outputs
   wire [6:0] instr_op_ext_D; // Outputs
   wire [2:0] writeRegSelDecode_D; // Outputs
   wire flush_FD_D, disablePC_D; // flush and disable outputs
   wire [2:0] regSelRs_D, regSelRt_D;

   // Forwarding Controls (DECODE)
   wire stall_D_FWD;
   wire [15:0] ALUInA_FWD;

   // Forwarding Controls (EXECUTE)
   wire stall_X_FWD;
   wire [15:0] regRsData_FWD, regRtData_FWD, memData_FWD, writeDataDecode_FWD;

   // Execute
   wire HaltSel_CNTRL_X, writeEnDecode_X, writeSetInDecode_X; // Inputs
   wire [2:0] writeRegSelDecode_X; // Input
   wire [6:0] instr_op_ext_X; // Input
   wire [15:0] ALUInA_X, ALUInB_X, writeRegDataDecode_X, memData_X; // Inpiuts
   wire [15:0] ALU_output_X, JaddrExecute_X, writeRegDataExecute_X; // Outputs
   wire memWriteEn_CNTRL_X, memRead_CNTRL_X, JSelExecute_CNTRL_X; // Outputs
   wire flush_DX_X, flush_FD_X; // flush outputs
   wire [2:0] regSelRs_X, regSelRt_X;

   // Memory
   wire HaltSel_CNTRL_M, writeEnDecode_M, memWriteEn_CNTRL_M, memRead_CNTRL_M; // Inputs
   wire [2:0] writeRegSelDecode_M, regSelRt_M; // Input
   wire [15:0] memData_M, ALU_output_M, writeRegDataExecute_M, memData_MEM; // Inputs
   wire [15:0] memDataOut_M; // Output

   // Write Back
   wire writeEnDecode_W, memRead_CNTRL_W, HaltSel_CNTRL_W; // Inputs
   wire [2:0] writeRegSelDecode_W; // Input
   wire [15:0] writeRegDataExecute_W, memDataOut_W; // Inputs
   wire writeRegEn; // Output
   wire [2:0] writeRegSel; // Output
   wire [15:0] writeRegData; // Output
   
   // Instantiate PIPELINE INIT (Feeds into Fetch)
   pipelineInit pipelineINIT(.clk(clk), .rst(rst), .BorJDecode_CNTRL_IN(BorJDecode_CNTRL_D), 
                             .BorJSelDecode_CNTRL_IN(BorJSelDecode_CNTRL_D), .HaltSel_CNTRL_IN(HaltSel_CNTRL_W), 
                             .SIIC_CNTRL_IN(SIIC_CNTRL_D), .RTI_CNTRL_IN(RTI_CNTRL_D), 
                             .JSelExecute_CNTRL_IN(JSelExecute_CNTRL_X), .disablePC_CNTRL_IN(disablePC_D | stall_X_FWD | stall_D_FWD), 
                             .BorJaddrDecode_IN(BorJaddrDecode_D), .JaddrExecute_IN(JaddrExecute_X), 
                             .BorJDecode_CNTRL_OUT(BorJDecode_CNTRL_F), .BorJSelDecode_CNTRL_OUT(BorJSelDecode_CNTRL_F), 
                             .HaltSel_CNTRL_OUT(HaltSel_CNTRL_F), .SIIC_CNTRL_OUT(SIIC_CNTRL_F), .RTI_CNTRL_OUT(RTI_CNTRL_F), 
                             .JSelExecute_CNTRL_OUT(JSelExecute_CNTRL_F), .disablePC_CNTRL_OUT(disablePC_CNTRL_F), 
                             .BorJaddrDecode_OUT(BorJaddrDecode_F), .JaddrExecute_OUT(JaddrExecute_F));

   // Instantiate Fetch
   fetch fetch(.clk(clk), .rst(rst), .PC_add_2(PC_add_2_F), .instr(instr_F), .BorJDecode_CNTRL(BorJDecode_CNTRL_F),
         .BorJSelDecode_CNTRL(BorJSelDecode_CNTRL_F), .HaltSel_CNTRL(HaltSel_CNTRL_F), .BorJaddrDecode(BorJaddrDecode_F), 
         .JaddrExecute(JaddrExecute_F), .SIIC_CNTRL(SIIC_CNTRL_F), .RTI_CNTRL(RTI_CNTRL_F), .disablePC_CNTRL(disablePC_CNTRL_F),
         .JSelExecute_CNTRL(JSelExecute_CNTRL_F));
   
   // Instantiate PIPELINE F/D
   pipelineFD pipelineFD(.clk(clk), .rst(rst), .PC_add_2_IN(PC_add_2_F), .PC_add_2_OUT(PC_add_2_D), 
              .instr_IN(instr_F), .instr_OUT(instr_D), .flush(flush_FD_X | flush_FD_D), .stall(stall_X_FWD | stall_D_FWD));

   // Instantiate Decode
   decode decode(.clk(clk), .rst(rst), .err(err), .writeRegSel(writeRegSel), .writeRegData(writeRegData), 
                      .writeRegEn(writeRegEn), .instr(instr_D), .PC_add_2(PC_add_2_D), 
                      .BorJDecode_CNTRL(BorJDecode_CNTRL_D), .BorJSelDecode_CNTRL(BorJSelDecode_CNTRL_D), 
                      .HaltSel_CNTRL(HaltSel_CNTRL_D), .writeEnDecode(writeEnDecode_D), 
                      .writeRegDataDecode(writeRegDataDecode_D), .writeRegSelDecode(writeRegSelDecode_D),
                      .BorJaddrDecode(BorJaddrDecode_D), .ALUInA(ALUInA_D), .ALUInB(ALUInB_D), 
                      .instr_op_ext(instr_op_ext_D), .memData(memData_D), .writeSetInDecode(writeSetInDecode_D), 
                      .SIIC_CNTRL(SIIC_CNTRL_D), .RTI_CNTRL(RTI_CNTRL_D), .flush_FD_D(flush_FD_D), .disablePC_D(disablePC_D),
                      .regSelRs(regSelRs_D), .regSelRt(regSelRt_D), .reg1Data_fwd(ALUInA_FWD));

   // Instantiate Forwarding Logic for DECODE Stage (Branches)
   forwardingLogicDecode forwardingLogicDecode(.DX_writeSetInDecode(writeSetInDecode_X), .XM_writeEn(writeEnDecode_M), 
                                               .XM_memRead(memRead_CNTRL_M), .FD_regRs(regSelRs_D), 
                                               .DX_regRd(writeRegSelDecode_X), .XM_regRd(writeRegSelDecode_M),
                                               .FD_regRsData(ALUInA_D), .DX_regRdData(writeRegDataDecode_X), 
                                               .XM_regRdData(writeRegDataExecute_M), 
                                               .FD_instr(instr_D), .stall_D_FWD(stall_D_FWD), .regRsData(ALUInA_FWD));

   // Instantiate PIPELINE D/X
   pipelineDX pipelineDX(.clk(clk), .rst(rst), .instr_op_ext_IN(instr_op_ext_D), .ALUInA_IN(ALUInA_FWD), .ALUInB_IN(ALUInB_D), 
              .writeRegDataDecode_IN(writeRegDataDecode_D), .writeSetInDecode_IN(writeSetInDecode_D), 
              .memData_IN(memData_D), .HaltSel_CNTRL_IN(HaltSel_CNTRL_D), .writeEnDecode_IN(writeEnDecode_D), 
              .writeRegSelDecode_IN(writeRegSelDecode_D), .ALUInA_OUT(ALUInA_X), .ALUInB_OUT(ALUInB_X),
              .instr_op_ext_OUT(instr_op_ext_X), .writeRegDataDecode_OUT(writeRegDataDecode_X), 
              .writeSetInDecode_OUT(writeSetInDecode_X), .memData_OUT(memData_X), .HaltSel_CNTRL_OUT(HaltSel_CNTRL_X),
              .writeEnDecode_OUT(writeEnDecode_X), .writeRegSelDecode_OUT(writeRegSelDecode_X), 
              .flush(flush_DX_X), .stall(stall_X_FWD), .regRsUpdate(regRsData_FWD), .regRtUpdate(regRtData_FWD), 
              .memDataUpdate(memData_FWD), .writeDataDecodeUpdate(writeDataDecode_FWD),
              .regSelRs_OUT(regSelRs_X), .regSelRt_OUT(regSelRt_X), .regSelRs_IN(regSelRs_D), .regSelRt_IN(regSelRt_D));

   // Instantiate ForwardingLogic
   forwardingLogic forwardingLogic(.XM_memRead(memRead_CNTRL_M), .XM_writeEn(writeEnDecode_M), .MW_writeEn(writeRegEn), 
                                   .DX_regRs(regSelRs_X), .DX_regRt(regSelRt_X), .XM_regRd(writeRegSelDecode_M), 
                                   .MW_regRd(writeRegSel), 
                                   .DX_instr_op_ext(instr_op_ext_X), .DX_regRsData(ALUInA_X), .DX_regRtData(ALUInB_X), 
                                   .DX_memData(memData_X), .XM_regRdData(writeRegDataExecute_M), .MW_regRdData(writeRegData), 
                                   .DX_writeDataDecode(writeRegDataDecode_X), 
                                   .stall_X_FWD(stall_X_FWD), .regRsData(regRsData_FWD), .regRtData(regRtData_FWD), 
                                   .memData(memData_FWD), .writeDataDecode(writeDataDecode_FWD));
   // Instantiate Execute
   execute execute(.ALUInA(regRsData_FWD), .ALUInB(regRtData_FWD), .writeSetInDecode(writeSetInDecode_X), 
            .writeRegDataDecode(writeDataDecode_FWD), .JaddrExecute(JaddrExecute_X),
            .ALU_output(ALU_output_X), .instr_op_ext(instr_op_ext_X),
            .writeRegDataExecute(writeRegDataExecute_X), .memWriteEn_CNTRL(memWriteEn_CNTRL_X),
            .memRead_CNTRL(memRead_CNTRL_X), .JSelExecute_CNTRL(JSelExecute_CNTRL_X),
            .flush_FD_X(flush_FD_X), .flush_DX_X(flush_DX_X));

   // Instantiate PIPELINE X/M
   pipelineXM pipelineXM(.clk(clk), .rst(rst), .HaltSel_CNTRL_IN(HaltSel_CNTRL_X), .writeEnDecode_IN(writeEnDecode_X), 
              .memWriteEn_CNTRL_IN(memWriteEn_CNTRL_X), .memRead_CNTRL_IN(memRead_CNTRL_X),
              .writeRegSelDecode_IN(writeRegSelDecode_X), .memData_IN(memData_FWD), .ALU_Output_IN(ALU_output_X), 
              .writeRegDataExecute_IN(writeRegDataExecute_X), .HaltSel_CNTRL_OUT(HaltSel_CNTRL_M), 
              .writeEnDecode_OUT(writeEnDecode_M), .memWriteEn_CNTRL_OUT(memWriteEn_CNTRL_M), 
              .memRead_CNTRL_OUT(memRead_CNTRL_M), .writeRegSelDecode_OUT(writeRegSelDecode_M), .memData_OUT(memData_M), 
              .ALU_Output_OUT(ALU_output_M), .writeRegDataExecute_OUT(writeRegDataExecute_M), .flush(stall_X_FWD), 
              .regSelRt_IN(regSelRt_X), .regSelRt_OUT(regSelRt_M));

   // Mem to Mem Forwarding
   //assign memData_MEM = (writeRegSel === regSelRt_M & writeRegEn) ? writeRegData : memData_M;

   // Instantiate Memory
   memory memory(.clk(clk), .rst(rst), .ALU_output(ALU_output_M), .memData(memData_M), 
           .HaltSel_CNTRL(HaltSel_CNTRL_M), .memWriteEn_CNTRL(memWriteEn_CNTRL_M), .memDataOut(memDataOut_M),
           .memRead_CNTRL(memRead_CNTRL_M));

   // Instantiate PIPELINE M/WB
   pipelineMW pipelineMW(.clk(clk), .rst(rst), .writeEnDecode_IN(writeEnDecode_M), .memRead_CNTRL_IN(memRead_CNTRL_M), 
              .writeRegSelDecode_IN(writeRegSelDecode_M), .writeRegDataExecute_IN(writeRegDataExecute_M), 
              .memDataOut_IN(memDataOut_M), .HaltSel_CNTRL_IN(HaltSel_CNTRL_M), .writeEnDecode_OUT(writeEnDecode_W), .memRead_CNTRL_OUT(memRead_CNTRL_W), 
              .writeRegSelDecode_OUT(writeRegSelDecode_W), .writeRegDataExecute_OUT(writeRegDataExecute_W), 
              .memDataOut_OUT(memDataOut_W), .HaltSel_CNTRL_OUT(HaltSel_CNTRL_W));

   // Instantiate Write Back   
   wb wb(.memDataOut(memDataOut_W), .writeRegDataExecute(writeRegDataExecute_W), .memRead_CNTRL(memRead_CNTRL_W), 
       .writeRegSel(writeRegSel), .writeRegData(writeRegData), .writeRegEn(writeRegEn), 
       .writeRegSelDecode(writeRegSelDecode_W), .writeEnDecode(writeEnDecode_W));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
