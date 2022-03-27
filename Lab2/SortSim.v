`timescale 1ns / 1ps
module sortSim( );
reg[15:0] in;
wire [3:0] out;
initial begin
in=0;
forever
#1 in=in+1;
end
encoder_16bits encoder_16bits(in,out);
endmodule