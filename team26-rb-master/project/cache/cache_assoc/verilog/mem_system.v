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
   wire cache_err, mem_err, err_cntrl;
   wire cache1_hit, cache1_dirty, cache1_valid, cache1En, comp, write, valid_in, mem_stall; 
   wire cache2_hit, cache2_dirty, cache2_valid, cache2En, mem_wr, mem_rd;
   wire [2:0] cache_offset;
   wire [3:0] mem_busy;
   wire [4:0] cache1_tag_out, cache_tag, cache2_tag_out;
   wire [7:0] cache_index;
   wire [15:0] cache1_data_out, cache_data_in, cache2_data_out, mem_data_out, mem_addr, mem_data_in;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache1_tag_out),
                          .data_out             (cache1_data_out),
                          .hit                  (cache1_hit),
                          .dirty                (cache1_dirty),
                          .valid                (cache1_valid),
                          .err                  (cache1_err),
                          // Inputs
                          .enable               (cache1En),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cache_tag),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (cache2_tag_out),
                          .data_out             (cache2_data_out),
                          .hit                  (cache2_hit),
                          .dirty                (cache2_dirty),
                          .valid                (cache2_valid),
                          .err                  (cache2_err),
                          // Inputs
                          .enable               (cache2En),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cache_tag),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // your code here
   setAssoc cacheController(.clk(clk), .rst(rst), .enable(Rd | Wr), .rd(Rd), .wr(Wr), .addr(Addr), .dataIn(DataIn), .Done(Done), 
                            .DataOut(DataOut),
                            .CacheHit(CacheHit), .stall(Stall), .err(err_ctrl), .cache1_hit(cache1_hit), .cache1_dirty(cache1_dirty), 
                            .cache1_valid(cache1_valid), .cache1_tag_out(cache1_tag_out), .cache1_data_out(cache1_data_out), 
                            .Cache1En(cache1En), .Comp(comp), .Write(write), .Valid_in(valid_in), .Cache_index(cache_index), 
                            .Cache_offset(cache_offset), .Cache_tag(cache_tag), .Cache_data_in(cache_data_in), 
                            .cache2_hit(cache2_hit), .cache2_dirty(cache2_dirty), .cache2_valid(cache2_valid), 
                            .cache2_tag_out(cache2_tag_out), .cache2_data_out(cache2_data_out), .Cache2En(cache2En), 
                            .mem_data_out(mem_data_out), .Mem_addr(mem_addr), .Mem_data_in(mem_data_in), .Mem_wr(mem_wr), 
                            .Mem_rd(mem_rd));

   assign err = cache_err | mem_err | err_ctrl;

   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
