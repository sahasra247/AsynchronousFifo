`timescale 1ns / 1ps

module write_controller (
  input resetw,
  input clkw,
  input write,
  input [5:0] rptrs,
  output reg fullflag,
  output reg [5:0] wptr
);
  always @(posedge clkw) begin
    if (resetw)
      wptr <= 6'd0;
    else if (write)
      wptr <= wptr + 6'd1;
  end

  always @(posedge clkw) begin
    fullflag <= ({~wptr[5], wptr[4:0]} == rptrs);
  end
endmodule
