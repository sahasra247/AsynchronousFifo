`timescale 1ns/1ps

module read_controller_tb;
  reg resetr;
  reg clkr;
  reg read;
  reg [5:0] wptrs;
  wire emptyflag;
  wire [5:0] rptr;

  // Instantiate the readController module
  read_controller uut (
    .resetr(resetr), 
    .clkr(clkr),
    .read(read),
    .wptrs(wptrs),
    .emptyflag(emptyflag),
    .rptr(rptr)
  );

  // Clock generation - 10ns period
  initial begin
    clkr = 0;
    forever #10 clkr = ~clkr;
  end

  initial begin
    // Initialize signals
    resetr = 1'b0;
    read = 1'b0;
    wptrs = 6'd0;

    // Apply reset
    #5;
    resetr = 1'b1;
    #10;
    resetr = 1'b0;

    // wptrs = 0, rptr reset to 0, emptyflag should be 1
    #20;
    if (emptyflag !== 1) $display("Test 1 Failed: emptyflag should be 1 when rptr == wptrs");
    #10
    // Move wptrs ahead of rptr, emptyflag should be 0
    wptrs = 6'd3;
    #10;
    if (emptyflag !== 0) $display("Test 2 Failed: emptyflag should be 0 when rptr != wptrs");

    // Increment read pointer until it matches wptrs, emptyflag should go to 1
    read = 1'b1;
    repeat(4) @(posedge clkr);
    read = 1'b0;
    #5;
    if (emptyflag !== 1) $display("Test 3 Failed: emptyflag should be 1 when rptr == wptrs again");

    $display("Testbench finished");
    $stop;
  end
endmodule
