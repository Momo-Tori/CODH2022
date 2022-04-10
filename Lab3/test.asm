.data				#假定起始地址为0
led_data:  .word  0xffff	#led指示灯状态，初始全亮
swt_data: .word  0xaa55	#开关(switch)状态

.text
main:
	#test sw: led全灭
	sw 	zero, 0 (zero)
	
	#test addi: led全亮
	addi 	t0, zero, -1#t0=0xFFFFFFFF
	sw 	t0, 0 (zero)
	
	#test lw: 由switch设置led
	lw 	t0, 4 (zero)
	sw 	t0, 0 (zero)
	
	#test add：led全灭，之后显示0x0001
	addi 	t0, zero, -1#t0=0xFFFFFFFF
	addi	t1, zero,1#t1=1
	add	t0, t0, t1#t0=t0+t1=0
	sw	t0, 0 ( zero )
	sw 	t1, 0 (zero)#led显示0x0001
	
	#test sub：led全亮，之后显示0x0002
	sub	t0,t0,t1#t0=t0-t1=0xFFFFFFFF
	sw	t0, 0 ( zero )
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led显示0x0002
	
	#test beq：过程中led全灭，直到led显示0x0003
	beq	t0,t1,skip1#beq条件不成立
	sw 	zero, 0 (zero)
	skip1:
	add	t2, zero, t1#t2=t1=1
	beq	t2,t1,skip2#beq条件成立
	sw 	t0, 0 (zero)
	skip2:
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led显示0x0003
	
	#test blt：过程中led全亮，直到led显示0x0004
	blt	t1,t0,skip3#blt条件不成立
	sw 	t0, 0 (zero)
	skip3:
	add	t2, zero, t1#t2=t1=1
	blt	t0,t1,skip4#blt条件成立
	sw 	zero, 0 (zero)
	skip4:
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led显示0x0004
	
	#test jal&jalr:分别先全亮、全暗之后全亮最后显示0x0005
	jal ra,Test#测试jal的pc += sext(offset) 
	sw 	zero, 0 (zero)
	jalr zero,0(ra)#测试jalr的x[rd] = pc+4
Test:
	sw 	t0, 0 (zero)
	jalr	ra,0(ra)#测试jal的x[rd] = pc+4以及jalr的pc=(x[rs1]+sext(offset))~(-1)
	sw 	t0, 0 (zero)
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led显示0x0005
	
	#test auipc:led先全亮后显示0x0006
	auipc t2,1#t2=pc0+1<<12=pc0+0x1000
	jal ra,Test2#ra=pc0+4
Test2:
	addi t3,zero,0x700#t3=0x700
	add t3,t3,t3#t3=0x800
	add t3,t3,t3#t3=0x1000
	add t3,t3,ra#t3=pc0+4+0x1000
	addi t3,t3,-4#t3=pc0+0x1000==t2
	beq t3,t2,skip5
	sw 	t0, 0 (zero)
	skip5:
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led显示0x0006
	
	
	
	
	