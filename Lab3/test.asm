.data				#�ٶ���ʼ��ַΪ0
led_data:  .word  0xffff	#ledָʾ��״̬����ʼȫ��
swt_data: .word  0xaa55	#����(switch)״̬

.text
main:
	#test sw: ledȫ��
	sw 	zero, 0 (zero)
	
	#test addi: ledȫ��
	addi 	t0, zero, -1#t0=0xFFFFFFFF
	sw 	t0, 0 (zero)
	
	#test lw: ��switch����led
	lw 	t0, 4 (zero)
	sw 	t0, 0 (zero)
	
	#test add��ledȫ��֮����ʾ0x0001
	addi 	t0, zero, -1#t0=0xFFFFFFFF
	addi	t1, zero,1#t1=1
	add	t0, t0, t1#t0=t0+t1=0
	sw	t0, 0 ( zero )
	sw 	t1, 0 (zero)#led��ʾ0x0001
	
	#test sub��ledȫ����֮����ʾ0x0002
	sub	t0,t0,t1#t0=t0-t1=0xFFFFFFFF
	sw	t0, 0 ( zero )
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led��ʾ0x0002
	
	#test beq��������ledȫ��ֱ��led��ʾ0x0003
	beq	t0,t1,skip1#beq����������
	sw 	zero, 0 (zero)
	skip1:
	add	t2, zero, t1#t2=t1=1
	beq	t2,t1,skip2#beq��������
	sw 	t0, 0 (zero)
	skip2:
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led��ʾ0x0003
	
	#test blt��������ledȫ����ֱ��led��ʾ0x0004
	blt	t1,t0,skip3#blt����������
	sw 	t0, 0 (zero)
	skip3:
	add	t2, zero, t1#t2=t1=1
	blt	t0,t1,skip4#blt��������
	sw 	zero, 0 (zero)
	skip4:
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led��ʾ0x0004
	
	#test jal&jalr:�ֱ���ȫ����ȫ��֮��ȫ�������ʾ0x0005
	jal ra,Test#����jal��pc += sext(offset) 
	sw 	zero, 0 (zero)
	jalr zero,0(ra)#����jalr��x[rd] = pc+4
Test:
	sw 	t0, 0 (zero)
	jalr	ra,0(ra)#����jal��x[rd] = pc+4�Լ�jalr��pc=(x[rs1]+sext(offset))~(-1)
	sw 	t0, 0 (zero)
	addi	t1,t1,1
	sw 	t1, 0 (zero)#led��ʾ0x0005
	
	#test auipc:led��ȫ������ʾ0x0006
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
	sw 	t1, 0 (zero)#led��ʾ0x0006
	
	
	
	
	