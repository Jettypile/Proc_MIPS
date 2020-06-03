/*
   CS/ECE 552 Spring '20
  
   Filename        : pipelineFD.v
   Description     : This module instantiates all IF/D Pipeline Registers.
*/
module pipelineFD(clk, rst, PC_add_2_IN, PC_add_2_OUT, instr_IN, instr_OUT, flush, stall, err, err_out);

   // Module Input/Output Variables
   input clk, rst, flush, stall, err;
   input [15:0] PC_add_2_IN, instr_IN;
   output err_out;
   output [15:0] PC_add_2_OUT, instr_OUT;

   // Intermediate Variables
   wire [15:0] instr_regIN, PC_add_2_regIN;

   // Register Declarations
   wire err_in;
   assign err_in = (stall) ? err_out : err;
   // Error
   dff errDFF(.d(err_in), .clk(clk), .rst(rst), .q(err_out));

   // FOR DECODE
   register PC_add_2_REG(.In(PC_add_2_regIN), .Clk(clk), .Rst(rst | flush), .Out(PC_add_2_OUT));
   register instr_REG(.In(instr_regIN), .Clk(clk), .Rst(1'b0), .Out(instr_OUT));

   // Flush and Stall Signals to NOP
   // on reset change instr to be NOP instead of all zeroes --> implies HALT
   assign instr_regIN = (flush | rst) ? 16'b0000100000000000 : 
                        (stall) ? instr_OUT : instr_IN;
   assign PC_add_2_regIN = (stall) ? PC_add_2_OUT : PC_add_2_IN;

endmodule
