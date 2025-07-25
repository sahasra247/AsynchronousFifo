`timescale 1ns / 1ps
`include "RAM.v"
`include "read_controller.v"
`include "write_controller.v"
`include "synchronizer.v"
module topmodule(
input         clkw,       // Write clock domain
  input         clkr,       // Read clock domain
  input         resetw,     // Write domain reset
  input         resetr,     // Read domain reset
  input         write,      // Write enable input
  input         read,       // Read enable input
  input  [31:0] wd,         // Write data input
  output [31:0] rd,         // Read data output
  output        full,       // FIFO full flag (write side)
  output        empty       // FIFO empty flag (read side)
 );
 // Internal pointers and synchronized versions
  wire [5:0] wptr;       // Write pointer in write clock domain
  wire [5:0] rptr;       // Read pointer in read clock domain

  wire [5:0] wptr_sync_rd; // Write pointer synchronized to read clock domain
  wire [5:0] rptr_sync_wr; // Read pointer synchronized to write clock domain

  // Generate write enable and read enable gated by full/empty flags
  wire writeEnable = write & ~full;
  wire readEnable  = read & ~empty;

  // Write Pointer Controller - increments wptr on write enable, reset with resetw
  write_controller write_ctrl (
    .resetw(resetw),
    .clkw(clkw),
    .write(writeEnable),
    .rptrs(rptr_sync_wr),  // synced read pointer, for full flag generation
    .fullflag(full),
    .wptr(wptr)
  );

  // Read Pointer Controller - increments rptr on read enable, reset with resetr
  read_controller read_ctrl (
    .resetr(resetr),
    .clkr(clkr),
    .read(readEnable),
    .wptrs(wptr_sync_rd),  // synced write pointer, for empty flag generation
    .emptyflag(empty),
    .rptr(rptr)
  );

  // Synchronize write pointer into read clock domain
  synchronizer sync_wptr (
    .clk(clkr),
    .reset(resetr),
    .otherptr(wptr),
    .otherptrs(wptr_sync_rd)
  );

  // Synchronize read pointer into write clock domain
  synchronizer sync_rptr (
    .clk(clkw),
    .reset(resetw),
    .otherptr(rptr),
    .otherptrs(rptr_sync_wr)
  );

  // Dual port RAM based FIFO memory instance
  // Writes at wptr in write clock domain, reads at rptr in read clock domain
  RAM fifo_mem (
    .wptr(wptr),
    .rptr(rptr),
    .writeEnable(writeEnable),
    .readEnable(readEnable),
    .clkw(clkw),
    .clkr(clkr),
    .resetw(resetw),
    .resetr(resetr),
    .wd(wd),
    .rd(rd)
  );

endmodule
