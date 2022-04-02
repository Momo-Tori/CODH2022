`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 22:43:01
// Design Name: 
// Module Name: asd
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


module  asd (
 
);

 reg  CLK100MHZ;
  reg  rstn=1;
  reg [15:0]  DPsw=0;		//????1��???????????
  reg   del=0;		//???1��???????????
  reg  addr=0;		//??????
  reg  data=0;		//???????
  reg chk=0;		//???????
  reg run;		//????????
  reg  [23:0]  SegData;
  reg  busy=1;		//1-????????0-???????
  reg  [15:0]  cnt=0;	//???????????????
  initial
  begin
  #1 run=1;
  #20 run=0;
  end
   initial
   begin
   CLK100MHZ=0;
  forever #0.01 CLK100MHZ=~CLK100MHZ;
  end
  
  
parameter Init=0;
parameter PreSort=1;
parameter SmallLoop1=2;
parameter SmallLoop2=3;
parameter SmallLoop3=4;
parameter SmallLoopFin=5;

//输入处理
wire ifInput;//SW是否有输�?
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
reg [15:0]i;//大循�?
reg [15:0]j;//小循�?
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
    if(~rstn) Address<=1;
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

initial DAdd=0;
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
//状�??
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=Init;//初始�?
    else case (status)
        Init:if(run) status<=PreSort;//处在初始态，run信号到来时开始排�?
        else status<=status;
        PreSort:status<=SmallLoop1;
        SmallLoop1:status<=SmallLoop2;
        SmallLoop2:if(ifSmallLoopFin)status<=SmallLoop3;else status<=SmallLoop2;
        SmallLoop3:status<=SmallLoopFin;
        SmallLoopFin:if(ifLoopFin)status<=Init;
        else status<=SmallLoop1;
        endcase
end

initial busy=0;

//状�?�对应数据�?�路
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn)begin 
        cnt<=0;
        busy<=0;
        max<=0;
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