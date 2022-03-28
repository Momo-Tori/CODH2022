`timescale 1ns / 1ps
module temp( );
reg clk;
reg [8:0]Address;
reg[15:0]D;
reg en;
wire [15:0]spo;

always@(posedge clk)begin
Address=10;
D=30;
en=1;
end

dist_mem_256_16 dist_mem_256_16(Address,D,clk,en,spo);

initial begin
    clk=0;
    forever #1 clk=~clk;
end
endmodule