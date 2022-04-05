module  sort3 (
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
//状态声明
parameter Init=0;
parameter PreSort=1;
parameter SmallLoop1=2;
parameter SmallLoop2=3;
parameter SmallLoop3=4;
parameter SmallLoopFin=5;

//输入处理
wire ifInput;//SW是否有输出
wire [3:0] code;//编码
assign ifInput=|DPsw;//十六位取或，若为1则有输入
encoder_16bits encoder_16bits(DPsw,code);//编码

//核心代码
reg [2:0]status;
reg [15:0] D;//暂时数据
reg [7:0] Address;//当前地址
reg [7:0] DAdd;
reg s;//用于判断输出
wire [15:0] spo;
reg en;
dist_mem_gen_2 dist_mem_gen_2(.a(DAdd),.d(D),.dpra(Address),.clk(CLK100MHZ),.we(en),.dpo(spo));

wire ifSmallLoopFin;
wire ifLoopFin;
reg [15:0]max;
reg [15:0]temp;
reg [15:0]i;//大循环
reg [15:0]j;//小循环
assign ifLoopFin=(i==1);
assign ifSmallLoopFin=(j+1==i);

always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) en<=0;
    else
    case (status)
        Init:begin
        if(data) en<=1;
        else en<=0;
        end
        PreSort:en<=0;
        SmallLoop1:en<=0;
        SmallLoop2:en<=1;
        SmallLoopFin:en<=0;
    endcase
end


//D部分
initial D=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) D<=0;
    else 
    case (status)
        Init:begin
        if(ifInput) D<={D[11:0],code};
        if(del) D<=D[15:4];
        if(en | addr) D<=0;
        end
        SmallLoop2:if(max<spo)D<=max;else D<=spo;
        SmallLoop3:D<=max;
        SmallLoopFin:D<=0;
    endcase
end



//Address部分
initial Address=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) Address<=0;
    else
    case (status)
        Init:begin
        if(chk) Address<=Address+1;
        else if(en) Address<=Address+1;
        else if(addr) Address<=D[7:0];
        end
        PreSort:Address<=0;
        SmallLoop1:Address<=j+1;
        SmallLoop2:Address<=j+2;
        SmallLoopFin:Address<=0;
    endcase
end

always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) DAdd<=0;
    else
    case (status)
        Init:begin
        if(chk) DAdd<=Address+1;
        else if(en) DAdd<=Address+1;
        else if(addr) DAdd<=D[7:0];
        end
        PreSort:DAdd<=0;
        SmallLoop2:DAdd<=j;
        SmallLoop3:DAdd<=j;
        SmallLoopFin:DAdd<=0;
    endcase
end

//s部分
initial s=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) s<=0;
    else if(status==Init)
        if(chk) s<=0;
        else if(ifInput) s<=1;
        else if(del) s<=1;
        else if(en) s<=0;
        else if(addr) s<=0;
end

always @(*) begin
    {SegData[23:20],SegData[19:16]}=Address;
    if(s) {SegData[15:12],SegData[11:8],SegData[7:4],SegData[3:0]}=D;
    else {SegData[15:12],SegData[11:8],SegData[7:4],SegData[3:0]}=spo;
end

//sort部分

initial status=Init;
//状态部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=Init;//初始状态
    else case (status)
        Init:if(run) status<=PreSort;//处在初始态，run信号到来时开始排序
        else status<=status;
        PreSort:status<=SmallLoop1;
        SmallLoop1:status<=SmallLoop2;
        SmallLoop2:if(ifSmallLoopFin)status<=SmallLoop3;else status<=SmallLoop2;
        SmallLoop3:status<=SmallLoopFin;
        SmallLoopFin:if(ifLoopFin)status<=Init;
        else status<=SmallLoop1;
        endcase
end

//状态对应数据通路
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn)begin 
        cnt<=0;
        busy<=0;
    end
    else if(status!=Init)
    begin
    cnt<=cnt+1;
    case (status)
        PreSort:begin
            busy<=1;
            i<=256;
            j<=0;
        end
        SmallLoop1:max<=spo;
        SmallLoop2:begin if(max<spo)max<=spo;
        j<=j+1;
        end
        SmallLoopFin:begin
            j<=0;
            i<=i-1;
            if(ifLoopFin) busy<=0;
        end
    endcase
    end
end



endmodule


module Sort_Twoport(
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


sort3 sort(CLK100MHZ,CPU_RESETN,DPsw,del,addr,data,chk,run,SegD,LED16_R,LED);
endmodule