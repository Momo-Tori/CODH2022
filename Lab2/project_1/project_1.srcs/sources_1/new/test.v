module test (
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

//输出部分
reg  [23:0]SegD;//六个数码管的十六进制形式
wire [7:0]Segout[5:0];//六个数码管的十六进制转化为Seg对应灯管亮起的信号

HexToSeg HexToSeg0 (SegD[3:0],Segout[0]);
HexToSeg HexToSeg1 (SegD[7:4],Segout[1]);
HexToSeg HexToSeg2 (SegD[11:8],Segout[2]);
HexToSeg HexToSeg3 (SegD[15:12],Segout[3]);
HexToSeg HexToSeg4 (SegD[19:16],Segout[4]);
HexToSeg HexToSeg5 (SegD[23:20],Segout[5]);

reg [15:0] hexplay_cnt=0;
always@(posedge CLK100MHZ) begin
	if (hexplay_cnt >= 2000000/8)
		hexplay_cnt <= 0;
	else
		hexplay_cnt <= hexplay_cnt + 1;
end

reg [7:0]cnt;
always@(posedge CLK100MHZ) begin
	if (hexplay_cnt==0)begin
        if (cnt >= 100)
		cnt <= 0;
	else
		cnt <= cnt + 1;
	end
end

always@(posedge CLK100MHZ) begin
	if (cnt==0)begin
        SegD=SegD+{24'h111111};
end
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

assign LED=AN;

endmodule