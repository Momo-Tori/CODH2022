`timescale 1ns / 1ps
module IPSource_256_16_Sim( );
reg [7:0]a;
reg [15:0]wd;
wire [15:0]OutBlkWF;
wire [15:0]OutBlkRF;
wire [15:0]OutDis;
reg we,clk;
initial
begin
    a=0;wd=0;we=1;
begin
#5  a=0;wd=10;
#5  a=0;wd=10;
#5  a=0;wd=40;
#5  a=20;wd=40;
#5  a=20;wd=114514;
#5  a=20;wd=114514;
#5  a=20;wd=1919810;
#5  a=20;wd=1919810;
#6  a=21;wd=1919810;
end
end

initial begin
    clk=0;
    forever #1 clk=~clk;
end

blk_mem_256_16 blk_mem_256_16(clk,1,we,a,wd,OutBlkWF);
blk_mem_gen_256_16_RF blk_mem_gen_256_16_RF(clk,1,we,a,wd,OutBlkRF);
dist_mem_256_16 dist_mem_256_16(a,wd,clk,we,OutDis);
endmodule