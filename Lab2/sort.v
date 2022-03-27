
module IP(input clk,input button,output button_edge);endmodule
module encoder_16bits(input[15:0] in,output reg [3:0] out);endmodule
module IP_BothEdge(input clk,input button,output button_edge);endmodule
module HexToSeg(input[3:0] hex,output reg [7:0] seg);endmodule
module dist_mem_256_16 (input[7:0]a,input[15:0]d,input clk,input we,input [15:0]spo);endmodule




module sort (
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
wire ifInput;//SW是否有输入
wire [3:0] code;//编码

genvar j;//声明的此变量只用于生成块的循环计算，在电路里面并不存在
generate
   for(j=0;j<16;j=j+1)
        begin:DP//DP为块名字，命名块
           IP_BothEdge IP_BothEdge (CLK100MHZ,SW[j],DPsw[j]);
        end
endgenerate

assign ifInput=|DPsw;//十六位取或，若为1则有输入
encoder_16bits encoder_16bits(DPsw,code);//编码

wire data;
wire addr;
wire del;
wire chk;
wire run;
wire rstn;
IP IP1(CLK100MHZ,BTNC,data);
IP IP2(CLK100MHZ,BTNU,addr);
IP IP3(CLK100MHZ,BTNL,del);
IP IP4(CLK100MHZ,BTNR,chk);
IP IP5(CLK100MHZ,BTND,run);
IP IP6(CLK100MHZ,CPU_RESETN,rstn);

//输出部分
reg [3:0] SegData [5:0];//六个数码管的十六进制形式
wire [7:0]Segout[5:0];//六个数码管的十六进制转化为Seg对应灯管亮起的信号
genvar i;
generate
   for(i=0;i<6;i=i+1)
    begin:HexToSeg//DP为块名字，命名块
        HexToSeg HexToSeg (SegData[i],Segout[i]);
    end
endgenerate

//数码管分时复用输出
reg [32:0] hexplay_cnt;
always@(posedge CLK100MHZ) begin
	if (hexplay_cnt >= (2000000 / 8))
		hexplay_cnt <= 0;
	else
		hexplay_cnt <= hexplay_cnt + 1;
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
	endcase
end

//核心代码
parameter BEFORE=0;
parameter RUNNING=1;
parameter AFTER=2;
reg [1:0] status;
reg [15:0] D;//暂时数据
reg [7:0] Address;//当前地址
reg s;//用于判断输出
wire [15:0] spo;
dist_mem_256_16 dist_mem_256_16(Address,D,CLK100MHZ,data,spo);

//D部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) D<=0;
    else if(status[0]) D<=D;//Blocked
    else if(ifInput) D<={D[11:0],code};
    else if(del) D<=D[15:4];
    else if(data | addr) D<=0;
end

//Address部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) Address<=0;
    else if(status[0]) Address<=Address;//Blocked
    else if(chk) Address<=Address+1;
    else if(data) Address<=Address+1;
    else if(addr) Address<=D[7:0];
end

//s部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) s<=0;
    else if(status[0]) s<=s;//Blocked
    else if(chk) s<=0;
    else if(ifInput) s<=1;
    else if(del) s<=1;
    else if(data) s<=0;
    else if(addr) s<=0;
end

always @(*) begin
    {SegData[5],SegData[4]}=Address;
    if(s) {SegData[3],SegData[2],SegData[1],SegData[0]}=D;
    else {SegData[3],SegData[2],SegData[1],SegData[0]}=spo;
end

wire FIN;

//status部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=BEFORE;
    else if(run) status<=RUNNING;
    else if(FIN) status<=BEFORE;//????????????
end

endmodule