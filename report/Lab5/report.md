<!--
 * @Author: MomoTori
 * @Date: 2022-03-27 01:02:45
 * @LastEditors: MomoTori
 * @LastEditTime: 2022-05-07 16:30:59
 * @FilePath: \CODExperiment\report\Lab5\report.md
 * @Description: 
 * Copyright (c) 2022 by MomoTori, All Rights Reserved. 
-->
# 实验五  流水线CPU设计

## 目录

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [实验五  流水线CPU设计](#实验五-流水线cpu设计)
  - [目录](#目录)
  - [附录文件一览](#附录文件一览)
  - [流水线cpu设计](#流水线cpu设计)
    - [数据通路](#数据通路)
  - [单周期CPU测试下载](#单周期cpu测试下载)
  - [单周期CPU数组排序下载](#单周期cpu数组排序下载)
    - [设计](#设计)
    - [下载测试](#下载测试)
    - [资源使用与电路性能](#资源使用与电路性能)
  - [实验总结](#实验总结)

<!-- /code_chunk_output -->

## 附录文件一览



## 流水线cpu设计

### 数据通路

数据通路如下所示，

![](pic/DataPath.png)




## 单周期CPU测试下载

![](pic/1.png)

经过对led的测试可得其每个指令均正常工作

## 单周期CPU数组排序下载

### 设计

通过对lab3的排序汇编程序改造成我们的cpu符合的MMIO，可以得到如下的汇编程序

```js
.data
buffer: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


.text
main:
auipc t6,0xF
addi t6,t6,0x780
addi t6,t6,0x780#t6=0xff00

#input
addi t5,zero,0#输入放置内存
again:
lw t1,0x10(t6)#开关是否有效
beq t1,zero,again
lw t1,0x14(t6)
sw t1,0(t5)
addi t5,t5,4
a:
lw t2,0x10(t6)
beq t2,zero,a
lw t2,0x14(t6)
sw t2,0(t5)
addi t5,t5,4
addi t1,t1,-1
blt zero,t1,a

#sort
addi t1,zero,0#buffer 位置
lw t0,0(t1)
LOOP1:
addi t0,t0,-1
beq t0,zero,FIN
addi t1,zero,4#buffer数组第一个数据
addi t2,t0,-1
add t2,t2,t2
add t2,t2,t2#t2=(t0-1)*4
add t2,t2,t1 #t2 is the finish address
lw t3,0(t1)
LOOP2:
blt t2,t1,LOOP2FIN
lw t4,4(t1)
blt t3,t4,jp
beq zero,zero,skip
jp:mv t5,t3
mv t3,t4
mv t4,t5
skip:
sw t4,0(t1)
addi t1,t1,4
beq zero,zero,LOOP2
LOOP2FIN:
sw t3,0(t1)
beq zero,zero,LOOP1
FIN:

#output
addi t1,zero,0#buffer 位置
lw t0,0(t1)
addi t1,t1,4#buffer数组第一个数据
add t2,t0,t0
add t2,t2,t2 #t2=t0*4
add t2,t2,t1 #t2 is the finish address
OutLoop:
beq t2,t1,OutputFin
ag2:
lw t0,0x8(t6)
beq zero,t0,ag2
lw t0,0(t1)
sw t0,0xc(t6)
addi 	t1,t1,4
beq zero,zero,OutLoop
OutputFin: addi zero,zero,0
```

并将原CPU的MMIO部分改为

```v
//DataMem&MMIO
DataMem DataMem(ALUResult[10:2],Reg2Data,DebugMemAddr,clk,MemWrite,ReadMemData,DebugMemData);//DataMem

wire MMIO;
assign MMIO=ALUResult>=32'hFF00;

assign io_we=MemWrite&MMIO;
assign io_rd=MemRead&MMIO;
assign io_addr=ALUResult[7:0];
assign io_dout=Reg2Data;
assign ReadData=MMIO?io_din:ReadMemData;
```

### 下载测试

下载测试图如下

![](pic/2.png)

可正常完成MMIO的输入输出


### 资源使用与电路性能

![](pic/Uti1.png)
![](pic/Uti2.png)
![](pic/time.png)

## 实验总结

通过本实验学习了简单的单周期cpu设计，并能够在其上跑简单的带有输入输出功能的排序汇编程序