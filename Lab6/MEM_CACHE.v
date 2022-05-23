module MEM_CACHE (
  input [7:0] Address,    //cpu给的地址
  input [31:0] WriteData,       //写的数据
  input [7:0] DebugAddr,     //chk用 仅可读
  input clk,
  input wr_req,//写请求信号
  input rstn,
  output wire [31:0] ReadData,      //从cache中取出的数据
  output wire [31:0] DebugData,
  output wire hit_m
);

localparam way_cnt = 2;//组相连度
//cache与主存之间使用全写法和不按写分配法
//使用块大小为一字（一字四字节）两组 共计8块的直接映射cache  总容量8*2*1=16字
//FIFO策略
//ADDR: 2:0为index 7:3为tag 

reg [31:0] cache[7:0][way_cnt - 1:0];
reg valid[7:0][way_cnt - 1:0];//标记有效位
reg [4:0] tag[7:0][way_cnt - 1:0];//标签位

reg [way_cnt-1 : 0] way_addr;//记录数据来自哪个通道
reg FIFO[7:0][way_cnt:0];// 实际上就是一个计数器 升满了表示要润了
reg [way_cnt-1:0] outway;//记录哪个通道的数据要被换出 似乎用不到这么多位宽233
reg [31:0] ReadData_r;//先在内部缓存一次 目的是方便always内操作

wire [31:0] ip_readdata;
wire [2:0] index;
wire [4:0] tag_in;

assign index = Address[2:0];
assign tag_in = Address[7:3];


// DataMem DataMem(
//   .a(Address),
//   .d(WriteData),
//   .dpra(DebugAddr),
//   .clk(clk),
//   .we(wr_req),
//   .spo(ip_readdata),
//   .dpo(DebugData)//由于使用的全写法和不按写分配法 所以内存中同样也是最新的值 直接读就可以了
// );

memory memory0(
  .a(Address),
  .d(WriteData),
  .dpra(DebugAddr),
  .clk(clk),
  .we(wr_req),
  .spo(ip_readdata),
  .dpo(DebugData)//由于使用的全写法和不按写分配法 所以内存中同样也是最新的值 直接读就可以了
);

reg hit;
integer i,j;
always @(*) begin
  //处理hit
  hit = 1'b0;
  for(i = 0;i < way_cnt;i = i + 1)begin
    if(valid[index][i] && tag[index][i] == tag_in)begin
        hit = 1'b1;
        way_addr = i;
    end
  end
end

integer free = 0;//标识是否还有空闲块
always @(posedge clk or negedge rstn)begin
  if(~rstn)begin
    for(i = 0;i < 8;i = i + 1)begin
      for(j = 0;j < way_cnt; j = j + 1)begin
        FIFO[i][j] = 0;
      end
    end
  end
  else begin
    if(~hit)begin
      //选出冲突时换出的块
      for(i = 0;i < way_cnt;i = i + 1)begin
        if(FIFO[index][i] == 0)begin//FIFO从1开始升序到way_cnt也就是组相联度
        //0表示还没开始 其实相当于valid位
          outway = i;
          free = 1;
        end
      end
      if(free == 0)begin
        for(i = 0;i < way_cnt;i = i +1)begin
          if(FIFO[index][i] == way_cnt)begin//最大值说明是最早进去的
          //最好是能break 但是应该也不会有多个通道都是最大值
            outway = i;
            FIFO[index][i] =0;
          end
        end
      end
      if(FIFO[index][outway] == 0)begin
        for(i = 0;i < way_cnt;i = i + 1)begin
          if(FIFO[index][i]!=0)begin
            FIFO[index][i] = FIFO[index][i] + 1;
          end
        end
      end
      FIFO[index][outway] = 1;//新数据会被换入到这里 所以可以先赋值为1
    end
  end
end

always@(posedge clk or negedge rstn)begin
  if(!rstn)begin
    for(i = 0;i < 8;i = i + 1)begin
      for(j = 0;j < way_cnt; j = j + 1)begin
        valid[i][j] = 1'b0;
        cache[i][j] = 0;
        tag[i][j] = 0;
      end
    end
  end
  else begin
    if(hit)begin
      if(wr_req)begin//写请求
        cache[index][way_addr] <= WriteData;
        //ip核的话直接写就是了 不需要在这里操作
      end
      else begin//cache命中 并且是读请求
        ReadData_r <= cache[index][way_addr];
      end
    end
    else begin
      if(~wr_req)begin
        //不是写的话就是默认的读取模式 读的话需要从内存中载入到缓存 当然为了速度 先直接返回内存读的值
        cache[index][outway] <= ip_readdata;
        // ReadData_r <= ip_readdata;
        valid[index][outway] <= 1'b1;
      end
      //写不命中直接写主存就是了 似乎不需要处理
    end
  end
end
assign hit_m = hit;
assign ReadData = (hit == 1) ? cache[index][way_addr] : ip_readdata;
endmodule //Cache

