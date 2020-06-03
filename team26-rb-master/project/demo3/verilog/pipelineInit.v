/*
   CS/ECE 552 Spring '20
  
   Filename        : pipelineInit.v
   Description     : This module instantiates IF Inputs coming from Decode (Control and B or J) and Execute (JR Instr)
*/

module pipelineInit(clk, rst, BorJDecode_CNTRL_IN, BorJSelDecode_CNTRL_IN, HaltSel_CNTRL_IN, SIIC_CNTRL_IN,
                    RTI_CNTRL_IN, JSelExecute_CNTRL_IN, disablePC_CNTRL_IN, BorJaddrDecode_IN, JaddrExecute_IN,
                    BorJDecode_CNTRL_OUT, BorJSelDecode_CNTRL_OUT, HaltSel_CNTRL_OUT, SIIC_CNTRL_OUT,
                    RTI_CNTRL_OUT, JSelExecute_CNTRL_OUT, disablePC_CNTRL_OUT, BorJaddrDecode_OUT, JaddrExecute_OUT);

   // Module Input / Output
   input clk, rst, BorJDecode_CNTRL_IN, BorJSelDecode_CNTRL_IN, HaltSel_CNTRL_IN, SIIC_CNTRL_IN;
   input RTI_CNTRL_IN, JSelExecute_CNTRL_IN, disablePC_CNTRL_IN;
   input [15:0] BorJaddrDecode_IN, JaddrExecute_IN;
   output BorJDecode_CNTRL_OUT, BorJSelDecode_CNTRL_OUT, HaltSel_CNTRL_OUT, SIIC_CNTRL_OUT;
   output RTI_CNTRL_OUT, JSelExecute_CNTRL_OUT, disablePC_CNTRL_OUT;
   output [15:0] BorJaddrDecode_OUT, JaddrExecute_OUT;

   // Intermediate Variables

   // Register Declarations
   // FROM Decode
   // dff BorJDecode_CNTRL_REG(.d(BorJDecode_CNTRL_IN), .clk(clk), .rst(rst), .q(BorJDecode_CNTRL_OUT));
   assign BorJDecode_CNTRL_OUT = BorJSelDecode_CNTRL_IN;
   // dff BorJSelDecode_CNTRL_REG(.d(BorJSelDecode_CNTRL_IN), .clk(clk), .rst(rst), .q(BorJSelDecode_CNTRL_OUT));
   assign BorJSelDecode_CNTRL_OUT = BorJSelDecode_CNTRL_IN;
   dff HaltSel_CNTRL_REG(.d(HaltSel_CNTRL_IN), .clk(clk), .rst(rst), .q(HaltSel_CNTRL_OUT));
   // dff SIIC_CNTRL_REG(.d(SIIC_CNTRL_IN), .clk(clk), .rst(rst), .q(SIIC_CNTRL_OUT));
   assign SIIC_CNTRL_OUT = SIIC_CNTRL_IN;
   // dff RTI_CNTRL_REG(.d(RTI_CNTRL_IN), .clk(clk), .rst(rst), .q(RTI_CNTRL_OUT));
   assign RTI_CNTRL_OUT = RTI_CNTRL_IN;
   // register BorJaddrDecode_REG(.In(BorJaddrDecode_IN), .Clk(clk), .Rst(rst), .Out(BorJaddrDecode_OUT));
   assign BorJaddrDecode_OUT = BorJaddrDecode_IN;

   // FROM Execute
   // dff JSelExecute_CNTRL_REG(.d(JSelExecute_CNTRL_IN), .clk(clk), .rst(rst), .q(JSelExecute_CNTRL_OUT));
   assign JSelExecute_CNTRL_OUT = JSelExecute_CNTRL_IN;
   // register JaddrExecute_REG(.In(JaddrExecute_IN), .Clk(clk), .Rst(rst), .Out(JaddrExecute_OUT));
   assign JaddrExecute_OUT = JaddrExecute_IN;

   // FROM Control
   // dff disablePC_CNTRL_REG(.d(disablePC_CNTRL_IN), .clk(clk), .rst(rst), .q(disablePC_CNTRL_OUT));
   assign disablePC_CNTRL_OUT = disablePC_CNTRL_IN;
endmodule
