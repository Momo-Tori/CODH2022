module  sort_B4096 (
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
BRAM_4096_16 BRAM_4096_16(CLK100MHZ,1,en,Address,D,spo);

wire ifSmallLoopFin;
wire ifLoopFin;
reg [15:0]max;
reg [15:0]temp;
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
        SmallLoop2:en<=0;
        SmallLoop4:en<=1;
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
        SmallLoop4:D<=temp;
        SmallLoop6:D<=max;
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
        else if(en&&status==Init) Address<=Address+1;
        else if(addr) Address<=D[7:0];
        end
        PreSort:Address<=0;
        SmallLoop2:Address<=j+1;
        SmallLoop4:Address<=j;
        SmallLoop6:Address<=j;
        SmallLoopFin:Address<=0;
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
        SmallLoop2:status<=SmallLoop3;
        SmallLoop3:status<=SmallLoop4;
        SmallLoop4:status<=SmallLoop5;
        SmallLoop5:if(ifSmallLoopFin)status<=SmallLoop6;else status<=SmallLoop2;
        SmallLoop6:status<=SmallLoopFin;
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
    end
    else if(status!=Init)
    begin
    cnt<=cnt+1;
    case (status)
        PreSort:begin
            busy<=1;
            cnt<=0;
            i<=4096;
            j<=0;
        end
        SmallLoop1:begin
            max<=spo;
        end
        SmallLoop3:begin
            if(max<spo)begin
                max<=spo;
                temp<=max;
            end
            else temp<=spo;
        end
        SmallLoop5:begin
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