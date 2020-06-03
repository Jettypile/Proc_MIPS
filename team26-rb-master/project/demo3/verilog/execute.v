/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (ALUInA, ALUInB, writeSetInDecode, writeRegDataDecode, JSelExecute_CNTRL,
                JaddrExecute, ALU_output, instr_op_ext, 
                writeRegDataExecute, memWriteEn_CNTRL, memRead_CNTRL, flush_FD_X, flush_DX_X);

   // TODO: Your code here
   
   // Module Input/Output Instantiation
   input writeSetInDecode;
   input [6:0] instr_op_ext; // opcode + op extension (last 2 bits)
   input [15:0] writeRegDataDecode, ALUInA, ALUInB;
   output JSelExecute_CNTRL, flush_FD_X, flush_DX_X;
   output [15:0] ALU_output, JaddrExecute, writeRegDataExecute;
   output reg memWriteEn_CNTRL, memRead_CNTRL;

   // Intermediate Variables
   wire SEQ_CNTRL, SLT_CNTRL, SLE_CNTRL, SCO_CNTRL;
   wire SetInstr_out_eq, SetInstr_out_lt, SetInstr_out_le, SetInstr_out_sco, SetInstr_out;
   wire [15:0] BTR_out;
   reg [15:0] writeRegDataX_intr;
   wire ALU_Cin_CNTRL, ALU_invA_CNTRL, ALU_invB_CNTRL, ALU_sign_CNTRL;
   wire [2:0] ALU_Op_CNTRL;
   wire ZeroFlg, OflFlg, NegFlg, SCOFlg;

   // Jump Register Addr Logic
   assign JSelExecute_CNTRL = ~(|instr_op_ext[6:5]) & instr_op_ext[4] & instr_op_ext[2];
   assign JaddrExecute = ALU_output;

   // Set Control Signals
   assign SEQ_CNTRL = &instr_op_ext[6:4] & ~(|instr_op_ext[3:2]); // 11100
   assign SLT_CNTRL = &instr_op_ext[6:4] & ~instr_op_ext[3] & instr_op_ext[2]; // 11101
   assign SLE_CNTRL = &instr_op_ext[6:3] & ~instr_op_ext[2]; // 11110
   assign SCO_CNTRL = &instr_op_ext[6:2]; // 11111

   // R-Format Set Instruction Logic
   assign SetInstr_out_eq = SEQ_CNTRL & ZeroFlg;
   assign SetInstr_out_lt = SLT_CNTRL & NegFlg;
   assign SetInstr_out_le = SLE_CNTRL & (NegFlg | ZeroFlg);
   assign SetInstr_out_sco = SCO_CNTRL & SCOFlg;
   assign SetInstr_out = SetInstr_out_eq | SetInstr_out_lt | SetInstr_out_le | SetInstr_out_sco;

   // BTR Instruction Logic
   assign BTR_out = {ALUInA[0], ALUInA[1], ALUInA[2], ALUInA[3], ALUInA[4], ALUInA[5], ALUInA[6], ALUInA[7], ALUInA[8], ALUInA[9], ALUInA[10], ALUInA[11], ALUInA[12], ALUInA[13], ALUInA[14], ALUInA[15]};


   // ALU Instantiation
   alu ALU_Inst(.InA(ALUInA), .InB(ALUInB), .Cin(ALU_Cin_CNTRL), .Op(ALU_Op_CNTRL), .invA(ALU_invA_CNTRL), 
                .invB(ALU_invB_CNTRL), .sign(ALU_sign_CNTRL), .Out(ALU_output), 
                .Zero(ZeroFlg), .Ofl(OflFlg), .Neg(NegFlg), .GenCOut(SCOFlg));

   // ALU CNTRL Logic
   aluOpCntrl ALUOpCNTRL_Inst(.instr_op_ext(instr_op_ext), .ALU_Cin_CNTRL(ALU_Cin_CNTRL), 
                              .ALU_invA_CNTRL(ALU_invA_CNTRL), .ALU_invB_CNTRL(ALU_invB_CNTRL), 
                              .ALU_sign_CNTRL(ALU_sign_CNTRL), .ALU_Op_CNTRL(ALU_Op_CNTRL));
   
   // Execute Register Write Logic
   always @ (*) begin
      casex (instr_op_ext[6:2])
         5'b11001: writeRegDataX_intr = BTR_out; // BTR
         5'b111xx: writeRegDataX_intr = {15'b0, SetInstr_out}; // for Set Instr
         default: writeRegDataX_intr = ALU_output;
      endcase
   end

   assign writeRegDataExecute = (writeSetInDecode) ? writeRegDataDecode : writeRegDataX_intr;

   // Mem Write Control Logic
   always @ (*) begin
      case (instr_op_ext[6:2])
         5'b10000: memWriteEn_CNTRL = 1'b1;
         5'b10011: memWriteEn_CNTRL = 1'b1;
         default: memWriteEn_CNTRL = 1'b0;
      endcase
   end

   // Mem Read Control Logic
   always @ (*) begin
      case (instr_op_ext[6:2])
         5'b10001: memRead_CNTRL = 1'b1;
         default: memRead_CNTRL = 1'b0;
      endcase
   end

   // Pipeline Control Logic Signals
   assign flush_FD_X = (JSelExecute_CNTRL) ? 1 : 0;
   assign flush_DX_X = (JSelExecute_CNTRL) ? 1 : 0;

endmodule
