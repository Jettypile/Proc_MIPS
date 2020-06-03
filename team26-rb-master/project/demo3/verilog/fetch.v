/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (clk, rst, PC_add_2, instr, BorJDecode_CNTRL, BorJSelDecode_CNTRL, JSelExecute_CNTRL, 
              HaltSel_CNTRL, BorJaddrDecode, JaddrExecute, SIIC_CNTRL, RTI_CNTRL, disablePC_CNTRL, stall, done, cacheHit, err,
              NoAddTwo_IN, NoAddTwo_OUT, NoAddTwoExe_IN, NoAddTwoExe_OUT, BorJAddr_IN, BorJAddr_OUT);

   // TODO: Your code here

   // Module Input/Output Variables
   input clk, rst, HaltSel_CNTRL, BorJSelDecode_CNTRL, JSelExecute_CNTRL, NoAddTwo_IN, NoAddTwoExe_IN;
   input BorJDecode_CNTRL, SIIC_CNTRL, RTI_CNTRL, disablePC_CNTRL;
   input [15:0] BorJaddrDecode, JaddrExecute, BorJAddr_IN;
   output stall, done, cacheHit, err, NoAddTwo_OUT, NoAddTwoExe_OUT;
   output [15:0] PC_add_2, instr, BorJAddr_OUT;

   // Intermediate Variables
   wire [15:0] PC_nxt, PC_cur;
   wire [15:0] BorJaddr;
   wire [15:0] set_EPC, EPC_reg;

   // PC Register
   register PC_reg(.In(PC_nxt), .Clk(clk), .Rst(rst), .Out(PC_cur));   

   // PC + 2 Adder
   cla_16b NxtPCAdder(.A(PC_cur), .B(16'b10), .C_in(1'b0), .S(PC_add_2), .C_out());

   // Mux for selecting branch or jump address from different stages
   assign BorJaddr = (BorJSelDecode_CNTRL) ? BorJaddrDecode : JaddrExecute;

   // PC Branch/Jump, SIIC, RTI, HALT Mux
   assign PC_nxt = (disablePC_CNTRL) ? PC_cur :
                   (SIIC_CNTRL) ? 16'h2 : 
                   (RTI_CNTRL) ? EPC_reg : 
		   (NoAddTwo_IN | NoAddTwoExe_IN) ? BorJAddr_IN : PC_add_2;

   assign BorJAddr_OUT = (BorJSelDecode_CNTRL & BorJaddr !== PC_cur) ? BorJaddrDecode :
                         (JSelExecute_CNTRL) ? JaddrExecute : 
                         (NoAddTwo_IN | NoAddTwoExe_IN) ? BorJAddr_IN : 16'bx;
   assign NoAddTwo_OUT = (BorJSelDecode_CNTRL & BorJaddrDecode !== PC_cur) ? 1'b1 : 
                         (~disablePC_CNTRL | rst) ? 1'b0 : NoAddTwo_IN;
   assign NoAddTwoExe_OUT = (JSelExecute_CNTRL) ? 1'b1 : 
                            (~disablePC_CNTRL | rst) ? 1'b0 : NoAddTwoExe_IN;

   // Instantiate Instruction Memory
   /* memory2c IM(.data_out(instr), .data_in(), .addr(PC_cur), .enable(~HaltSel_CNTRL), 
               .wr(1'b0), .createdump(HaltSel_CNTRL), .clk(clk), .rst(rst)); */
   mem_system #0 IM(/*AUTOARG*/
      // Outputs
      .DataOut(instr), .Done(done), .Stall(stall), .CacheHit(cacheHit), .err(err), 
      // Inputs
      .Addr(PC_cur), .DataIn(), .Rd(~HaltSel_CNTRL), .Wr(1'b0), .createdump(HaltSel_CNTRL), .clk(clk), .rst(rst)
      );  

   // Instruction register
   //register instrREG(.In((rst) ? 16'h0800 : (stall) ? instr : instr_out), .Clk(clk), .Rst(1'b0), .Out(instr));

   // EPC Register Instantiation
   register EPC(.In(set_EPC), .Clk(clk), .Rst(rst), .Out(EPC_reg));

   // EPC Input Logic
   assign set_EPC = (SIIC_CNTRL) ? PC_add_2 : EPC_reg;

endmodule
