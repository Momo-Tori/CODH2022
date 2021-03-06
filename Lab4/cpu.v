module  cpu (
  input clk, 
  input rstn,

  //IO_BUS
  output [7:0]  io_addr,	//外设地址
  output [31:0]  io_dout,	//向外设输出的数据
  output  io_we,		//向外设输出数据时的写使能信号
  output  io_rd,		//从外设输入数据时的读使能信号
  input [31:0]  io_din,	//来自外设输入的数据

  //Debug_BUS
  output reg [31:0] pc, 	//当前执行指令地址
  input [15:0] chk_addr,	//数据通路状态的编码地址
  output reg [31:0] chk_data    //数据通路状态的数据
);
wire MemtoReg,MemWrite,ALUSrc,RegWrite,MemRead;
wire [3:0]ALUOp;
wire [31:0]ALU2;//MUX
reg [31:0]WriteData;
reg [31:0]pcn;//MUX
reg [2:0]pcMUX;
wire [31:0]Ins;
wire [31:0]Reg1Data,Reg2Data;
wire [31:0]ALUResult;
wire [2:0]f;
wire zero;
wire [31:0]Imm;
wire [31:0]ReadData;
wire [31:0]ReadMemData;
reg [31:0]cnt;

//Debug_Bus
wire [4:0]DebugRegAddr;
wire [31:0]DebugRegData;
wire [7:0]DebugMemAddr;
wire [31:0]DebugMemData;
assign DebugRegAddr=chk_addr[4:0];
assign DebugMemAddr=chk_addr[7:0];

always @(*) begin
    if(chk_addr[15:12]==4'b0000)
    case (chk_addr[3:0])
        4'b0000:chk_data=pcn;
        4'b0001:chk_data=pc;
        4'b0010:chk_data=Ins;
        4'b0011:chk_data={MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,ALUOp};
        4'b0100:chk_data=Reg1Data;
        4'b0101:chk_data=Reg2Data;
        4'b0110:chk_data=Imm;
        4'b0111:chk_data=ALUResult;
        4'b1000:chk_data=ReadData;
        default:chk_data=0;
    endcase
    else if(chk_addr[15:12]==4'b0001)
        chk_data=DebugRegData;
    else if(chk_addr[15:12]==4'b0010)
        chk_data=DebugMemData;
end


//pcn
always @(*) begin
  if(Ins[6:4]==3'b110)
    pcMUX=Ins[3:2];
    //00-11分别为B,JALR,无,JAL
  else
    pcMUX=2'b10;
end
always @(*) begin
  case (pcMUX)
  2'b00:pcn=(zero)?(pc + {{20{Ins[31]}},Ins[7],Ins[30:25],Ins[11:8],1'b0} ):(pc+4);//Branch
  2'b01:pcn=(Reg1Data + {{20{Ins[31]}},Ins[31:20]} )&32'hFFFE;//JALR
  2'b10:pcn=pc+4;//普通周期
  2'b11:pcn=pc + { {12{Ins[31]}},Ins[19:12],Ins[20],Ins[30:21],1'b0 };//JAL
  default:pcn=4'bxxxx;
  endcase
end


always @(*) begin
  if(MemtoReg)WriteData=ReadData;
  else if(Ins[6:4]==3'b110) WriteData=pc+4;
  else if(Ins[6:2]==5'b00101) WriteData=pc+{Ins[31:12],{12{1'b0}}};
  else WriteData=ALUResult;
end

//Control模块

assign ALU2=ALUSrc?Imm:Reg2Data;
assign MemtoReg=Ins[6:2]==5'b00000;//LW
assign MemRead=Ins[6:2]==5'b00000;//LW
assign MemWrite=Ins[6:2]==5'b01000;//SW
assign ALUSrc=(Ins[5]==0)|(Ins[6:2]==5'b01000);
assign RegWrite=~(Ins[5:2]==4'b1000);
wire sub;
assign sub=(Ins[30]==1&&Ins[6:2]==5'b01100)||(Ins[6:2]==5'b11000);
assign ALUOp={2'b00,~sub};
assign zero=Ins[14]?f[1]:f[0];

always @(posedge clk or negedge rstn) begin
  if(~rstn) pc<=0;
  else pc<=pcn;
end

always @(posedge clk or negedge rstn) begin
  if(~rstn) cnt<=0;
  else cnt<=cnt+1;
end

ImmGen ImmGen(Ins,Imm);
alu alu(Reg1Data,ALU2,ALUOp,ALUResult,f);
InstMem InstMem(pc[10:2],Ins);
register_file register_file(clk,Ins[19:15],Ins[24:20],Reg1Data,Reg2Data,Ins[11:7],WriteData,RegWrite,DebugRegAddr,DebugRegData);



//DataMem&MMIO
DataMem DataMem(ALUResult[10:2],Reg2Data,DebugMemAddr,clk,MemWrite,ReadMemData,DebugMemData);//DataMem

assign io_we=MemWrite&(io_addr<8'h20);
assign io_rd=MemRead;
assign io_addr=ALUResult[7:0];
assign io_dout=Reg2Data;
assign ReadData=(io_addr<8'h20)?io_din:ReadMemData;

endmodule