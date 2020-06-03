/*
Purpose: This module serves as a cache controller for a set associative cache.
Uses an FSM.
*/

module setAssoc(clk, rst, enable, rd, wr, addr, dataIn, Done, DataOut, CacheHit, stall, err, cache1_hit, cache1_dirty, cache1_valid,
                 cache1_tag_out, cache1_data_out, Cache1En, Comp, Write, Valid_in, Cache_index, Cache_offset, Cache_tag, 
                 Cache_data_in, cache2_hit, cache2_dirty, cache2_valid, cache2_tag_out, cache2_data_out, Cache2En, 
                 mem_data_out, Mem_addr, Mem_data_in, Mem_wr, Mem_rd);

   /* Module Input / Outpus */
   // Inputs 0: General Inputs from the heirarchy
   input clk, rst, enable, rd, wr;
   input [15:0] addr, dataIn; // addr[2:0] -> offset, addr[10:3] -> index, addr[15:11] -> tag

   // Outputs 0: General Outputs to the heirarchy
   output Done, CacheHit, stall, err;
   output [15:0] DataOut;

   // Inputs 1: Outputs from the Cache 1 Interface
   input cache1_hit, cache1_dirty, cache1_valid;
   input [4:0] cache1_tag_out;
   input [15:0] cache1_data_out;
   input cache2_hit, cache2_dirty, cache2_valid;
   input [4:0] cache2_tag_out;
   input [15:0] cache2_data_out;

   // Outputs 1: Inputs to the Cache Interface
   output Cache1En, Cache2En, Comp, Write, Valid_in;
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
             SET_DONE = 5'h10, ACCESS_WRITE1 = 5'h11;
   wire [4:0] next_state, state;
   wire evict_cache, next_evict, victimway, next_victimway, done;
   wire cacheHit, cache1En, cache2En, comp, write, valid_in, mem_wr, mem_rd;
   wire [15:0] dataOut, cache_data_in, mem_addr, mem_data_in;
   wire [4:0] cache_tag;
   wire [2:0] cache_offset;
   wire [7:0] cache_index;

   // ERROR SIGNAL
   assign err = addr[0];

   /* Cache Controller FSM */
   // Register for storing State
   register #(5) stateRegister(.In(next_state), .Clk(clk), .Rst(rst), .Out(state));

   // FlipFlop for victimway
   assign next_victimway = (state === INIT & (enable & (rd | wr))) ? ~victimway : victimway;
   dff victimwayDFF(.d(next_victimway), .clk(clk), .rst(rst), .q(victimway));
   assign next_evict = (state === LOAD & (cache1_valid & cache2_valid)) ? victimway :
                       (state === LOAD & (cache1_valid & ~cache2_valid)) ? 1 : 
                       (state === LOAD & ~cache1_valid) ? 0 : evict_cache;
   dff evict_cacheDFF(.d(next_evict), .clk(clk), .rst(rst), .q(evict_cache));

   // Logic for Setting Outputs
   // DONE FLIP FLOP
   dff doneDFF(.d(done), .clk(clk), .rst(rst), .q(Done));

   assign stall = (state === INIT) ? 0 : ~Done;

   outputsFSM setOutputs(.enable(enable), .rd(rd), .wr(wr), .state(state), .victimway(victimway),  
                         .addr(addr), .evict_cache(evict_cache), 
                         .dataIn(dataIn), .done(done), .cacheHit(cacheHit), .dataOut(dataOut), 
                         .cache1_hit(cache1_hit), .cache1_dirty(cache1_dirty), .cache1_valid(cache1_valid), 
                         .cache1_tag_out(cache1_tag_out), .cache1_data_out(cache1_data_out), .cache2_hit(cache2_hit), 
                         .cache2_dirty(cache2_dirty), .cache2_valid(cache2_valid), 
                         .cache2_tag_out(cache2_tag_out), .cache2_data_out(cache2_data_out),
                         .cache1En(cache1En), .cache2En(cache2En), .comp(comp), .write(write), .valid_in(valid_in), 
                         .cache_index(cache_index), .cache_offset(cache_offset), .cache_tag(cache_tag), .cache_data_in(cache_data_in), 
                         .mem_data_out(mem_data_out), .mem_addr(mem_addr), .mem_data_in(mem_data_in), .mem_wr(mem_wr), 
                         .mem_rd(mem_rd));

   // Logic for Setting Next State
   nextStateFSM setNextState(.enable(enable), .rd(rd), .wr(wr), .state(state), .victimway(victimway), .hit1(cache1_hit), .dirty1(cache1_dirty), 
                             .valid1(cache1_valid), .hit2(cache2_hit), .dirty2(cache2_dirty), .valid2(cache2_valid),
                             .nxt_state(next_state));

   /* FLOP Outputs */
   // Outputs 0: General Outputs to the heirarchy
   dff cacheHitDFF(.d(cacheHit), .clk(clk), .rst(rst), .q(CacheHit));
   register dataOutReg(.In(dataOut), .Clk(clk), .Rst(rst),. Out(DataOut));

   // Outputs 1: Inputs to the Cache Interface
   dff cache1EnDFF(.d(cache1En), .clk(clk), .rst(rst), .q(Cache1En));
   dff cache2EnDFF(.d(cache2En), .clk(clk), .rst(rst), .q(Cache2En));
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
