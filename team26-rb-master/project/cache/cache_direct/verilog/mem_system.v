/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   /* Internal Variables */
   wire err_directmap, err_cache, err_mem;
   wire cache_hit, cache_dirty, cache_valid, cacheEn, comp, write, valid_in, mem_wr, mem_rd, stall_mem;
   wire [2:0] cache_offset;
   wire [3:0] busy_mem;
   wire [4:0] cache_tag_out, cache_tag_in;
   wire [7:0] cache_index;
   wire [15:0] cache_data_out, cache_data_in, mem_data_out, mem_addr, mem_data_in;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_tag_out),
                          .data_out             (cache_data_out),
                          .hit                  (cache_hit),
                          .dirty                (cache_dirty),
                          .valid                (cache_valid),
                          .err                  (err_cache),
                          // Inputs
                          .enable               (cacheEn),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cache_tag_in),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (stall_mem),
                     .busy              (busy_mem),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));

   
   // your code here
   directMap cacheController(.clk(clk), .rst(rst), .enable(Rd | Wr), .rd(Rd), .wr(Wr), .addr(Addr), .dataIn(DataIn), .Done(Done),
                             .DataOut(DataOut), 
                             .CacheHit(CacheHit), .stall(Stall), .err(err_directmap), .cache_hit(cache_hit), .cache_dirty(cache_dirty), 
                             .cache_valid(cache_valid), .cache_tag_out(cache_tag_out), .cache_data_out(cache_data_out), 
                             .CacheEn(cacheEn), .Comp(comp), .Write(write), .Valid_in(valid_in), .Cache_index(cache_index), 
                             .Cache_offset(cache_offset), .Cache_tag(cache_tag_in), .Cache_data_in(cache_data_in), 
                             .mem_data_out(mem_data_out), .Mem_addr(mem_addr), .Mem_data_in(mem_data_in), .Mem_wr(mem_wr), 
                             .Mem_rd(mem_rd));

   assign err = err_directmap | err_mem | err_cache;
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
