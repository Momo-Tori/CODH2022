module InsCache (
  input clk,
  input [31:0] address,    //cpu给的地址
  output [31:0] data,      //从cache中取出的数据
  output hit,               //是否hit

  input memWE,              //数据准备好的信号
  input [31:0] memAdd,      //写入数据对应的地址
  input [31:0] memData      //从主存输入用来更新Cache的Data
);
//全相连，FIFO，共有8个缓存地址

parameter WIDTH=8;
parameter WIDTH_CNT = 3;
reg [WIDTH-1:0] valid=0;
reg [29:0] tag[WIDTH-1:0];//用[31:2]来确定tag
reg [31:0] cacheData[WIDTH-1:0];//对应的地址

reg[WIDTH_CNT-1:0] cnt=0;
always @(posedge clk) begin
    if(memWE)
    if(cnt==WIDTH-1) cnt=0;
    else cnt=cnt+1;
end
always @(posedge clk) begin
    if(memWE) 
    begin
        valid[cnt]<=1;
        tag[cnt]<=memAdd[31:2];
        cacheData[cnt]<=memData;
    end
end


reg[WIDTH-1:0] eq;
integer i;
always @(*) begin
    for(i=0; i<WIDTH; i=i+1)
    eq[i]=(address[31:2]==tag[i]);
end

wire [WIDTH-1:0] sig;
assign sig = eq & valid;
assign hit = |sig;
wire [WIDTH_CNT-1:0] sel;
encoder_16bits encoder_16bits({0,sig},sel);
assign data=cacheData[sel];

endmodule //InsCache