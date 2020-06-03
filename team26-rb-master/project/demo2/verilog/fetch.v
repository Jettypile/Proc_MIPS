/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (clk, rst, PC_add_2, instr, BorJDecode_CNTRL, BorJSelDecode_CNTRL, JSelExecute_CNTRL, 
              HaltSel_CNTRL, BorJaddrDecode, JaddrExecute, SIIC_CNTRL, RTI_CNTRL, disablePC_CNTRL);

   // TODO: Your code here

   // Module Input/Output Variables
   input clk, rst, HaltSel_CNTRL, BorJSelDecode_CNTRL, JSelExecute_CNTRL;
   input BorJDecode_CNTRL, SIIC_CNTRL, RTI_CNTRL, disablePC_CNTRL;
   input [15:0] BorJaddrDecode, JaddrExecute;
   output [15:0] PC_add_2, instr;

   // Intermediate Variables
   wire [15:0] PC_nxt, PC_cur;
   wire [15:0] BorJaddr;
   wire [15:0] set_EPC, EPC_reg;

   // PC Register
   register PC_reg(.In(PC_nxt), .Clk(clk), .Rst(rst), .Out(PC_cur));   

   // PC + 2 Adder
   cla_16b NxtPCAdder(.A(PC_cur), .B(16'b10), .C_in(1'b0), .S(PC_add_2), .C_out());

   // Mux for selecting branch or jump address from different stages
   assign BorJaddr = (BorJDecode_CNTRL) ? BorJaddrDecode : JaddrExecute;

   // PC Branch/Jump, SIIC, RTI, HALT Mux
   assign PC_nxt = (disablePC_CNTRL) ? PC_cur : 
                   (SIIC_CNTRL) ? 16'h2 : 
                   (RTI_CNTRL) ? EPC_reg : 
                   ((BorJSelDecode_CNTRL & BorJaddr !== PC_cur) | JSelExecute_CNTRL) ? BorJaddr : PC_add_2;

   // Instantiate Instruction Memory
   memory2c IM(.data_out(instr), .data_in(), .addr(PC_cur), .enable(~HaltSel_CNTRL), 
               .wr(1'b0), .createdump(HaltSel_CNTRL), .clk(clk), .rst(rst));
   
   // EPC Register Instantiation
   register EPC(.In(set_EPC), .Clk(clk), .Rst(rst), .Out(EPC_reg));

   // EPC Input Logic
   assign set_EPC = (SIIC_CNTRL) ? PC_add_2 : EPC_reg;

endmodule
