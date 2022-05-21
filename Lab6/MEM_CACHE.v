module MEM_CACHE(
  input [7:0] Address,    //cpu给的地址
  input [31:0] WriteData,       //写的数据
  input [7:0] DebugAddr,     
  input clk,
  input [31:0] we,      
  input rstn,
  output wire [31:0] ReadData,      //从cache中取出的数据
  output wire [31:0] DebugData
);
//cache与主存之间使用写回法和写分配法
//使用块大小为一字（一字四字节）共计8块的全相联cache 基于LRU替换策略 总容量8字
//ADDR: 最后一位为offset 对应块内字地址 3:1为index 7:4为tag 
reg [31:0] cache[7:0];
reg valid[7:0];//标记有效位 直接按块标记得了 懒
reg [3:0] tag[7:0];//标签位
reg [31:0] ReadData_r,DebugData_r;//先在内部缓存一次 目的是方便always内操作
reg [2:0] LRU[7:0];//LRU实现的想法是直接用一个reg记录

wire [7:0] ip_addr,ip_addr_debug;
wire [31:0] ip_readdata,ip_readdata_debug;
wire [3:1] index,index_debug;
wire offset,offset_debug;
wire tag_in,tag_debug;

assign index = Address[3:1];
assign index_debug = DebugAddr[3:1];
assign offset = Address[0];
assign offset_debug = DebugAddr[0];
assign tag_in = Address[7:4];
assign tag_debug = DebugAddr[7:4];
assign ReadData = ReadData_r;
assign DebugData = DebugData_r;

DataMem DataMem(
  .a(ip_addr),
  .d(WriteData),
  .dpra(ip_addr_debug),
  .clk(clk),
  .we(we),
  .spo(ip_readdata),
  .dpo(ip_readdata_debug)
);


//读取模块
wire hit,hit_debug;
//hit:位有效并且tag对上了
assign hit = (valid[index] == 1) && (tag[index] == tag_in);
assign hit_debug = (valid[index_debug] == 1) &&(tag[index_debug] == tag_debug);

integer i;//循环用
always@(posedge clk or negedge rstn)begin
  if(!rstn)begin
    for(i = 0;i < 8; i = i  + 1)begin
      cache[i][0] <= 0 ;
      cache[i][1] <= 0 ;
      valid[i] <= 0;
      tag[i] <= 0;
    end
  end
  else begin
    if(!we)begin
      //也就是读取
      if(hit)begin
        ReadData_r <= cache[index][offset];
        //TODO: 更新LRU
      end
      else begin
        //TODO: 先从内存读出数据传回 然后放到cache里面 换出的时候要写入
        ReadData_r <= ip_readdata;
      end
      //注意 debug不需要管将内存读到cache里 有就直接读 没有就读内存 保证数据是最新的就好了
      if(hit_debug)begin
        DebugData_r <= cache[index_debug][offset_debug];
      end
      else begin
        DebugData_r <= ip_readdata_debug;
      end
    end
    else begin

    end
  end
end
endmodule //Cache