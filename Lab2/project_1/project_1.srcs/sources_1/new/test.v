module  sort22 (
  input  CLK100MHZ, 
  input  rstn,
  input [15:0]  DPsw,		//输入1位十六进制数�?
  input   del,		//删除1位十六进制数�?
  input  addr,		//设置地址
  input  data,		//修改数据
  input chk,		//查看下一�?
  input run,		//启动排序
  output reg [23:0]  SegData,
  output reg busy,		//1—正在排序，0—排序结�?
  output reg [15:0]  cnt	//排序耗费时钟周期�?
);
//状�?�声�?
parameter Init=0;
parameter PreSort=1;
parameter SmallLoop1=2;
parameter SmallLoop2=3;
parameter SmallLoop3=4;
parameter SmallLoop4=5;
parameter SmallLoop5=6;
parameter SmallLoop6=7;
parameter SmallLoopFin=8;

//输入处理
wire ifInput;//SW是否有输�?
wire [3:0] code;//编码
assign ifInput=|DPsw;//十六位取或，若为1则有输入
encoder_16bits encoder_16bits(DPsw,code);//编码

//核心代码
reg [3:0]status;
reg [15:0] D;//暂时数据
reg [7:0] Address;//当前地址
reg s;//用于判断输出
wire [15:0] spo;
reg en;
dist_mem_256_16 dist_mem_256_16(Address,D,CLK100MHZ,en,spo);

wire ifSmallLoopFin;
wire ifLoopFin;
reg [15:0]max;
reg [15:0]temp;
reg [7:0]i;//大循�?
reg [7:0]j;//小循�?

initial en=0;


//D部分
initial D=0;


//Address部分
initial Address=0;


//s部分
initial s=0;

initial SegData=0;
//sort部分
initial busy=0;
initial status=Init;
//状�??
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=Init;//初始�?
    else case (status)
        Init:if(run) status<=PreSort;//处在初始态，run信号到来时开始排�?
        PreSort:status<=SmallLoop1;
        SmallLoop1:status<=SmallLoop2;
        SmallLoop2:status<=SmallLoop3;
        SmallLoop3:status<=SmallLoop4;
        SmallLoop4:status<=SmallLoop5;
        SmallLoop5:if(1)status<=SmallLoop6;else status<=SmallLoop2;
        SmallLoop6:status<=SmallLoopFin;
        SmallLoopFin:if(1)begin status<=Init;busy<=0;end else status<=SmallLoop1;
        endcase
end

initial cnt=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) cnt<=0;
    else if(status!=Init)
    begin
    cnt<=cnt+1;
    case (status)
        PreSort:begin
        i<=16;
        j<=0;
        end
        SmallLoop5:begin
            j<=j+1;
        end
        SmallLoopFin:begin
            j<=0;
            i<=i-1;
        end
    endcase
    end
end



endmodule

module testsort (
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
wire [15:0] DPsw;
genvar j;//声明的此变量只用于生成块的循环计算，在电路里面并不存�?
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
wire [7:0]Segout[5:0];//六个数码管的十六进制转化为Seg对应灯管亮起的信�?

HexToSeg HexToSeg0 (SegD[3:0],Segout[0]);
HexToSeg HexToSeg1 (SegD[7:4],Segout[1]);
HexToSeg HexToSeg2 (SegD[11:8],Segout[2]);
HexToSeg HexToSeg3 (SegD[15:12],Segout[3]);
HexToSeg HexToSeg4 (SegD[19:16],Segout[4]);
HexToSeg HexToSeg5 (SegD[23:20],Segout[5]);


//数码管分时复用输�?
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


sort22 sort(CLK100MHZ,CPU_RESETN,DPsw,del,addr,data,chk,run,SegD,LED16_R,LED);


endmodule