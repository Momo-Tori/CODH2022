.text
start:
	addi t0, x0, 0		# counter

test0: 				# test beq
	addi t1, x0, 1
	addi t2, x0, 1
	nop
	nop
	nop
	nop
	beq t1, t2, pass0
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass0:
	addi t0, t0, 1		# counter++

test1: 				# test ADD
	addi t1, x0, 1		# operand 1
	addi t2, x0, 2		# operand 2
	addi t3, x0, 3		# result
	nop
	nop
	nop
	nop
	add t4, t2, t1		# execute
	nop
	nop
	nop
	nop
	beq t4, t3, pass1	# t4 == t3
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop

pass1:
	addi t0, t0, 1
	
test2:				# test SUB
	addi t1, x0, 1
	addi t2, x0, 2
	addi t3, x0, 1
	nop
	nop
	nop
	nop
	sub t4, t2, t1
	nop
	nop
	nop
	nop
	beq t4, t3, pass2
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass2:
	addi t0, t0, 1
	
test3:				# test LW
	addi t1, x0, 0
	addi t2, x0, 8
	nop
	nop
	nop
	nop
	lw t3, 4(t1)
	nop
	nop
	nop
	nop
	beq t3, t2, pass3
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass3:
	addi t0, t0, 1

test4:				# test SW
	addi t1, x0, 0
	addi t2, x0, 4
	nop
	nop
	nop
	nop
	sw t2, 4(t1)
	lw t3, 4(t1)
	nop
	nop
	nop
	nop
	beq t3, t2, pass4
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass4:
	addi t0, t0, 1

test5:				# test BLT
	addi t1, x0, 1
	addi t2, x0, 2
	nop
	nop
	nop
	nop
	blt t1, t2, pass5
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass5:
	addi t0, t0, 1

test6:				# test AUIPC JAL
	auipc t1, 0
	jal t2, temp6
temp6:
	nop
	nop
	nop
	nop
	addi t2, t2, -8
	nop
	nop
	nop
	nop
	beq t1, t2, pass6
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass6:
	addi t0, t0, 1
	
test7:				# test AUIPC JALR
	auipc t1, 0
	nop
	nop
	nop
	nop
	jalr t2, 32(t1)
	nop
	nop
	nop
	nop
	addi t2, t2, -24
	nop
	nop
	nop
	nop
	beq t1, t2, pass7
	nop
	nop
	jal fail
	nop
	nop
	nop
	nop
pass7:
	addi t0, t0, 1
	
allpass:
	addi a0, x0, -256
	nop
	nop
	nop
	nop
	sw t0, 0(a0)		# led
	jal allpass
	nop
	nop
	nop
	nop

fail:
	addi t0, x0, -1
	addi a0, x0, -256
	nop
	nop
	nop
	nop
	sw t0, 0(a0)		# led
	jal fail
	nop
	nop
	nop
	nop

.data
.word 0xdeadbeef
.word 0x00000008
