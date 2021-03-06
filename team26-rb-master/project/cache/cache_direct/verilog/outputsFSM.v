/*
Purpose: This module is a case statement for setting outputs to the FSM
*/

module outputsFSM(enable, rd, wr, state, addr, dataIn, done, cacheHit, dataOut, cache_hit, cache_dirty, cache_valid,
                  cache_tag_out, cache_data_out, cacheEn, comp, write, valid_in, cache_index, cache_offset, cache_tag,
                  cache_data_in, mem_data_out, mem_addr, mem_data_in, mem_wr, mem_rd);

   /* Module Input / Outpus */
   // Inputs 0: General Inputs from the heirarchy
   input enable, rd, wr;
   input [4:0] state;
   input [15:0] addr, dataIn;

   // Outputs 0: General Outputs to the heirarchy
   output reg done, cacheHit;
   output reg [15:0] dataOut;

   // Inputs 1: Outputs from the Cache Interface
   input cache_hit, cache_dirty, cache_valid;
   input [4:0] cache_tag_out;
   input [15:0] cache_data_out;

   // Outputs 1: Inputs to the Cache Interface
   output reg cacheEn, comp, write, valid_in;
   output reg [7:0] cache_index;
   output reg [2:0] cache_offset;
   output reg [4:0] cache_tag;
   output reg [15:0] cache_data_in;

   // Inputs 2: Outputs from the Memory Interface
   input [15:0] mem_data_out;

   // Outputs 2: Inputs to the Memory Interface
   output reg [15:0] mem_addr, mem_data_in;
   output reg mem_wr, mem_rd;

   /* Internal Variables */
   // FSM State Names
   parameter INIT = 4'h0, LOAD = 4'h1, STORE = 4'h2, ACCESS_WRITE = 4'h3, WAIT_FOR_READ_0 = 4'h4, WAIT_FOR_READ_1 = 4'h5, 
             WAIT_FOR_READ_2 = 4'h6, WAIT_FOR_READ_3 = 4'h7, ACCESS_READ_0 = 4'h8, ACCESS_READ_1 = 4'h9, ACCESS_READ_2 = 4'ha, 
             ACCESS_READ_3 = 4'hb, WAIT_FOR_WRITE_0 = 4'hc, WAIT_FOR_WRITE_1 = 4'hd, WAIT_FOR_WRITE_2 = 4'he, WAIT_FOR_WRITE_3 = 4'hf,
             ACCESS_WRITE_1 = 5'h10;

   /* Cache Controller FSM */
   // Logic for Setting Next State
   always @ (*) begin
      case (state)
         INIT: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = enable;
            comp = (enable & rd) | (enable & wr);
            write = enable & wr;
            valid_in = 0;
            cache_index = addr[10:3];
            cache_offset = addr[2:0];
            cache_tag = addr[15:11];
            cache_data_in = dataIn;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         LOAD: begin
            done = cache_hit & cache_valid;
            cacheHit = cache_hit & cache_valid;
            dataOut = cache_data_out;
            cacheEn = ~cache_hit & cache_valid & cache_dirty;
            comp = 0;
            write = 0;
            valid_in = 0;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b010 : 
                           (addr[2:1] === 2'b01) ? 3'b100 :
                           (addr[2:1] === 2'b10) ? 3'b110 : 3'b000;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = {addr[15:3], cache_offset};
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = ~done & ~cacheEn;
         end
         STORE: begin
            done = cache_hit & cache_valid;
            cacheHit = cache_hit & cache_valid;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = addr;
            mem_data_in = dataIn;
            mem_wr = ~done;
            mem_rd = 0;
         end
         ACCESS_WRITE: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {addr[15:3], 3'b100} : 
                       (addr[2:1] === 2'b01) ? {addr[15:3], 3'b110} :
                       (addr[2:1] === 2'b10) ? {addr[15:3], 3'b000} : {addr[15:3], 3'b010};
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 1;
         end
         ACCESS_WRITE_1: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {addr[15:3], 3'b110} : 
                       (addr[2:1] === 2'b01) ? {addr[15:3], 3'b000} :
                       (addr[2:1] === 2'b10) ? {addr[15:3], 3'b010} : {addr[15:3], 3'b100};
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 1;
         end
         WAIT_FOR_READ_0: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 1;
            valid_in = 1;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b010 : 
                           (addr[2:1] === 2'b01) ? 3'b100 :
                           (addr[2:1] === 2'b10) ? 3'b110 : 3'b000;
            cache_tag = addr[15:11];
            cache_data_in = mem_data_out;
            mem_addr = addr;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 1;
         end
         WAIT_FOR_READ_1: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 1;
            valid_in = 1;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b100 : 
                           (addr[2:1] === 2'b01) ? 3'b110 :
                           (addr[2:1] === 2'b10) ? 3'b000 : 3'b010;
            cache_tag = addr[15:11];
            cache_data_in = mem_data_out;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         WAIT_FOR_READ_2: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 1;
            valid_in = 1;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b110 : 
                           (addr[2:1] === 2'b01) ? 3'b000 :
                           (addr[2:1] === 2'b10) ? 3'b010 : 3'b100;
            cache_tag = addr[15:11];
            cache_data_in = mem_data_out;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         WAIT_FOR_READ_3: begin
            done = 1;
            cacheHit = 0;
            dataOut = mem_data_out;
            cacheEn = 1;
            comp = 0;
            write = 1;
            valid_in = 1;
            cache_index = addr[10:3];
            cache_offset = addr[2:0];
            cache_tag = addr[15:11];
            cache_data_in = mem_data_out;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         ACCESS_READ_0: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 0;
            valid_in = 1'bx;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b100 : 
                           (addr[2:1] === 2'b01) ? 3'b110 :
                           (addr[2:1] === 2'b10) ? 3'b000 : 3'b010;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {cache_tag_out, addr[10:3], 3'b010} : 
                       (addr[2:1] === 2'b01) ? {cache_tag_out, addr[10:3], 3'b100} :
                       (addr[2:1] === 2'b10) ? {cache_tag_out, addr[10:3], 3'b110} : {cache_tag_out, addr[10:3], 3'b000};
            mem_data_in = cache_data_out;
            mem_wr = 1;
            mem_rd = 0;
         end
         ACCESS_READ_1: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 0;
            valid_in = 1'bx;
            cache_index = addr[10:3];
            cache_offset = (addr[2:1] === 2'b00) ? 3'b110 : 
                           (addr[2:1] === 2'b01) ? 3'b000 :
                           (addr[2:1] === 2'b10) ? 3'b010 : 3'b100;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {cache_tag_out, addr[10:3], 3'b100} : 
                       (addr[2:1] === 2'b01) ? {cache_tag_out, addr[10:3], 3'b110} :
                       (addr[2:1] === 2'b10) ? {cache_tag_out, addr[10:3], 3'b000} : {cache_tag_out, addr[10:3], 3'b010};
            mem_data_in = cache_data_out;
            mem_wr = 1;
            mem_rd = 0;
         end
         ACCESS_READ_2: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 1;
            comp = 0;
            write = 0;
            valid_in = 1'bx;
            cache_index = addr[10:3];
            cache_offset = addr[2:0];
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {cache_tag_out, addr[10:3], 3'b110} : 
                       (addr[2:1] === 2'b01) ? {cache_tag_out, addr[10:3], 3'b000} :
                       (addr[2:1] === 2'b10) ? {cache_tag_out, addr[10:3], 3'b010} : {cache_tag_out, addr[10:3], 3'b100};
            mem_data_in = cache_data_out;
            mem_wr = 1;
            mem_rd = 0;
         end
         ACCESS_READ_3: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = {cache_tag_out, addr[10:0]};
            mem_data_in = cache_data_out;
            mem_wr = 1;
            mem_rd = 0;
         end
         WAIT_FOR_WRITE_0: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         WAIT_FOR_WRITE_1: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         WAIT_FOR_WRITE_2: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
         WAIT_FOR_WRITE_3: begin
            done = wr;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = (addr[2:1] === 2'b00) ? {addr[15:3], 3'b010} : 
                       (addr[2:1] === 2'b01) ? {addr[15:3], 3'b100} :
                       (addr[2:1] === 2'b10) ? {addr[15:3], 3'b110} : {addr[15:3], 3'b000};
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = rd;
         end
         default: begin
            done = 0;
            cacheHit = 0;
            dataOut = 16'bx;
            cacheEn = 0;
            comp = 1'bx;
            write = 1'bx;
            valid_in = 1'bx;
            cache_index = 8'bx;
            cache_offset = 3'bx;
            cache_tag = 5'bx;
            cache_data_in = 16'bx;
            mem_addr = 16'bx;
            mem_data_in = 16'bx;
            mem_wr = 0;
            mem_rd = 0;
         end
      endcase
   end

endmodule
