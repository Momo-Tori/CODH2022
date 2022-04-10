.data
buffer: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
HexToASCII:.word '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'


.text
main:
auipc t6,4
addi t6,t6,0x780
addi t6,t6,0x780#t6=7f00
addi t4,zero,1
sw t4,8(t6)#初始化输出

#input
la t5,buffer
addi t5,zero,0#输入放置内存
jal ra,inputNum
addi t1,a0,0#t1为输入数量
sw t1,0(t5)
addi t5,t5,4
a:
jal ra,inputNum
sw a0,0(t5)
addi t5,t5,4
addi t1,t1,-1
bne zero,t1,a

#sort
addi t1,zero,0#buffer 位置
lw t0,0(t1)
LOOP1:
addi t0,t0,-1
beqz t0,FIN
addi t1,zero,4#buffer数组第一个数据
addi t2,t0,-1
slli t2,t2,2 #t2=(t0-1)*4
add t2,t2,t1 #t2 is the finish address
lw t3,0(t1)
LOOP2:
blt t2,t1,LOOP2FIN
lw t4,4(t1)
bge t3,t4,skip
mv t5,t3
mv t3,t4
mv t4,t5
skip:
sw t4,0(t1)
addi t1,t1,4
 j LOOP2
LOOP2FIN:
sw t3,0(t1)
j LOOP1
FIN:

#output
addi t1,zero,0#buffer 位置
lw t0,0(t1)
addi t1,t1,4#buffer数组第一个数据
addi t2,t0,0
slli t2,t2,2 #t2=t0*4
add t2,t2,t1 #t2 is the finish address
OutLoop:
beq t2,t1,OutputFin
lw t3,0(t1)
srli t4,t3,12
andi a0,t4,0xF
jal ra,PutOut
srli t4,t3,8
andi a0,t4,0xF
jal ra,PutOut
srli t4,t3,4
andi a0,t4,0xF
jal ra,PutOut
andi a0,t3,0xF
jal ra,PutOut

LOOP3FIN:
lw t4,8(t6)
beq zero,t4,LOOP3FIN
addi t4,zero,'\n'
sw t4,12(t6)

addi 	t1,t1,4
j OutLoop

OutputFin:
li a7, 10 # Exit program
ecall

inputNum:
addi t3,zero,0#输入字符个数
Ag:lw t4,0(t6)
beq t4,zero,Ag
lw t4,4(t6)
addi t2,t4,-0x8#判断退格backspace
bne t2,zero,notBackspace
beq t3,zero,Ag
addi t3,t3,-1
addi sp,sp,4
j Ag
notBackspace:
addi t2,t4,-0xa#判断回车
beq t2,zero,process
addi t4,t4,-0x30#-'0'
addi t2,t4,-9#用于判断这个数是'0'-'9'还是'A'-'F'
bge zero,t2,notAF
addi t4,t4,-11#'0'-'A'
notAF:
sw t4,0(sp)
addi sp,sp,-4
addi t3,t3,1
j Ag
process:
slli t3,t3,2 #t3=4n
add t3,t3,sp#原sp位置
addi t0,t3,0#记录原sp
addi a0,zero,0
load:
beq t3,sp,loadfin
lw t2,0(t3)
slli a0,a0,4
add a0,a0,t2
addi t3,t3,-4
j load
loadfin:
addi sp,t0,0
jalr zero,0(ra)

PutOut:
la t5,HexToASCII
slli a0,a0,2 #*4
add a0,a0,t5
lw a0,0(a0)
Again:
lw t4,8(t6)
beq zero,t4,Again
sw a0,12(t6)
jalr zero,0(ra)
        
