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
  wire [7:0]  io_addr=0;	//外设地址
  wire [31:0]  io_dout=0;	//向外设输出的数据
  wire  io_we=0;		//向外设输出数据时的写使能信号
  wire  io_rd=0;		//从外设输入数据时的读使能信号
  reg [31:0]  io_din=0;	//来自外设输入的数�?

  //Debug_BUS
  reg [31:0] pc=0; 	//当前执行指令地址
  reg [15:0] chk_addr=16'h0000;	//数据通路状�?�的编码地址
  reg [31:0] chk_data=0;    //数据通路状�?�的数据
  
  initial begin
  clk=0;
  forever #0.1 clk=~clk;
  end
  
   initial begin
  rstn=0;
  #1 rstn =1;
  end
  
  
  
  
  
  
//De �������ź�
wire MemtoReg, MemWrite, ALUSrc, RegWrite, MemRead, PCChange, UI;
reg [3:0]ALUOp;

//ALU ����������
reg [31:0]ALU1, ALU2;//MUX
//д�� Mem ������
reg [31:0]WriteData;
//��һ�� PC
reg [31:0]pcn;
//PC �� MUX
reg [2:0]pcMUX;
//�� InsMem ������ָ��
wire [31:0]Ins;
//�ӼĴ�������������ֵ
wire [31:0]Reg1Data, Reg2Data;
// ALU �����
wire [31:0]ALUResult;
//���ո� Y_r ��ֵ
reg [31:0] Y;
// ALU �� f ���
wire [2:0]f;
// Br ָ���Ƿ���ת���ź�
reg zero;
//�����������
wire [31:0]Imm;
//��� MMIO ֮������ LD ������������
wire [31:0]ReadData;
// LD ָ��� Mem ������������
wire [31:0]ReadMemData;
//������cnt
reg [31:0]cnt;
//��ת��cnt
reg [31:0]JmpCnt;
//�ı�PCָ��(JAR JARR BRANCH)��cnt
reg [31:0]PCChangeInsCnt;
//Ԥ��ɹ�cnt
reg [31:0]PredHitCnt;

//pipeline

/* 
PCD_r IF-ID �� pc
IR_r  IF-ID �� IR
PCE_r ID-EX �� pc
A_r   ID-EX �δӼĴ������ж������ĵ�һ���Ĵ���
B_r   �ڶ���
Imm_r ID-EX ��������
Rd_r  ID-EX ��Ŀ��Ĵ���
Y_r   EX-MEM �� Alu ���
MDW_r EX-MEM �� Mem Ҫд�صĵ�ַ
RdM_r EX-MEM ��Ŀ��Ĵ���
MDR_r MEM-WB �δ� Mem ����������
YW_r  MEM-WB �� Alu ���
RdW_r MEM-WB ��Ŀ��Ĵ���
 */
reg [31:0] PCD_r, IR_r, PCE_r, A_r, B_r, Imm_r, Rd_r, Y_r, MDW_r, RdM_r, MDR_r, YW_r, RdW_r;

//���� IR ����ˮ�ߺ���
reg [31:0] IR_EX_r, IR_MEM_r, IR_WB_r;

//ALUOp �Ĵ���
reg [3:0] ALUOp_r;

//�������źŸ����׶εĴ���
reg MemtoReg_r_EX, MemWrite_r_EX, ALUSrc_r_EX, RegWrite_r_EX, MemRead_r_EX, PCChange_r_EX, UI_r_EX;

reg MemtoReg_r_MEM, MemWrite_r_MEM, RegWrite_r_MEM, MemRead_r_MEM;

reg MemtoReg_r_WB, RegWrite_r_WB;

//data path of pipeline
always @( posedge clk or negedge rstn ) begin
  if( ~rstn )
  begin
  PCD_r <= 0;
  IR_r <= 32'h00000013;//��� NOP
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

  if( B_Hazard )//branch hazard ����Ϊ NOP
      IR_r <= 32'h00000013;
  else if( LD_R_Hazard )//Load hazard�� stall һ������
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
// EX ָ���Ƿ�Ҫȡ�Ĵ��� SR1 �� SR2
wire SR1, SR2;
assign SR1 = ~( ( IR_EX_r[6:2] == 5'b11011 )|UI_r_EX );
assign SR2 = ( IR_EX_r[3:2] == 2'b00&IR_EX_r[5] );
//�Ƿ���Ҫ Wb to Ex �� Mem to Ex
wire Wb2Ex_sr1, Wb2Ex_sr2, Mem2Ex_sr1, Mem2Ex_sr2;
//����Ĵ���
wire nonzeroRdW_r=|RdW_r;
wire nonzeroRdM_r=|RdM_r;

assign Wb2Ex_sr1 = ( RdW_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_WB & nonzeroRdW_r;
assign Wb2Ex_sr2 = ( RdW_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_WB & nonzeroRdW_r;
assign Mem2Ex_sr1 = ( RdM_r == IR_EX_r[19:15] ) & SR1 & RegWrite_r_MEM & nonzeroRdM_r;
assign Mem2Ex_sr2 = ( RdM_r == IR_EX_r[24:20] ) & SR2 & RegWrite_r_MEM & nonzeroRdM_r;

//�ش� ALU �������� Contorl ����



//Load-Use Hazard����
//���� LD-R ���ͱ��ŵ�ָ������� Load-Use Hazard
//�� LD_R_Hazard Ϊ�������� EX �ε����룬�������� EX Ϊһ�� NOP

//�ж��Ƿ������ݳ�ͻ
wire SR1_ID, SR2_ID, isLWHazard;
assign SR1_ID = ~( ( IR_r[6:2] == 5'b11011 )|UI );
assign SR2_ID = ( IR_r[3:2] == 2'b00&IR_r[5] );
assign isLWHazard = (  ( Rd_r == IR_r[19:15] ) & SR1_ID & ( | IR_r[19:15] )  ) | (  Rd_r == IR_r[24:20] & SR2_ID &( |IR_r[24:20] )  );

//LD_R_Hazard = EXΪLW��ID��ҪMem����������
wire LD_R_Hazard;
//����MemtoReg_r_EX = LW_EXΪEX���Ƿ���LW����
assign LD_R_Hazard = MemtoReg_r_EX&isLWHazard;


//Branch Hazard ����
//JARR ��Ԥ��ʧ��ʱ���Ѿ�������ˮ�ߵ�����ָ�����Ϊ NOP
wire B_Hazard;
wire JARR;
assign JARR=PCChange_r_EX&(IR_EX_r[2]&~IR_EX_r[3]);
assign B_Hazard = predictJ_r_Ex ^ ifJ;





//��̬Ԥ�ⲿ��

//Ԥ������ת���ǲ���ת����Ϊ 1 ��Ԥ��Ϊ��ת
wire predictJ;
reg predictJ_r_Ex;
//��ԭԤ��Ϊ Branch Ԥ����ת�� JAR �ض���ת �� cache ����ʱ����ת
//��������Ԥ��Ϊ����ת
// JARR Ĭ�ϲ���ת����Ϊ�Ĵ�����ֵδ֪
assign predictJ = InsCacheRead & hit;


//�Ƿ���branchָ��
wire Branch_Ex ;
assign Branch_Ex = PCChange_r_EX & ~(IR_EX_r[3] | IR_EX_r[2]);

//��֧����������ı䱥�ͼĴ�����ʹ��
//ֻ�� Br �Ÿı䱥�ͼĴ���
wire SCwe;
assign SCwe = Branch_Ex;

//�Ƿ���ת
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

//4bits ȫ����ʷ�Ĵ�������Ӧ16��PHT
reg[3:0] GHR;

always @(posedge clk or negedge rstn) begin
  if(~rstn) GHR=4'b0101;
  else if(Branch_Ex)
        GHR={GHR[2:0],zero};
end

//�����������ڶ�λ���ͼ����� SC
wire [15:0]x;
decoder_4t16 decoder_x(GHR,x);

//һ�� PHT �� PCD_r[5:2] ȷ������һ�� PHT ��16�� saturatingCounter �����ͼ�����

wire [15:0]y_ex;
decoder_4t16 decoder_y_ex(PCE_r[5:2],y_ex);

// saturatingCounter �����
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

wire InsCacheRead;// JAR �� BR ԭԤ��ɹ�
assign InsCacheRead =  PCChange & ( ( ( ~(|IR_r[3:2])) & branchTrue) | ( &IR_r[3:2] ) );

wire[31:0] nextBranch;
wire hit;

//��ָ��洢ȡ�ض�Ӧ��ָ��
wire AddressReady;
assign AddressReady= InsCacheAdd==pc;

//�üĴ����洢 Inscache �Ƿ���Ҫ����ֵ
//��ԭԤ��Ϊ��ת��δ����ʱ��Ϊ 1��Ԥʾ��Ҫ��ȡ�ڴ��ȡ��ת��ַ
reg InsCacheNeed;

//��תָ��ָʾ�ĵ�ַ
reg [31:0]InsCacheAdd;
//��ַ�����Ӧ������
wire [31:0] InsCacheData;
assign InsCacheData=Ins;

always @(posedge clk or negedge rstn) begin
  if(~rstn) 
  begin
    InsCacheAdd<=0;
    InsCacheNeed<=0;
  end
  else begin
    if(PCChange & ( ~( |IR_r[3:2] ) | (  & ( &IR_r[3:2] ) ) ) & ~hit)//Ϊ��תָ���Ҳ�����ʱ��׼���������cache
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


//Controlģ��

//���� Forwarding ֮��� A_r �� B_r
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

//ALU ����� MUX
always @( * ) begin
  if((IR_EX_r[4:2]==4'b100)&IR_EX_r[14:13]==2'b01)//SLT ���ָ��
    if(IR_EX_r[12])Y=f[2];
    else Y=f[1]; 
  else
    Y=ALUResult;
end


//д��Mem��MUX
always @( * ) begin
  if( MemtoReg_r_WB )WriteData = MDR_r;
  else WriteData = YW_r;
end

wire JAL_Ex;
assign JAL_Ex=PCChange_r_EX&( IR_EX_r[2]);

//������ ALU �����������ݵ�ѡ��
always @( * ) begin
  if( JAL_Ex |(UI_r_EX & ( ~IR_EX_r[5] ))) ALU1 = PCE_r;
  else if(UI_r_EX & IR_EX_r[5] ) ALU1 = 0;
  else ALU1 = A_r_fixed;

  if( JAL_Ex ) ALU2 = 4;
  else if( UI_r_EX ) ALU2 = {IR_EX_r[31:12], {12{1'b0}}};
  else if( ALUSrc_r_EX ) ALU2 = Imm_r;
  else ALU2 = B_r_fixed;
end


//�źŵĸ�ֵ
assign LW = IR_r[6:2] == 5'b00000;
assign MemtoReg = LW;//LW
assign MemRead = LW;//LW
assign SW = IR_r[6:2] == 5'b01000;
assign MemWrite = SW;//SW
assign ALUSrc = ( ~IR_r[5] )|( SW );
assign RegWrite = ~( IR_r[5]& ~( |IR_r[4:2]) );
assign PCChange = IR_r[6:4] == 3'b110;//�ı�PC���Ǽ���ָ������ж�
//UI ָָ��Ϊ LUI �� AUIPC
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


//Ԥ��� pc �����м�ֵ
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
    //pcMUX = 00-11 �ֱ�Ϊ B, JALR, ����ָ��, JAL
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
    2'b10:pcn = pc+4;//��ͨ����
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
