`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 13:28:50
// Design Name: 
// Module Name: fas
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


module fas(
    );
 reg  CLK100MHZ;
  reg  rstn=1;
  reg [15:0]  DPsw=0;		//????1¦Ë???????????
  reg   del=0;		//???1¦Ë???????????
  reg  addr=0;		//??????
  reg  data=0;		//???????
  reg chk=0;		//???????
  reg run=0;		//????????
  wire  [23:0]  SegData;
  wire  busy;		//1-????????0-???????
  wire  [15:0]  cnt=0;	//???????????????
  initial
  begin
  #1 run=1;
  #40 run=0;
  end
   initial
   begin
   CLK100MHZ=0;
  forever #0.1 CLK100MHZ=~CLK100MHZ;
  end
sort sort(CLK100MHZ,rstn,DPsw,del,addr,data,chk,run,SegData,busy,cnt);
initial
begin
#150 chk<=1;
#40 chk<=0;
end
endmodule
