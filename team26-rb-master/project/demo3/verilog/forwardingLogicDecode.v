/*
   CS/ECE 552 Spring '20
  
   Filename        : forwardingLogicDecode.v
   Description     : This module instantiates the logic for forwarding within DECODE (D to D).
*/

module forwardingLogicDecode(DX_writeSetInDecode, XM_writeEn, XM_memRead, FD_regRs, 
                             DX_regRd, XM_regRd, FD_instr, stall_D_FWD, regRsData,
                             FD_regRsData, DX_regRdData, XM_regRdData);

   // Module Input / Output
   input DX_writeSetInDecode, XM_writeEn, XM_memRead;
   input [2:0] FD_regRs, DX_regRd, XM_regRd;
   input [15:0] FD_instr, FD_regRsData, DX_regRdData, XM_regRdData;
   output stall_D_FWD;
   output [15:0] regRsData;

   // Intermediate Variables
   reg FD_readRsReq; // applies only for reads NEEDED in decode

   // Read Rs Required Logic
   always @ (*) begin
      casex (FD_instr[15:11])
         5'b011xx: FD_readRsReq = 1; // branches
         default: FD_readRsReq = 0;
      endcase
   end

   // Stall Condition
   assign stall_D_FWD = ((FD_regRs === DX_regRd) & ~DX_writeSetInDecode & FD_readRsReq) |
                        ((FD_regRs === XM_regRd) & XM_writeEn & XM_memRead & FD_readRsReq) ? 1 : 0;

   assign regRsData = ((FD_regRs === DX_regRd) & DX_writeSetInDecode & FD_readRsReq) ? DX_regRdData :
                      ((FD_regRs === XM_regRd) & XM_writeEn & ~XM_memRead & FD_readRsReq) ? XM_regRdData : FD_regRsData; 
                       
                   
 endmodule
