/*
Purpose: This module serves as a cache controller for a direct mapped cache.
Uses an FSM.
*/

module directMap(clk, rst, enable, rd, wr, addr, dataIn, DataOut, Done, CacheHit, stall, err, cache_hit, cache_dirty, cache_valid,
                 cache_tag_out, cache_data_out, CacheEn, Comp, Write, Valid_in, Cache_index, Cache_offset, Cache_tag, Cache_data_in,
                 mem_data_out, Mem_addr, Mem_data_in, Mem_wr, Mem_rd);

   /* Module Input / Outpus */
   // Inputs 0: General Inputs from the heirarchy
   input clk, rst, enable, rd, wr;
   input [15:0] addr, dataIn; // addr[2:0] -> offset, addr[10:3] -> index, addr[15:11] -> tag

   // Outputs 0: General Outputs to the heirarchy
   output Done, CacheHit, stall, err;
   output [15:0] DataOut; 
   // Inputs 1: Outputs from the Cache Interface
   input cache_hit, cache_dirty, cache_valid;
   input [4:0] cache_tag_out;
   input [15:0] cache_data_out;

   // Outputs 1: Inputs to the Cache Interface
   output CacheEn, Comp, Write, Valid_in;
   output [7:0] Cache_index;
   output [2:0] Cache_offset;
   output [4:0] Cache_tag;
   output [15:0] Cache_data_in;

   // Inputs 2: Outputs from the Memory Interface
   input [15:0] mem_data_out;

   // Outputs 2: Inputs to the Memory Interface
   output [15:0] Mem_addr, Mem_data_in;
   output Mem_wr, Mem_rd;
   
   /* Internal Variables */
   // FSM State Names
   parameter INIT = 4'h0, LOAD = 4'h1, STORE = 4'h2, ACCESS_WRITE = 4'h3, WAIT_FOR_READ_0 = 4'h4, WAIT_FOR_READ_1 = 4'h5, 
             WAIT_FOR_READ_2 = 4'h6, WAIT_FOR_READ_3 = 4'h7, ACCESS_READ_0 = 4'h8, ACCESS_READ_1 = 4'h9, ACCESS_READ_2 = 4'ha, 
             ACCESS_READ_3 = 4'hb, WAIT_FOR_WRITE_0 = 4'hc, WAIT_FOR_WRITE_1 = 4'hd, WAIT_FOR_WRITE_2 = 4'he, WAIT_FOR_WRITE_3 = 4'hf,
             ACCESS_WRITE_1 = 5'h10;
   wire [4:0] next_state, state;
   wire done;
   wire cacheHit, cacheEn, comp, write, valid_in, mem_wr, mem_rd;
   wire [15:0] dataOut, cache_data_in, mem_addr, mem_data_in;
   wire [4:0] cache_tag;
   wire [2:0] cache_offset;
   wire [7:0] cache_index;

   // ERROR SIGNAL
   assign err = addr[0];

   // RD AND WR SIGNAL
   dff doneDFF(.d(done), .clk(clk), .rst(rst), .q(Done));

   /* Cache Controller FSM */
   // Register for storing State
   register #(5) stateRegister(.In(next_state), .Clk(clk), .Rst(rst), .Out(state));

   // Logic for Setting Outputs
   assign stall = (state === INIT) ? 0 : ~Done;

   outputsFSM setOutputs(.enable(enable), .rd(rd), .wr(wr), .state(state), .addr(addr), .dataIn(dataIn), .done(done), 
                         .cacheHit(cacheHit), .dataOut(dataOut), .cache_hit(cache_hit), .cache_dirty(cache_dirty), 
                         .cache_valid(cache_valid), .cache_tag_out(cache_tag_out), .cache_data_out(cache_data_out), 
                         .cacheEn(cacheEn), .comp(comp), .write(write), .valid_in(valid_in), .cache_index(cache_index), 
                         .cache_offset(cache_offset), .cache_tag(cache_tag), .cache_data_in(cache_data_in), 
                         .mem_data_out(mem_data_out), .mem_addr(mem_addr), .mem_data_in(mem_data_in), .mem_wr(mem_wr), 
                         .mem_rd(mem_rd));

   // Logic for Setting Next State
   nextStateFSM setNextState(.enable(enable), .rd(rd), .wr(wr), .state(state), .hit(cache_hit), .dirty(cache_dirty), .valid(cache_valid), 
                             .nxt_state(next_state));

  /* FLOP Outputs */
   // Outputs 0: General Outputs to the heirarchy
   dff cacheHitDFF(.d(cacheHit), .clk(clk), .rst(rst), .q(CacheHit));
   register dataOutReg(.In(dataOut), .Clk(clk), .Rst(rst),. Out(DataOut));

   // Outputs 1: Inputs to the Cache Interface
   dff cacheEnDFF(.d(cacheEn), .clk(clk), .rst(rst), .q(CacheEn));
   dff compDFF(.d(comp), .clk(clk), .rst(rst), .q(Comp));
   dff writeDFF(.d(write), .clk(clk), .rst(rst), .q(Write));
   dff validInDFF(.d(valid_in), .clk(clk), .rst(rst), .q(Valid_in));
   register #(8) cacheIndexReg(.In(cache_index), .Clk(clk), .Rst(rst), .Out(Cache_index));
   register #(3) cacheOffsetReg(.In(cache_offset), .Clk(clk), .Rst(rst), .Out(Cache_offset));
   register #(5) cacheTagReg(.In(cache_tag), .Clk(clk), .Rst(rst), .Out(Cache_tag));
   register cacheDataInReg(.In(cache_data_in), .Clk(clk), .Rst(rst), .Out(Cache_data_in));

   // Outputs 2: Inputs to the Memory Interface
   dff memWrDFF(.d(mem_wr), .clk(clk), .rst(rst), .q(Mem_wr));
   dff memRdDFF(.d(mem_rd), .clk(clk), .rst(rst), .q(Mem_rd));
   register memAddrReg(.In(mem_addr), .Clk(clk), .Rst(rst), .Out(Mem_addr));
   register memDataInReg(.In(mem_data_in), .Clk(clk), .Rst(rst), .Out(Mem_data_in));

endmodule
