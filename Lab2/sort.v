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
  output busy,		//1—正在排序，0—排序结束
  output reg [15:0]  cnt	//排序耗费时钟周期数
);

//输入处理
wire ifInput;//SW是否有输入
wire [3:0] code;//编码
assign ifInput=|DPsw;//十六位取或，若为1则有输入
encoder_16bits encoder_16bits(DPsw,code);//编码

//核心代码
parameter BEFORE=0;
parameter RUNNING=1;
reg status;
reg [15:0] D;//暂时数据
reg [7:0] Address;//当前地址
reg s;//用于判断输出
wire [15:0] spo;
dist_mem_256_16 dist_mem_256_16(Address,D,CLK100MHZ,data,spo);

//D部分
initial D=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) D<=0;
    else 
        if(~status)
        if(ifInput) D<={D[11:0],code};
        if(del) D<=D[15:4];
        if(data | addr) D<=0;
end

//Address部分
initial Address=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) Address<=0;
    else
        if(~status)
        if(chk) Address<=Address+1;
        else if(data) Address<=Address+1;
        else if(addr) Address<=D[7:0];
end

//s部分
initial s=0;
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) s<=0;
    else if(~status)
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

wire FIN;

//status部分
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=BEFORE;
    else if(run) status<=RUNNING;
    else if(FIN) status<=BEFORE;
end




endmodule