`timescale 1ns / 1ps
module read_controller (
  input resetr,
  input clkr,
  input read,
  input [5:0] wptrs,
  output reg emptyflag,
  output reg [5:0] rptr
);
  always @(posedge clkr) begin
    if (resetr)
      rptr <= 6'd0;
    else if (read)
      rptr <= rptr + 6'd1;
  end

  always @(posedge clkr) begin
    emptyflag <= (rptr == wptrs);
  end
endmodule
