module  sort (
  input  CLK100MHZ, 
  input  rstn,
  input [15:0]  DPsw,		//输入1位十六进制数字
  input   del,		//删除1位十六进制数字
  input  addr,		//设置地址
  input  data,		//修改数据
  input chk,		//查看下一项
  input run,		//启动排序
  output reg [23:0]  SegData,
  output reg busy,		//1—正在排序，0—排序结束
  output reg [15:0]  cnt	//排序耗费时钟周期数
);
//状态声明
parameter Init=0;
parameter PreSort=1;//排序前准备
parameter SmallLoopPreRead=2;//为读取数据传输地址
parameter SmallLoopRead=3;//读取数据
parameter SmallLoopPreWrite=4;//为写入数据传递地址
parameter SmallLoopWrite=5;//写入数据
parameter SmallLoopFin=5;//小循环结束收尾
parameter ReadyToFin=7;//大循环结束收尾

//输入处理
wire ifInput;//SW是否有输入
wire [3:0] code;//编码
assign ifInput=|DPsw;//十六位取或，若为1则有输入
encoder_16bits encoder_16bits(DPsw,code);//编码

//核心代码
reg [2:0]status;
reg [15:0] D;//暂时数据
reg [7:0] Address;//当前地址
reg s;//用于判断输出
wire [15:0] spo;
reg en;
dist_mem_256_16 dist_mem_256_16(Address,D,CLK100MHZ,en,spo);

always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) en<=0;
    else 
        if(status==Init)
        if(data) en<=1;
        else en<=0;
end


//D部分
initial D=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) D<=0;
    else 
        if(status==Init)
        if(ifInput) D<={D[11:0],code};
        if(del) D<=D[15:4];
        if(data | addr) D<=0;
end

//Address部分
initial Address=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) Address<=0;
    else
        if(status==Init)
        if(chk) Address<=Address+1;
        else if(data) Address<=Address+1;
        else if(addr) Address<=D[7:0];
end

//s部分
initial s=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) s<=0;
    else if(status==Init)
        if(chk) s<=0;
        else if(ifInput) s<=1;
        else if(del) s<=1;
        else if(data) s<=0;
        else if(addr) s<=0;
end

always @(*) begin
    {SegData[23:20],SegData[19:16]}=Address;
    if(s) {SegData[15:12],SegData[11:8],SegData[7:4],SegData[3:0]}=D;
    else {SegData[15:12],SegData[11:8],SegData[7:4],SegData[3:0]}=spo;
end

//sort部分
wire ifSmallLoopFin;
wire ifLoopFin;
reg [15:0]max;
reg [15:0]temp;
reg [7:0]i;//大循环
reg [7:0]j;//小循环
assign ifLoopFin=(i==1);
assign ifSmallLoopFin=(j+1==i);

//状态
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=Init;//初始态
    else case (status)
        Init:if(run) status<=PreSort;//处在初始态，run信号到来时开始排序
        PreSort:status<=SmallLoopPreRead;
        SmallLoopPreRead:status<=SmallLoopRead;
        SmallLoopRead:status<=SmallLoopPreWrite;
        SmallLoopPreWrite:status<=SmallLoopWrite;
        SmallLoopWrite:if(ifSmallLoopFin)status<=SmallLoopFin;else status<=SmallLoopPreRead;
        SmallLoopFin:if(ifLoopFin)status<=ReadyToFin;else status<=SmallLoopPreRead;
        ReadyToFin:status<=Init;
        endcase
end

//状态对应数据通路
always @(posedge CLK100MHZ or negedge rstn) begin
    if(rstn)
    if(status!=Init)
    begin
    cnt<=cnt+1;
    case (status)
        PreSort:begin
            busy<=1;
            cnt<=0;
            i<=15;
            j<=0;
            Address<=0;
            en<=0;
        end
        SmallLoopPreRead:begin
            en<=0;
            if(j==0)max<=spo;//第一次初始化
            Address<=j+1;
        end
        SmallLoopRead:begin
            if(max<spo)begin
                max<=spo;
                temp<=max;
            end
            else temp<=spo;
        end
        SmallLoopPreWrite:begin
            D<=temp;
            Address<=j;
            en<=1;
        end
        SmallLoopWrite:begin
            j<=j+1;
            Address<=j+1;
            D<=max;
            en<=1;
        end
        SmallLoopFin:begin
            en<=0;
            Address<=0;
            j<=0;
            i<=i-1;
        end
        ReadyToFin:begin
            busy<=0;
        end
    endcase
    end
end


endmodule