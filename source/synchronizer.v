`timescale 1ns / 1ps
module synchronizer(
  input clk,
  input reset,
  input [5:0] otherptr,
  output reg [5:0] otherptrs
);

  reg [5:0] temp;  // to hold Gray code of otherptr
  reg [5:0] d1;
  reg [5:0] d2;

  // Binary to Gray code conversion as a function, assigned inside always block since temp is reg
  function [5:0] bin_to_gray(input [5:0] bin);
    begin
      bin_to_gray[5] = bin[5];
      bin_to_gray[4] = bin[5] ^ bin[4];
      bin_to_gray[3] = bin[4] ^ bin[3];
      bin_to_gray[2] = bin[3] ^ bin[2];
      bin_to_gray[1] = bin[2] ^ bin[1];
      bin_to_gray[0] = bin[1] ^ bin[0];
    end
  endfunction

  // Gray to Binary conversion as a function
  function [5:0] gray_to_bin(input [5:0] gray);
    integer i;
    begin
      gray_to_bin[5] = gray[5];
      for(i=4; i>=0; i=i-1)
        gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
    end
  endfunction

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      temp <= 6'd0;
      d1 <= 6'd0;
      d2 <= 6'd0;
      otherptrs <= 6'd0;
    end else begin
      temp <= bin_to_gray(otherptr);  // convert input to Gray code
      d1 <= temp;                     // first stage register of synchronizer
      d2 <= d1;                       // second stage register of synchronizer
      otherptrs <= gray_to_bin(d2);   // convert back to binary pointer after sync
    end
  end

endmodule