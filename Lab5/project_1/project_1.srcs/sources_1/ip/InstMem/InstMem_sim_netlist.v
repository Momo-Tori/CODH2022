// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon May  2 15:31:02 2022
// Host        : Yun running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/CodeTry/CODExperiment/Lab5/project_1/project_1.srcs/sources_1/ip/InstMem/InstMem_sim_netlist.v
// Design      : InstMem
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "InstMem,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module InstMem
   (a,
    spo);
  input [7:0]a;
  output [31:0]spo;

  wire [7:0]a;
  wire [31:0]spo;
  wire [31:0]NLW_U0_dpo_UNCONNECTED;
  wire [31:0]NLW_U0_qdpo_UNCONNECTED;
  wire [31:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "artix7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "8" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "256" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "InstMem.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "32" *) 
  InstMem_dist_mem_gen_v8_0_13 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[31:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[31:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[31:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule

(* C_ADDR_WIDTH = "8" *) (* C_DEFAULT_DATA = "0" *) (* C_DEPTH = "256" *) 
(* C_ELABORATION_DIR = "./" *) (* C_FAMILY = "artix7" *) (* C_HAS_CLK = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_DPO = "0" *) (* C_HAS_DPRA = "0" *) 
(* C_HAS_I_CE = "0" *) (* C_HAS_QDPO = "0" *) (* C_HAS_QDPO_CE = "0" *) 
(* C_HAS_QDPO_CLK = "0" *) (* C_HAS_QDPO_RST = "0" *) (* C_HAS_QDPO_SRST = "0" *) 
(* C_HAS_QSPO = "0" *) (* C_HAS_QSPO_CE = "0" *) (* C_HAS_QSPO_RST = "0" *) 
(* C_HAS_QSPO_SRST = "0" *) (* C_HAS_SPO = "1" *) (* C_HAS_WE = "0" *) 
(* C_MEM_INIT_FILE = "InstMem.mif" *) (* C_MEM_TYPE = "0" *) (* C_PARSER_TYPE = "1" *) 
(* C_PIPELINE_STAGES = "0" *) (* C_QCE_JOINED = "0" *) (* C_QUALIFY_WE = "0" *) 
(* C_READ_MIF = "1" *) (* C_REG_A_D_INPUTS = "0" *) (* C_REG_DPRA_INPUT = "0" *) 
(* C_SYNC_ENABLE = "1" *) (* C_WIDTH = "32" *) (* ORIG_REF_NAME = "dist_mem_gen_v8_0_13" *) 
module InstMem_dist_mem_gen_v8_0_13
   (a,
    d,
    dpra,
    clk,
    we,
    i_ce,
    qspo_ce,
    qdpo_ce,
    qdpo_clk,
    qspo_rst,
    qdpo_rst,
    qspo_srst,
    qdpo_srst,
    spo,
    dpo,
    qspo,
    qdpo);
  input [7:0]a;
  input [31:0]d;
  input [7:0]dpra;
  input clk;
  input we;
  input i_ce;
  input qspo_ce;
  input qdpo_ce;
  input qdpo_clk;
  input qspo_rst;
  input qdpo_rst;
  input qspo_srst;
  input qdpo_srst;
  output [31:0]spo;
  output [31:0]dpo;
  output [31:0]qspo;
  output [31:0]qdpo;

  wire \<const0> ;
  wire [7:0]a;
  wire [31:0]\^spo ;

  assign dpo[31] = \<const0> ;
  assign dpo[30] = \<const0> ;
  assign dpo[29] = \<const0> ;
  assign dpo[28] = \<const0> ;
  assign dpo[27] = \<const0> ;
  assign dpo[26] = \<const0> ;
  assign dpo[25] = \<const0> ;
  assign dpo[24] = \<const0> ;
  assign dpo[23] = \<const0> ;
  assign dpo[22] = \<const0> ;
  assign dpo[21] = \<const0> ;
  assign dpo[20] = \<const0> ;
  assign dpo[19] = \<const0> ;
  assign dpo[18] = \<const0> ;
  assign dpo[17] = \<const0> ;
  assign dpo[16] = \<const0> ;
  assign dpo[15] = \<const0> ;
  assign dpo[14] = \<const0> ;
  assign dpo[13] = \<const0> ;
  assign dpo[12] = \<const0> ;
  assign dpo[11] = \<const0> ;
  assign dpo[10] = \<const0> ;
  assign dpo[9] = \<const0> ;
  assign dpo[8] = \<const0> ;
  assign dpo[7] = \<const0> ;
  assign dpo[6] = \<const0> ;
  assign dpo[5] = \<const0> ;
  assign dpo[4] = \<const0> ;
  assign dpo[3] = \<const0> ;
  assign dpo[2] = \<const0> ;
  assign dpo[1] = \<const0> ;
  assign dpo[0] = \<const0> ;
  assign qdpo[31] = \<const0> ;
  assign qdpo[30] = \<const0> ;
  assign qdpo[29] = \<const0> ;
  assign qdpo[28] = \<const0> ;
  assign qdpo[27] = \<const0> ;
  assign qdpo[26] = \<const0> ;
  assign qdpo[25] = \<const0> ;
  assign qdpo[24] = \<const0> ;
  assign qdpo[23] = \<const0> ;
  assign qdpo[22] = \<const0> ;
  assign qdpo[21] = \<const0> ;
  assign qdpo[20] = \<const0> ;
  assign qdpo[19] = \<const0> ;
  assign qdpo[18] = \<const0> ;
  assign qdpo[17] = \<const0> ;
  assign qdpo[16] = \<const0> ;
  assign qdpo[15] = \<const0> ;
  assign qdpo[14] = \<const0> ;
  assign qdpo[13] = \<const0> ;
  assign qdpo[12] = \<const0> ;
  assign qdpo[11] = \<const0> ;
  assign qdpo[10] = \<const0> ;
  assign qdpo[9] = \<const0> ;
  assign qdpo[8] = \<const0> ;
  assign qdpo[7] = \<const0> ;
  assign qdpo[6] = \<const0> ;
  assign qdpo[5] = \<const0> ;
  assign qdpo[4] = \<const0> ;
  assign qdpo[3] = \<const0> ;
  assign qdpo[2] = \<const0> ;
  assign qdpo[1] = \<const0> ;
  assign qdpo[0] = \<const0> ;
  assign qspo[31] = \<const0> ;
  assign qspo[30] = \<const0> ;
  assign qspo[29] = \<const0> ;
  assign qspo[28] = \<const0> ;
  assign qspo[27] = \<const0> ;
  assign qspo[26] = \<const0> ;
  assign qspo[25] = \<const0> ;
  assign qspo[24] = \<const0> ;
  assign qspo[23] = \<const0> ;
  assign qspo[22] = \<const0> ;
  assign qspo[21] = \<const0> ;
  assign qspo[20] = \<const0> ;
  assign qspo[19] = \<const0> ;
  assign qspo[18] = \<const0> ;
  assign qspo[17] = \<const0> ;
  assign qspo[16] = \<const0> ;
  assign qspo[15] = \<const0> ;
  assign qspo[14] = \<const0> ;
  assign qspo[13] = \<const0> ;
  assign qspo[12] = \<const0> ;
  assign qspo[11] = \<const0> ;
  assign qspo[10] = \<const0> ;
  assign qspo[9] = \<const0> ;
  assign qspo[8] = \<const0> ;
  assign qspo[7] = \<const0> ;
  assign qspo[6] = \<const0> ;
  assign qspo[5] = \<const0> ;
  assign qspo[4] = \<const0> ;
  assign qspo[3] = \<const0> ;
  assign qspo[2] = \<const0> ;
  assign qspo[1] = \<const0> ;
  assign qspo[0] = \<const0> ;
  assign spo[31:2] = \^spo [31:2];
  assign spo[1] = \^spo [0];
  assign spo[0] = \^spo [0];
  GND GND
       (.G(\<const0> ));
  InstMem_dist_mem_gen_v8_0_13_synth \synth_options.dist_mem_inst 
       (.a(a),
        .spo({\^spo [31:2],\^spo [0]}));
endmodule

(* ORIG_REF_NAME = "dist_mem_gen_v8_0_13_synth" *) 
module InstMem_dist_mem_gen_v8_0_13_synth
   (spo,
    a);
  output [30:0]spo;
  input [7:0]a;

  wire [7:0]a;
  wire [30:0]spo;

  InstMem_rom \gen_rom.rom_inst 
       (.a(a),
        .spo(spo));
endmodule

(* ORIG_REF_NAME = "rom" *) 
module InstMem_rom
   (spo,
    a);
  output [30:0]spo;
  input [7:0]a;

  wire [7:0]a;
  wire [30:0]spo;
  wire \spo[0]_INST_0_i_1_n_0 ;
  wire \spo[10]_INST_0_i_1_n_0 ;
  wire \spo[11]_INST_0_i_1_n_0 ;
  wire \spo[11]_INST_0_i_2_n_0 ;
  wire \spo[13]_INST_0_i_1_n_0 ;
  wire \spo[14]_INST_0_i_1_n_0 ;
  wire \spo[15]_INST_0_i_1_n_0 ;
  wire \spo[15]_INST_0_i_2_n_0 ;
  wire \spo[15]_INST_0_i_3_n_0 ;
  wire \spo[16]_INST_0_i_1_n_0 ;
  wire \spo[16]_INST_0_i_2_n_0 ;
  wire \spo[16]_INST_0_i_3_n_0 ;
  wire \spo[17]_INST_0_i_1_n_0 ;
  wire \spo[17]_INST_0_i_2_n_0 ;
  wire \spo[17]_INST_0_i_3_n_0 ;
  wire \spo[18]_INST_0_i_1_n_0 ;
  wire \spo[19]_INST_0_i_1_n_0 ;
  wire \spo[19]_INST_0_i_2_n_0 ;
  wire \spo[19]_INST_0_i_3_n_0 ;
  wire \spo[20]_INST_0_i_1_n_0 ;
  wire \spo[20]_INST_0_i_2_n_0 ;
  wire \spo[20]_INST_0_i_3_n_0 ;
  wire \spo[20]_INST_0_i_4_n_0 ;
  wire \spo[20]_INST_0_i_5_n_0 ;
  wire \spo[20]_INST_0_i_6_n_0 ;
  wire \spo[21]_INST_0_i_1_n_0 ;
  wire \spo[21]_INST_0_i_2_n_0 ;
  wire \spo[21]_INST_0_i_3_n_0 ;
  wire \spo[21]_INST_0_i_4_n_0 ;
  wire \spo[22]_INST_0_i_1_n_0 ;
  wire \spo[22]_INST_0_i_2_n_0 ;
  wire \spo[22]_INST_0_i_3_n_0 ;
  wire \spo[22]_INST_0_i_4_n_0 ;
  wire \spo[23]_INST_0_i_1_n_0 ;
  wire \spo[23]_INST_0_i_2_n_0 ;
  wire \spo[23]_INST_0_i_3_n_0 ;
  wire \spo[23]_INST_0_i_4_n_0 ;
  wire \spo[23]_INST_0_i_5_n_0 ;
  wire \spo[23]_INST_0_i_6_n_0 ;
  wire \spo[24]_INST_0_i_1_n_0 ;
  wire \spo[24]_INST_0_i_2_n_0 ;
  wire \spo[24]_INST_0_i_3_n_0 ;
  wire \spo[25]_INST_0_i_1_n_0 ;
  wire \spo[25]_INST_0_i_2_n_0 ;
  wire \spo[25]_INST_0_i_3_n_0 ;
  wire \spo[26]_INST_0_i_1_n_0 ;
  wire \spo[26]_INST_0_i_2_n_0 ;
  wire \spo[27]_INST_0_i_1_n_0 ;
  wire \spo[27]_INST_0_i_2_n_0 ;
  wire \spo[27]_INST_0_i_3_n_0 ;
  wire \spo[27]_INST_0_i_4_n_0 ;
  wire \spo[28]_INST_0_i_1_n_0 ;
  wire \spo[28]_INST_0_i_2_n_0 ;
  wire \spo[29]_INST_0_i_1_n_0 ;
  wire \spo[2]_INST_0_i_1_n_0 ;
  wire \spo[2]_INST_0_i_2_n_0 ;
  wire \spo[30]_INST_0_i_1_n_0 ;
  wire \spo[31]_INST_0_i_1_n_0 ;
  wire \spo[31]_INST_0_i_2_n_0 ;
  wire \spo[31]_INST_0_i_3_n_0 ;
  wire \spo[3]_INST_0_i_1_n_0 ;
  wire \spo[3]_INST_0_i_2_n_0 ;
  wire \spo[3]_INST_0_i_3_n_0 ;
  wire \spo[4]_INST_0_i_1_n_0 ;
  wire \spo[4]_INST_0_i_2_n_0 ;
  wire \spo[4]_INST_0_i_3_n_0 ;
  wire \spo[4]_INST_0_i_4_n_0 ;
  wire \spo[4]_INST_0_i_5_n_0 ;
  wire \spo[4]_INST_0_i_6_n_0 ;
  wire \spo[5]_INST_0_i_1_n_0 ;
  wire \spo[6]_INST_0_i_1_n_0 ;
  wire \spo[6]_INST_0_i_2_n_0 ;
  wire \spo[6]_INST_0_i_3_n_0 ;
  wire \spo[7]_INST_0_i_1_n_0 ;
  wire \spo[7]_INST_0_i_2_n_0 ;
  wire \spo[7]_INST_0_i_3_n_0 ;
  wire \spo[8]_INST_0_i_1_n_0 ;
  wire \spo[8]_INST_0_i_2_n_0 ;
  wire \spo[8]_INST_0_i_3_n_0 ;
  wire \spo[9]_INST_0_i_1_n_0 ;
  wire \spo[9]_INST_0_i_2_n_0 ;
  wire \spo[9]_INST_0_i_3_n_0 ;

  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hD1FF)) 
    \spo[0]_INST_0 
       (.I0(a[6]),
        .I1(a[5]),
        .I2(\spo[0]_INST_0_i_1_n_0 ),
        .I3(a[7]),
        .O(spo[0]));
  LUT6 #(
    .INIT(64'h00000000001FFFFF)) 
    \spo[0]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[3]),
        .I4(a[4]),
        .I5(a[6]),
        .O(\spo[0]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[10]_INST_0 
       (.I0(\spo[26]_INST_0_i_2_n_0 ),
        .I1(\spo[10]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[11]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[11]_INST_0_i_1_n_0 ),
        .O(spo[9]));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \spo[10]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[10]_INST_0_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h00E2)) 
    \spo[11]_INST_0 
       (.I0(\spo[11]_INST_0_i_1_n_0 ),
        .I1(a[5]),
        .I2(\spo[11]_INST_0_i_2_n_0 ),
        .I3(a[7]),
        .O(spo[10]));
  LUT6 #(
    .INIT(64'h0000000008048010)) 
    \spo[11]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[11]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000002400)) 
    \spo[11]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[11]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \spo[12]_INST_0 
       (.I0(a[5]),
        .I1(\spo[19]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .O(spo[11]));
  LUT4 #(
    .INIT(16'h8830)) 
    \spo[13]_INST_0 
       (.I0(\spo[18]_INST_0_i_1_n_0 ),
        .I1(a[7]),
        .I2(\spo[13]_INST_0_i_1_n_0 ),
        .I3(a[5]),
        .O(spo[12]));
  LUT6 #(
    .INIT(64'h000000000000C010)) 
    \spo[13]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[13]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h8888B88800000000)) 
    \spo[14]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(a[7]),
        .I2(a[0]),
        .I3(\spo[14]_INST_0_i_1_n_0 ),
        .I4(a[4]),
        .I5(a[5]),
        .O(spo[13]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h0200)) 
    \spo[14]_INST_0_i_1 
       (.I0(a[6]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[3]),
        .O(\spo[14]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[15]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[15]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[15]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[15]_INST_0_i_3_n_0 ),
        .O(spo[14]));
  LUT6 #(
    .INIT(64'h0000080100000200)) 
    \spo[15]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[15]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000010000114888)) 
    \spo[15]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[6]),
        .I4(a[2]),
        .I5(a[1]),
        .O(\spo[15]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000240008008000)) 
    \spo[15]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[15]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[16]_INST_0 
       (.I0(\spo[18]_INST_0_i_1_n_0 ),
        .I1(\spo[16]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[16]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[16]_INST_0_i_3_n_0 ),
        .O(spo[15]));
  LUT6 #(
    .INIT(64'h0000020100000080)) 
    \spo[16]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[16]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000816000000000)) 
    \spo[16]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[16]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h000000000A00C010)) 
    \spo[16]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[16]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[17]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[17]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[17]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[17]_INST_0_i_3_n_0 ),
        .O(spo[16]));
  LUT6 #(
    .INIT(64'h00000A0100000280)) 
    \spo[17]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[17]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000010080116888)) 
    \spo[17]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[6]),
        .I4(a[2]),
        .I5(a[1]),
        .O(\spo[17]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h024024000A00E010)) 
    \spo[17]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[17]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hB8883333B8880000)) 
    \spo[18]_INST_0 
       (.I0(\spo[18]_INST_0_i_1_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_2_n_0 ),
        .I3(a[0]),
        .I4(a[5]),
        .I5(\spo[19]_INST_0_i_3_n_0 ),
        .O(spo[17]));
  LUT6 #(
    .INIT(64'h0200000000020104)) 
    \spo[18]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[18]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB8883333B8880000)) 
    \spo[19]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(a[7]),
        .I2(\spo[19]_INST_0_i_2_n_0 ),
        .I3(a[0]),
        .I4(a[5]),
        .I5(\spo[19]_INST_0_i_3_n_0 ),
        .O(spo[18]));
  LUT6 #(
    .INIT(64'h0000000000010010)) 
    \spo[19]_INST_0_i_1 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .I5(a[0]),
        .O(\spo[19]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00010000)) 
    \spo[19]_INST_0_i_2 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .O(\spo[19]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0040040000002000)) 
    \spo[19]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[4]),
        .O(\spo[19]_INST_0_i_3_n_0 ));
  MUXF8 \spo[20]_INST_0 
       (.I0(\spo[20]_INST_0_i_1_n_0 ),
        .I1(\spo[20]_INST_0_i_2_n_0 ),
        .O(spo[19]),
        .S(a[7]));
  MUXF7 \spo[20]_INST_0_i_1 
       (.I0(\spo[20]_INST_0_i_3_n_0 ),
        .I1(\spo[20]_INST_0_i_4_n_0 ),
        .O(\spo[20]_INST_0_i_1_n_0 ),
        .S(a[5]));
  MUXF7 \spo[20]_INST_0_i_2 
       (.I0(\spo[20]_INST_0_i_5_n_0 ),
        .I1(\spo[20]_INST_0_i_6_n_0 ),
        .O(\spo[20]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0220400002600506)) 
    \spo[20]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[20]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000802802300380)) 
    \spo[20]_INST_0_i_4 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[4]),
        .O(\spo[20]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0030001000000000)) 
    \spo[20]_INST_0_i_5 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .I5(a[0]),
        .O(\spo[20]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0200000200020104)) 
    \spo[20]_INST_0_i_6 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[20]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[21]_INST_0 
       (.I0(\spo[21]_INST_0_i_1_n_0 ),
        .I1(\spo[21]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[21]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[21]_INST_0_i_4_n_0 ),
        .O(spo[20]));
  LUT6 #(
    .INIT(64'h0001000000000000)) 
    \spo[21]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000002000000000)) 
    \spo[21]_INST_0_i_2 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[21]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2000000002101040)) 
    \spo[21]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[3]),
        .I5(a[4]),
        .O(\spo[21]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h1000049200000880)) 
    \spo[21]_INST_0_i_4 
       (.I0(a[0]),
        .I1(a[2]),
        .I2(a[1]),
        .I3(a[6]),
        .I4(a[3]),
        .I5(a[4]),
        .O(\spo[21]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[22]_INST_0 
       (.I0(\spo[22]_INST_0_i_1_n_0 ),
        .I1(\spo[22]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[22]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[22]_INST_0_i_4_n_0 ),
        .O(spo[21]));
  LUT6 #(
    .INIT(64'h0000000100008028)) 
    \spo[22]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[22]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000400000801)) 
    \spo[22]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[22]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0085000800108020)) 
    \spo[22]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[6]),
        .I2(a[4]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[22]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h200E40110A401000)) 
    \spo[22]_INST_0_i_4 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[6]),
        .O(\spo[22]_INST_0_i_4_n_0 ));
  MUXF8 \spo[23]_INST_0 
       (.I0(\spo[23]_INST_0_i_1_n_0 ),
        .I1(\spo[23]_INST_0_i_2_n_0 ),
        .O(spo[22]),
        .S(a[7]));
  MUXF7 \spo[23]_INST_0_i_1 
       (.I0(\spo[23]_INST_0_i_3_n_0 ),
        .I1(\spo[23]_INST_0_i_4_n_0 ),
        .O(\spo[23]_INST_0_i_1_n_0 ),
        .S(a[5]));
  MUXF7 \spo[23]_INST_0_i_2 
       (.I0(\spo[23]_INST_0_i_5_n_0 ),
        .I1(\spo[23]_INST_0_i_6_n_0 ),
        .O(\spo[23]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'h0804010000000000)) 
    \spo[23]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[23]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0004008200000000)) 
    \spo[23]_INST_0_i_4 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[23]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    \spo[23]_INST_0_i_5 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[23]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000108)) 
    \spo[23]_INST_0_i_6 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[23]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8F800F0F8F800000)) 
    \spo[24]_INST_0 
       (.I0(a[0]),
        .I1(\spo[24]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[24]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[24]_INST_0_i_3_n_0 ),
        .O(spo[23]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \spo[24]_INST_0_i_1 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .O(\spo[24]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000104000000408)) 
    \spo[24]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[24]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0084010000000000)) 
    \spo[24]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[24]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[25]_INST_0 
       (.I0(\spo[27]_INST_0_i_1_n_0 ),
        .I1(\spo[25]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[25]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[25]_INST_0_i_3_n_0 ),
        .O(spo[24]));
  LUT6 #(
    .INIT(64'h0004000000000803)) 
    \spo[25]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[0]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[25]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000906000000008)) 
    \spo[25]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[25]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0884410002200000)) 
    \spo[25]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[25]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[26]_INST_0 
       (.I0(\spo[27]_INST_0_i_1_n_0 ),
        .I1(\spo[26]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[27]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[26]_INST_0_i_2_n_0 ),
        .O(spo[25]));
  LUT5 #(
    .INIT(32'h00000002)) 
    \spo[26]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[0]),
        .O(\spo[26]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \spo[26]_INST_0_i_2 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[26]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[27]_INST_0 
       (.I0(\spo[27]_INST_0_i_1_n_0 ),
        .I1(\spo[27]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[27]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[27]_INST_0_i_4_n_0 ),
        .O(spo[26]));
  LUT6 #(
    .INIT(64'h0000000200000104)) 
    \spo[27]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[27]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \spo[27]_INST_0_i_2 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[0]),
        .O(\spo[27]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002102000)) 
    \spo[27]_INST_0_i_3 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040000)) 
    \spo[27]_INST_0_i_4 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[27]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[28]_INST_0 
       (.I0(\spo[31]_INST_0_i_1_n_0 ),
        .I1(\spo[31]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[28]_INST_0_i_1_n_0 ),
        .I4(a[5]),
        .I5(\spo[28]_INST_0_i_2_n_0 ),
        .O(spo[27]));
  LUT6 #(
    .INIT(64'h0000000000080200)) 
    \spo[28]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[0]),
        .O(\spo[28]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0800000000040000)) 
    \spo[28]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[28]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[29]_INST_0 
       (.I0(\spo[31]_INST_0_i_1_n_0 ),
        .I1(\spo[31]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[31]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[29]_INST_0_i_1_n_0 ),
        .O(spo[28]));
  LUT6 #(
    .INIT(64'h0000800000000400)) 
    \spo[29]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[4]),
        .O(\spo[29]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[2]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[2]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[2]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[3]_INST_0_i_3_n_0 ),
        .O(spo[1]));
  LUT6 #(
    .INIT(64'h0000020401000001)) 
    \spo[2]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[2]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000100000C00400)) 
    \spo[2]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[2]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hA0AFA0A0C0C0C0C0)) 
    \spo[30]_INST_0 
       (.I0(\spo[31]_INST_0_i_1_n_0 ),
        .I1(\spo[31]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(a[0]),
        .I4(\spo[30]_INST_0_i_1_n_0 ),
        .I5(a[5]),
        .O(spo[29]));
  LUT5 #(
    .INIT(32'h00180000)) 
    \spo[30]_INST_0_i_1 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .O(\spo[30]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hAFA0C0C0)) 
    \spo[31]_INST_0 
       (.I0(\spo[31]_INST_0_i_1_n_0 ),
        .I1(\spo[31]_INST_0_i_2_n_0 ),
        .I2(a[7]),
        .I3(\spo[31]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .O(spo[30]));
  LUT6 #(
    .INIT(64'h0000000000011024)) 
    \spo[31]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[6]),
        .O(\spo[31]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000008002)) 
    \spo[31]_INST_0_i_2 
       (.I0(a[4]),
        .I1(a[3]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[0]),
        .O(\spo[31]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000080000)) 
    \spo[31]_INST_0_i_3 
       (.I0(a[4]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[3]),
        .I5(a[0]),
        .O(\spo[31]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[3]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[3]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[3]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[3]_INST_0_i_3_n_0 ),
        .O(spo[2]));
  LUT6 #(
    .INIT(64'h0000000000020001)) 
    \spo[3]_INST_0_i_1 
       (.I0(a[3]),
        .I1(a[1]),
        .I2(a[2]),
        .I3(a[6]),
        .I4(a[4]),
        .I5(a[0]),
        .O(\spo[3]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000100000800400)) 
    \spo[3]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[3]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0880000000000440)) 
    \spo[3]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[3]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[4]),
        .O(\spo[3]_INST_0_i_3_n_0 ));
  MUXF8 \spo[4]_INST_0 
       (.I0(\spo[4]_INST_0_i_1_n_0 ),
        .I1(\spo[4]_INST_0_i_2_n_0 ),
        .O(spo[3]),
        .S(a[7]));
  MUXF7 \spo[4]_INST_0_i_1 
       (.I0(\spo[4]_INST_0_i_3_n_0 ),
        .I1(\spo[4]_INST_0_i_4_n_0 ),
        .O(\spo[4]_INST_0_i_1_n_0 ),
        .S(a[5]));
  MUXF7 \spo[4]_INST_0_i_2 
       (.I0(\spo[4]_INST_0_i_5_n_0 ),
        .I1(\spo[4]_INST_0_i_6_n_0 ),
        .O(\spo[4]_INST_0_i_2_n_0 ),
        .S(a[5]));
  LUT6 #(
    .INIT(64'hFFBF71EE7DEFBFFF)) 
    \spo[4]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[6]),
        .O(\spo[4]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFF6FFFDFFFFB7FF7)) 
    \spo[4]_INST_0_i_4 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[1]),
        .I4(a[2]),
        .I5(a[3]),
        .O(\spo[4]_INST_0_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FFDFF7BE)) 
    \spo[4]_INST_0_i_5 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[6]),
        .O(\spo[4]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00000000133D363B)) 
    \spo[4]_INST_0_i_6 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[6]),
        .O(\spo[4]_INST_0_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[5]_INST_0 
       (.I0(\spo[18]_INST_0_i_1_n_0 ),
        .I1(\spo[6]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[22]_INST_0_i_3_n_0 ),
        .I4(a[5]),
        .I5(\spo[5]_INST_0_i_1_n_0 ),
        .O(spo[4]));
  LUT6 #(
    .INIT(64'h048181400060A000)) 
    \spo[5]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[3]),
        .O(\spo[5]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[6]_INST_0 
       (.I0(\spo[19]_INST_0_i_1_n_0 ),
        .I1(\spo[6]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[6]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[6]_INST_0_i_3_n_0 ),
        .O(spo[5]));
  LUT6 #(
    .INIT(64'h0002000400000801)) 
    \spo[6]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[6]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000902000800408)) 
    \spo[6]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[6]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0481814000202000)) 
    \spo[6]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[2]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[3]),
        .O(\spo[6]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[7]_INST_0 
       (.I0(\spo[27]_INST_0_i_1_n_0 ),
        .I1(\spo[7]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[7]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[7]_INST_0_i_3_n_0 ),
        .O(spo[6]));
  LUT6 #(
    .INIT(64'h0002080400000205)) 
    \spo[7]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[7]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0011011509488080)) 
    \spo[7]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[2]),
        .O(\spo[7]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h20208002A1018401)) 
    \spo[7]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[6]),
        .I2(a[2]),
        .I3(a[3]),
        .I4(a[1]),
        .I5(a[4]),
        .O(\spo[7]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[8]_INST_0 
       (.I0(\spo[26]_INST_0_i_2_n_0 ),
        .I1(\spo[8]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[8]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[8]_INST_0_i_3_n_0 ),
        .O(spo[7]));
  LUT6 #(
    .INIT(64'h0402000001000004)) 
    \spo[8]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[8]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000400C001E01200)) 
    \spo[8]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[1]),
        .I3(a[2]),
        .I4(a[6]),
        .I5(a[3]),
        .O(\spo[8]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h300000000001000E)) 
    \spo[8]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[6]),
        .O(\spo[8]_INST_0_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \spo[9]_INST_0 
       (.I0(\spo[21]_INST_0_i_1_n_0 ),
        .I1(\spo[9]_INST_0_i_1_n_0 ),
        .I2(a[7]),
        .I3(\spo[9]_INST_0_i_2_n_0 ),
        .I4(a[5]),
        .I5(\spo[9]_INST_0_i_3_n_0 ),
        .O(spo[8]));
  LUT6 #(
    .INIT(64'h0002080001000204)) 
    \spo[9]_INST_0_i_1 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[6]),
        .I3(a[2]),
        .I4(a[1]),
        .I5(a[3]),
        .O(\spo[9]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000103130F48C080)) 
    \spo[9]_INST_0_i_2 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[2]),
        .O(\spo[9]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h302C28000001050F)) 
    \spo[9]_INST_0_i_3 
       (.I0(a[0]),
        .I1(a[4]),
        .I2(a[3]),
        .I3(a[1]),
        .I4(a[6]),
        .I5(a[2]),
        .O(\spo[9]_INST_0_i_3_n_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
