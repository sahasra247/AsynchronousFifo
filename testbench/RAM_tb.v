`timescale 1ns / 1ps
module RAM_tb;
  reg [5:0] wptr,rptr;
  reg writeEnable,readEnable;
  reg clk1,clk2;
  reg resetw,resetr;
  reg [31:0] wd;
  wire [31:0] rd;
  dualInputRamFifo fifo1(wptr,rptr,writeEnable,readEnable,clk1,clk2,resetw,resetr,wd,rd);
  initial #1500 $finish;
  
  initial begin
    clk1=1'b1;
    forever #5 clk1=~clk1;
  end
  initial begin
    clk2=1'b1;
    forever #10 clk2=~clk2;
  end
  initial begin
    writeEnable=1'b1;
    readEnable=1'b0;
    resetw=1'b1;
    resetr=1'b1;
    wptr=6'd0;
    rptr=6'd0;
    wd=31'd0;
   	#5;
    resetw=0;
    resetr=0;
    #5;
    repeat (31) begin
      wptr=wptr+1;
      wd=wd+1;
    #10;
  end
    #70;
    readEnable=1'b1;
    writeEnable=1'b0;
    
    repeat (31) begin
      display;
      rptr=rptr+1;
      
    #20;
  end
  end
  task display;
    #1 $display("rptr:%0d,readdata:%0d, time:%0t",rptr ,rd,$time);
  endtask
endmodule