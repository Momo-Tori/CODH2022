`timescale 1ns / 1ps
module FSLTB();
reg clk;
reg [15:0] a;
reg rstn;
reg button;
wire [15:0]out;

initial
begin
a=1;
#640 a=2;
#40 a=3;
end

initial
begin
rstn=0;
#5 rstn=1;
#600 rstn=0;
#5 rstn=1;
end

initial
begin
button=1;
forever #35 button=~button;
end

initial
begin
clk=0;
forever
#1 clk=~clk;
end


fls2 fls2(clk,a,rstn,button,out);
endmodule
