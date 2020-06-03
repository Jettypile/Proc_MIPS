/*
   CS/ECE 552, Spring '20

   This module incorporates the large Case Statement
   required to output the ALU Cntrl Signals.
*/

module aluOpCntrl(instr_op_ext, ALU_Cin_CNTRL, ALU_invA_CNTRL, ALU_invB_CNTRL, ALU_sign_CNTRL, ALU_Op_CNTRL);

   // Module Input/Output Variables
   input [6:0] instr_op_ext;
   output reg ALU_Cin_CNTRL, ALU_invA_CNTRL, ALU_invB_CNTRL, ALU_sign_CNTRL;
   output reg [2:0] ALU_Op_CNTRL;

   // ALU Control Case Statement
   always @ (*) begin
      casex (instr_op_ext)
         7'b01001xx: begin // SubI Imm - Rs
            ALU_Cin_CNTRL = 1'b1;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b1;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b1101101: begin // Sub Rt - Rs
            ALU_Cin_CNTRL = 1'b1;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b1;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b11100xx: begin // Sub Rs - Rt (Set Instr)
            ALU_Cin_CNTRL = 1'b1;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b1;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b11101xx: begin // Sub Rs - Rt (Set Instr)
            ALU_Cin_CNTRL = 1'b1;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b1;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b11110xx: begin // Sub Rs - Rt (Set Instr)
            ALU_Cin_CNTRL = 1'b1;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b1;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b01000xx: begin // Add Rs + Imm
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b1000xxx: begin // Add Rs + Imm (St and Ld)
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b10011xx: begin // Add Rs + Imm (Stu)
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b1000xxx: begin // Add Rs + Imm (St and Ld)
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b1101100: begin // Add Rs + Rt 
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b11111xx: begin // Add Rs + Rt (SCO Set Instr)
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b01011xx: begin // ANDNI
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b101;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b1;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101111: begin // ANDN
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b101;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b1;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b01010xx: begin // XORI
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b111;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101110: begin // XOR
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b111;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b10100xx: begin // ROLI
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b000;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101000: begin // ROL
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b000;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b10101xx: begin // SLLI
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b001;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101001: begin // SLL
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b001;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b10110xx: begin // RORI
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b010;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101010: begin // ROR
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b010;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b10111xx: begin // SRL
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b011;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b1101011: begin // SRL
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b011;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b0;
         end
         7'b001x1xx: begin // JALR and JR
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         7'b10011xx: begin // STU
            ALU_Cin_CNTRL = 1'b0;
            ALU_Op_CNTRL = 3'b100;
            ALU_invA_CNTRL = 1'b0;
            ALU_invB_CNTRL = 1'b0;
            ALU_sign_CNTRL = 1'b1;
         end
         default: begin 
            ALU_Cin_CNTRL = 1'bx;
            ALU_Op_CNTRL = 3'bx;
            ALU_invA_CNTRL = 1'bx;
            ALU_invB_CNTRL = 1'bx;
            ALU_sign_CNTRL = 1'bx;
         end
      endcase
   end

endmodule
