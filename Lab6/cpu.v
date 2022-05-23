module  cpu ( 
  input clk,  
  input rstn, 

  //IO_BUS
  output [7:0]  io_addr, 	//外设地址
  output [31:0]  io_dout, 	//向外设输出的数据
  output  io_we, 		//向外设输出数据时的写使能信号
  output  io_rd, 		//从外设输入数据时的读使能信号
  input [31:0]  io_din, 	//来自外设输入的数据

  //Debug_BUSs
  output reg [31:0] pc,  	//当前执行指令地址
  input [15:0] chk_addr, 	//数据通路状态的编码地址
  output reg [31:0] chk_data    //数据通路状态的数据
 );

//De段生成信号
wire MemtoReg, MemWrite, ALUSrc, RegWrite, MemRead, PCChange, UI;
reg [3:0]ALUOp;

//ALU的两个输入
reg [31:0]ALU1, ALU2;//MUX
//写入Mem的数据
reg [31:0]WriteData;
//下一个PC
reg [31:0]pcn;
//PC的MUX
reg [2:0]pcMUX;
//从InsMem读出的指令
wire [31:0]Ins;
//从寄存器读出的两个值
wire [31:0]Reg1Data, Reg2Data;
//ALU的输出
wire [31:0]ALUResult;
//最终给Y_r的值
reg [31:0] Y;
//ALU的f输出
wire [2:0]f;
//Br指令是否跳转的信号
reg zero;
//处理的立即数
wire [31:0]Imm;
//结合MMIO之后最终LD读出来的数据
wire [31:0]ReadData;
//LD指令从Mem读出来的数据
wire [31:0]ReadMemData;
//周期数cnt
reg [31:0]cnt;

//pipeline

/* 
PCD_r IF-ID段pc
IR_r  IF-ID段IR
PCE_r ID-EX段pc
A_r   ID-EX段从寄存器堆中读出来的第一个寄存器
B_r   第二个
Imm_r ID-EX段立即数
Rd_r  ID-EX段目标寄存器
Y_r   EX-MEM段Alu结果
MDW_r EX-MEM段Mem要写回的地址
RdM_r EX-MEM段目标寄存器
MDR_r MEM-WB段从Mem读出的数据
YW_r  MEM-WB段Alu结果
RdW_r MEM-WB段目标寄存器
 */
reg [31:0] PCD_r, IR_r, PCE_r, A_r, B_r, Imm_r, Rd_r, Y_r, MDW_r, RdM_r, MDR_r, YW_r, RdW_r;

//传递IR到流水线后面
reg [31:0] IR_EX_r, IR_MEM_r, IR_WB_r;

//ALUOp的传递
reg [3:0] ALUOp_r;

//下面是信号各个阶段的传递
reg MemtoReg_r_EX, MemWrite_r_EX, ALUSrc_r_EX, RegWrite_r_EX, MemRead_r_EX, PCChange_r_EX, UI_r_EX;

reg MemtoReg_r_MEM, MemWrite_r_MEM, RegWrite_r_MEM, MemRead_r_MEM;

reg MemtoReg_r_WB, RegWrite_r_WB;

//data path of pipeline
always @( posedge clk or negedge rstn ) begin
  if( ~rstn )
  begin
  PCD_r <= 0;
  IR_r <= 32'h00000013;//变成NOP
  PCE_r <= 0;
  A_r <= 0;
  B_r <= 0;
  Imm_r <= 0;
  Rd_r <= 0;
  Y_r <= 0;
  MDW_r <= 0;
  RdM_r <= 0;
  MDR_r <= 0;
  YW_r <= 0;
  RdW_r <= 0;

  IR_EX_r <= 32'h00000013;
  IR_MEM_r <= 32'h00000013;
  IR_WB_r <= 32'h00000013;
  end
  else begin

  if( B_Hazard )//branch hazard，清为NOP
      IR_r <= 32'h00000013;
  else if( LD_R_Hazard )//Load hazard，stall一个周期
      IR_r <= IR_r;
  else
      IR_r <= Ins;
  
  if( LD_R_Hazard )begin
    PCD_r <= PCD_r;
  end
  else begin
    PCD_r <= pc;
  end
  
  PCE_r <= PCD_r;
  A_r <= Reg1Data;
  B_r <= Reg2Data;
  Imm_r <= Imm;
  Rd_r <= IR_r[11:7];
  Y_r <= Y;
  MDW_r <= B_r_fixed;
  RdM_r <= Rd_r;
  MDR_r <= ReadData;
  YW_r <= Y_r;
  RdW_r <= RdM_r;

  IR_EX_r <= IR_r;
  IR_MEM_r <= IR_EX_r;
  IR_WB_r <= IR_MEM_r;
  end
end


//control sign of pipeline

always @( posedge clk or negedge rstn ) begin
  if( ~rstn )
  begin
  MemtoReg_r_EX <= 0;
  MemWrite_r_EX <= 0;
  ALUSrc_r_EX <= 0;
  RegWrite_r_EX <= 0;
  MemRead_r_EX <= 0;
  PCChange_r_EX <= 0;
  UI_r_EX <= 0;
  end
  else begin
  if( LD_R_Hazard|B_Hazard )
  begin
    MemtoReg_r_EX <= 0;
    MemWrite_r_EX <= 0;
    RegWrite_r_EX <= 0;
    MemRead_r_EX <= 0;
    PCChange_r_EX <= 0;
  end
  else
  begin
    MemtoReg_r_EX <= MemtoReg;
    MemWrite_r_EX <= MemWrite;
    RegWrite_r_EX <= RegWrite;
    MemRead_r_EX <= MemRead;
    PCChange_r_EX <= PCChange;
  end
  ALUOp_r <= ALUOp;

  ALUSrc_r_EX <= ALUSrc;
  UI_r_EX <= UI;
  end
end

always @( posedge clk or negedge rstn ) begin
  if( ~rstn )
  begin
  MemtoReg_r_MEM <= 0;
  MemWrite_r_MEM <= 0;
  RegWrite_r_MEM <= 0;
  MemRead_r_MEM <= 0;
  end
  else begin
  MemtoReg_r_MEM <= MemtoReg_r_EX;
  MemWrite_r_MEM <= MemWrite_r_EX;
  RegWrite_r_MEM <= RegWrite_r_EX;
  MemRead_r_MEM <= MemRead_r_EX;
  end
end

always @( posedge clk or negedge rstn ) begin
  if( ~rstn )
  begin
  MemtoReg_r_WB <= 0;
  RegWrite_r_WB <= 0;
  end
  else begin
  MemtoReg_r_WB <= MemtoReg_r_MEM;
  RegWrite_r_WB <= RegWrite_r_MEM;
  end
end

//forwarding unit
//EX指令是否要取寄存器SR1或SR2
wire SR1, SR2;
assign SR1 = ~( ( IR_EX_r[6:2] == 5'b11011 )|UI_r_EX );
assign SR2 = ( IR_EX_r[3:2] == 2'b00&IR_EX_r[5] );
//是否需要Wb to Ex或Mem to Ex
wire Wb2Ex_sr1, Wb2Ex_sr2, Mem2Ex_sr1, Mem2Ex_sr2;
//非零寄存器
wire nonzeroRdW_r=|RdW_r;
wire nonzeroRdM_r=|RdM_r;

assign Wb2Ex_sr1 = ( RdW_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_WB & nonzeroRdW_r;
assign Wb2Ex_sr2 = ( RdW_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_WB & nonzeroRdW_r;
assign Mem2Ex_sr1 = ( RdM_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_MEM & nonzeroRdM_r;
assign Mem2Ex_sr2 = ( RdM_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_MEM & nonzeroRdM_r;

//回传ALU的描述在Contorl部分



//Load-Use Hazard部分
//对于LD-R类型编排的指令必须有Load-Use Hazard
//若LD_R_Hazard为真则阻塞EX段的输入，反而输入EX为一个NOP

//判断是否有数据冲突
wire SR1_ID, SR2_ID, isLWHazard;
assign SR1_ID = ~( ( IR_r[6:2] == 5'b11011 )|UI );
assign SR2_ID = ( IR_r[3:2] == 2'b00&IR_r[5] );
assign isLWHazard = (  ( Rd_r == IR_r[19:15] ) & SR1_ID & ( | IR_r[19:15] )  ) | (  Rd_r == IR_r[24:20] & SR2_ID &( |IR_r[24:20] )  );

//LD_R_Hazard = EX为LW且ID需要Mem读出的数据
wire LD_R_Hazard;
//其中MemtoReg_r_EX = LW_EX为EX段是否是LW命令
assign LD_R_Hazard = MemtoReg_r_EX&isLWHazard;


//Branch Hazard部分
//跳转成功时将已经进入流水线的两个指令清除为NOP
wire B_Hazard;
assign B_Hazard = PCChange_r_EX&( ( ( IR_EX_r[3:2] == 2'b00 )&zero )|IR_EX_r[2] );



//Debug_Bus
wire [4:0]DebugRegAddr;
wire [31:0]DebugRegData;
wire [7:0]DebugMemAddr;
wire [31:0]DebugMemData;
assign DebugRegAddr = chk_addr[4:0];
assign DebugMemAddr = chk_addr[7:0];

always @( * ) begin
    if( chk_addr[15:12] == 4'b0000 )
    case ( chk_addr[4:0] )
        5'h0:chk_data = pcn;
        5'h1:chk_data = pc;
        5'h2:chk_data = PCD_r;
        5'h3:chk_data = IR_r;
        5'h4:chk_data = {Mem2Ex_sr1, Wb2Ex_sr1, Mem2Ex_sr2, 
        Wb2Ex_sr2, B_Hazard, isLWHazard, MemtoReg_r_EX, 
        MemWrite_r_EX, ALUSrc_r_EX, 
        RegWrite_r_EX, MemRead_r_EX, PCChange_r_EX, UI_r_EX};
        5'h5:chk_data = PCE_r;
        5'h6:chk_data = A_r;
        5'h7:chk_data = B_r;
        5'h8:chk_data = Imm_r;
        5'h9:chk_data = IR_EX_r;
        5'hA:chk_data = {MemtoReg_r_MEM, MemWrite_r_MEM, RegWrite_r_MEM, MemRead_r_MEM};
        5'hB:chk_data = Y_r;
        5'hC:chk_data = MDW_r;
        5'hD:chk_data = IR_MEM_r;
        5'hE:chk_data = {MemtoReg_r_WB, RegWrite_r_WB};
        5'hF:chk_data = MDR_r;
        5'h10:chk_data = YW_r;
        5'h11:chk_data = IR_WB_r;
        default:chk_data = 0;
    endcase
    else if( chk_addr[15:12] == 4'b0001 )
        chk_data = DebugRegData;
    else if( chk_addr[15:12] == 4'b0010 )
        chk_data = DebugMemData;
end


//Control模块

//经过Forwarding之后的A_r和B_r
reg [31:0] A_r_fixed;
reg [31:0] B_r_fixed;

always @( * ) begin
  case( {Mem2Ex_sr1, Wb2Ex_sr1} )
  2'b00:A_r_fixed = A_r;
  2'b01:A_r_fixed = WriteData;
  2'b10:A_r_fixed = Y_r;
  2'b11:A_r_fixed = Y_r;
  default:A_r_fixed = 32'hxxxxxxxx;
  endcase

  case( {Mem2Ex_sr2, Wb2Ex_sr2} )
  2'b00:B_r_fixed = B_r;
  2'b01:B_r_fixed = WriteData;
  2'b10:B_r_fixed = Y_r;
  2'b11:B_r_fixed = Y_r;
  default:B_r_fixed = 32'hxxxxxxxx;
  endcase
end

//ALU输出的MUX
always @( * ) begin
  if((IR_EX_r[4:2]==4'b100)&IR_EX_r[14:13]==2'b01)//SLT相关指令
    if(IR_EX_r[12])Y=f[2];
    else Y=f[1]; 
  else
    Y=ALUResult;
end


//写入Mem的MUX
always @( * ) begin
  if( MemtoReg_r_WB )WriteData = MDR_r;
  else WriteData = YW_r;
end

wire JAL_Ex;
assign JAL_Ex=PCChange_r_EX&( IR_EX_r[2]);

//这里是ALU两个输入数据的选择
always @( * ) begin
  if( JAL_Ex |(UI_r_EX & ( ~IR_EX_r[5] ))) ALU1 = PCE_r;
  else if(UI_r_EX & IR_EX_r[5] ) ALU1 = 0;
  else ALU1 = A_r_fixed;

  if( JAL_Ex ) ALU2 = 4;
  else if( UI_r_EX ) ALU2 = {IR_EX_r[31:12], {12{1'b0}}};
  else if( ALUSrc_r_EX ) ALU2 = Imm_r;
  else ALU2 = B_r_fixed;
end


//信号的赋值
assign LW = IR_r[6:2] == 5'b00000;
assign MemtoReg = LW;//LW
assign MemRead = LW;//LW
assign SW = IR_r[6:2] == 5'b01000;
assign MemWrite = SW;//SW
assign ALUSrc = ( ~IR_r[5] )|( SW );
assign RegWrite = ~( IR_r[5]& ~( |IR_r[4:2]) );
assign PCChange = IR_r[6:4] == 3'b110;//改变PC的那几条指令初步判断
//UI指指令为LUI或AUIPC
assign UI = IR_r[4:2] == 3'b101;

wire op=~(|IR_r[14:12]);
wire sub;
assign sub= (~IR_r[2])&(IR_r[6]|(IR_r[4]&
          ((IR_r[14:13]==2'b01)|(op & IR_r[30] & IR_r[5]))));
wire add;
assign add= LW|SW|IR_r[2]|(IR_r[4] & op);
always @( * ) begin
  if(sub) ALUOp=3'b000;
  else if(add) ALUOp=3'b001;
  else case (IR_r[14:12])
    3'b001: ALUOp=6;
    3'b100: ALUOp=4;
    3'b101: if(IR_r[30])ALUOp=7;
            else        ALUOp=5;
    3'b110: ALUOp=3;
    3'b111: ALUOp=2;
    default: ALUOp=0;
  endcase
end
always @( * ) begin
  case (IR_EX_r[14:12])
    3'b000: zero=f[0];
    3'b001: zero=~f[0];
    3'b100: zero=f[1];
    3'b101: zero=~f[1];
    3'b110: zero=f[2];
    3'b111: zero=~f[2];
    default: zero=0;
  endcase
end

//pcn
always @( * ) begin
  if( PCChange_r_EX )
    pcMUX = IR_EX_r[3:2];
    //pcMUX = 00-11分别为B, JALR, 其他指令, JAL
  else
    pcMUX = 2'b10;
end
always @( * ) begin
  case ( pcMUX )
  2'b00:pcn =  ( zero )?(  PCE_r+ {{20{IR_EX_r[31]}}, IR_EX_r[7], IR_EX_r[30:25], IR_EX_r[11:8], 1'b0}  ): pc + 4;//Branch
  2'b01:pcn = ( A_r + {{20{IR_EX_r[31]}}, IR_EX_r[31:20]}  )&32'hFFFE;//JALR
  2'b10:pcn = pc+4;//普通周期
  2'b11:pcn = PCE_r + { {12{IR_EX_r[31]}}, IR_EX_r[19:12], IR_EX_r[20], IR_EX_r[30:21], 1'b0 };//JAL
  default:pcn = 4'bxxxx;
  endcase
end


always @( posedge clk or negedge rstn ) begin
  if( ~rstn ) pc <= 0;
  else if( LD_R_Hazard )pc <= pc;
  else pc <= pcn;
end

always @( posedge clk or negedge rstn ) begin
  if( ~rstn ) cnt <= 0;
  else cnt <= cnt+1;
end

ImmGen ImmGen( IR_r, Imm );
alu alu( ALU1, ALU2, ALUOp_r, ALUResult, f );
InstMem InstMem( pc[10:2], Ins );
register_file register_file( clk, IR_r[19:15], IR_r[24:20], Reg1Data, Reg2Data, RdW_r, WriteData, RegWrite_r_WB, DebugRegAddr, DebugRegData );



//DataMem&MMIO
//DataMem DataMem( Y_r[10:2], MDW_r, DebugMemAddr, clk, MemWrite_r_MEM, ReadMemData, DebugMemData );//DataMem
MEM_CACHE DataMem(
  .Address(Y_r[10:2]),
  .WriteData(MDW_r),
  .DebugAddr(DebugMemAddr),
  .clk(clk),
  .we(MemWrite_r_MEM),
  .rstn(rstn),
  .ReadData(ReadMemData),
  .DebugData(DebugMemData)
  );
wire MMIO;
assign MMIO = Y_r >= 32'hFF00;

assign io_we = MemWrite_r_MEM&MMIO;
assign io_rd = MemRead_r_MEM&MMIO;
assign io_addr = Y_r[7:0];
assign io_dout = MDW_r;
assign ReadData = MMIO?io_din:ReadMemData;

endmodule