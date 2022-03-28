`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 12:08:47
// Design Name: 
// Module Name: temp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module temp(

    );
    reg CLK100MHZ;
reg [32:0] hexplay_cnt=0;
reg CG,CF,CE,CD,CC,CB,CA;
reg [7:0]AN;
reg  [23:0]SegD;//六个数码管的十六进制形式
wire [7:0]Segout[5:0];//六个数码管的十六进制转化为Seg对应灯管亮起的信号

HexToSeg HexToSeg0 (SegD[3:0],Segout[0]);
HexToSeg HexToSeg1 (SegD[7:4],Segout[1]);
HexToSeg HexToSeg2 (SegD[11:8],Segout[2]);
HexToSeg HexToSeg3 (SegD[15:12],Segout[3]);
HexToSeg HexToSeg4 (SegD[19:16],Segout[4]);
HexToSeg HexToSeg5 (SegD[23:20],Segout[5]);
initial hexplay_cnt=0;
always@(posedge CLK100MHZ) begin
if(hexplay_cnt==1)
hexplay_cnt<=0;
else
hexplay_cnt <=1;
end

initial begin//初始化
    AN=1;
end
always@(posedge CLK100MHZ) begin
	if (hexplay_cnt == 0)begin
		if (AN == 8'b10000000)
			AN <= 1;
		else
			AN <= AN << 1;
	end
end
always@(*) begin
	case(AN)
		8'b00000001: {CG,CF,CE,CD,CC,CB,CA} =Segout[0];
		8'b00000010: {CG,CF,CE,CD,CC,CB,CA} =Segout[1];
		8'b00000100: {CG,CF,CE,CD,CC,CB,CA} =Segout[2];
		8'b00001000: {CG,CF,CE,CD,CC,CB,CA} =Segout[3];
		8'b00010000: {CG,CF,CE,CD,CC,CB,CA} =0;
		8'b00100000: {CG,CF,CE,CD,CC,CB,CA} =0;
		8'b01000000: {CG,CF,CE,CD,CC,CB,CA} =Segout[4];
		8'b10000000: {CG,CF,CE,CD,CC,CB,CA} =Segout[5];
        default:{CG,CF,CE,CD,CC,CB,CA}=0;
	endcase
end   
initial begin
CLK100MHZ=0;
forever #1 CLK100MHZ=~CLK100MHZ;
end
initial begin
SegD=24'hABCDEF;
#20 SegD=24'h012345;
end
endmodule
