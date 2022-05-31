`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/02 11:22:38
// Design Name: 
// Module Name: test
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


module test(

    );
      reg clk; 
  reg rstn;

  //IO_BUS
  wire [7:0]  io_addr=0;	//澶栬鍦板潃
  wire [31:0]  io_dout=0;	//鍚戝璁捐緭鍑虹殑鏁版嵁
  wire  io_we=0;		//鍚戝璁捐緭鍑烘暟鎹椂鐨勫啓浣胯兘淇″彿
  wire  io_rd=0;		//浠庡璁捐緭鍏ユ暟鎹椂鐨勮浣胯兘淇″彿
  reg [31:0]  io_din=0;	//鏉ヨ嚜澶栬杈撳叆鐨勬暟鎹?

  //Debug_BUS
  reg [31:0] pc=0; 	//褰撳墠鎵ц鎸囦护鍦板潃
  reg [15:0] chk_addr=16'h0000;	//鏁版嵁閫氳矾鐘舵?佺殑缂栫爜鍦板潃
  reg [31:0] chk_data=0;    //鏁版嵁閫氳矾鐘舵?佺殑鏁版嵁
  
  initial begin
  clk=0;
  forever #0.1 clk=~clk;
  end
  
   initial begin
  rstn=0;
  #1 rstn =1;
  end
  
  
  
  
  
  
//De 段生成信号
wire MemtoReg, MemWrite, ALUSrc, RegWrite, MemRead, PCChange, UI;
reg [3:0]ALUOp;

//ALU 的两个输入
reg [31:0]ALU1, ALU2;//MUX
//写入 Mem 的数据
reg [31:0]WriteData;
//下一个 PC
reg [31:0]pcn;
//PC 的 MUX
reg [2:0]pcMUX;
//从 InsMem 读出的指令
wire [31:0]Ins;
//从寄存器读出的两个值
wire [31:0]Reg1Data, Reg2Data;
// ALU 的输出
wire [31:0]ALUResult;
//最终给 Y_r 的值
reg [31:0] Y;
// ALU 的 f 输出
wire [2:0]f;
// Br 指令是否跳转的信号
reg zero;
//处理的立即数
wire [31:0]Imm;
//结合 MMIO 之后最终 LD 读出来的数据
wire [31:0]ReadData;
// LD 指令从 Mem 读出来的数据
wire [31:0]ReadMemData;
//周期数cnt
reg [31:0]cnt;
//跳转数cnt
reg [31:0]JmpCnt;
//改变PC指令(JAR JARR BRANCH)的cnt
reg [31:0]PCChangeInsCnt;
//预测成功cnt
reg [31:0]PredHitCnt;

//pipeline

/* 
PCD_r IF-ID 段 pc
IR_r  IF-ID 段 IR
PCE_r ID-EX 段 pc
A_r   ID-EX 段从寄存器堆中读出来的第一个寄存器
B_r   第二个
Imm_r ID-EX 段立即数
Rd_r  ID-EX 段目标寄存器
Y_r   EX-MEM 段 Alu 结果
MDW_r EX-MEM 段 Mem 要写回的地址
RdM_r EX-MEM 段目标寄存器
MDR_r MEM-WB 段从 Mem 读出的数据
YW_r  MEM-WB 段 Alu 结果
RdW_r MEM-WB 段目标寄存器
 */
reg [31:0] PCD_r, IR_r, PCE_r, A_r, B_r, Imm_r, Rd_r, Y_r, MDW_r, RdM_r, MDR_r, YW_r, RdW_r;

//传递 IR 到流水线后面
reg [31:0] IR_EX_r, IR_MEM_r, IR_WB_r;

//ALUOp 的传递
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
  IR_r <= 32'h00000013;//变成 NOP
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

  if( B_Hazard )//branch hazard ，清为 NOP
      IR_r <= 32'h00000013;
  else if( LD_R_Hazard )//Load hazard， stall 一个周期
      IR_r <= IR_r;
  else if(predictJ)
      IR_r <= nextBranch;
  else
      IR_r <= Ins;
  
  if( LD_R_Hazard )begin
    PCD_r <= PCD_r;
  end
  else if(predictJ)
    PCD_r <= PredictPC;
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
  predictJ_r_Ex<=0;
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
    predictJ_r_Ex<=0;
    MemtoReg_r_EX <= 0;
    MemWrite_r_EX <= 0;
    RegWrite_r_EX <= 0;
    MemRead_r_EX <= 0;
    PCChange_r_EX <= 0;
  end
  else
  begin
    predictJ_r_Ex<=predictJ;
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
// EX 指令是否要取寄存器 SR1 或 SR2
wire SR1, SR2;
assign SR1 = ~( ( IR_EX_r[6:2] == 5'b11011 )|UI_r_EX );
assign SR2 = ( IR_EX_r[3:2] == 2'b00&IR_EX_r[5] );
//是否需要 Wb to Ex 或 Mem to Ex
wire Wb2Ex_sr1, Wb2Ex_sr2, Mem2Ex_sr1, Mem2Ex_sr2;
//非零寄存器
wire nonzeroRdW_r=|RdW_r;
wire nonzeroRdM_r=|RdM_r;

assign Wb2Ex_sr1 = ( RdW_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_WB & nonzeroRdW_r;
assign Wb2Ex_sr2 = ( RdW_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_WB & nonzeroRdW_r;
assign Mem2Ex_sr1 = ( RdM_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_MEM & nonzeroRdM_r;
assign Mem2Ex_sr2 = ( RdM_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_MEM & nonzeroRdM_r;

//回传 ALU 的描述在 Contorl 部分



//Load-Use Hazard部分
//对于 LD-R 类型编排的指令必须有 Load-Use Hazard
//若 LD_R_Hazard 为真则阻塞 EX 段的输入，反而输入 EX 为一个 NOP

//判断是否有数据冲突
wire SR1_ID, SR2_ID, isLWHazard;
assign SR1_ID = ~( ( IR_r[6:2] == 5'b11011 )|UI );
assign SR2_ID = ( IR_r[3:2] == 2'b00&IR_r[5] );
assign isLWHazard = (  ( Rd_r == IR_r[19:15] ) & SR1_ID & ( | IR_r[19:15] )  ) | (  Rd_r == IR_r[24:20] & SR2_ID &( |IR_r[24:20] )  );

//LD_R_Hazard = EX为LW且ID需要Mem读出的数据
wire LD_R_Hazard;
//其中MemtoReg_r_EX = LW_EX为EX段是否是LW命令
assign LD_R_Hazard = MemtoReg_r_EX&isLWHazard;


//Branch Hazard 部分
//JARR 和预测失败时将已经进入流水线的两个指令清除为 NOP
wire B_Hazard;
wire JARR;
assign JARR=PCChange_r_EX&(IR_EX_r[2]&~IR_EX_r[3]);
assign B_Hazard = predictJ_r_Ex ^ ifJ;





//动态预测部分

//预测是跳转还是不跳转，若为 1 则预测为跳转
wire predictJ;
reg predictJ_r_Ex;
//若原预测为 Branch 预测跳转或 JAR 必定跳转 且 cache 命中时，跳转
//否则最终预测为不跳转
// JARR 默认不跳转，因为寄存器的值未知
assign predictJ = InsCacheRead & hit;


//是否是branch指令
wire Branch_Ex ;
assign Branch_Ex = PCChange_r_EX & ~(IR_EX_r[3] | IR_EX_r[2]);

//分支结果判明，改变饱和寄存器的使能
//只有 Br 才改变饱和寄存器
wire SCwe;
assign SCwe = Branch_Ex;

//是否跳转
reg ifJ;
always @(*) begin
  if(PCChange_r_EX)
    begin
      if(IR_EX_r[2])//JAR & JARR
        ifJ=1;
      else if(~(IR_EX_r[3]|IR_EX_r[2]))//Branch
        ifJ=zero;
      else ifJ=0;
    end
  else ifJ=0;
end

//4bits 全局历史寄存器，对应16个PHT
reg[3:0] GHR;

always @(posedge clk or negedge rstn) begin
  if(~rstn) GHR=4'b0101;
  else if(Branch_Ex)
        GHR={GHR[2:0],zero};
end

//编码器，用于定位饱和计数器 SC
wire [15:0]x;
decoder_4t16 decoder_x(GHR,x);

//一个 PHT 由 PCD_r[5:2] 确定，即一个 PHT 有16个 saturatingCounter 即饱和计数器

wire [15:0]y_ex;
decoder_4t16 decoder_y_ex(PCE_r[5:2],y_ex);

// saturatingCounter 的输出
wire [15:0]SCout[15:0];

genvar i;
genvar j;
generate
    for(i=0; i<16; i=i+1)
      for(j=0;j<16;j=j+1)
      begin
        wire out;
        saturatingCounter SC(clk,rstn,SCwe & (x[i]) & (y_ex[i]),
                            zero,SCout[i][j]);
      end
endgenerate

wire branchTrue = SCout[GHR][PCD_r[5:2]];

wire InsCacheRead;// JAR 或 BR 原预测成功
assign InsCacheRead =  PCChange & ( ( ( ~(|IR_r[3:2])) & branchTrue) | ( &IR_r[3:2] ) );

wire[31:0] nextBranch;
wire hit;

//从指令存储取回对应的指令
wire AddressReady;
assign AddressReady= InsCacheAdd==pc;

//该寄存器存储 Inscache 是否需要更新值
//当原预测为跳转且未命中时置为 1，预示需要读取内存获取跳转地址
reg InsCacheNeed;

//跳转指令指示的地址
reg [31:0]InsCacheAdd;
//地址里面对应的内容
wire [31:0] InsCacheData;
assign InsCacheData=Ins;

always @(posedge clk or negedge rstn) begin
  if(~rstn) 
  begin
    InsCacheAdd<=0;
    InsCacheNeed<=0;
  end
  else begin
    if(PCChange & ( ~( |IR_r[3:2] ) | (  & ( &IR_r[3:2] ) ) ) & ~hit)//为跳转指令且不命中时，准备将其读入cache
    begin
      InsCacheNeed<=1;
      InsCacheAdd<=PredictPC;
    end
    else
      if(AddressReady)
        begin
          InsCacheNeed<=0;
        end
  end
end

InsCache InsCache(clk,PredictPC,nextBranch,hit,
                  AddressReady&InsCacheNeed,InsCacheAdd,InsCacheData);



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

        5'h1c:chk_data = cnt;
        5'h1d:chk_data = JmpCnt;
        5'h1e:chk_data = PCChangeInsCnt;
        5'h1f:chk_data = PredHitCnt;
        default:chk_data = 0;
    endcase
    else if( chk_addr[15:12] == 4'b0001 )
        chk_data = DebugRegData;
    else if( chk_addr[15:12] == 4'b0010 )
        chk_data = DebugMemData;
end


//Control模块

//经过 Forwarding 之后的 A_r 和 B_r
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

//ALU 输出的 MUX
always @( * ) begin
  if((IR_EX_r[4:2]==4'b100)&IR_EX_r[14:13]==2'b01)//SLT 相关指令
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

//这里是 ALU 两个输入数据的选择
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
//UI 指指令为 LUI 或 AUIPC
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


//预测的 pc 计算中间值
reg [31:0]PredictPC;

always @(*) begin
  case ( IR_r[3:2] )
      2'b00:PredictPC = PCD_r+ {{20{IR_r[31]}}, IR_r[7], IR_r[30:25], IR_r[11:8], 1'b0}  ;//Branch
      2'b11:PredictPC = PCD_r + { {12{IR_r[31]}}, IR_r[19:12], IR_r[20], IR_r[30:21], 1'b0 }  ;//JAL
      default:PredictPC = pc;
  endcase
end

//pcn
always @( * ) begin
  if( PCChange_r_EX )
    pcMUX = IR_EX_r[3:2];
    //pcMUX = 00-11 分别为 B, JALR, 其他指令, JAL
  else
    pcMUX = 2'b10;  
end
always @( * ) begin
  if(B_Hazard)
    begin
    if(predictJ_r_Ex)
      pcn=PCE_r+4;
    else 
    case ( pcMUX )
    2'b00:pcn =  ( zero )?(  PCE_r+ {{20{IR_EX_r[31]}}, IR_EX_r[7], IR_EX_r[30:25], IR_EX_r[11:8], 1'b0}  ): pc + 4;//Branch
    2'b01:pcn = ( A_r_fixed + {{20{IR_EX_r[31]}}, IR_EX_r[31:20]}  )&32'hFFFE;//JALR
    2'b10:pcn = pc+4;//普通周期
    2'b11:pcn = PCE_r + { {12{IR_EX_r[31]}}, IR_EX_r[19:12], IR_EX_r[20], IR_EX_r[30:21], 1'b0 };//JAL
    default:pcn = 4'bxxxx;
    endcase
    end
  else
    if(predictJ)
    begin
      pcn=PredictPC+4;
    end
    else
    pcn=pc+4;
end

always @( posedge clk or negedge rstn ) begin
  if( ~rstn ) pc <= 0;
  else if( LD_R_Hazard )pc <= pc;
  else pc <= pcn;
end

always @( posedge clk or negedge rstn ) begin
  if( ~rstn ) 
  begin
  cnt <= 0;
  JmpCnt <= 0;
  PCChangeInsCnt <= 0;
  PredHitCnt <= 0;
  end
  else 
  begin
  cnt <= cnt+1;
  if(ifJ)
  JmpCnt <= JmpCnt+1;
  if(PCChange_r_EX & pcMUX!=2'b10)
  PCChangeInsCnt <= PCChangeInsCnt+1;
  if(PCChange_r_EX & pcMUX!=2'b10 & ( ifJ ^~ predictJ_r_Ex ))
  PredHitCnt <= PredHitCnt+1;
  end
end



ImmGen ImmGen( IR_r, Imm );
alu alu( ALU1, ALU2, ALUOp_r, ALUResult, f );
InstMem InstMem( pc[10:2], Ins );
register_file register_file( clk, IR_r[19:15], IR_r[24:20], Reg1Data, Reg2Data, RdW_r, WriteData, RegWrite_r_WB, DebugRegAddr, DebugRegData );


wire CacheHit;

//DataMem&MMIO
//DataMem DataMem( Y_r[10:2], MDW_r, DebugMemAddr, clk, MemWrite_r_MEM, ReadMemData, DebugMemData );//DataMem
MEM_CACHE DataMem(
  .Address(Y_r[10:2]),
  .WriteData(MDW_r),
  .DebugAddr(DebugMemAddr),
  .clk(clk),
  .wr_req(MemWrite_r_MEM),
  .rd_req(MemRead_r_MEM),
  .rstn(rstn),
  .ReadData(ReadMemData),
  .DebugData(DebugMemData),
  .hit_m(CacheHit)
  );

wire MMIO;
assign MMIO = Y_r >= 32'hFF00;

assign io_we = MemWrite_r_MEM&MMIO;
assign io_rd = MemRead_r_MEM&MMIO;
assign io_addr = Y_r[7:0];
assign io_dout = MDW_r;
assign ReadData = MMIO?io_din:ReadMemData;

  endmodule
