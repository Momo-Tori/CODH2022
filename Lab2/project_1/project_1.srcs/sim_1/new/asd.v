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
  reg [15:0]  DPsw=0;		//????1¦Ë???????????
  reg   del=0;		//???1¦Ë???????????
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
  forever #0.1 CLK100MHZ=~CLK100MHZ;
  end
//??????
parameter Init=0;
parameter PreSort=1;
parameter SmallLoop1=2;
parameter SmallLoop2=3;
parameter SmallLoop3=4;
parameter SmallLoop4=5;
parameter SmallLoop5=6;
parameter SmallLoop6=7;
parameter SmallLoopFin=8;

wire ifSmallLoopFin;
wire ifLoopFin;
reg [15:0]max=0;
reg [15:0]temp=0;
reg [7:0]i=0;//?????
reg [7:0]j=0;//§³???
assign ifLoopFin=(i==1);
assign ifSmallLoopFin=(j+1==i);
//??????
wire ifInput;//SW?????????
wire [3:0] code;//????
assign ifInput=|DPsw;//???¦Ë??????1????????
encoder_16bits encoder_16bits(DPsw,code);//????

//???????
reg [3:0]status=0;
reg [15:0] D=0;//???????
reg [7:0] Address=0;//??????
reg s=0;//?????§Ø????
wire [15:0] spo;
reg en=0;
dist_mem_gen_0 dist_mem_gen_0(Address,D,CLK100MHZ,en,spo);

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


//D????
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

//Address????
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

//s????
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

//sort????


//??
always @(posedge CLK100MHZ or negedge rstn) begin
    if(~rstn) status<=Init;//????
    else case (status)
        Init:if(run) status<=PreSort;//?????????run??????????????
        PreSort:status<=SmallLoop1;
        SmallLoop1:status<=SmallLoop2;
        SmallLoop2:status<=SmallLoop3;
        SmallLoop3:status<=SmallLoop4;
        SmallLoop4:status<=SmallLoop5;
        SmallLoop5:if(ifSmallLoopFin)status<=SmallLoop6;else status<=SmallLoop2;
        SmallLoop6:status<=SmallLoopFin;
        SmallLoopFin:if(ifLoopFin)begin status<=Init;busy<=1;end else status<=SmallLoop1;
        endcase
end

initial busy=1;

//??????????¡¤
always @(posedge CLK100MHZ or negedge rstn) begin
    if(rstn)
    if(status!=Init)
    begin
    cnt<=cnt+1;
    case (status)
        PreSort:begin
            busy<=0;
            cnt<=0;
            i<=15;
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
        end
    endcase
    end
end

initial
begin
#110 chk<=1;
#10 chk<=0;
end

endmodule