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
