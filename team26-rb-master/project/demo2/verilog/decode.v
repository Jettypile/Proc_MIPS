/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk, rst, err, writeRegSel, writeRegData, writeRegEn, instr, PC_add_2, 
               BorJDecode_CNTRL, BorJSelDecode_CNTRL, HaltSel_CNTRL, writeEnDecode, 
               writeRegDataDecode, writeRegSelDecode, BorJaddrDecode, ALUInA, 
               ALUInB, instr_op_ext, memData, writeSetInDecode, SIIC_CNTRL, RTI_CNTRL,
               flush_FD_D, disablePC_D, regSelRs, regSelRt, reg1Data_fwd);

   // TODO: Your code here

   // Module Input/Output Variables
   input clk, rst, err, writeRegEn;
   input [15:0] writeRegData, instr, PC_add_2, reg1Data_fwd;
   input [2:0] writeRegSel;
   output BorJDecode_CNTRL, BorJSelDecode_CNTRL, HaltSel_CNTRL, SIIC_CNTRL, RTI_CNTRL, flush_FD_D, disablePC_D;
   output [15:0] ALUInA;
   output [6:0] instr_op_ext; // opcode + last 2 bit extension of rformat instr
   output reg writeEnDecode, writeSetInDecode;
   output reg [15:0] writeRegDataDecode, BorJaddrDecode, ALUInB;
   output reg [2:0] writeRegSelDecode;
   output [2:0] regSelRs, regSelRt;
   output [15:0] memData;

   // Intermediate Variables
   wire [15:0] reg1Data, reg2Data;
   wire [15:0] immZeroExtIform1, immSignExtIform1, immSignExtIform2, immSignExtJump;
   wire beq_sig, blt_sig, SIIC_Rs_Valid;
   reg take_branch;

   // Write Register Select Logic in Decode
   always @ (*)  begin
      casex (instr[15:11])
         5'b010xx: begin writeRegSelDecode = instr[7:5]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Iform1
         5'b101xx: begin writeRegSelDecode = instr[7:5]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Iform1
         5'b10001: begin writeRegSelDecode = instr[7:5]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Iform1
         5'b11000: begin writeRegSelDecode = instr[10:8]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Iform2
         5'b1001x: begin writeRegSelDecode = instr[10:8]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // STU and Iform2
         5'b11001: begin writeRegSelDecode = instr[4:2]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // BTR
         5'b1101x: begin writeRegSelDecode = instr[4:2]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Rform
         5'b111xx: begin writeRegSelDecode = instr[4:2]; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // Rform
         5'b0011x: begin writeRegSelDecode = 3'b111; writeEnDecode = 1'b1 & ~HaltSel_CNTRL; end // JAL(R)
         default: begin writeRegSelDecode = 3'bxxx; writeEnDecode = 1'b0; end // No write op
      endcase
   end

   // Write Data Logic in Decode
   always @ (*) begin
      casex (instr[15:11]) 
         5'b0011x: begin writeRegDataDecode = PC_add_2; writeSetInDecode = 1'b1; end// JAL(R)
         5'b11000: begin writeRegDataDecode = immSignExtIform2; writeSetInDecode = 1'b1; end// LBI
         5'b10010: begin writeRegDataDecode = {reg1Data[7:0], instr[7:0]}; writeSetInDecode = 1'b1; end// SLBI
         default: begin writeRegDataDecode = 16'bx; writeSetInDecode = 1'b0; end
      endcase
   end

   // Branch Comparisions
   assign beq_sig = ~(|reg1Data_fwd);
   assign blt_sig = reg1Data_fwd[15];
   always @ (*) begin
      case (instr[12:11])
         2'b00: take_branch = beq_sig;
         2'b01: take_branch = ~beq_sig;
         2'b10: take_branch = blt_sig;
         2'b11: take_branch = ~blt_sig;
         default: take_branch = 1'b0;
      endcase
   end

   // Branch or Jump Addr in Decode Stage Logic
   always @ (*) begin
      casex (instr[15:11]) 
         5'b001x0: BorJaddrDecode = PC_add_2 + immSignExtJump; // jump
         5'b011xx: BorJaddrDecode = PC_add_2 + immSignExtIform2; // branch
         default: BorJaddrDecode = 16'bx;
      endcase
   end

   // Immediate Sign/Zero Extension
   assign immZeroExtIform1 = {11'b0, instr[4:0]};
   assign immSignExtIform1 = {{11{instr[4]}}, instr[4:0]};
   assign immSignExtIform2 = {{8{instr[7]}}, instr[7:0]};
   assign immSignExtJump = {{5{instr[10]}}, instr[10:0]};

   // Instatiate Register File
   assign regSelRs = instr[10:8];
   assign regSelRt = instr[7:5];
   regFile_bypass registerFile(.clk(clk), .rst(rst), .err(err), .read1Data(reg1Data), .read2Data(reg2Data), .read1RegSel(instr[10:8]), .read2RegSel(instr[7:5]), 
                        .writeRegSel(writeRegSel), .writeData(writeRegData), .writeEn(writeRegEn)); 

   // ALU Input Muxes and Mem Data for Stores
   assign memData = reg2Data;
   assign ALUInA = reg1Data;
   always @ (*) begin
      casex (instr[15:11])
         5'b0101x: ALUInB = immZeroExtIform1; // Logical I format 1
         5'b1101x: ALUInB = reg2Data; // R format
         5'b111xx: ALUInB = reg2Data; // R format
         5'b001x1: ALUInB = immSignExtIform2; // I format 2 JR and JALR
         default: ALUInB = immSignExtIform1; // I format 1 SE Cases (Arith and Load/Store)
      endcase
   end

   // CNTRL Signal Decoding
   assign BorJSelDecode_CNTRL = ~instr[15] & instr[13] & (~instr[14] | take_branch);
   assign BorJDecode_CNTRL = ~instr[15] & instr[13] & (instr[14] | ~instr[11]);
   assign HaltSel_CNTRL = (rst) ? 0 : ~(|instr[15:11]); // 00000 => HALT
   // assign SIIC, RTI Control
   assign SIIC_Rs_Valid = ~(reg1Data === 3'bxxx);
   assign SIIC_CNTRL = (rst) ? 0 : ~(|instr[15:13]) & instr[12] & ~instr[11] & SIIC_Rs_Valid;
   assign RTI_CNTRL = (rst) ? 0 : ~(|instr[15:13]) & &instr[12:11];
   assign instr_op_ext = {instr[15:11], instr[1:0]};

   // Pipeline Control Logic Signals
   // Flush FD Cases
   assign flush_FD_D = (BorJSelDecode_CNTRL & BorJaddrDecode !== PC_add_2) ? 1 :
                       (HaltSel_CNTRL) ? 1 : 
                       (SIIC_CNTRL) ? 1 : 
                       (RTI_CNTRL) ? 1 : 0;
   // assign haltFlush_FD_D = HaltSel_CNTRL;

   // Disable PC Cases
   assign disablePC_D = (HaltSel_CNTRL) ? 1 : 0;
   
endmodule
