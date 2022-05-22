module MEM_CACHE (
  input [7:0] Address,    //cpu给的地址
  input [31:0] WriteData,       //写的数据
  input [7:0] DebugAddr,     //chk用 仅可读
  input clk,
  input wr_req,//写请求信号
  input rd_req,//读请求信号
  input rstn,
  output wire [31:0] ReadData,      //从cache中取出的数据
  output wire [31:0] DebugData,
  output wire StallNeed //告诉cpu需要stall
);

parameter IDLE = 2'b0;
parameter SWAP_OUT = 2'b01;
parameter SWAP_IN = 2'b10;
parameter SWAP_IN_OK = 2'b11;

localparam way_cnt = 2;//组相连度
//cache与主存之间使用写回法和写分配法
//使用块大小为一字（一字四字节）两组 共计8块的直接映射cache  总容量8*2*1=16字
//FIFO策略
//ADDR: 2:0为index 7:3为tag 

reg [31:0] cache[7:0][way_cnt - 1:0];
reg valid[7:0][way_cnt - 1:0];//标记有效位
reg dirty[7:0][way_cnt - 1:0];//dirty的意思是在cache中的值是否以及被更改 需要写回内存
reg [4:0] tag[7:0][way_cnt - 1:0];//标签位
reg [way_cnt-1 : 0] way_addr,way_addr_Debug;//记录数据来自哪个通道
reg FIFO[7:0][way_cnt:0];// 实际上就是一个计数器 升满了表示要润了
reg [way_cnt-1:0] outway;//记录哪个通道的数据要被换出 似乎用不到这么多位宽233
reg [31:0] ReadData_r;//先在内部缓存一次 目的是方便always内操作
// reg we_r;//用于内部写入
reg [31:0] WriteData_r;
reg [7:0] ip_addr_r;
reg [1:0] cache_state;

wire [7:0] ip_addr_w;
wire [31:0] ip_readdata,ip_readdata_debug;
wire [2:0] index,index_debug;
wire [4:0] tag_in,tag_debug;
// wire we_w;
wire [31:0] WriteData_w;

assign index = Address[2:0];
assign index_debug = DebugAddr[2:0];
assign tag_in = Address[7:3];
assign tag_debug = DebugAddr[7:3];
// assign ReadData = ReadData_r;
// assign we_w = we_r;
assign WriteData_w = WriteData_r;
assign ip_addr_w = ip_addr_r;

DataMem DataMem(
  .a(ip_addr_w),
  .d(WriteData_w),
  .dpra(DebugAddr),
  .clk(clk),
  //.we(we_w),
  .spo(ip_readdata),
  .dpo(ip_readdata_debug)
);
reg hit,hit_debug;
integer i,j;
always @(posedge clk) begin
  //处理hit
  hit = 1'b0;
  for(i = 0;i < way_cnt;i = i + 1)begin
    if(valid[index][i] && tag[index][i] == tag_in)begin
        hit = 1'b1;
        way_addr = i;
    end
  end
  hit_debug = 1'b0;
  for(i = 0;i < way_cnt;i = i + 1)begin
    if(valid[index][i] && tag[index][i] == tag_debug)begin
        hit_debug = 1'b1;
        way_addr_Debug = i;
    end
  end
end

//debug 只读信号
assign DebugData = ( hit_debug == 1 ) ? cache[index_debug][way_addr_Debug] : ip_readdata_debug;

integer free = 0;//标识是否还有空闲块
always @(posedge clk)begin
  if(~hit & (wr_req | rd_req))begin
    //选出冲突时换出的块
    for(i = 0;i < 2;i = i + 1)begin
      if(FIFO[index][i] == 0)begin//FIFO从1开始升序到way_cnt也就是组相联度
      //0表示还没开始 其实相当于valid位
        outway = i;
        free = 1;
      end
    end
    if(free == 0)begin
      for(i = 0;i < way_cnt;i = i +1)begin
        if(FIFO[index][i] == way_cnt)begin
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

always@(posedge clk or negedge rstn)begin
  if(!rstn)begin
    cache_state <= IDLE;
    for(i = 0;i < 8;i = i + 1)begin
      for(j = 0;j < way_cnt; j = j + 1)begin
        valid[i][j] = 1'b0;
        dirty[i][j] = 1'b0;
        cache[i][j] = 0;
        tag[i][j] = 0;
        FIFO[i][j] = 0;
      end
    end
  end
  else begin
    case(cache_state)
      IDLE:begin
        if(hit)begin
          if(rd_req)begin//cache命中 并且是读请求
            ReadData_r <= cache[index][way_addr];
          end
          else if(wr_req)begin//写请求
            cache[index][way_addr] <= WriteData;
            dirty[index][way_addr] <= 1'b1;
          end
        end
        else begin
          if(wr_req | rd_req)begin
            if(valid[index][outway] & dirty[index][outway])begin
              //未命中 有效 dirty 需要换出
              cache_state <= SWAP_OUT;
              ip_addr_r <= {tag[]}
            end
          end
        end
      end

    endcase
  end
end

endmodule //Cache