`timescale 1ns/1ps

module write_controller_tb;
  reg resentw;
  reg clkw;
  reg write;
  reg [5:0] rptrs;
  wire fullflag;
  wire [5:0] wptr;

  // Instantiate the module
  write_controller uut (
    .resetw(resentw),
    .clkw(clkw),
    .write(write),
    .rptrs(rptrs),
    .fullflag(fullflag),
    .wptr(wptr)
  );

  // Clock generation: 10ns period
  initial begin
    clkw = 0;
    forever #5 clkw = ~clkw;
  end

  initial begin
    // Initialize signals
    resentw = 0;
    write = 0;
    rptrs = 6'd0;

    // Apply reset
    #3;
    resentw = 1;
    #10;
    resentw = 0;

    // Initially, wptr=0, rptrs=0, so fullflag should be 0 (not full)
    #10;
    if (fullflag !== 1'b0)
      $display("Test 1 Failed: fullflag should be 0 when FIFO is empty");

    // Set rptrs to a value that will cause fullflag when wptr reaches next write position
    // For example, if wptr=0, then check {~wptr[5], wptr[4:0]} == rptrs for full:
    // Let's pick rptrs = 6'b100000 (bit 5 set), then wptr = 6'b000000,
    // so next wptr could be 6'b000001 or so to test.
    // Let's do a loop and watch for fullflag to toggle

    rptrs = 6'b000000; 

    // Start writing and observe fullflag when condition met
    write = 1;
    repeat(33) begin
    @(posedge clkw);  // write 33 times to increment wptr
     $display("wptr: %d time:%t",wptr,$time);
     end
    write = 0;
    #10;

    // Display results
    $display("wptr = %b", wptr);
    $display("fullflag = %b", fullflag);

    // Test if fullflag asserted correctly
    if (fullflag !== 1'b1) begin
      $display("Test 2 Failed: fullflag should be 1 when write pointer reaches condition full");
    end else begin
      $display("Test 2 Passed: fullflag asserted correctly");
    end

    $stop;
  end
endmodule
