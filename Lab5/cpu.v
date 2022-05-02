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
wire MemtoReg,MemWrite,ALUSrc,RegWrite,MemRead,PCChange,AUIPC;
wire [3:0]ALUOp;
reg [31:0]ALU1,ALU2;//MUX
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

//pipeline

reg [31:0] PCD_r,IR_r,PCE_r,A_r,B_r,Imm_r,Rd_r,Y_r,MDW_r,RdM_r,MDR_r,YW_r,RdW_r;

reg [31:0] IR_EX_r,IR_MEM_r,IR_WB_r;

reg [3:0] ALUOp_r;

reg MemtoReg_r_EX,MemWrite_r_EX,ALUSrc_r_EX,RegWrite_r_EX,MemRead_r_EX,PCChange_r_EX,AUIPC_r_EX;

reg MemtoReg_r_MEM,MemWrite_r_MEM,RegWrite_r_MEM,MemRead_r_MEM;

reg MemtoReg_r_WB,RegWrite_r_WB;

//data path of pipeline
always @(posedge clk or negedge rstn) begin
  if(~rstn)
  begin
  PCD_r<=0;
  IR_r<=32'h00000013;//NOP
  PCE_r<=0;
  A_r<=0;
  B_r<=0;
  Imm_r<=0;
  Rd_r<=0;
  Y_r<=0;
  MDW_r<=0;
  RdM_r<=0;
  MDR_r<=0;
  YW_r<=0;
  RdW_r<=0;

  IR_EX_r<=32'h00000013;
  IR_MEM_r<=32'h00000013;
  IR_WB_r<=32'h00000013;
  end
  else begin
  PCD_r<=pc;
  IR_r<=Ins;
  PCE_r<=PCD_r;
  A_r<=Reg1Data;
  B_r<=Reg2Data;
  Imm_r<=Imm;
  Rd_r<=IR_r[11:7];
  Y_r<=ALUResult;
  MDW_r<=B_r;
  RdM_r<=Rd_r;
  MDR_r<=ReadData;
  YW_r<=Y_r;
  RdW_r<=RdM_r;

  IR_EX_r<=IR_r;
  IR_MEM_r<=IR_EX_r;
  IR_WB_r<=IR_MEM_r;
  end
end


//control sign of pipeline

always @(posedge clk or negedge rstn) begin
  if(~rstn)
  begin
  MemtoReg_r_EX<=0;
  MemWrite_r_EX<=0;
  ALUSrc_r_EX<=0;
  RegWrite_r_EX<=0;
  MemRead_r_EX<=0;
  PCChange_r_EX<=0;
  AUIPC_r_EX<=0;
  end
  else begin
  ALUOp_r<=ALUOp;

  MemtoReg_r_EX<=MemtoReg;
  MemWrite_r_EX<=MemWrite;
  ALUSrc_r_EX<=ALUSrc;
  RegWrite_r_EX<=RegWrite;
  MemRead_r_EX<=MemRead;
  PCChange_r_EX<=PCChange;
  AUIPC_r_EX<=AUIPC;
  end
end

always @(posedge clk or negedge rstn) begin
  if(~rstn)
  begin
  MemtoReg_r_MEM<=0;
  MemWrite_r_MEM<=0;
  RegWrite_r_MEM<=0;
  MemRead_r_MEM<=0;
  end
  else begin
  MemtoReg_r_MEM<=MemtoReg_r_EX;
  MemWrite_r_MEM<=MemWrite_r_EX;
  RegWrite_r_MEM<=RegWrite_r_EX;
  MemRead_r_MEM<=MemRead_r_EX;
  end
end

always @(posedge clk or negedge rstn) begin
  if(~rstn)
  begin
  MemtoReg_r_WB<=0;
  RegWrite_r_WB<=0;
  end
  else begin
  MemtoReg_r_WB<=MemtoReg_r_MEM;
  RegWrite_r_WB<=RegWrite_r_MEM;
  end
end

//




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


//Control模块

always @(*) begin
  if(MemtoReg_r_WB)WriteData=MDR_r;
  else WriteData=YW_r;
end

always @(*) begin
  if((PCChange_r_EX&(IR_EX_r[2]))|AUIPC_r_EX) ALU1=PCE_r;
  else ALU1=A_r;

  if(PCChange_r_EX&(IR_EX_r[2])) ALU2=4;
  else if(AUIPC_r_EX) ALU2={IR_EX_r[31:12],{12{1'b0}}};
  else ALU2=ALUSrc_r_EX?Imm_r:B_r;
end

assign LW=IR_r[6:2]==5'b00000;
assign MemtoReg=LW;//LW
assign MemRead=LW;//LW
assign SW=IR_r[6:2]==5'b01000;
assign MemWrite=SW;//SW
assign ALUSrc=(IR_r[5]==0)|(SW);
assign RegWrite=(IR_r[5:2]!=4'b1000);
wire sub;
assign sub=(IR_r[30]==1&&IR_r[6:2]==5'b01100)||(IR_r[6:2]==5'b11000);
assign ALUOp={2'b00,~sub};
assign PCChange=IR_r[6:4]==3'b110;//改变PC的那几条指令初步判断
assign AUIPC=IR_r[6:2]==5'b00101;

assign zero=IR_EX_r[14]?f[1]:f[0];

//pcn
always @(*) begin
  if(PCChange_r_EX)
    pcMUX=IR_EX_r[3:2];
    //00-11分别为B,JALR,无,JAL
  else
    pcMUX=2'b10;
end
always @(*) begin
  case (pcMUX)
  2'b00:pcn=PCE_r+( (zero)?( {{20{IR_EX_r[31]}},IR_EX_r[7],IR_EX_r[30:25],IR_EX_r[11:8],1'b0} ):4);//Branch
  2'b01:pcn=(A_r + {{20{IR_EX_r[31]}},IR_EX_r[31:20]} )&32'hFFFE;//JALR
  2'b10:pcn=pc+4;//普通周期
  2'b11:pcn=PCE_r + { {12{IR_EX_r[31]}},IR_EX_r[19:12],IR_EX_r[20],IR_EX_r[30:21],1'b0 };//JAL
  default:pcn=4'bxxxx;
  endcase
end


always @(posedge clk or negedge rstn) begin
  if(~rstn) pc<=0;
  else pc<=pcn;
end

always @(posedge clk or negedge rstn) begin
  if(~rstn) cnt<=0;
  else cnt<=cnt+1;
end

ImmGen ImmGen(IR_r,Imm);
alu alu(ALU1,ALU2,ALUOp_r,ALUResult,f);
InstMem InstMem(pc[10:2],Ins);
register_file register_file(clk,IR_r[19:15],IR_r[24:20],Reg1Data,Reg2Data,RdW_r,WriteData,RegWrite_r_WB,DebugRegAddr,DebugRegData);



//DataMem&MMIO
DataMem DataMem(Y_r[10:2],MDW_r,DebugMemAddr,clk,MemWrite_r_MEM,ReadMemData,DebugMemData);//DataMem

wire MMIO;
assign MMIO=Y_r>=32'hFF00;

assign io_we=MemWrite_r_MEM&MMIO;
assign io_rd=MemRead_r_MEM&MMIO;
assign io_addr=Y_r[7:0];
assign io_dout=MDW_r;
assign ReadData=MMIO?io_din:ReadMemData;

endmodule