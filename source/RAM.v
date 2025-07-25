`timescale 1ns / 1ps
module RAM(
  input[5:0] wptr,rptr,
  input writeEnable,readEnable,
  input clkw,clkr,
  input resetw,resetr,//synchronous reset
  input [31:0] wd,
  output reg [31:0] rd);
  reg [31:0] ram[31:0];//depth 32 and each word size for now is 32
  
  //write side of the dual input RAM
  always @(posedge clkw) begin
    if(resetw) begin
      ram[wptr]<=31'd0;//if reset empty RAM wptr ??
     end
    else begin
      if (writeEnable) begin
        ram[wptr]<=wd;//store wd data at the wptr address
      end
    end
  end
  
  //read side of the dual input RAM
  always @(posedge clkr) begin
    if(resetr) begin
      rd<=31'd0;//if reset the rd should read 0?
    end
    else begin
      if(readEnable) begin
        rd<=ram[rptr];
      end//read enable =empty+read if empty contoller sends signal to the receiver and if read(0) then receiver will ignore the given rd value
    end 
  end
endmodule


  

    
