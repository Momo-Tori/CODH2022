module sortDownload (
    input [15:0] SW,
    input CLK100MHZ,
    output [15:0]LED,
    output LED16_R,
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,
    output reg CF,
    output reg CG,
    output reg [7:0] AN,
    input CPU_RESETN,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND
);
//输入部分
wire [15:0] DPsw;
genvar j;//声明的此变量只用于生成块的循环计算，在电路里面并不存在
generate
   for(j=0;j<16;j=j+1)
        begin:DP//DP为块名字，命名块
           IP_BothEdge IP_BothEdge (CLK100MHZ,SW[j],DPsw[j]);
        end
endgenerate

wire data;
wire addr;
wire del;
wire chk;
wire run;
IP IP1(CLK100MHZ,BTNC,data);
IP IP2(CLK100MHZ,BTNU,addr);
IP IP3(CLK100MHZ,BTNL,del);
IP IP4(CLK100MHZ,BTNR,chk);
IP IP5(CLK100MHZ,BTND,run);


//输出部分
wire  [23:0]SegD;//六个数码管的十六进制形式
wire [7:0]Segout[5:0];//六个数码管的十六进制转化为Seg对应灯管亮起的信号

HexToSeg HexToSeg0 (SegD[3:0],Segout[0]);
HexToSeg HexToSeg1 (SegD[7:4],Segout[1]);
HexToSeg HexToSeg2 (SegD[11:8],Segout[2]);
HexToSeg HexToSeg3 (SegD[15:12],Segout[3]);
HexToSeg HexToSeg4 (SegD[19:16],Segout[4]);
HexToSeg HexToSeg5 (SegD[23:20],Segout[5]);


//数码管分时复用输出
reg [15:0] hexplay_cnt=0;
always@(posedge CLK100MHZ) begin
	if (hexplay_cnt >= 2000000/8)
		hexplay_cnt <= 0;
	else
		hexplay_cnt <= hexplay_cnt + 1;
end

always@(posedge CLK100MHZ) begin
	if (hexplay_cnt==0)begin
        case(AN)
		8'b11111110: AN<=8'b11111101;
		8'b11111101: AN<=8'b11111011;
		8'b11111011: AN<=8'b11110111;
		8'b11110111: AN<=8'b11101111;
		8'b11101111:AN<=8'b11011111;
		8'b11011111:AN<=8'b10111111;
		8'b10111111:AN<=8'b01111111;
		8'b01111111:AN<=8'b11111110;
        default:AN<=8'b11111110;
	endcase
	end
end

always@(*) begin
	case(AN)
		8'b11111110: {CG,CF,CE,CD,CC,CB,CA} =Segout[0];
		8'b11111101: {CG,CF,CE,CD,CC,CB,CA} =Segout[1];
		8'b11111011: {CG,CF,CE,CD,CC,CB,CA} =Segout[2];
		8'b11110111: {CG,CF,CE,CD,CC,CB,CA} =Segout[3];
		8'b11101111: {CG,CF,CE,CD,CC,CB,CA} =7'b1111111;
		8'b11011111: {CG,CF,CE,CD,CC,CB,CA} =7'b1111111;
		8'b10111111: {CG,CF,CE,CD,CC,CB,CA} =Segout[4];
		8'b01111111: {CG,CF,CE,CD,CC,CB,CA} =Segout[5];
        default:{CG,CF,CE,CD,CC,CB,CA}=7'b1111111;
	endcase
end


sort sort(CLK100MHZ,CPU_RESETN,DPsw,del,addr,data,chk,run,SegD,LED16_R,LED);


endmodule