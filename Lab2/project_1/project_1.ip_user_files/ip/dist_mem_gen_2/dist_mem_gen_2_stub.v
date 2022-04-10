// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Thu Mar 31 19:57:23 2022
// Host        : Yun running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/CodeTry/CODExperiment/Lab2/project_1/project_1.srcs/sources_1/ip/dist_mem_gen_2/dist_mem_gen_2_stub.v
// Design      : dist_mem_gen_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2019.1" *)
module dist_mem_gen_2(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],d[15:0],dpra[7:0],clk,we,dpo[15:0]" */;
  input [7:0]a;
  input [15:0]d;
  input [7:0]dpra;
  input clk;
  input we;
  output [15:0]dpo;
endmodule