module  register_file  #(
    parameter AW = 5,		//地址宽度
    parameter DW = 32		//数据宽度
)(
    input  clk,			//时钟
    input [AW-1:0]  ra0, ra1,	//读地址
    output [DW-1:0]  rd0, rd1,	//读数据
    input [AW-1:0]  wa,		//写地址
    input [DW-1:0]  wd,		//写数据
    input we			//写使能
);
reg [DW-1:0]  rf [0: (1<<AW)-1]; 	//寄存器堆
assign rd0 =(we==1&&ra0==wa)?wd: rf[ra0], rd1 =(we==1&&ra1==wa)?wd: rf[ra1];	//读操作
always  @(posedge  clk)begin
    if (we)  rf[wa]  =  wd;		//写操作
    rf[0]=0;
end
endmodule
