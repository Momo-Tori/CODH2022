`timescale 1ns / 1ps
module registerSim( );
reg [4:0]ra0;
wire [31:0]rd0;
reg [4:0]ra1;
wire [31:0]rd1;
reg [4:0]wa;
reg [31:0]wd;
reg we,clk;
initial
begin
    ra0=0;ra1=0;wa=0;wd=0;we=0;
begin
#5  ra0=0;ra1=0;wa=0;wd=10;we=0;
#5  ra0=0;ra1=0;wa=0;wd=10;we=1;
#5  ra0=0;ra1=0;wa=3;wd=40;we=0;
#5  ra0=20;ra1=3;wa=3;wd=40;we=1;
#5  ra0=20;ra1=3;wa=20;wd=114514;we=0;
#5  ra0=20;ra1=20;wa=20;wd=114514;we=1;
#5  ra0=20;ra1=20;wa=21;wd=1919810;we=0;
#5  ra0=20;ra1=21;wa=21;wd=1919810;we=1;
#6  ra0=21;ra1=20;wa=21;wd=1919810;we=1;
end
end

initial begin
    clk=0;
    forever #1 clk=~clk;
end

register_file register_file(clk,ra0,ra1,rd0,rd1,wa,wd,we);
endmodule